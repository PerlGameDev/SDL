#!/usr/bin/env perl
#
# Animation.pm
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

package SDL::Tutorial::Animation;

use strict;
use warnings;

use SDL;
use SDLx::App;
use SDL::Rect;
use SDL::Color;
use SDL::Video;

# change these values as necessary
my $title = 'My SDL Animation';
my ( $width,      $height,      $depth )  = ( 640,  480,  16 );
my ( $bg_r,       $bg_g,        $bg_b )   = ( 0x00, 0x00, 0x00 );
my ( $rect_r,     $rect_g,      $rect_b ) = ( 0x00, 0x00, 0xff );
my ( $rect_width, $rect_height, $rect_y ) = ( 100,  100,  190 );

my $app = SDLx::App->new(
    -width  => $width,
    -height => $height,
    -depth  => $depth,
);

my $color = SDL::Video::map_RGB( $app->format, $rect_r, $rect_g, $rect_b, );

my $bg_color = SDL::Video::map_RGB( $app->format, $bg_r, $bg_g, $bg_b, );

my $background = SDL::Rect->new( 0, 0, $width, $height, );

my $rect = create_rect();

# your code here, perhaps
for my $x ( 0 .. 640 ) {
    $rect->x($x);
    draw_frame(
        $app,
        bg         => $background,
        bg_color   => $bg_color,
        rect       => $rect,
        rect_color => $color,
    );
}

# remove this line
sleep 2;

# XXX - if you know why I need to create a new rect here, please tell me!
$rect = create_rect();
my $old_rect = create_rect();

# your code also here, perhaps
for my $x ( 0 .. 640 ) {
    $rect->x($x);
    draw_undraw_rect(
        $app,
        rect       => $rect,
        old_rect   => $old_rect,
        rect_color => $color,
        bg_color   => $bg_color,
    );
    $old_rect->x($x);
}

# your code almost certainly follows; remove this line
sleep 2;

sub create_rect {
    return SDL::Rect->new( 0, $rect_y, $rect_width, $rect_height, );
}

sub draw_frame {
    my ( $app, %args ) = @_;

    SDL::Video::fill_rect( $app, $args{bg},   $args{bg_color} );
    SDL::Video::fill_rect( $app, $args{rect}, $args{rect_color} );
    SDL::Video::update_rects( $app, $args{bg} );
}

sub draw_undraw_rect {
    my ( $app, %args ) = @_;

    SDL::Video::fill_rect( $app, $args{old_rect}, $args{bg_color} );
    SDL::Video::fill_rect( $app, $args{rect},     $args{rect_color} );
    SDL::Video::update_rects( $app, $args{old_rect} );
    SDL::Video::update_rects( $app, $args{rect} );
}

1;

