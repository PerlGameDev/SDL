#!/usr/bin/env perl
#
# Drawing.pm
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

package SDL::Tutorial::Drawing;

use strict;
use warnings;

use SDL;
use SDL::App;
use SDL::Rect;
use SDL::Color;

# change these values as necessary
my $title                      = 'My SDL Rectangle-Drawing App';
my ($width, $height, $depth)   = ( 640,   480, 16   );
my ($red, $green, $blue)       = ( 0x00, 0x00, 0xff );
my ($rect_width, $rect_height) = ( 100,   100       );
my ($rect_x,     $rect_y)      = ( 270,   190       );

my $app = SDL::App->new(
	-width  => $width,
	-height => $height,
	-depth  => $depth,
);

my $rect = SDL::Rect->new(
	-height => $rect_height,
	-width  => $rect_width,
	-x      => $rect_x,
	-y      => $rect_y,
);

my $color = SDL::Color->new(
	-r => $red,
	-g => $green,
	-b => $blue,
);

$app->fill( $rect, $color );
$app->update( $rect );

# your code here; remove the next line
sleep 2;

1;
__END__

=head1 NAME

SDL::Tutorial::Drawing - basic drawing with Perl SDL

=head1 SYNOPSIS

	# to read this tutorial
	$ perldoc SDL::Tutorial::Drawing

	# to create a bare-bones SDL app based on this tutorial
	$ perl -MSDL::Tutorial::Drawing=basic_app.pl -e 1

=head1 DRAWING BASICS

As explained in L<SDL::Tutorial>, all graphics in SDL live on a surface.
Consequently, all drawing operations operate on a surface, whether drawing on
it directly or blitting from another surface.  The important modules for this
exercise are L<SDL::Rect> and L<SDL::Color>.

As usual, we'll start by creating a L<SDL::App> object:

	use SDL::App;

	my $app = SDL::App->new(
		-width  => 640,
		-height => 480,
		-depth  => 16,
	);

=head2 Creating a New Surface with SDL::Rect

A SDL::Rect object is an SDL surface, just as an SDL::App object is.  As you'd
expect, you need to specify the size of this object as you create it.  You can
also specify its coordinates relative to the origin.

B<Note:>  The origin, or coordinates 0, 0, is at the upper left of the screen.

Here's how to create a square 100 pixels by 100 pixels centered in the window:

	use SDL::Rect;

	my $rect = SDL::Rect->new(
		-height => 100,
		-width  => 100,
		-x      => 270,
		-y      => 390,
	);

This won't actually display anything yet, it just creates a rectangular
surface.  Of course, even if it did display, you wouldn't see anything, as it
defaults to the background color just as C<$app> does.  That's where SDL::Color
comes in.

=head2 A Bit About Color

SDL::Color objects represent colors in the SDL world.  These colors are
additive, so they're represented as mixtures of Red, Green, and Blue
components.  The color values are traditionally given in hexadecimal numbers.
If you're exceedingly clever or really like the math, you can figure out which
values are possible by comparing them to your current bit depth.  SDL does a
lot of autoconversion for you, though, so unless extreme speed or pedantic
detail are important, you can get by without worrying too much.

Creating a color object is reasonably easy.  As the color scheme is additive,
the lower the number for a color component, the less of that color.  The higher
the number, the higher the component.  Experimentation may be your best bet, as
these aren't exactly the primary colors you learned as a child (since that's a
subtractive scheme).

Let's create a nice, full blue:

	use SDL::Color;

	my $color = SDL::Color->new(
		-r => 0x00,
		-g => 0x00,
		-b => 0xff,
	);

B<Note:>  The numbers are in hex; if you've never used hex notation in Perl
before, the leading C<0x> just signifies that the rest of the number is in
base-16.  In this case, the blue component has a value of 255 and the red and
green are both zero.

=head2 Filling Part of a Surface

The C<fill()> method of SDL::Surface fills a given rectangular section of the
surface with the given color.  Since we already have a rect and a color, it's
as easy as saying:

	$app->fill( $rect, $color );

That's a little subtle; it turns out that the SDL::Rect created earlier
represents a destination within the surface of the main window.  It's not
attached to anything else.  We could re-use it later, as necessary.

=head2 Updating the Surface

If you try the code so far, you'll notice that it still doesn't display.  Don't
fret.  All that's left to do is to call C<update()> on the appropriate surface.
As usual, C<update()> takes a Rect to control which part of the surface to
update.  In this case, that's:

	$app->update( $rect );

This may seem like a useless extra step, but it can be quite handy.  While
drawing to the screen directly seems like the fastest way to go, the
intricacies of working with hardware with the appropriate timings is tricky.

=head2 Working With The App

You can, of course, create all sorts of Rects with different sizes and
coordinates as well as varied colors and experiment to your heart's content
drawing them to the window.  It's more fun when you can animate them smoothly,
though.

That, as usual, is another tutorial.

=head1 SEE ALSO

=over 4

=item L<SDL::Tutorial>

the basics of Perl SDL.

=item L<SDL::Tutorial::Animation>

basic animation techniques

=back

=head1 AUTHOR

chromatic, E<lt>chromatic@wgz.orgE<gt>

Written for and maintained by the Perl SDL project, L<http://sdl.perl.org/>.

=head1 BUGS

No known bugs.

=head1 COPYRIGHT

Copyright (c) 2003 - 2004, chromatic.  All rights reserved.  This module is
distributed under the same terms as Perl itself, in the hope that it is useful
but certainly under no guarantee.
