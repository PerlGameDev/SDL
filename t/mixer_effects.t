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

is( SDL::Mixer::open_audio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 ),  0, '[open_audio] ran');

my $delay           = 100;
my $audio_test_file = 'test/data/silence.wav';
SDL::Mixer::Channels::volume( -1,  1 );

if($ENV{'RELEASE_TESTING'})
{
	SDL::Mixer::Channels::volume( -1, 20 );
	$delay           = 2000;
	$audio_test_file = 'test/data/sample.wav';
}

#my $sample_chunk    = SDL::Mixer::Samples::load_WAV($audio_test_file);
#my $playing_channel = SDL::Mixer::Channels::play_channel( -1, $sample_chunk, -1 );

my $effect_func_called = 0;
my $effect_done_called = 0;
my $effect_func        = sub
{
	my $channel  = shift;
	my $stream   = shift;
	my $length   = shift;
	my $position = shift;

	$effect_func_called++;
	
	#printf("[effect_func] callback: channel=%2s, position=%8s, stream length=%6s, stream=%6s\n", $channel, $position, $length, scalar(@stream));

	return $stream;
};
my $effect_done = sub
{
	#printf("[effect_done] called\n");
	$effect_done_called++;
};

isnt( SDL::Mixer::Effects::register(MIX_CHANNEL_POST, $effect_func, $effect_done, 0), 0, '[register] register effect_func and effect_done callback' );
SDL::delay(1000);
isnt( SDL::Mixer::Effects::unregister(MIX_CHANNEL_POST, $effect_func),                0, '[unregister] unregistering effect_func will call effect_done' );
SDL::delay(100);
is( $effect_func_called > 0,                                                          1, "[effect_func] called $effect_func_called times" );
is( $effect_done_called > 0,                                                          1, "[effect_done] called $effect_done_called times" );

$effect_func_called = 0;
$effect_done_called = 0;
isnt( SDL::Mixer::Effects::register(MIX_CHANNEL_POST, $effect_func, $effect_done, 0), 0, '[register]' );
SDL::delay(1000);
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

