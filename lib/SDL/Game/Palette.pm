#!/usr/bin/env perl
#
# Palette.pm
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

# NB: there is no palette destructor because most of the time the 
# palette will be owned by a surface, so any palettes you create 
# with new, won't be destroyed until the program ends!

package SDL::Game::Palette;
use strict;
use warnings;
use Carp;

# NB: there is no palette destructor because most of the time the 
# palette will be owned by a surface, so any palettes you create 
# with new, won't be destroyed until the program ends!

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $image;
	my $self;
	if (@_) { 
		$image = shift;
		$self = \$image->palette(); 
	} else { 
		$self = \SDL::NewPalette(256); 
	}
	croak SDL::GetError() unless $$self;
	bless $self, $class;
	return $self;
}

sub size {
	my $self = shift;
	return SDL::PaletteNColors($$self);
}

sub color {
	my $self = shift;
	my $index = shift;
	my ($r,$g,$b);
	if (@_) { 
		$r = shift; $g = shift; $b = shift; 
		return SDL::PaletteColors($$self,$index,$r,$g,$b);
	} else {
		return SDL::PaletteColors($$self,$index);
	}
}

sub red {
	my $self = shift;
	my $index = shift;
	my $c;
	if (@_) {
		$c = shift;
		return SDL::ColorR(
			SDL::PaletteColors($$self,$index),$c);
	} else {	
		return SDL::ColorR(
			SDL::PaletteColors($$self,$index));
	}
}

sub green {
	my $self = shift;
	my $index = shift;
	my $c;
	if (@_) {
		$c = shift;
		return SDL::ColorG(
			SDL::PaletteColors($$self,$index),$c);
	} else {	
		return SDL::ColorG(
			SDL::PaletteColors($$self,$index));
	}
}

sub blue {
	my $self = shift;
	my $index = shift;
	my $c;
	if (@_) {
		$c = shift;
		return SDL::ColorB(
			SDL::PaletteColors($$self,$index),$c);
	} else {	
		return SDL::ColorB(
			SDL::PaletteColors($$self,$index));
	}
}

1;
