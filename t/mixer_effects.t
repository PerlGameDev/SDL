#!/usr/bin/perl -w

my $audiodriver;

BEGIN
{
	use Config;
	if (! $Config{'useithreads'}) {
		print("1..0 # Skip: Perl not compiled with 'useithreads'\n");
		exit(0);
	}
	use SDL;
	use SDL::Config;
	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

    $audiodriver          = $ENV{SDL_AUDIODRIVER};
    $ENV{SDL_AUDIODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

	if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
		plan( skip_all => 'Failed to init sound' );
	}
	elsif( !SDL::Config->has('SDL_mixer') )
	{
		plan( skip_all => 'SDL_mixer support not compiled' );
	}
}
use strict;
use threads;
use threads::shared;

use SDL::Mixer;
use SDL::Mixer::Channels;
use SDL::Mixer::Effects;
use SDL::Mixer::Samples;

is( SDL::Mixer::open_audio( 44100, SDL::Audio::AUDIO_S16SYS, 2, 1024 ),  0, '[open_audio] ran');

my $delay           = 500;
my $audio_test_file = 'test/data/silence.wav';
SDL::Mixer::Channels::volume( -1,  1 );

if($ENV{'SDL_RELEASE_TESTING'})
{
	SDL::Mixer::Channels::volume( -1, 20 );
	$delay           = 1000;
	$audio_test_file = 'test/data/sample.wav';
}

my $effect_func_called : shared = 0;
my $effect_done_called : shared = 0;
my @last_stream        = ();
sub echo_effect_func
{
	my $channel  = shift;
	my $samples  = shift;
	my $position = shift;
	my @stream   = @_;
	
	$effect_func_called++;
	printf("[effect_func] callback: channel=%2s, position=%8s, samples=%6s\n", $channel, $position, scalar(@stream));
	
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
	push(@stream2, $position + $samples);
	return @stream2;
};
sub echo_effect_func2
{
	my $channel  = shift;
	my $samples  = shift;
	my $position = shift;
	my @stream   = @_;
	
	$effect_func_called++;
	printf("[effect_func2] callback: channel=%2s, position=%8s, samples=%6s\n", $channel, $position, scalar(@stream));
	push(@stream, $position + $samples);
	return @stream;
	
};

sub effect_done2
{
	printf("[effect_done2] called\n");
	$effect_done_called++;
};

sub effect_done
{
	printf("[effect_done] called\n");
	$effect_done_called++;
};

my $sample_chunk    = SDL::Mixer::Samples::load_WAV($audio_test_file);
my $playing_channel = SDL::Mixer::Channels::play_channel( -1, $sample_chunk, -1 );
is( $playing_channel >= 0, 1, "[play_channel] playing $audio_test_file");

SDL::delay($delay);
my $effect_id = SDL::Mixer::Effects::register($playing_channel, "main::echo_effect_func2", "main::effect_done2", 0);
isnt( $effect_id, -1, '[register] registerering echo effect callback' );
SDL::delay($delay);
my $check = SDL::Mixer::Effects::unregister($playing_channel, $effect_id);
isnt( $check,                0, '[unregister] unregistering effect_func will call effect_done' );
SDL::delay(200);
is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
is( $effect_done_called > 0,                                                          1, "[effect_done] called $effect_done_called times" );

SDL::delay($delay);
$effect_func_called = 0;
$effect_done_called = 0;

$effect_id = SDL::Mixer::Effects::register($playing_channel, "main::echo_effect_func2", "main::effect_done2", 0);
isnt( $effect_id, -1, '[register] registerering echo effect callback' );
SDL::delay($delay);
$check = SDL::Mixer::Effects::unregister($playing_channel, $effect_id);
isnt( $check,                0, '[unregister] unregistering effect_func will call effect_done' );
SDL::delay(200);
is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
is( $effect_done_called > 0,                                                          1, "[effect_done] called $effect_done_called times" );

$effect_func_called = 0;
$effect_done_called = 0;
my $effect_id_all = SDL::Mixer::Effects::register(MIX_CHANNEL_POST, "main::echo_effect_func", "main::effect_done", 0);
isnt( $effect_id_all, -1, '[register] registerering echo effect callback' );
SDL::delay($delay);
isnt( SDL::Mixer::Effects::unregister_all(MIX_CHANNEL_POST),                          0, '[unregister_all] unregistering all will call effect_done' );
SDL::delay(200);
is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
is( $effect_done_called > 0,                                                          1, "[effect_done] called $effect_done_called times" );

$effect_func_called = 0;
is( SDL::Mixer::Effects::set_post_mix("main::echo_effect_func", 0),                      undef, '[set_post_mix] registering echo effect callback' );
SDL::delay($delay);
is( SDL::Mixer::Effects::set_post_mix(),                                          undef, '[set_post_mix] unregistering echo effect callback' );
SDL::delay(200);
is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
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

if($audiodriver)
{
	$ENV{SDL_AUDIODRIVER} = $audiodriver;
}
else
{
	delete $ENV{SDL_AUDIODRIVER};
}

done_testing();
