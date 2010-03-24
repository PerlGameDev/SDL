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
use SDL::Mixer::Groups;
use SDL::Mixer::Samples;

is( SDL::Mixer::open_audio( 44100, SDL::Audio::AUDIO_S16SYS, 2, 4096 ),  0, '[open_audio] ran');
is( SDL::Mixer::Channels::allocate_channels( 8 ),                         8, "[allocate_channels] 8 channels allocated" );
is( SDL::Mixer::Groups::reserve_channels( 4 ),                            4, "[reserve_channels] 4 channels reserved" );

my $delay           = 100;
my $audio_test_file = 'test/data/silence.wav';

if($ENV{'SDL_RELEASE_TESTING'})
{
		SDL::Mixer::Channels::volume( -1, 10 );
	is( SDL::Mixer::Channels::volume( -1, 20 ),                          10, "[volume] set to 20, previously was 10" );
	$delay           = 2000;
	$audio_test_file = 'test/data/sample.wav';
}
else
{
		SDL::Mixer::Channels::volume( -1, 10 );
	is( SDL::Mixer::Channels::volume( -1,  1 ),                          10, "[volume] set to 1, previously was 10" );
}

my $sample_chunk    = SDL::Mixer::Samples::load_WAV($audio_test_file);
my $playing_channel = SDL::Mixer::Channels::play_channel( -1, $sample_chunk, -1 );
is( $playing_channel > 3,                                                 1, "[play_channel] plays on channel $playing_channel" );
SDL::Mixer::Channels::halt_channel(-1);

is( SDL::Mixer::Groups::group_channel( 0, 0 ),                            1, "[group_channel] channel 0 to group 0" );
is( SDL::Mixer::Groups::group_channels( 1, 3, 1 ),                        3, "[group_channels] channel 1-3 to group 1" );
is( SDL::Mixer::Groups::group_channel( 3, -1 ),                           1, "[group_channel] channel 0 ungrouped" );
is( SDL::Mixer::Groups::group_channels( 3, 3, 2 ),                        1, "[group_channels] channel 3-3 to group 2" );
is( SDL::Mixer::Groups::group_count( 0 ),                                 1, "[group_count] for group 0 is 1" );
is( SDL::Mixer::Groups::group_count( 1 ),                                 2, "[group_count] for group 1 is 2" );
is( SDL::Mixer::Groups::group_count( 2 ),                                 1, "[group_count] for group 2 is 1" );
is( SDL::Mixer::Groups::group_available( 0 ),                             0, "[group_available] first channel for group 0 is 0" );
is( SDL::Mixer::Groups::group_available( 1 ),                             1, "[group_available] first channel for group 1 is 1" );
is( SDL::Mixer::Groups::group_available( 2 ),                             3, "[group_available] first channel for group 2 is 3" );
is( SDL::Mixer::Groups::group_oldest( 1 ),                               -1, "[group_oldest] group 1 does not play something" );

SDL::Mixer::Channels::play_channel( 2, $sample_chunk, -1 );
SDL::delay($delay / 4);
SDL::Mixer::Channels::play_channel( 1, $sample_chunk, -1 );
SDL::delay(100);

is( SDL::Mixer::Groups::group_oldest( 1 ),                                2, "[group_oldest] channel 2 started first" );
is( SDL::Mixer::Groups::group_newer( 1 ),                                 1, "[group_newer] channel 1 started at last" );

SDL::delay(100);
is( SDL::Mixer::Groups::fade_out_group( 1, $delay * 2),                   2, "[fade_out_group] $delay ms for group 1" );

SDL::delay($delay);
is( SDL::Mixer::Groups::halt_group( 1 ),                                  0, "[halt_group] group 1 halted" );

SDL::Mixer::close_audio(); pass '[close_audio] ran';

done_testing();
