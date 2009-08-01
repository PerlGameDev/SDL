#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::TTFont

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

if ( SDL::Config->has('SDL_ttf') ) {
	plan ( tests => 2 );
} else {
	plan ( skip_all => 'SDL_ttf support not compiled' );
}

use_ok( 'SDL::TTFont' ); 
  
can_ok ('SDL::TTFont', qw/
	new 
	print 
	width 
	height
	ascent 
	descent 
	normal 
	bold 
	italic 
	underline
	text_shaded 
	text_solid 
	text_blended 
	utf8_shaded 
	utf8_solid 
	utf8_blended 
	unicode_shaded 
	unicode_solid 
	unicode_blended /);
