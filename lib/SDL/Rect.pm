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
use SDL;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %options = @_;

	verify (%options, qw/ -x -y -top -left -width -height -w -h / ) if $SDL::DEBUG;

	my $x = $options{-x} 		|| $options{-left}  || 0;
	my $y = $options{-y} 		|| $options{-top}   || 0;
	my $w = $options{-width}	|| $options{-w}		|| 0;
	my $h = $options{-height}	|| $options{-h}		|| 0;
	
	my $self = \SDL::NewRect($x,$y,$w,$h);
	unless ($$self) {
	    require Carp;
	    Carp::croak SDL::GetError();
	}
	bless $self,$class;
	return $self;
}

sub DESTROY {
	SDL::FreeRect(${$_[0]});
}

# TODO: mangle with the symbol table to create an alias
# to sub x. We could call x from inside the sub but that
# would be another call and rects are a time-critical object.
sub left {
	my $self = shift;
	SDL::RectX($$self,@_);
}

sub x {
	my $self = shift;
	SDL::RectX($$self,@_);
}

### TODO: see 'left' above (this is an 'alias' to sub y)
sub top {
	my $self = shift;
	SDL::RectY($$self,@_);
}

sub y {
	my $self = shift;
	SDL::RectY($$self,@_);
}

### TODO: see 'left' above (this is an 'alias' to sub width)
sub w {
	my $self = shift;
	SDL::RectW($$self,@_);
}

sub width {
	my $self = shift;
	SDL::RectW($$self,@_);
}

### TODO: see 'left' above (this is an 'alias' to sub height)
sub h {
	my $self = shift;
	SDL::RectH($$self,@_);
}

sub height {
	my $self = shift;
	SDL::RectH($$self,@_);
}

1;

__END__;

=head1 NAME

SDL::Rect - raw object for storing rectangular coordinates

=head1 SYNOPSIS

  my $rect = SDL::Rect->new( -height => 4, -width => 40 );
  
  $rect->x(12);  # same as $rect->left(12)
  $rect->y(9);   # same as $rect->top(9)

=head1 DESCRIPTION

C<SDL::Rect::new> creates a SDL_Rect structure which is
used for specifying regions of pixels for filling, blitting, and updating.
These objects make it easy to cut and backfill.

By default, x, y, height and width are all set to 0.

=head2 METHODS 

The four fields of a rectangle can be set simply
by passing a value to the applicable method.  These are:

=head3 x

=head3 left

sets and fetches the x (lefmost) position of the rectangle.

=head3 y

=head3 top

sets and fetches the y (topmost) position.

=head3 w

=head3 width

sets and fetches the width of the rectangle (in pixels).

=head3 h

=head3 height 

sets and fetches the height of the rectangle (in pixels).

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

perl(1) SDL::Surface(3)
