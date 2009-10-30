#!/usr/bin/env perl
#
# Cdrom.pm
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

package SDL::Cdrom;
use strict;
use warnings;
use Carp;

BEGIN {
	use Exporter();
	use vars qw(@ISA @EXPORT);
	@ISA = qw(Exporter);
	@EXPORT = qw/ &CD_NUM_DRIVES /;
}

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self;
	my $number = shift;
	$self = \SDL::CDOpen($number);
	croak SDL::GetError() if ( SDL::CD_ERROR() eq SDL::CDStatus($$self));
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::CDClose($$self);
}

sub cd_num_drives {
	return SDL::CDNumDrives();
}

sub name ($) {
	my $self = shift;
	return SDL::CDName($$self);
}

sub status ($) {
	my $self = shift;
	return SDL::CDstatus($$self);
}

sub play ($$$;$$) {
	my ($self,$start,$length,$fs,$fl) = @_;
	return SDL::CDPlayTracks($$self,$start,$length,$fs,$fl);
}

sub pause ($) {
	my $self = shift;
	return SDL::CDPause($$self);
}

sub resume ($) {
	my $self = shift;
	return SDL::CDResume($$self);
}

sub stop ($) {
	my $self = shift;
	return SDL::CDStop($$self);
}

sub eject ($) {
	my $self = shift;
	return SDL::CDEject($$self);
}

sub id ($) {
	my $self = shift;
	return SDL::CDId($$self);
}

sub num_tracks ($) {
	my $self = shift;
	return SDL::CDNumTracks($$self);
}

my $buildtrack = sub {
	my $ptr = shift;
	my %track = ();
	$track{-id} = SDL::CDTrackId($ptr);
	$track{-type} = SDL::CDTrackType($ptr);
	$track{-length} = SDL::CDTrackLength($ptr);
	$track{-offset} = SDL::CDTrackOffset($ptr);
	return \%track;
};

sub track {
	my $self = shift;
	my $number = shift;
	return &$buildtrack(SDL::CDTrack($$self,$number));
}

sub current {
	my $self = shift;
	return $self->track(SDL::CDCurTrack($$self));
}

sub current_frame {
	my $self = shift;
	return SDL::CDCurFrame($$self);
}

1;
