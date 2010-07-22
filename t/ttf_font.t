#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;

BEGIN {
	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

	if ( !SDL::Config->has('SDL_ttf') ) {
		plan( skip_all => 'SDL_ttf support not compiled' );
	}
}

use SDL::TTF;
use SDL::TTF::Font;
use SDL::Version;

my $lv = SDL::TTF::linked_version();
my $cv = SDL::TTF::compile_time_version();

isa_ok( $lv, 'SDL::Version', '[linked_version] returns a SDL::Version object' );
isa_ok(
	$cv, 'SDL::Version',
	'[compile_time_version] returns a SDL::Version object'
);
printf(
	"got version: %d.%d.%d/%d.%d.%d\n",
	$lv->major, $lv->minor, $lv->patch, $cv->major, $cv->minor, $cv->patch
);

is( SDL::TTF::init(), 0, "[init] succeeded" );

isa_ok(
	SDL::TTF::Font->new( 'test/data/aircut3.ttf', 24 ),
	'SDL::TTF::Font',
	"[new] with font and size"
);
isa_ok(
	SDL::TTF::Font->new( 'test/data/aircut3.ttf', 24, 0 ),
	'SDL::TTF::Font',
	"[new] with font, size and index"
);

is( SDL::TTF::quit(), undef, "[quit] ran" );

done_testing;

sleep(1);
