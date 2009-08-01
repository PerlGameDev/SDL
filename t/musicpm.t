#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Music

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

plan ( tests => 2 );

use_ok( 'SDL::Music' ); 
  
can_ok ('SDL::Music', qw/
	new
	/);


