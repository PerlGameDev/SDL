#!perl 
# basic testing of SDL::SMPEG

BEGIN {
	unshift @INC, 'blib/lib', 'blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

if ( SDL::Config->has('smpeg') ) {
	plan( tests => 4 );
} else {
	plan( skip_all => ( SDL::Config->has('smpeg') ? '' : ' smpeg support not compiled' ) );
}

use_ok('SDL::SMPEG');

can_ok(
	'SDL::SMPEG', qw/
		new
		error
		audio
		video
		volume
		display
		scale
		play
		pause
		stop
		rewind
		seek
		skip
		loop
		region
		frame
		info
		status
		/
);

my ($smpeg, $mpeg) = SDL::SMPEG->new(-name => 'test/data/test-mpeg.mpg' );
isa_ok( $smpeg, 'SDL::SMPEG' );
isa_ok( $mpeg, 'SDL::MPEG' );

sleep(2);
