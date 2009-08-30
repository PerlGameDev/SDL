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
# basic testing of SDL::Timer

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL;
use SDL::Config;

use Test::More;

if (SDL::Init(SDL_INIT_TIMER) < 0 )
{
	 plan( skip_all => "Cannot initialize timer!!" );

}
plan ( tests => 4 );

use_ok( 'SDL::Timer' ); 
  
can_ok ('SDL::Timer', qw/
	new run stop
	/);

my $fired = 0;


my $timer = new SDL::Timer 
	sub { $fired++ }, -delay => 30, -times => 1;

isa_ok($timer, 'SDL::Timer');

SDL::Delay(100);
is ($fired, 1,'timer fired once');
