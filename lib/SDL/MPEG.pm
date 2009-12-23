#!/usr/bin/env perl
#
# MPEG.pm
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

package SDL::MPEG;

use strict;
use warnings;
use Carp;
use SDL;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %options = @_;

	my $self;
	if ( $options{-from} ) {
		croak "SDL::MPEG::new -from requires a SDL::Video object\n"
			unless $options{-from}->isa('SDL::Video');

		$self = \SDL::SMPEGGetInfo(${$options{-from}});
	} else {
		$self = \SDL::NewSMPEGInfo();
	}	
	bless $self,$class;
	return $self;
}

sub DESTROY {
	SDL::FreeSMPEGInfo(${$_[0]});
}

sub has_audio {
	SDL::SMPEGInfoHasAudio(${$_[0]});
}

sub has_video {
	SDL::SMPEGInfoHasVideo(${$_[0]});
}

sub width {
	SDL::SMPEGInfoWidth(${$_[0]});
}

sub height {
	SDL::SMPEGInfoHeight(${$_[0]});
}

sub size {
	SDL::SMPEGInfoTotalSize(${$_[0]});
}

sub offset {
	SDL::SMPEGInfoCurrentOffset(${$_[0]});
}

sub frame {
	SDL::SMPEGInfoCurrentFrame(${$_[0]});
}

sub fps {
	SDL::SMPEGInfoCurrentFPS(${$_[0]});
}

sub time {
	SDL::SMPEGInfoCurrentTime(${$_[0]});
}

sub length {
	SDL::SMPEGInfoTotalTime(${$_[0]});
}

1;
