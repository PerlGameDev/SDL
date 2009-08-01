#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Event

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;

use Test::More;

plan ( tests => 2 );

use_ok( 'SDL::Event' ); 
  
can_ok ('SDL::Event', qw/
	new 
	type 
	pump 
	poll 
	wait 
	set 
	set_unicode 
	set_key_repeat
	active_gain 
	active_state 
	key_state 
	key_sym 
	key_name 
	key_mod
	key_unicode 
	key_scancode 
	motion_state
	motion_x 
	motion_y 
	motion_xrel 
	motion_yrel
	button 
	button_state 
	button_x 
	button_y /);



