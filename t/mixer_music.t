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
	skip ('[hook_music] leaks mem', 1);
	SDL::Mixer::Music::hook_music( $mix_func, 0 );       pass '[hook_music] registered custom music player';
}
#my $callback  = sub{ printf("[channel_finished] callback called for channel %d\n", shift); $finished++; };
#SDL::Mixer::Music::hook_music_finished( $callback ); pass '[hook_music_finished] registered callback';

my $delay           = 100;
my $audio_test_file = 'test/data/silence.wav';

if($ENV{'RELEASE_TESTING'})
{
	$delay           = 2000;
	#$audio_test_file = 'test/data/78plus_sie_will.mp3';
}

my $sample_music = SDL::Mixer::Music::load_MUS($audio_test_file);
isa_ok( $sample_music, 'SDL::Mixer::MixMusic', '[load_MUS]' );
is( SDL::Mixer::Music::play_music($sample_music, 0), 0,     "[play_music] plays $audio_test_file" );

SDL::delay($delay);

is( SDL::Mixer::Music::playing_music(),              1,     "[playing_music] music is playing" );

SDL::delay($delay);

is( SDL::Mixer::Music::pause_music(),                undef, "[pause_music] ran" );
is( SDL::Mixer::Music::paused_music(),               1,     "[paused_music] music is paused" );

SDL::delay($delay);

is( SDL::Mixer::Music::resume_music(),               undef, "[resume_music] ran" );
is( SDL::Mixer::Music::playing_music(),              1,     "[paused_music] music is playing" );
is( SDL::Mixer::Music::halt_music(),                 0,     '[halt_music]' );

SDL::delay(1000);

my @done = qw/
load_MUS
play_music
halt_music
playing_music
pause_music
paused_music
resume_music
hook_music
/;

my @left = qw/
getnummusicdecoders	  	
getmusicdecoder	  	
freemusic	  	
fadeinmusic	  	
fadeinmusicpos	  	
volumemusic	  	
rewindmusic	  	
setmusicposition	  	
setmusiccmd	  	
fadeoutmusic	  	
hookmusicfinished	  	
getmusictype	  	
fadingmusic	  	
getmusichookdata	  	
/	
;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

#TODO:
#{
#    local $TODO = $why;
#    fail "Not Implmented SDL::Mixer::*::$_" foreach(@left)
#}
diag $why;

SDL::Mixer::close_audio(); pass '[close_audio] ran';

SKIP:
{
	skip ('hook_music leaks mem', 1);
	is ( $mix_func_called > 0, 1 , "[hook_music] called $mix_func_called times" );
}
#is ( $finished        > 0, 1 , "[hook_music_finished] called the callback $finished times");

SDL::quit();

done_testing();
