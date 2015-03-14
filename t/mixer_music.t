#!/usr/bin/perl -w
use strict;

my $audiodriver;

BEGIN {
	use Config;
	if ( !$Config{'useithreads'} ) {
		print("1..0 # Skip: Perl not compiled with 'useithreads'\n");
		exit(0);
	}
	use SDL;
	use SDL::Config;
	require threads;
	require threads::shared;

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
use SDL::Mixer::Music;
use SDL::Mixer::Samples;
use SDL::RWOps;
use SDL::Version;

my $v = SDL::Mixer::linked_version();

is( SDL::Mixer::open_audio( 44100, SDL::Audio::AUDIO_S16SYS, 2, 4096 ),
	0, '[open_audio] ran'
);

my $finished : shared        = 0;
my $mix_func_called : shared = 0;

sub mix_func {
	my $position = shift; # position
	my $length   = shift; # length of bytes we have to put in stream
	my @stream   = '';

	$mix_func_called++;

	# printf("[hook_music] callback: position=%8s, stream length=%6s\n", $position, $length);

	for ( my $i = 0; $i < $length; $i++ ) {
		push( @stream, ( ( $i + $position ) & 0xFF ) );
	}

	return @stream;
}

my $delay         = 100;
my $wav_test_file = 'test/data/silence.wav';
my $ogg_test_file = 'test/data/silence.ogg';
my $volume1       = 2;
my $volume2       = 1;

if ( $ENV{'SDL_RELEASE_TESTING'} ) {
	$delay         = 2000;
	$wav_test_file = 'test/data/sample.wav';
	$ogg_test_file = 'test/data/sample.ogg';
	$volume1       = 20;
	$volume2       = 10;
}

SDL::Mixer::Music::volume_music($volume1);
is( SDL::Mixer::Music::volume_music($volume2),
	$volume1, "[volume_music] was $volume1, now set to $volume2"
);

sub callback {

	# printf("[hook_music_finished] callback called\n", shift);
	$finished++;
}

SKIP:
{
	skip( 'No sound unless SDL_RELEASE_TESTING', 5 )
		unless $ENV{'SDL_RELEASE_TESTING'};
	SDL::Mixer::Music::hook_music_finished('main::callback');
	pass '[hook_music_finished] registered callback';

	SDL::Mixer::Music::hook_music( 'main::mix_func', 0 );
	pass '[hook_music] registered custom music player';
	is( SDL::Mixer::Music::get_music_hook_data(),
		0, "[get_music_hook_data] should return 0"
	);

	SDL::delay(1000);

	SDL::Mixer::Music::hook_music();
	pass '[hook_music] unregistered custom music player';
	SDL::delay($delay);
	is( $mix_func_called > 0, 1, "[hook_music] called $mix_func_called times" );
}

SKIP:
{
	skip( 'Version 1.2.7 needed', 3 ) if $v < 1.2.7;

	my $rw = SDL::RWOps->new_file( $ogg_test_file, "rb" );
	isa_ok( $rw, 'SDL::RWOps', '[SDL::RWOps->new_file]' );
	my $sample_music_rw = SDL::Mixer::Music::load_MUS_RW( $rw );
	isa_ok( $sample_music_rw, 'SDL::Mixer::MixMusic', '[load_MUS_RW]' );
	is( SDL::Mixer::Music::play_music( $sample_music_rw, 0 ),
		0, "[play_music_rw] plays $wav_test_file"
	);
}

my $wav_music = SDL::Mixer::Music::load_MUS($wav_test_file);
my $ogg_music = SDL::Mixer::Music::load_MUS($ogg_test_file);
isa_ok( $wav_music, 'SDL::Mixer::MixMusic', '[load_MUS]' );
is( SDL::Mixer::Music::play_music( $wav_music, 0 ),
	0, "[play_music] plays $wav_test_file"
);

SKIP:
{
	skip( 'Version 1.2.9 needed', 2 ) if $v < 1.2.9;

	my $num_decoders = SDL::Mixer::Music::get_num_music_decoders();
	is( $num_decoders >= 0,
		1, "[get_num_music_decoders] $num_decoders decoders available"
	);

	my $decoder = SDL::Mixer::Music::get_music_decoder(0);
	isnt( $decoder, undef, "[get_music_decoder] got $decoder" );
}

SDL::delay($delay);

is( SDL::Mixer::Music::playing_music(), 1, "[playing_music] music is playing" );
is( SDL::Mixer::Music::get_music_type($wav_music),
	MUS_WAV, "[get_music_type] $wav_test_file is MUS_WAV"
);
is( SDL::Mixer::Music::get_music_type(),
	MUS_WAV, "[get_music_type] currently playing MUS_WAV"
);

SDL::delay($delay);

is( SDL::Mixer::Music::pause_music(),  undef, "[pause_music] ran" );
is( SDL::Mixer::Music::paused_music(), 1,     "[paused_music] music is paused" );

SDL::delay($delay);

is( SDL::Mixer::Music::resume_music(),  undef, "[resume_music] ran" );
is( SDL::Mixer::Music::playing_music(), 1,     "[paused_music] music is playing" );
is( SDL::Mixer::Music::fading_music(),
	MIX_NO_FADING, "[fading_music] music is not fading"
);
is( SDL::Mixer::Music::rewind_music(), undef, "[rewind_music] ran" );

SDL::delay($delay);

is( SDL::Mixer::Music::fade_out_music(2000), 1, "[fade_out_music] $delay ms" );
is( SDL::Mixer::Music::fading_music(),
	MIX_FADING_OUT, "[fading_music] music is fading out"
);

SDL::delay(3000);

is( SDL::Mixer::Music::halt_music(), 0, '[halt_music]' );
is( SDL::Mixer::Music::set_music_cmd("mpeg123 -q"),
	0, '[set_music_cmd] we can specify an external player'
);
is( SDL::Mixer::Music::set_music_cmd(),
	0, '[set_music_cmd] return to the internal player'
);
is( SDL::Mixer::Music::fade_in_music( $wav_music, 0, 2000 ),
	0, "[fade_in_music] $delay ms"
);

SDL::delay(100);

is( SDL::Mixer::Music::fading_music(),
	MIX_FADING_IN, "[fading_music] music is fading in"
);
is( SDL::Mixer::Music::halt_music(), 0, '[halt_music]' );

SKIP:
{
	skip( 'We need an MOD/OGG/MP3 for positioning', 2 )
		unless $ogg_test_file =~ /\.(ogg|mod|mp3)$/;
	is( SDL::Mixer::Music::fade_in_music_pos( $ogg_music, 0, 2000, 2.5 ),
		0, "[fade_in_music_pos] $delay ms, beginning at 2.5 ms"
	);
	is( SDL::Mixer::Music::set_music_position(2.5),
		0, "[set_music_position] skipping 2.5 ms"
	);
	SDL::Mixer::Music::halt_music();
}

SKIP:
{
	skip( 'No sound unless SDL_RELEASE_TESTING', 2 )
		unless $ENV{'SDL_RELEASE_TESTING'};
	is( $finished > 0,
		1, "[hook_music_finished] called the callback $finished times"
	);
	SDL::Mixer::Music::hook_music_finished();
	pass '[hook_music_finished] unregistered callback';
}
SDL::delay($delay);

SDL::Mixer::close_audio();
pass '[close_audio] ran';

if ($audiodriver) {
	$ENV{SDL_AUDIODRIVER} = $audiodriver;
} else {
	delete $ENV{SDL_AUDIODRIVER};
}

done_testing();
