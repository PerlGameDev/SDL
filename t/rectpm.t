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
# basic testing of SDL::Rect

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;

use Test::More;

plan ( tests => 35 );

use_ok( 'SDL::Rect' ); 
  
can_ok ('SDL::Rect', qw/
	new
	x 
	y 
	width 
	height
	w
	h
	top
	left
	 /);

my $rect = SDL::Rect->new();

# creating with defaults
is (ref($rect),'SDL::Rect','new went ok');
is ($rect->x(), 0, 'x is 0');
is ($rect->y(), 0, 'y is 0');
is ($rect->top(), 0, 'top is 0');
is ($rect->left(), 0, 'left is 0');
is ($rect->width(), 0, 'width is 0');
is ($rect->height(), 0, 'height is 0');
is ($rect->w(), 0, 'w is 0');
is ($rect->h(), 0, 'h is 0');

# set and get at the same time (and testing method aliases)
is ($rect->left(15), 15, 'left is now 15');
is ($rect->x, 15, 'x and left point to the same place');
is ($rect->x(12), 12, 'x is now 12');
is ($rect->left, 12, 'left is an alias to x');

is ($rect->top(132), 132, 'top is now 132');
is ($rect->y, 132, 'y and top point to the same place');
is ($rect->y(123), 123, 'y is now 123');
is ($rect->top, 123, 'top is an alias to y');

is ($rect->w(54), 54, 'w is now 54');
is ($rect->width, 54, 'w and width point to the same place');
is ($rect->width(45), 45, 'w is now 45');
is ($rect->w, 45, 'w is an alias to width');

is ($rect->h(76), 76, 'h is now 76');
is ($rect->height, 76, 'h and height point to the same place');
is ($rect->height(67), 67, 'h is now 67');
is ($rect->h, 67, 'h is an alias to height');

# get alone
is ($rect->x(), 12, 'x is 12');
is ($rect->left(), 12, 'left is 12');
is ($rect->y(), 123, 'y is 123');
is ($rect->top(), 123, 'top is 123');
is ($rect->width(), 45, 'width is 45');
is ($rect->w(), 45, 'w is 45');
is ($rect->height(), 67, 'height is 67');
is ($rect->h(), 67, 'h is 67');

