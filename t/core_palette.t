#!perl
use strict;
use warnings;
use Test::More;

use SDL;
use SDL::Surface;
use SDL::PixelFormat;
use SDL::Video;

use lib 't/lib';
use SDL::TestTool;

my $videodriver       = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
    plan( skip_all => 'Failed to init video' );
}
else
{
    plan( tests => 9);
}

use_ok('SDL::Palette');

can_ok('SDL::Palette', qw/ ncolors colors color_index /); 

my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );

isa_ok($display->format, 'SDL::PixelFormat', 'Are we a SDL::PixelFormat?');

ok( ! defined $display->format->palette , 'Palette is not defined as BitPerPixels is greater then 8');


my $disp = SDL::Video::set_video_mode(640,480,8, SDL_SWSURFACE );

SKIP:
{

skip ('Cannot open display: '.SDL::get_error(), 4) unless ($disp);
isa_ok($disp->format, 'SDL::PixelFormat', 'Are we a SDL::PixelFormat?');

isa_ok( $disp->format->palette , 'SDL::Palette', 'Palette is SDL::Palette when BitPerPixels is 8 ');

is( $disp->format->palette->ncolors, 256, '256 colors in palette');

isa_ok( $disp->format->palette->colors(), 'ARRAY', 'Palette->colors[x] is a color');

isa_ok( $disp->format->palette->color_index(23), 'SDL::Color', 'Palette->color_index() is a SDL::Color');
}

$ENV{SDL_VIDEODRIVER} = $videodriver;
