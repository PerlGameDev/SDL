#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Cursor

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;

use Test::More;

plan ( tests => 2 );

use_ok( 'SDL::Cursor' ); 
  
can_ok ('SDL::Cursor', qw/
	new 
	warp 
	use 
	get 
	show /);

