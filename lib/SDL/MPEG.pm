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
our @ISA = qw(Exporter DynaLoader);
use SDL::SMPEG;
use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::MPEG;

sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;
	my %options = @_;

	my $self;
	if ( $options{-from} ) {
		$self = \SDL::SMPEG::SMPEGGetInfo( ${ $options{-from} } );
	} else {
		$self = \SDL::MPEG::NewSMPEGInfo();
	}
	bless $self, $class;
	return $self;
}

sub DESTROY {
	SDL::MPEG::FreeSMPEGInfo( ${ $_[0] } );
}

sub has_audio {
	SDL::MPEG::SMPEGInfoHasAudio( ${ $_[0] } );
}

sub has_video {
	SDL::MPEG::SMPEGInfoHasVideo( ${ $_[0] } );
}

sub width {
	SDL::MPEG::SMPEGInfoWidth( ${ $_[0] } );
}

sub height {
	SDL::MPEG::SMPEGInfoHeight( ${ $_[0] } );
}

sub size {
	SDL::MPEG::SMPEGInfoTotalSize( ${ $_[0] } );
}

sub offset {
	SDL::MPEG::SMPEGInfoCurrentOffset( ${ $_[0] } );
}

sub frame {
	SDL::MPEG::SMPEGInfoCurrentFrame( ${ $_[0] } );
}

sub fps {
	SDL::MPEG::SMPEGInfoCurrentFPS( ${ $_[0] } );
}

sub time {
	SDL::MPEG::SMPEGInfoCurrentTime( ${ $_[0] } );
}

sub length {
	SDL::MPEG::SMPEGInfoTotalTime( ${ $_[0] } );
}

1;
