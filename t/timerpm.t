#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Timer

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL;
use SDL::Config;

use Test::More;

plan ( tests => 4 );

use_ok( 'SDL::Timer' ); 
  
can_ok ('SDL::Timer', qw/
	new run stop
	/);

my $fired = 0;

SDL::Init(SDL_INIT_TIMER);

my $timer = new SDL::Timer 
	sub { $fired++ }, -delay => 30, -times => 1;

isa_ok($timer, 'SDL::Timer');

SDL::Delay(100);
is ($fired, 1,'timer fired once');
