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

use_ok( 'SDLx::Text' );

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

use FindBin;
use File::Spec;
my $score = SDLx::Text->new(
       font => File::Spec->catfile($FindBin::Bin, '..', 'share', 'GenBasR.ttf')
);

isa_ok( $score, 'SDLx::Text');

$score->text('Hello!');

is( $score->w, 60, 'Hello! is 62 px wide!' );
is( $score->h, 28, 'Hello! is 28 px high!' );


END {

	if ($videodriver) {
		$ENV{SDL_VIDEODRIVER} = $videodriver;
	} else {
		delete $ENV{SDL_VIDEODRIVER};
	}

	done_testing;
}
