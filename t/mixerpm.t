#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig\@cpan.org>
#
# ------------------------------------------------------------------------------
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ------------------------------------------------------------------------------
#
# Please feel free to send questions, suggestions or improvements to:
#
#	David J. Goehrig
#	dgoehrig\@cpan.org
#
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


if ( SDL::Init(SDL_INIT_AUDIO) < 0) {
	        plan( skip_all => "Cannot initialize audio!!" );
	}

# these are exported by default, so main:: should know them:
my $mixer = SDL::Mixer->new();
isa_ok($mixer, 'SDL::Mixer', 'Checking if mixer can be build');

