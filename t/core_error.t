#!/usr/bin/perl
use strict;
use warnings;
use SDL;
use Test::More tests => 5;

use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

SKIP:
{
    skip "Video fail", 1 unless SDL::TestTool->init(SDL_INIT_VIDEO);
    is( SDL::init(SDL_INIT_VIDEO), 0, '[init] returns 0 on success' );
}
SDL::set_error('Hello');
is( SDL::get_error, 'Hello', '[get_error] returns Hello' );

SDL::set_error( 'Hello %s!', 'SDL' );
is( SDL::get_error, 'Hello SDL!', '[get_error] returns Hello SDL!' );

SDL::set_error( 'Hello %s! Three is %d.', 'SDL', 3 );
is( SDL::get_error,
    'Hello SDL! Three is 3.',
    '[get_error] returns Hello SDL! Three is 3.'
);

SDL::clear_error();
is( SDL::get_error, '', '[get_error] returns no error' );
sleep(2);

if ($videodriver) {
    $ENV{SDL_VIDEODRIVER} = $videodriver;
}
else {
    delete $ENV{SDL_VIDEODRIVER};
}
