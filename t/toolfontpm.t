#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Tool::Font

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

if ( SDL::Config->has('SDL_image') 
	&& SDL::Config->has('SDL_ttf') ) {
	plan ( tests => 2 );
} else {
	plan ( skip_all => 
		( SDL::Config->has('SDL_image') 
			? '' 
			: ' SDL_image support not compiled')
		. ( SDL::Config->has('SDL_ttf') 
			? ''
			: ' SDL_ttf support not compiled'));
}

use_ok( 'SDL::Tool::Font' ); 
  
can_ok ('SDL::Tool::Font', qw/
	new 
	print
	/);

