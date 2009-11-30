#!perl
use strict;
use warnings;
use SDL;
use SDL::Config;
use SDL::Video;
use SDL::Surface;
use SDL::GFX::Primitives;
use Test::More;

use lib 't/lib';
use SDL::TestTool;

if( !SDL::TestTool->init(SDL_INIT_VIDEO) )
{
    plan( skip_all => 'Failed to init video' );
}
elsif( !SDL::Config->has('SDL_gfx') )
{
    plan( skip_all => 'SDL_gfx support not compiled' );
}
else
{
    plan( tests => 5 );
}

use_ok('SDL');
use_ok('SDL::Surface');
use_ok('SDL::GFX::Primitives');

my $display = SDL::Video::set_video_mode(640,480,32, SDL_HWSURFACE );

if(!$display)
{
	plan skip_all => 'Couldn\'t set video mode: ' . SDL::get_error();
}

SDL::Video::lock_surface($display) if(SDL::Video::MUSTLOCK($display));

is( SDL::GFX::Primitives::pixel_color($display, 5, 5, 0xFFFFFF00), 0,   'pixel_color' );

SDL::Video::unlock_surface($display) if(SDL::Video::MUSTLOCK($display));

SDL::Video::update_rect($display, 0, 0, 640, 480); 

SDL::delay(2000);

pass 'Are we still alive? Checking for segfaults';
