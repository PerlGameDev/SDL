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

package SDL::SMPEG::Info;

use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA);
use Carp;
use SDL;
our @ISA = qw(Exporter DynaLoader);
use SDL::SMPEG;
use SDL::Internal::Loader;

our $VERSION    = '2.541_10';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

internal_load_dlls(__PACKAGE__);

bootstrap SDL::SMPEG::Info;

sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;
	my %options = @_;

	my $self;
	if ( $options{-from} ) {
		$self = \SDL::SMPEG::SMPEGGetInfo( $options{-from} );
	} else {
		$self = \NewSMPEGInfo();
	}
	bless $self, $class;
	return $self;
}

sub DESTROY {

	#	FreeSMPEGInfo(  $_[0] );
}

sub has_audio {
	SMPEGInfoHasAudio( $_[0] );
}

sub has_video {
	SMPEGInfoHasVideo( $_[0] );
}

sub width {
	SMPEGInfoWidth( $_[0] );
}

sub height {
	SMPEGInfoHeight( $_[0] );
}

sub size {
	SMPEGInfoTotalSize( $_[0] );
}

sub offset {
	SMPEGInfoCurrentOffset( $_[0] );
}

sub frame {
	SMPEGInfoCurrentFrame( $_[0] );
}

sub fps {
	SMPEGInfoCurrentFPS( $_[0] );
}

sub time {
	SMPEGInfoCurrentTime( $_[0] );
}

sub length {
	SMPEGInfoTotalTime( $_[0] );
}

1;
