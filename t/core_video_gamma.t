#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Color;
use SDL::Surface;
use SDL::Config;
use SDL::Overlay;
use Test::More;
use SDL::Rect;
use SDL::Video;
use SDL::VideoInfo;

use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
}

my $zero = [ 0, 0, 0, 0 ];
SDL::Video::set_gamma_ramp( $zero, $zero, $zero );
pass '[set_gamma_ramp] ran';

my ( $r, $g, $b ) = ( [], [], [] );
SDL::Video::get_gamma_ramp( $r, $g, $b );
pass '[get_gamma_ramp] ran got ' . @{$r};
is( @{$r}, 256, '[get_gamma_ramp] got 256 gamma ramp red back' );
is( @{$g}, 256, '[get_gamma_ramp] got 256 gamma ramp green back' );
is( @{$b}, 256, '[get_gamma_ramp] got 256 gamma ramp blue back' );

SDL::Video::set_gamma( 1.0, 1.0, 1.0 );
pass '[set_gamma] ran ';

if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

pass 'Are we still alive? Checking for segfaults';

sleep(1);

done_testing();
