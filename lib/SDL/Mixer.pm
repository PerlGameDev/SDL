#!/usr/bin/env perl
#
# Mixer.pm
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
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
#	dgoehrig@cpan.org
#

package SDL::Mixer;

use strict;
use warnings;
use Carp;

use SDL;
use SDL::Sound;
use SDL::Music;

BEGIN {
}

$SDL::Mixer::initialized = 0;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	my %options = @_;
	my $frequency = $options{-frequency} || $options{-rate} || SDL::MIX_DEFAULT_FREQUENCY();
	my $format = $options{-format} || SDL::MIX_DEFAULT_FORMAT();
	my $channels = $options{-channels} || SDL::MIX_DEFAULT_CHANNELS();
	my $size = $options{-size} || 4096;
	unless ( $SDL::Mixer::initialized ) {
		SDL::MixOpenAudio($frequency,$format,$channels,$size ) && 
			croak SDL::get_error(); 
		$SDL::Mixer::initialized = 1;
	} else {
		++$SDL::Mixer::initialized;
	}
	bless $self,$class;
	return $self;
}	

sub DESTROY {
	my $self = shift;
	--$SDL::Mixer::initialized;
	unless ($SDL::Mixer::initialized) {
		SDL::MixCloseAudio();
	}
}


sub query_spec () {
	my ($status,$freq,$format,$channels) = SDL::MixQuerySpec();
	my %hash = ( -status => $status, -frequency => $freq, 
			-format => $format, -channels => $channels );
	return \%hash;
}

sub reserve_channels ($$) {
	my ($self,$channels) = @_;
	return SDL::MixReserveChannels($channels);
}

sub allocate_channels ($$) {
	my ($self,$channels) = @_;
	return SDL::MixAllocateChannels($channels);
}

sub group_channel ($$$) {
	my ($self,$channel,$group) = @_;
	return SDL::MixGroupChannel($channel, $group);
}

sub group_channels ($$$$) {
	my ($self,$from,$to,$group) = @_;
	return SDL::MixGroupChannels($from,$to,$group);
}

sub group_available ($$) {
	my ($self,$group) = @_;	
	return SDL::MixGroupAvailable($group);
}

sub group_count ($$) {
	my ($self,$group) = @_;	
	return SDL::MixGroupCount($group);
}	

sub group_oldest ($$) {
	my ($self,$group) = @_;	
	return SDL::MixGroupOldest($group);
}	

sub group_newer ($$) {
	my ($self,$group) = @_;	
	return SDL::MixGroupNewer($group);
}	

sub play_channel ($$$$;$) {
	my ($self,$channel,$chunk,$loops,$ticks) = @_;
	$ticks ||= -1; 
	return SDL::MixPlayChannelTimed($channel,$$chunk,$loops,$ticks);
}

sub play_music ($$$) {
	my ($self,$music,$loops) = @_;
	return SDL::MixPlayMusic($$music,$loops);
}

sub fade_in_channel ($$$$$;$) {
	my ($self,$channel,$chunk,$loops,$ms,$ticks) = @_;
	$ticks ||= -1;
	return SDL::MixFadeInChannelTimed($channel,$$chunk,$loops,$ms,$ticks);
}

sub fade_in_music ($$$$) {
	my ($self,$music,$loops,$ms) = @_;
	return SDL::MixFadeInMusic($$music,$loops,$ms);
}

sub channel_volume ($$$) {
	my ($self,$channel,$volume) = @_;
	return SDL::MixVolume($channel,$volume);
}

sub music_volume ($$) {
	my ($self,$volume) = @_;
	return SDL::MixVolumeMusic($volume);
}

sub halt_channel ($$) {
	my ($self,$channel) = @_;
	return SDL::MixHaltChannel($channel);
}

sub halt_group ($$) {
	my ($self,$group) = @_;
	return SDL::MixHaltGroup($group);
}

sub halt_music (){
	return SDL::MixHaltMusic();
}

sub channel_expire ($$$) {
	my ($self,$channel,$ticks) = @_;
	return SDL::MixExpireChannel($channel,$ticks);
}

sub fade_out_channel ($$$) {
	my ($self,$channel,$ms) = @_;
	return SDL::MixFadeOutChannel($channel,$ms);
}

sub fade_out_group ($$$) {
	my ($self,$group,$ms) = @_;
	return SDL::MixFadeOutGroup($group,$ms);
}

sub fade_out_music ($$) {
	my ($self,$ms) = @_;
	return SDL::MixFadeOutMusic($ms);
}

sub fading_music () {
	return SDL::MixFadingMusic();
}

sub fading_channel ($$) {
	my ($self,$channel) = @_;
	return SDL::MixFadingChannel($channel);
}
	
sub pause ($$) {
	my ($self,$channel) = @_;
	SDL::MixPause($channel);
}

sub resume ($$) {
	my ($self,$channel) = @_;
	SDL::MixResume($channel);
}

sub paused ($$) {
	my ($self,$channel) = @_;
	return SDL::MixPaused($channel);
}

sub pause_music () {
	SDL::MixPauseMusic();
}

sub resume_music () {
	SDL::MixResumeMusic();
}

sub rewind_music (){
	SDL::MixRewindMusic();
}

sub music_paused (){
	return SDL::MixPausedMusic();
}

sub playing ($$) {
	my ($self,$channel) = @_;
	return SDL::MixPlaying($channel);
}

sub playing_music () {
	return SDL::MixPlayingMusic();
}

sub set_panning {
  my($self, $channel, $left, $right) = @_;
	return SDL::MixSetPanning($channel, $left, $right);
}

1;
