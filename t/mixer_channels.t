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
use SDL::Mixer::Samples;

my @done = qw/
allocate_channels
volume
play_channel
fade_out_channel
fade_in_channel
pause
resume
fading_channel
playing
paused
halt_channel
play_channel_timed
expire_channel
fade_in_channel_timed
get_chunk
/;

is( SDL::Mixer::open_audio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 ),  0, '[open_audio] ran');

is( SDL::Mixer::Channels::allocate_channels( 4 ),                         4, "[allocate_channels] 4 channels allocated" );

    SDL::Mixer::Channels::volume( -1, 10 );
is( SDL::Mixer::Channels::volume( -1, 20 ),                              10, "[volume] set to 20, previously was 10" );

my $sample_chunk    = SDL::Mixer::Samples::load_WAV('test/data/sample.wav');
my $playing_channel = SDL::Mixer::Channels::play_channel( -1, $sample_chunk, -1 );
isnt( $playing_channel,   -1, "[play_channel] plays sample.wav on channel " . $playing_channel );
is( SDL::Mixer::Channels::fading_channel( $playing_channel ), MIX_NO_FADING, "[fading_channel] channel $playing_channel is not fading" );
is( SDL::Mixer::Channels::playing( $playing_channel ), 1, "[playing] channel $playing_channel is playing" );
is( SDL::Mixer::Channels::paused( $playing_channel ), 0, "[paused] channel $playing_channel is not paused" );

my $delay = 100; # set it to at least 2000 te hear the tests right

my $fading_channels = SDL::Mixer::Channels::fade_out_channel( $playing_channel, $delay );
is( $fading_channels > 0,  1, "[fade_out_channel] $delay ms for $fading_channels channel(s)" );
is( SDL::Mixer::Channels::fading_channel( $playing_channel ), MIX_FADING_OUT, "[fading_channel] channel $playing_channel is fading out" );

SDL::delay($delay);

$playing_channel = SDL::Mixer::Channels::fade_in_channel( -1, $sample_chunk, 0, $delay );
isnt( $playing_channel,   -1, "[fade_in_channel] $delay ms for channel $playing_channel" );
is( SDL::Mixer::Channels::fading_channel( $playing_channel ), MIX_FADING_IN, "[fading_channel] channel $playing_channel is fading in" );

SDL::delay($delay);

SDL::Mixer::Channels::pause(-1); pass '[pause] ran';
is( SDL::Mixer::Channels::paused( $playing_channel ), 1, "[paused] channel $playing_channel is paused" );

SDL::delay(500);

SDL::Mixer::Channels::resume(-1); pass '[resume] ran';

SDL::delay($delay);

is( SDL::Mixer::Channels::halt_channel( $playing_channel ), 0, "[halt_channel] stop channel $playing_channel" );
is( SDL::Mixer::Channels::playing( $playing_channel ), 0, "[playing] channel $playing_channel is not playing" );

SDL::delay($delay);

$playing_channel = SDL::Mixer::Channels::play_channel_timed( -1, $sample_chunk, 0, $delay );
isnt( $playing_channel,   -1, "[play_channel_timed] play $delay ms for channel $playing_channel" );
SDL::delay(500);
my $expire_channel = SDL::Mixer::Channels::expire_channel( $playing_channel, $delay );
is( $expire_channel > 0,  1, "[expire_channel] stops after $delay ms for $expire_channel channel(s)" );

SDL::delay($delay);

$playing_channel = SDL::Mixer::Channels::fade_in_channel_timed( -1, $sample_chunk, 0, $delay, $delay * 2 );
isnt( $playing_channel,   -1, "[fade_in_channel_timed] play " . ($delay * 2) . " ms after $delay ms fade in for channel $playing_channel" );

isa_ok( SDL::Mixer::Channels::get_chunk( $playing_channel ), 'SDL::Mixer::MixChunk', '[get_chunk]');

SDL::Mixer::close_audio(); pass '[close_audio] ran';

SDL::delay(100);

my @left = qw/
channel_finished
/;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    fail "Not Implmented SDL::Mixer::Channels::$_" foreach(@left)
    
}
diag $why;

done_testing();

