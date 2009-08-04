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
# basic testing of SDL::Color

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;

use Test::More;

plan ( tests => 10 );

use_ok( 'SDL::Color' ); 
  
can_ok ('SDL::Color', qw/
	new 
	r 
	g 
	b 
	pixel /);

# some basic tests:

my $color = SDL::Color->new();
is (ref($color), 'SDL::Color', 'new was ok');
is ($color->r(),0, 'r is 0');
is ($color->g(),0, 'g is 0');
is ($color->b(),0, 'b is 0');

$color = SDL::Color->new( -r => 0xff, -g => 0xff, -b => 0xff);
is (ref($color), 'SDL::Color', 'new was ok');
is ($color->r(),255, 'r is 255');
is ($color->g(),255, 'g is 255');
is ($color->b(),255, 'b is 255');

