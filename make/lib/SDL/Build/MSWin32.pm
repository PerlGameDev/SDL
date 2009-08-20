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
use Carp;
use base 'SDL::Build';

sub opengl_headers
{
	return GL => 'SDL_opengl.h';
}

sub fetch_includes
{
	return (

	$ENV{SDL_INST_DIR}.'/include'              => $ENV{SDL_INST_DIR}.'/lib',
	$ENV{SDL_INST_DIR}.'/include/gl'           => $ENV{SDL_INST_DIR}.'/lib',
	$ENV{SDL_INST_DIR}.'/include/GL'           => $ENV{SDL_INST_DIR}.'/lib',
	$ENV{SDL_INST_DIR}.'/include/SDL'          => $ENV{SDL_INST_DIR}.'/lib',
	$ENV{SDL_INST_DIR}.'/include/smpeg'        => $ENV{SDL_INST_DIR}.'/lib',
	);
}

#Todo: his needs to be fixed hash references are a mess
#sub build_links
#{
	
#	my $self  = shift;
#	my $links = $self->SUPER::build_links(@_);
#	
#	for my $subsystem (values %$links)
#	{
#		push @{ $subsystem{ libs } }, '-lpthreads';
#	}

#		return \%links;
#}


sub alt_link_flags
{
	my $self = shift;
	my $sdl_dir = shift;

	return $self->SUPER::alt_link_flags($sdl_dir).' -mwindows -lSDLmain -lSDL.dll';
}

sub alt_compile_flags
{
	my $self = shift;
	my $sdl_dir = shift;

	return $self->SUPER::alt_compile_flags($sdl_dir).' -D_GNU_SOURCE=1 -Dmain=SDL_main';
}

1;
