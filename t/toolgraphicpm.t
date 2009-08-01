#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::Tool::Graphic

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

if ( SDL::Config->has('SDL_gfx') ) {
	plan ( tests => 3 );
} else {
	plan ( skip_all => 'SDL_gfx support not compiled' );
}

use_ok( 'SDL::Tool::Graphic' ); 
  
can_ok ('SDL::Tool::Graphic', qw/
	new zoom rotoZoom
	/);

my $gtool = SDL::Tool::Graphic->new();
isa_ok ($gtool, 'SDL::Tool::Graphic');

