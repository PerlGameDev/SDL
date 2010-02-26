#!perl
use strict;
use warnings;
use SDL;
use SDL::Config;
use SDL::GFX::Framerate;
use SDL::GFX::FPSManager;
use Test::More;

use lib 't/lib';
use SDL::TestTool;

if( !SDL::TestTool->init(SDL_INIT_VIDEO) )
{
    plan( skip_all => 'Failed to init video' );
}
elsif( !SDL::Config->has('SDL_gfx_framerate') )
{
    plan( skip_all => 'SDL_gfx_framerate support not compiled' );
}
else
{
    plan( tests => 5 );
}

# init
my $fps = SDL::GFX::FPSManager->new(0, 0, 0, 0);
is( SDL::GFX::Framerate::init($fps), undef, '[init] returns undef' );

# get
my $rate = SDL::GFX::Framerate::get($fps);
is( $rate, 30, "[rate] is 30 by default" );

# set
SDL::GFX::Framerate::set($fps, 60);
is( SDL::GFX::Framerate::get($fps), 60, "[rate] successfully set to 60" );

# delay
is( SDL::GFX::Framerate::delay($fps), undef, "[delay] return undef" );

SDL::delay(100);

pass 'Are we still alive? Checking for segfaults';

done_testing;


