#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;
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

use SDL::Mixer;
use SDL::Mixer::Channels;
use SDL::Mixer::Effects;
use SDL::Mixer::Samples;

is( SDL::Mixer::open_audio( 44100, SDL::Constants::AUDIO_S16, 2, 1024 ),  0, '[open_audio] ran');

my $delay           = 500;
my $audio_test_file = 'test/data/silence.wav';
SDL::Mixer::Channels::volume( -1,  1 );

if($ENV{'RELEASE_TESTING'})
{
	SDL::Mixer::Channels::volume( -1, 20 );
	$delay           = 1000;
	$audio_test_file = 'test/data/sample.wav';
}

my $effect_func_called = 0;
my $effect_done_called = 0;
my @last_stream        = ();
my $echo_effect_func   = sub
{
	my $channel  = shift;
	my $samples  = shift;
	my $position = shift;
	my @stream   = @_;
	
	$effect_func_called++;
	printf("[effect_func] callback: channel=%2s, position=%8s, samples=%6s\n", $channel, $position, $samples);
	
	my @stream2 = @stream;
	my $offset  = $samples / 2;
	for(my $i = 0; $i < $samples; $i+=2)
	{
		if($i < $offset)
		{
			if(scalar(@last_stream) == $samples)
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
	printf("[effect_done] called\n");
	$effect_done_called++;
};

my $sample_chunk    = SDL::Mixer::Samples::load_WAV($audio_test_file);
my $playing_channel = SDL::Mixer::Channels::play_channel( -1, $sample_chunk, -1 );
is( $playing_channel >= 0, 1, "[play_channel] playing $audio_test_file");

SKIP:
{
	skip('(Un)Registering callbacks crash sometimes', 11) unless $ENV{'RELEASE_TESTING'}; 
	SDL::delay($delay);
	isnt( SDL::Mixer::Effects::register($playing_channel, $echo_effect_func, $effect_done, 0), 0, '[register] registerering echo effect callback' );
	SDL::delay($delay);
	isnt( SDL::Mixer::Effects::unregister($playing_channel, $echo_effect_func),                0, '[unregister] unregistering effect_func will call effect_done' );
	SDL::delay(200);
	is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
	is( $effect_done_called > 0,                                                          1, "[effect_done] called $effect_done_called times" );

	$effect_func_called = 0;
	$effect_done_called = 0;
	isnt( SDL::Mixer::Effects::register(MIX_CHANNEL_POST, $echo_effect_func, $effect_done, 0), 0, '[register] registerering echo effect callback' );
	SDL::delay($delay);
	isnt( SDL::Mixer::Effects::unregister_all(MIX_CHANNEL_POST),                          0, '[unregister_all] unregistering all will call effect_done' );
	SDL::delay(200);
	is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
	is( $effect_done_called > 0,                                                          1, "[effect_done] called $effect_done_called times" );
	
	$effect_func_called = 0;
	is( SDL::Mixer::Effects::set_post_mix($echo_effect_func, 0),                      undef, '[set_post_mix] registering echo effect callback' );
	SDL::delay($delay);
	is( SDL::Mixer::Effects::set_post_mix(),                                          undef, '[set_post_mix] unregistering echo effect callback' );
	SDL::delay(200);
	is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
}
SDL::delay($delay);
isnt( SDL::Mixer::Effects::set_panning($playing_channel, 128, 255), 0, '[set_panning]  50% left, 100% right' );
SDL::delay($delay);
isnt( SDL::Mixer::Effects::set_position($playing_channel, 225, 80), 0, '[set_position] left-behind, 33% away' );
SDL::delay($delay);
isnt( SDL::Mixer::Effects::set_distance($playing_channel, 160),     0, '[set_distance] 66% away' );
SDL::delay($delay);
isnt( SDL::Mixer::Effects::set_position($playing_channel,   0,  0), 0, '[set_position] front, 0% away' );
SDL::delay($delay);
isnt( SDL::Mixer::Effects::set_reverse_stereo($playing_channel, 1), 0, '[set_reverse_stereo] on' );
SDL::delay($delay);
isnt( SDL::Mixer::Effects::set_reverse_stereo($playing_channel, 0), 0, '[set_reverse_stereo] off' );
SDL::delay($delay);

SDL::Mixer::close_audio(); pass '[close_audio] ran';

SDL::quit();

done_testing();
