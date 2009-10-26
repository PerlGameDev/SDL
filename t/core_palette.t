#!perl
use strict;
use warnings;
use Test::More tests => 9;
use_ok('SDL::Palette');

can_ok('SDL::Palette', qw/ ncolors colors color_index /); 

use SDL;
use SDL::Surface;
use SDL::PixelFormat;

SDL::Init(SDL_INIT_VIDEO);

my $display = SDL::SetVideoMode(640,480,32, SDL_SWSURFACE );

isa_ok($display->format, 'SDL::PixelFormat', 'Are we a SDL::PixelFormat?');

is( !defined $display->format->palette , 1, 'Palette is not defined as BitPerPixels is greater then 8');

$display = SDL::SetVideoMode(640,480,8, SDL_SWSURFACE );
isa_ok($display->format, 'SDL::PixelFormat', 'Are we a SDL::PixelFormat?');

isa_ok( $display->format->palette , 'SDL::Palette', 'Palette is SDL::Palette when BitPerPixels is 8 ');

is( $display->format->palette->ncolors, 256, '256 colors in palette');

isa_ok( $display->format->palette->colors(), 'ARRAY', 'Palette->colors[x] is a color');

isa_ok( $display->format->palette->color_index(23), 'SDL::Color', 'Palette->color_index() is a SDL::Color');

