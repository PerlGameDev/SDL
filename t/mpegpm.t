#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig\@cpan.org>
#
# ------------------------------------------------------------------------------
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ------------------------------------------------------------------------------
#
# Please feel free to send questions, suggestions or improvements to:
#
#	David J. Goehrig
#	dgoehrig\@cpan.org
#
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

sleep(2);
