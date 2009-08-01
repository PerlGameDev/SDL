#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Mixer

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL;
use SDL::Config;

use Test::More;

if ( SDL::Config->has('SDL_mixer') ) {
	plan ( tests => 3 );
} else {
	plan ( skip_all => 'SDL_mixer support not compiled' );
}

use_ok( 'SDL::Mixer' ); 
  
can_ok ('SDL::Mixer', qw/
	new
	query_spec
	reserve_channels
	allocate_channels
	group_channel
	group_channels
	group_available
	group_count
	group_oldest
	group_newer
	play_channel
	play_music
	fade_in_channel
	fade_in_music
	channel_volume
	music_volume
	halt_channel
	halt_group
	halt_music
	channel_expire
	fade_out_channel
	fade_out_group
	fade_out_music
	fading_music
	fading_channel
	pause
	resume
	paused
	pause_music
	resume_music
	rewind_music
	music_paused
	playing
	playing_music
	/);

# these are exported by default, so main:: should know them:
SDL::Init(SDL_INIT_AUDIO);
my $mixer = SDL::Mixer->new();
isa_ok($mixer, 'SDL::Mixer');

