#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::VIDEO

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

use_ok( 'SDL::Video' ); 
  
can_ok ('SDL::Video', qw/
	new
	error
	audio
	video
	volume
	display
	scale
	play
	pause
	stop
	rewind
	seek
	skip
	loop
	region
	frame
	info
	status /);


