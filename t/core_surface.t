#!perl -w
# Copyright (C) 2009 kthakore
#
# Spec tests for SDL::Surface
#

BEGIN {
    unshift @INC, 'blib/lib', 'blib/arch';
}

use strict;
use SDL;
use SDL::Config;
use SDL::Surface;
use SDL::App;
use SDL::Rect;
use SDL::Color;
use Test::More tests => 15;

my $surface
    = SDL::Surface->new( SDL::SDL_ANYFORMAT(), 640, 320, 8, 0, 0, 0, 0 );
isa_ok( $surface, 'SDL::Surface' );
is( $surface->w,     640, 'surface has width' );
is( $surface->h,     320, 'surface has height' );
is( $surface->pitch, 640, 'surface has pitch' );
my $clip_rect = SDL::Rect->new( 0, 0, 0, 0 );
SDL::GetClipRect( $surface, $clip_rect );
isa_ok( $clip_rect, 'SDL::Rect' );
is( $clip_rect->x, 0,   'clip_rect has x' );
is( $clip_rect->y, 0,   'clip_rect has y' );
is( $clip_rect->w, 640, 'clip_rect has width' );
is( $clip_rect->h, 320, 'clip_rect has height' );

my $image = SDL::Surface->load('test/data/logo.png');
is( $image->w, 608, 'image has width' );
is( $image->h, 126, 'image has height' );

$surface->fill_rect( SDL::Rect->new( 0, 0, 32, 32 ),
    SDL::Color->new( 200, 200, 200 ) );
ok( 1, 'Managed to fill_rect' );

my $small_rect = SDL::Rect->new( 0, 0, 64, 64 );
$image->blit( $small_rect, $surface, $small_rect );
ok( 1, 'Managed to blit' );

#my $image_format = $surface->display;
#$surface->update_rect( 0, 0, 32, 32 );
#ok( 1, 'Managed to update_rect' );
#$surface->update_rects( SDL::Rect->new( 0, 0, 32, 32 ) );
#ok( 1, 'Managed to update_rects' );

my $app = SDL::App->new(
    -title  => "Test",
    -width  => 640,
    -height => 480,
    -init   => SDL_INIT_VIDEO
);

pass 'did this pass';

my $rect = SDL::Rect->new( 0, 0, $app->w, $app->h );

my $blue = SDL::Color->new( 0x00, 0x00, 0xff, );

$app->fill_rect( $rect, $blue );

diag( 'This is in surface : ' . SDL::Surface::get_pixels($app) );

pass 'did this pass';

