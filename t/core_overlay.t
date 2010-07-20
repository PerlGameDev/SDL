#!perl
use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Surface;
use SDL::Video;

use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
    plan( skip_all => 'Failed to init video' );
}
else {
    plan( tests => 2 );
}

use_ok('SDL::Overlay');

my $display = SDL::Video::set_video_mode( 640, 480, 32, SDL_ANYFORMAT );

my $overlay = SDL::Overlay->new( 100, 100, SDL_YV12_OVERLAY, $display );

isa_ok( $overlay, 'SDL::Overlay' );

if ($videodriver) {
    $ENV{SDL_VIDEODRIVER} = $videodriver;
}
else {
    delete $ENV{SDL_VIDEODRIVER};
}

sleep(2);
