#!/usr/bin/perl -w
use strict;
use warnings;
use SDL;
use SDL::Config;

my $audiodriver;

BEGIN {
	use Config;
	if ( !$Config{'useithreads'} ) {
		print("1..0 # Skip: Perl not compiled with 'useithreads'\n");
		exit(0);
	}
	use threads;
	use threads::shared;


	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

	$audiodriver = $ENV{SDL_AUDIODRIVER};
	$ENV{SDL_AUDIODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

	if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
		plan( skip_all => 'Failed to init sound' );
	} elsif ( !SDL::Config->has('SDL_mixer') ) {
		plan( skip_all => 'SDL_mixer support not compiled' );
	}
}

use SDL::Mixer;
use SDL::Mixer::Channels;
use SDL::Mixer::Samples;
my $can_open = SDL::Mixer::open_audio( 44100, SDL::Audio::AUDIO_S16SYS, 2, 4096 );

unless($can_open == 0) 
{
	plan( skip_all => 'Cannot open audio :'.SDL::get_error() );
}

is( $can_open ,
		0, '[open_audio] ran'
  );

is( SDL::Mixer::Channels::allocate_channels(4),
		4, "[allocate_channels] 4 channels allocated"
  );

my $finished :shared = 0;
my $callback = sub {
	my $channel = shift;
	printf( "[channel_finished] callback called for channel %d\n", $channel);
	$finished++;
};
SDL::Mixer::Channels::channel_finished($callback);
pass '[channel_finished] registered callback';

my $delay           = 500;
my $audio_test_file = 'test/data/silence.wav';

if ( $ENV{'SDL_RELEASE_TESTING'} ) {
	SDL::Mixer::Channels::volume( -1, 10 );
	is( SDL::Mixer::Channels::volume( -1, 20 ),
			10, "[volume] set to 20, previously was 10"
	  );
	$delay           = 2000;
	$audio_test_file = 'test/data/sample.wav';
} else {
	SDL::Mixer::Channels::volume( -1, 10 );
	is( SDL::Mixer::Channels::volume( -1, 1 ),
			10, "[volume] set to 1, previously was 10"
	  );
}

my $sample_chunk = SDL::Mixer::Samples::load_WAV($audio_test_file);
my $playing_channel = SDL::Mixer::Channels::play_channel( -1, $sample_chunk, -1 );
isnt(
		$playing_channel, -1,
		"[play_channel] plays $audio_test_file on channel " . $playing_channel
	);
is( SDL::Mixer::Channels::fading_channel($playing_channel),
		MIX_NO_FADING, "[fading_channel] channel $playing_channel is not fading"
  );
is( SDL::Mixer::Channels::playing($playing_channel),
		1, "[playing] channel $playing_channel is playing"
  );
is( SDL::Mixer::Channels::paused($playing_channel),
		0, "[paused] channel $playing_channel is not paused"
  );
ok( $delay, 'delay definedness madness test #1' );
my $fading_channels = SDL::Mixer::Channels::fade_out_channel( $playing_channel, $delay );
is( $fading_channels > 0,
		1, "[fade_out_channel] $delay ms for $fading_channels channel(s)"
  );
is( SDL::Mixer::Channels::fading_channel($playing_channel),
		MIX_FADING_OUT, "[fading_channel] channel $playing_channel is fading out"
  );
ok( $delay, 'delay definedness madness test #2' );
SDL::delay($delay);
ok( $delay, 'delay definedness madness test #3' );

$playing_channel = SDL::Mixer::Channels::fade_in_channel( -1, $sample_chunk, 0, $delay );
ok( $delay, 'delay definedness madness test #4' );

isnt(
		$playing_channel, -1,
		"[fade_in_channel] $delay ms for channel $playing_channel"
	);
is( SDL::Mixer::Channels::fading_channel($playing_channel),
		MIX_FADING_IN, "[fading_channel] channel $playing_channel is fading in"
  );
ok( $delay, 'delay definedness madness test #5' );

SDL::delay($delay);
ok( $delay, 'delay definedness madness test #6' );

SDL::Mixer::Channels::pause(-1);
pass '[pause] ran';
is( SDL::Mixer::Channels::paused($playing_channel),
		1, "[paused] channel $playing_channel is paused"
  );


SDL::delay( $delay / 4 );
ok( $delay, 'delay definedness madness test #7' );

SDL::Mixer::Channels::resume(-1);
pass '[resume] ran';

SDL::delay($delay);
ok( $delay, 'delay definedness madness test #8' );

is( SDL::Mixer::Channels::halt_channel($playing_channel),
		0, "[halt_channel] stop channel $playing_channel"
  );
is( SDL::Mixer::Channels::playing($playing_channel),
		0, "[playing] channel $playing_channel is not playing"
  );

SDL::delay($delay);
ok( $delay, 'delay definedness madness test #9' );

$playing_channel = SDL::Mixer::Channels::play_channel_timed( -1, $sample_chunk, 0, $delay );
ok( $delay, 'delay definedness madness test #10' );

isnt(
		$playing_channel, -1,
		"[play_channel_timed] play $delay ms for channel $playing_channel"
	);
SDL::delay( $delay / 4 );
ok( $delay, 'delay definedness madness test #11' );

my $expire_channel = SDL::Mixer::Channels::expire_channel( $playing_channel, $delay );
ok( $delay, 'delay definedness madness test #12' );

is( $expire_channel > 0,
		1,
		"[expire_channel] stops after $delay ms for $expire_channel channel(s)"
  );

SDL::delay($delay);
ok( $delay, 'delay definedness madness test #13' );

$playing_channel = SDL::Mixer::Channels::fade_in_channel_timed(
		-1, $sample_chunk, 0, $delay,
		$delay * 2
		);
ok( $delay, 'delay definedness madness test #14' );

isnt(
		$playing_channel, -1,
		"[fade_in_channel_timed] play " . ( $delay * 2 ) . " ms after $delay ms fade in for channel $playing_channel"
	);

isa_ok(
		SDL::Mixer::Channels::get_chunk($playing_channel),
		'SDL::Mixer::MixChunk', '[get_chunk]'
	  );

SDL::delay(1000);
ok( $delay, 'delay definedness madness test #15' );

SDL::Mixer::close_audio();
pass '[close_audio] ran';

is( $finished > 0,
		1, '[callback_finished] called the callback got ' . $finished
  );

if ($audiodriver) {
	$ENV{SDL_AUDIODRIVER} = $audiodriver;
} else {
	delete $ENV{SDL_AUDIODRIVER};
}

sleep(1);

done_testing();
