#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;

BEGIN
{
	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

	if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
	    plan( skip_all => 'Failed to init sound' );
	}
	elsif( !SDL::Config->has('SDL_mixer') )
	{
	    plan( skip_all => 'SDL_mixer support not compiled' );
	}
}

use SDL::Mixer;
use SDL::Mixer::Music;
use SDL::Mixer::Samples;
use SDL::Version;

my $v = SDL::Mixer::linked_version();

is( SDL::Mixer::open_audio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 ),  0, '[open_audio] ran');

my $finished        = 0;
my $mix_func_called = 0;
my $mix_func        = sub
{
	my $position = shift; # position
	my $length   = shift; # length of bytes we have to put in stream
	my @stream   = '';

	printf("[hook_music] called: position=%8s, stream length=%6s\n", $position, $length);
	$mix_func_called++;
	
	if($ENV{'RELEASE_TESTING'})
	{
		for(my $i = 0; $i < $length; $i++)
		{
			push(@stream, (($i + $position) & 0xFF));
		}
	}

	return @stream;
};

SKIP:
{
	skip ('[hook_music] leaks mem', 2);
	SDL::Mixer::Music::hook_music( $mix_func, 0 ); pass '[hook_music] registered custom music player';
	is( SDL::Mixer::Music::get_music_hook_data(), 0,    "[get_music_hook_data] should return 0" );
}
my $callback  = sub{ printf("[hook_music_finished] callback called\n", shift); $finished++; };
SDL::Mixer::Music::hook_music_finished( $callback ); pass '[hook_music_finished] registered callback';

my $delay           = 100;
my $audio_test_file = 'test/data/silence.wav';
my $volume1         = 2;
my $volume2         = 1;

if($ENV{'RELEASE_TESTING'})
{
	$delay           = 2000;
	$audio_test_file = 'test/data/sample.wav';
	$volume1         = 20;
	$volume2         = 10;
}

SDL::Mixer::Music::volume_music($volume1);
is( SDL::Mixer::Music::volume_music($volume2),                $volume1,       "[volume_music] was $volume1, now set to $volume2" );
my $sample_music = SDL::Mixer::Music::load_MUS($audio_test_file);
isa_ok( $sample_music, 'SDL::Mixer::MixMusic', '[load_MUS]' );
is( SDL::Mixer::Music::play_music($sample_music, 0),          0,              "[play_music] plays $audio_test_file" );

SKIP:
{
	skip ( 'Version 1.2.9 needed', 2) unless ($v->major >= 1 && $v->minor >= 2 && $v->patch >= 9);
	
	my $num_decoders = SDL::Mixer::Music::get_num_music_decoders();
	is( $num_decoders >= 0, 1,     "[get_num_music_decoders] $num_decoders decoders available" );
	
	my $decoder = SDL::Mixer::Music::get_music_decoder(0);
	isnt( $decoder,         undef, "[get_music_decoder] got $decoder" );
}

SDL::delay($delay);

is( SDL::Mixer::Music::playing_music(),                       1,              "[playing_music] music is playing" );
is( SDL::Mixer::Music::get_music_type($sample_music),         MUS_WAV,        "[get_music_type] $audio_test_file is MUS_WAV" );
is( SDL::Mixer::Music::get_music_type(),                      MUS_WAV,        "[get_music_type] currently playing MUS_WAV" );


SDL::delay($delay);

is( SDL::Mixer::Music::pause_music(),                         undef,          "[pause_music] ran" );
is( SDL::Mixer::Music::paused_music(),                        1,              "[paused_music] music is paused" );

SDL::delay($delay);

is( SDL::Mixer::Music::resume_music(),                        undef,          "[resume_music] ran" );
is( SDL::Mixer::Music::playing_music(),                       1,              "[paused_music] music is playing" );
is( SDL::Mixer::Music::fading_music(),                        MIX_NO_FADING,  "[fading_music] music is not fading" );
is( SDL::Mixer::Music::rewind_music(),                        undef,          "[rewind_music] ran" );

SDL::delay($delay);

is( SDL::Mixer::Music::fade_out_music(2000),                  1,              "[fade_out_music] $delay ms" );
is( SDL::Mixer::Music::fading_music(),                        MIX_FADING_OUT, "[fading_music] music is fading out" );

SDL::delay($delay);

is( SDL::Mixer::Music::halt_music(),                          0,              '[halt_music]' );
is( SDL::Mixer::Music::set_music_cmd("mpeg123 -q"),           0,              '[set_music_cmd] we can specify an external player' );
is( SDL::Mixer::Music::set_music_cmd(),                       0,              '[set_music_cmd] return to the internal player' );
is( SDL::Mixer::Music::fade_in_music($sample_music, 0, 2000), 0,              "[fade_in_music] $delay ms" );

SDL::delay(100);

is( SDL::Mixer::Music::fading_music(),                        MIX_FADING_IN,  "[fading_music] music is fading in" );
is( SDL::Mixer::Music::halt_music(),                          0,              '[halt_music]' );

SKIP:
{
	skip('We need an MOD/OGG/MP3 for positioning', 2) unless $audio_test_file =~ /\.(ogg|mod|mp3)$/;
	is( SDL::Mixer::Music::fade_in_music_pos($sample_music, 0, 2000, 2.5), 0,     "[fade_in_music_pos] $delay ms, beginning at 2.5 ms" );
	is( SDL::Mixer::Music::set_music_position(2.5),                        0,     "[set_music_position] skipping 2.5 ms" );
}

SDL::delay($delay);

SDL::Mixer::close_audio(); pass '[close_audio] ran';

SKIP:
{
	skip ('[hook_music] leaks mem', 1);
	is ( $mix_func_called > 0, 1 , "[hook_music] called $mix_func_called times" );
}

# I dont know how the callback will ever be called.
#is ( $finished        > 0, 1 , "[hook_music_finished] called the callback $finished times");

my @done = qw/
load_MUS
play_music
halt_music
playing_music
pause_music
paused_music
resume_music
hook_music
fade_out_music
fade_in_music
fading_music
rewind_music
fade_in_music_position
set_music_position
get_num_music_decoders
get_music_decoder
volumemusic
get_music_type
set_music_cmd
get_music_hook_data
/;

my @left = qw/
hook_music_finished
/;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

diag $why;

SDL::quit();

done_testing();
