#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
# Copyright (C) 2009 Kartik Thakore
# basic testing of SDL::Surface

BEGIN {
	unshift @INC, 'blib/lib','blib/arch', 'blib/arch/auto/src/SDL/SFont',;
}

use strict;

use Test::More;

plan ( tests => 3 );

use_ok( 'SDL::Surface' ); 
  
can_ok ('SDL::Surface', qw/
	new
	flags
	palette
	bpp
	bytes_per_pixel
	Rshift
	Gshift
	Bshift
	Ashift
	Rmask
	Bmask
	Gmask
	Amask
	color_key
	alpha
	width
	height
	pitch
	pixels
	pixel
	fill
	lockp
	lock
	unlock
	update
	flip
	blit
	set_colors
	set_color_key
	set_alpha
	display_format
	rgb
	rgba
	print
	save_bmp
	video_info /);

my $surface = SDL::Surface->new();

isa_ok($surface,'SDL::Surface');

