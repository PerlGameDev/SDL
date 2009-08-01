#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Font

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

if ( SDL::Config->has('SDL_image') ) {
	plan ( tests => 2 );
} else {
	plan ( skip_all => 'SDL_image support not compiled' );
}

use_ok( 'SDL::Font' ); 
  
can_ok ('SDL::Font', qw/ new use /);


