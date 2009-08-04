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

package SDL::Palette;
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

__END__;

=pod

=head1 NAME

SDL::Palette - a perl extension

=head1 DESCRIPTION

L<SDL::Palette> provides an interface to the SDL_Palette structures,
and can be used to set the color values of an existing palette's indexes.

=head1 METHODS

=head2 blue ( index, [value] )

Fetches and sets the blue component of the color at index.

=head2 green ( index, [value] )

Fetches and sets the green component of the color at index.

=head2 red ( index, [value] )

Fetches and sets the red component of the color at index.

=head2 color ( index, [ r, g, b ] )

Fetches and sets the RGB, returns an SDL_Color *.

=head2 size

Returns the size of the palette.

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl> L<SDL::Color> L<SDL::Surface>

=cut
