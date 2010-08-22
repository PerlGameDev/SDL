#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Video;
use SDLx::Queue;
use Test::More;
use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
}


SDLx::Queue::enqueue( 'foo', 'Data' );
SDLx::Queue::enqueue( 'foo1', 'Data' );

SDLx::Queue::enqueue( 'foo1', 'Data 1' );
SDLx::Queue::enqueue( 'foo', 'Data 1' );


is( SDLx::Queue::dequeue( 'foo1' ), 'Data' , 'Got data for foo queue');

is( SDLx::Queue::dequeue( 'foo' ), 'Data 1', 'Got data for foo1 queue');

is( SDLx::Queue::dequeue( 'foo' ), 'Data', 'Got data for foo1 queue');

is( SDLx::Queue::dequeue( 'foo1' ), 'Data 1' , 'Got data for foo queue');


if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

#SDL::quit();
pass 'Are we still alive? Checking for segfaults';

done_testing;
sleep(2);
