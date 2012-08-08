#!perl 
# basic testing of SDL::SMPEG

BEGIN {
	unshift @INC, 'blib/lib', 'blib/arch';
}

use strict;
use warnings;
use SDL;
use SDL::Config;

use Test::More;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};


if ( SDL::Config->has('smpeg') ) {
	if ( $ENV{SDL_RELEASE_TESTING} ) {
		plan( tests => 17 );
	} else {
		plan( skip_all => "Skiping test for now. EXPERIMENTAL" );
	}
} else {
	plan( skip_all => ( SDL::Config->has('smpeg') ? '' : ' smpeg support not compiled' ) );
}

use_ok('SDL::SMPEG');
use SDL::Video;

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

# Create a video as it is done in the SYNOPSIS for SDL::SMPEG
SCOPE: {
	my $smpeg = SDL::SMPEG->new(
		-name => 'test/data/test-mpeg.mpg',
	);
	isa_ok( $smpeg, 'SDL::SMPEG' );
}

# Get some information about a video
SCOPE: {

	# TODO: On the following line we don't use the same code as
	# above, intentionally so we can evade the failing test and
	# continue testing. Once the above test case passes, merge
	# this with the test case above.
	my ($smpeg) = SDL::SMPEG->new(
		-name => 'test/data/test-mpeg.mpg',
	);
	isa_ok( $smpeg, 'SDL::SMPEG' );

	# Get the video metadata
	my $mpeg = $smpeg->info;
	isa_ok( $mpeg, 'SDL::SMPEG::Info' );

	# Check it matches what we expect
	is( $mpeg->has_audio, 1,      '->has_audio ok' );
	is( $mpeg->has_video, 1,      '->has_video ok' );
	is( $mpeg->width,     160,    '->width ok' );
	is( $mpeg->height,    120,    '->height ok' );
	is( $mpeg->size,      706564, '->size ok' );
	is( $mpeg->offset,    2717,   '->offset ok' );
	is( $mpeg->frame,     0,      '->frame ok' );
	is( $mpeg->time,      0,      '->time ok' );
	like( $mpeg->length, qr/^21.3/, '->length ok' );

	# TODO: I'm not entirely sure this is meant to be zero
	is( $mpeg->fps, 0, '->fps ok' );

	# Create a display to attach the movie to
	my $surface = SDL::Video::set_video_mode(
		$mpeg->height,
		$mpeg->width,
		32,                        # Colour bits
		SDL::Video::SDL_SWSURFACE, # flags
	);
	isa_ok( $surface, 'SDL::Surface' );

	# Attach the movie to a surface
	is( $smpeg->display($surface), undef, '->display(surface) ok' );

	# Now that we are bound we should be able to do things
	# to the movie and have them actually work.
	# Confirm we can change where we are in the video.
	#	is( $smpeg->frame(5), undef, '->frame(5) ok' );
	$smpeg->play();

	# TODO: Figure out how this info object really works
	#is( $mpeg->current_frame, 5, '->frame updated in info object' );
}


if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

