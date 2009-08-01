#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Palette

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;

use Test::More;

plan ( tests => 2 );

use_ok( 'SDL::Palette' ); 
  
can_ok ('SDL::Palette', qw/
	new
	size
	red 
	green 
	blue 
	color /);

