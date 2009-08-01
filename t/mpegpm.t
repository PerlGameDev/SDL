#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::MPEG

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

if ( SDL::Config->has('smpeg') && SDL::Config->has('SDL_mixer') ) {
	plan ( tests => 2 );
} else {
	plan ( skip_all => 
		( SDL::Config->has('smpeg') ? '' : ' smpeg support not compiled')  .
		( SDL::Config->has('SDL_mixer') ? '' : ' SDL_mixer support not compiled') );
}

use_ok( 'SDL::MPEG' ); 
  
can_ok ('SDL::MPEG', qw/
	new 
	has_audio 
	has_video 
	width 
	height 
	size 
	offset 
	frame		 
	fps 
	time 
	length /);


