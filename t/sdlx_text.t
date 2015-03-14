use strict;
use warnings;
use SDL;
use SDL::Config;
use SDL::Color;
use SDL::Surface;
use SDLx::App;
BEGIN {
	use FindBin;
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

use File::Spec;
my $score = SDLx::Text->new(
       font => File::Spec->catfile($FindBin::Bin, '..', 'share', 'GenBasR.ttf')
);

isa_ok( $score, 'SDLx::Text');

is($score->x, 0, 'default x position');
is($score->y, 0, 'default y position');
is($score->h_align, 'left', 'default horizontal alignment');
isa_ok( $score->font, 'SDL::TTF::Font' );
isa_ok($score->color, 'SDL::Color', 'default color');
is($score->size, 24, 'default size');

$score->text('Hello');

is( $score->text, 'Hello', 'text() as a getter' );
ok( $score->w >= 50 && $score->w <= 53, 'Hello! is 50..53 px wide!' );
is( $score->h, 28, 'Hello! is 28 px high!' );
isa_ok($score->surface, 'SDL::Surface');

my $value = undef;
my $other_self = $score->text($value);
isa_ok($score, 'SDLx::Text');

END {

	if ($videodriver) {
		$ENV{SDL_VIDEODRIVER} = $videodriver;
	} else {
		delete $ENV{SDL_VIDEODRIVER};
	}

	done_testing;
}
