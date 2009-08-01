#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
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

