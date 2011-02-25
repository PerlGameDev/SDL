use strict;
use SDL;
use SDL::Config;
use SDL::Color;
use SDL::Surface;
use SDLx::App;
BEGIN {
	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

	if ( !SDL::Config->has('SDL_ttf') ) {
		plan( skip_all => 'SDL_ttf support not compiled' );
	}
}

use SDLx::Text;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};


my $score = SDLx::Text->new( font => 'test/data/aircut3.ttf' );

isa_ok( $score, 'SDLx::Text');

$score->text('Hello!');

is( $score->w, 56, 'Hello! is 56 px wide!' );
is( $score->h, 27, 'Hello! is 27 px high!' );


END {

	if ($videodriver) {
		$ENV{SDL_VIDEODRIVER} = $videodriver;
	} else {
		delete $ENV{SDL_VIDEODRIVER};
	}

	done_testing;
}
