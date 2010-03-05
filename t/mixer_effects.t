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
use SDL::Mixer::Channels;
use SDL::Mixer::Effects;
use SDL::Mixer::Samples;

is( SDL::Mixer::open_audio( 44100, SDL::Constants::AUDIO_S16, 2, 1024 ),  0, '[open_audio] ran');

my $delay           = 100;
my $audio_test_file = 'test/data/silence.wav';
SDL::Mixer::Channels::volume( -1,  1 );

if(1 || $ENV{'RELEASE_TESTING'})
{
	SDL::Mixer::Channels::volume( -1, 80 );
	$delay           = 5500;
	$audio_test_file = 'test/data/sample.wav';
}

my $sample_chunk    = SDL::Mixer::Samples::load_WAV($audio_test_file);
my $playing_channel = SDL::Mixer::Channels::play_channel( -1, $sample_chunk, -1 );

sub turn
{
	my $val = shift;
	
	return ((($val & 0xFF00) >> 8) | (($val & 0x00FF) << 8));
}

my $effect_func_called = 0;
my $effect_done_called = 0;
my @last_stream        = ();
my $effect_func        = sub
{
	my $channel  = shift;
	my $samples  = shift;
	my $position = shift;
	my @stream   = @_;

	$effect_func_called++;
	
	printf("[effect_func] callback: channel=%2s, position=%8s, samples=%6s\n", $channel, $position, $samples);
	
	my @stream2 = @stream;
	my $offset  = 13000;
	for(my $i = 0; $i < $samples; $i+=2)
	{
		if($i < $offset)
		{
			if(scalar(@last_stream))
			{
				$stream2[$i]     = $stream[$i]     * 0.6 + $last_stream[$samples + $i - $offset]     * 0.4; # left
				$stream2[$i + 1] = $stream[$i + 1] * 0.6 + $last_stream[$samples + $i - $offset + 1] * 0.4; # right
			}
		}
		else
		{
			$stream2[$i]     = $stream[$i]     * 0.6 + $stream[$i - $offset]     * 0.4; # left
			$stream2[$i + 1] = $stream[$i + 1] * 0.6 + $stream[$i - $offset + 1] * 0.4; # right
		}
	}
	
	@last_stream = @stream;
	return @stream2;
};
my $effect_done = sub
{
	#printf("[effect_done] called\n");
	$effect_done_called++;
};

SDL::delay(100);
isnt( SDL::Mixer::Effects::register(0, $effect_func, $effect_done, 0), 0, '[register] register effect_func and effect_done callback' );
SDL::delay($delay);
isnt( SDL::Mixer::Effects::unregister(0, $effect_func),                0, '[unregister] unregistering effect_func will call effect_done' );
SDL::delay(200);
is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
is( $effect_done_called > 0,                                                          1, "[effect_done] called $effect_done_called times" );

$effect_func_called = 0;
$effect_done_called = 0;
isnt( SDL::Mixer::Effects::register(MIX_CHANNEL_POST, $effect_func, $effect_done, 0), 0, '[register]' );
SDL::delay($delay);
isnt( SDL::Mixer::Effects::unregister_all(MIX_CHANNEL_POST),                          0, '[unregister_all] unregistering all will call effect_done' );
SDL::delay(100);
is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
is( $effect_done_called > 0,                                                          1, "[effect_done] called $effect_done_called times" );

my @done = qw/
register
unregister
unregister_all
/;

my @left = qw/
set_postmix
set_panning
set_distance
set_position
set_reverse_stereo
/;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

#TODO:
#{
#    local $TODO = $why;
#    fail "Not Implmented SDL::Mixer::Effects::$_" foreach(@left)
#}

diag $why;

done_testing();

