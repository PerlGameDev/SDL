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
# basic testing of SDL

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

plan ( tests => 9 );

use_ok( 'SDL' ); 
  
can_ok ('SDL', qw/in verify/);

is (SDL::in('foo','bar'), 0, "foo isn't in ('bar')");
is (SDL::in('foo','foo'), 1, "foo is in ('foo')");
is (SDL::in('foo','foo','bar'), 1, "foo is in ('foo','bar')");
is (SDL::in('foo','foo','bar','foo'), 1, "foo is once in ('foo','bar','foo')");
is (SDL::in('foo','fab','bar'), 0, "foo isn't in ('fab','bar')");
is (SDL::in('foo','fab',undef,'bar'), 0, "foo isn't in ('fab',undef,'bar')");
is (SDL::in('foo','fab',undef,'foo'), 1, "foo is in ('fab',undef,'foo')");

