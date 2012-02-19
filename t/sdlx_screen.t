use strict;
use warnings;
use Test::More;
use SDL;
use SDLx::Screen;
use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
}

my $surface = SDLx::Screen::screenshot();

if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

pass 'Final SegFault test';

done_testing;
