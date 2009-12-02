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
# basic testing of SDL::Tool::Font

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL;
use SDL::Config;
use Test::More;

plan( skip_all => "Failing test due to moving stuff around");

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
my $font = new SDL::Tool::Font
		-normal => 1,
		-ttfont => 'test/data/aircut3.ttf',
		-size => 20,
		-fg => $SDL::Color::black,
	 	-bg => $SDL::Color::black;

#use utf8;

#my $string = "Test";
#my $aref = SDL::TTFSizeText( $font, $string);
#ok( defined($$aref[0]), "Testi width for SDL::TTFSizeText." );
#ok( defined($$aref[1]), "Test height for SDL::TTFSizeText." );

#utf8::encode($string);
#my $bref =  SDL::TTFSizeUTF8( $font, $string);
#ok( defined($$bref[0]), "Test for width SDL::TTFSizeUTF8." );
#ok( defined($$bref[1]), "Test for height SDL::TTFSizeUTF8." );

sleep(2);
