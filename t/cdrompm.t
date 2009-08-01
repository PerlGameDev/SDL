#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Cdrom

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;

use Test::More;

plan ( tests => 3 );

use_ok( 'SDL::Cdrom' ); 
  
can_ok ('main', qw/ CD_NUM_DRIVES /);

can_ok ('SDL::Cdrom', qw/
	new
	name
	status
	play
	pause
	resume
	stop
	eject
	id
	num_tracks
	track
	current
	current_frame /);
