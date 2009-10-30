#!/usr/bin/env perl
#
# Graphic.pm
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

package SDL::Tool::Graphic;

use strict;
use warnings;
use Carp;
use SDL;
use SDL::Config;
require SDL::Surface;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	bless $self, $class;
	$self;
}


sub DESTROY {
	# nothing to do
}


sub zoom {
	my ( $self, $surface, $zoomx, $zoomy, $smooth) = @_;
	croak "SDL::Tool::Graphic::zoom requires an SDL::Surface\n"
		unless ( ref($surface) && $surface->isa('SDL::Surface'));
	my $tmp = $$surface;
	$$surface = SDL::GFXZoom($$surface, $zoomx, $zoomy, $smooth);
	SDL::FreeSurface($tmp);
	$surface;
}

sub rotoZoom {
	my ( $self, $surface, $angle, $zoom, $smooth) = @_;
	croak "SDL::Tool::Graphic::rotoZoom requires an SDL::Surface\n"
		unless ( ref($surface) && $surface->isa('SDL::Surface'));
	my $tmp = $$surface;
	$$surface = SDL::GFXRotoZoom($$surface, $angle, $zoom, $smooth);
	SDL::FreeSurface($tmp);
	$surface;
}

sub grayScale {
	my ( $self, $surface ) = @_;
	my $workingSurface;
	if($surface->isa('SDL::Surface')) {
		 $workingSurface = $$surface;
	} else {
		$workingSurface = $surface;
	}
	my $color;
	my $width = SDL::SurfaceW($workingSurface);
	my $height = SDL::SurfaceH($workingSurface);
	for(my $x = 0; $x < $width; $x++){
		for(my $y = 0; $y < $height; $y++){
			my $origValue = SDL::SurfacePixel($workingSurface, $x, $y);
			my $newValue = int(0.3*SDL::ColorR($origValue) + 0.59 * SDL::ColorG($origValue) + 0.11*SDL::ColorB($origValue));
			SDL::SurfacePixel($workingSurface, $x, $y, SDL::NewColor($newValue, $newValue, $newValue));
		}
	}
 
	if($surface->isa('SDL::Surface')) {
       		$surface = \$workingSurface;
	} else {
		$surface = $workingSurface;
	}
}
 
sub invertColor {
	my ( $self, $surface ) = @_;
	#Added because of strict if we needed global
    #do $workingSurface init outside subs.
	my $workingSurface;
	if($surface->isa('SDL::Surface')) {
		$workingSurface = $$surface;
	} else {
		$workingSurface = $surface;
	}
	my $width = SDL::SurfaceW($workingSurface);
	my $height = SDL::SurfaceH($workingSurface);
	for(my $x = 0; $x < $width; $x++){
		for(my $y = 0; $y < $height; $y++){
			my $origValue = SDL::SurfacePixel($workingSurface, $x, $y);
			my $newValue = int(0.3*SDL::ColorR($origValue) + 0.59 * SDL::ColorG($origValue) + 0.11*SDL::ColorB($origValue));
			SDL::SurfacePixel($workingSurface, $x, $y, SDL::NewColor(255-SDL::ColorR($origValue), 255 - SDL::ColorG($origValue), 255 - SDL::ColorB($origValue)));
		}
	}

	if($surface->isa('SDL::Surface')) {
		$$surface = $workingSurface;
	} else {
		$surface = $workingSurface;
	}
}

croak "SDL::Tool::Graphic requires SDL_gfx support\n"
	unless SDL::Config->has('SDL_gfx');
 

1;
