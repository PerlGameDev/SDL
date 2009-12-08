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
use Data::Dumper;
use Config;
use Carp;
use base 'SDL::Build';

#Ideal Solution but it is not called!
#sub process_xs
#{
#	my ($self, $file) = @_;
#	$file =~ s/\\/\//g; #replace \ for / (Win32 needs this);
#	$self->SUPER::process_xs($file);
#}

sub opengl_headers
{
	return GL => 'SDL_opengl.h';
}

sub fetch_includes
{
	my ($sdlinc, $sdllib);
        if(defined($ENV{SDL_INST_DIR})) {
          $sdlinc = $ENV{SDL_INST_DIR}.'/include';
          $sdllib = $ENV{SDL_INST_DIR}.'/lib';
        }
        else {
          $sdlinc = $Config{incpath};
          $sdllib = $Config{libpth};
        }
	return (
	$sdlinc              => $sdllib,
	$sdlinc.'/gl'        => $sdllib,
	$sdlinc.'/GL'        => $sdllib,
	$sdlinc.'/SDL'       => $sdllib,
	$sdlinc.'/smpeg'     => $sdllib,
	);
}

# we need to override build_links method because on Windows we need to replace 
# some library names - see %replace hash below
sub build_links
{
	my ($self, $libraries, $build_systems) = @_;

	my %links;
	my %replace = (
		'GL'                  => 'opengl32', 
		'GLU'                 => 'glu32',
		'SDL_gfx_blitfunc'    => 'SDL_gfx',
		'SDL_gfx_framerate'   => 'SDL_gfx',
		'SDL_gfx_imagefilter' => 'SDL_gfx',
		'SDL_gfx_primitives'  => 'SDL_gfx',
		'SDL_gfx_rotozoom'    => 'SDL_gfx',
    );

	while (my ($subsystem, $buildable) = each %$build_systems)
	{
		my %sub_links;
		for my $build (grep { $buildable->{ $_ } } keys %$buildable)
		{
			$sub_links{ $buildable->{ $build }[1] }++;
			my $newbuild = $replace{$build} || $build;
			push @{ $links{ $subsystem }{libs} }, "-l$newbuild";
		}

		$links{ $subsystem }{paths} = [ map { "-L$_" } keys %sub_links ];
	}
	return \%links;
}

sub alt_link_flags
{
	my $self = shift;
	my $sdl_dir = shift;

	return $self->SUPER::alt_link_flags($sdl_dir).' -mwindows -lSDLmain -lSDL';
}

sub alt_compile_flags
{
	my $self = shift;
	my $sdl_dir = shift;

	return $self->SUPER::alt_compile_flags($sdl_dir).' -D_GNU_SOURCE=1 -Dmain=SDL_main';
}

1;
