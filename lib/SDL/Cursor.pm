#!/usr/bin/env perl
#
# Cursor.pm
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

package SDL::Cursor;
use strict;
use warnings;
use Carp;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %options = @_;

	verify (%options, qw/ -data -mask -x -y /) if $SDL::DEBUG;

	
	my $self = \SDL::NewCursor($options{-data},$options{-mask},
				$options{-x},$options{-y});
	croak SDL::GetError() unless $$self;
	bless $self, $class;
	$self;
}

sub DESTROY ($) {
	my $self = shift;
	SDL::FreeCursor($$self);
}

sub warp ($$$) {
	my ($self,$x,$y) = @_;
	SDL::WarpMouse($x,$y);
}

sub use ($) {
	my $self = shift;
	SDL::SetCursor($$self);
}

sub get () {
	SDL::GetCursor();
}

sub show ($;$) {
	my ($self,$toggle) = @_;
	$toggle = 0 unless defined $toggle;
	SDL::ShowCursor($toggle);
}

1;
