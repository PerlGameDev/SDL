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
# basic testing of SDLx::App



use strict;
use SDL;
use SDL::Config;
use SDL::Video;
use Test::More;
use lib 't/lib';
use SDL::TestTool;

    plan( tests => 8 );
use_ok( 'SDLx::App' ); 
  
can_ok ('SDLx::App', qw/
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
	attribute
/);

my $videodriver       = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

SKIP:
{
	skip 'Video not avaiable', 6 unless SDL::TestTool->init(SDL_INIT_VIDEO);

	my $app  = SDLx::App->new(-title => "Test", -width => 640, -height => 480, -init => SDL_INIT_VIDEO);

	$app->sync;
	sleep(1);
	pass 'App inited';
	ok(!eval { $app->resize(640, 480); 1 }, "can't resize with no -resizeable");
	like($@, qr/not resizable/, "check for error message");
	SDL::quit;

	my $app2 = SDLx::App->new(-title => "Test", -width => 640, -height => 480, -init => SDL_INIT_VIDEO, -resizeable => 1);
	$app2->sync;

	my $driver = SDL::Video::video_driver_name();
	#should really check for all drivers that don't support resize
	skip "Video driver $driver doesn't support resize", 3 if ( $driver  eq 'fbcon' || $driver eq 'dummy' );

	ok(eval { $app2->resize(640, 480); 1 }, "succeed at resize with $driver");
	ok(!eval { $app2->resize(-1, -1); 1 }, "fail to resize to bad size with $driver");
	like($@, qr/cannot set video/, "check error message");
}

if($videodriver)
{
	$ENV{SDL_VIDEODRIVER} = $videodriver;
}
else
{
	delete $ENV{SDL_VIDEODRIVER};
}

sleep(2);
