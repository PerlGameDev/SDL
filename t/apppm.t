#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
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
# basic testing of SDL::App



use strict;
use SDL;
use SDL::Config;

use Test::More;
use lib 't/lib';
use SDL::TestTool;

    plan( tests => 3 );
use_ok( 'SDL::App' ); 
  
can_ok ('SDL::App', qw/
	new 
	resize 
	title 
	delay
	ticks 
	error 
	warp 
	fullscreen 
	iconify 
	grab_input 
	loop
	sync 
	attribute /);

SKIP:
{
	skip 'Video not avaiable', 1 unless SDL::TestTool->init(SDL_INIT_VIDEO);

	my $app  = SDL::App->new(-title => "Test", -width => 640, -height => 480, -init => SDL_INIT_VIDEO);

	$app->sync;
	sleep(1);
	pass 'App inited';
  }
