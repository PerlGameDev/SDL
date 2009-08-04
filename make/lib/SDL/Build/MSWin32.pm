#!/usr/bin/env perl
#
# MSWin32.pm
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
#
# ------------------------------------------------------------------------------
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ------------------------------------------------------------------------------
#
# Please feel free to send questions, suggestions or improvements to:
#
#	David J. Goehrig
#	dgoehrig@cpan.org
#

package SDL::Build::MSWin32;

use strict;
use warnings;
usr Carp;
use base 'SDL::Build';
use File::Spec::Functions;

sub fetch_includes
{
	croak "Environment variable INCLUDE is empty\n" unless $ENV{INCLUDE};

	return map { $_ => 1 } grep { $_ } split( ';', $ENV{INCLUDE} );
}

sub find_header
{
	for my $key (qw( LIBS PATH ))
	{
		#this needs to be carp because some users will have SDL libs in same folder
		carp "Environment variable $key is empty\n" unless $ENV{$key};
		carp "This will probably fail the compile \nSet $key manually or try building anyway\n"  unless $ENV{$key}; 
	}

	my ( $self, $header, $includes ) = @_;
	( my $dll = $header ) =~ s/\.h/\.dll/;

	my $include_dir;

	for my $inc_dir ( keys %$includes )
	{
		next unless -e catfile( $inc_dir, $header );
		$include_dir = $inc_dir;
	}

	return unless $include_dir;

	for my $lib_path ( map { split(';', ( $ENV{$_} || '' )) }
		                   qw( LIB LIBS PATH ) )
	{
		return ( $include_dir, $header ) if -e catfile( $lib_path, $dll );
	}
}

sub link_flags
{
	return 'SDL.lib';
}

sub compile_flags
{
	return;
}

sub subsystems
{
	my $self         = shift;
	my $subsystems   = $self->SUPER::subsystems();
	my $gl_ss_method = $self->gl_vendor( $ENV{SDL_GL_VENDOR} ) . '_subsystems';

	$subsystems->{OpenGL}{libraries} = $self->$gl_ss_method();
	return $subsystems;
}

sub libraries
{
	my $self          = shift;
	my $libraries     = $self->SUPER::libraries();
	my $gl_lib_method = $self->gl_vendor( $ENV{SDL_GL_VENDOR} ) . '_libraries';

	$libraries->{OpenGL}{define} .= ' -D' . $self->$gl_lib_method();
	return $libraries;
}

sub gl_vendor
{
	my ( $self, $vendor ) = @_;

	return 'ms_gl' unless defined $vendor;
	return 'mesa_gl' if $vendor eq 'MESA';
	return 'ms_gl'   if $vendor eq 'MS';
	croak "Unrecognized GL vendor '$vendor'\n";

}

sub ms_gl_subsystems
{
	return [qw( OpenGL GLU )];
}

sub mesa_gl_subsystems
{
	return [qw( mesagl mesaglu osmesa )];
}

sub ms_gl_libraries
{
	define => 'OPENGL_VENDOR_MS';
}

sub mesa_gl_libraries
{
	define => 'OPENGL_VENDOR_MESA';
}

sub link_c
{
	my $self           = shift;
	my ( $blib, $rib ) = @_;

	# until ExtUtils::ParseXS is patched, avoid warnings from cl.exe
	$_[-1] =~ s{\\}{/}g;

	$rib   =~ s{^src[\\/]}{};
	$rib   =~ s{[\\/]}{::}g;

	local $self->{properties}{module_name} = $rib;
	$self->SUPER::link_c( @_ );
}

1;
