#!/usr/bin/env perl
#
# Rect.pm
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

package SDL::Rect;

use strict;
use warnings;
use Carp;
use SDL;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %options = @_;

	verify (%options, qw/ -x -y -width -height -w -h / ) if $SDL::DEBUG;

	my $x = $options{-x} 		|| 0;
	my $y = $options{-y} 		|| 0;
	my $w = $options{-width}	|| $options{-w}		|| 0;
	my $h = $options{-height}	|| $options{-h}		|| 0;
	
	my $self = \SDL::NewRect($x,$y,$w,$h);
	croak SDL::GetError() unless $$self;
	bless $self,$class;
	return $self;
}

sub DESTROY {
	SDL::FreeRect(${$_[0]});
}

sub x {
	my $self = shift;
	SDL::RectX($$self,@_);
}

sub y {
	my $self = shift;
	SDL::RectY($$self,@_);
}

sub width {
	my $self = shift;
	SDL::RectW($$self,@_);
}

sub height {
	my $self = shift;
	SDL::RectH($$self,@_);
}

1;

__END__;

=pod


=head1 NAME

SDL::Rect - a SDL perl extension

=head1 SYNOPSIS

  $rect = new SDL::Rect ( -height => 4, -width => 40 );

=head1 DESCRIPTION

C<SDL::Rect::new> creates a SDL_Rect structure which is
used for specifying regions for filling, blitting, and updating.
These objects make it easy to cut and backfill.
By default, x, y, h, w are 0.

=head2 METHODS 

The four fields of a rectangle can be set simply
by passing a value to the applicable method.  These are:

=over 4

=item *

C<SDL::Rect::x>	sets and fetches the x position.

=item *

C<SDL::Rect::y>	sets and fetches the y position.

=item *

C<SDL::Rect::width> sets and fetched the width.

=item *

C<SDL::Rect::height> sets and fetched the height.

=back

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

perl(1) SDL::Surface(3)


=cut

