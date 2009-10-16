#!perl -w
# Copyright (C) 2009 kthakore
#
# Spec tests for SDL::Surface
#

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
	}

use strict;
use SDL;
use SDL::Config;
use SDL::Surface;
use SDL::App;
use SDL::Rect;
use SDL::Color;
use Test::More;

plan (tests => 2 );


my $app  = SDL::App->new(-title => "Test", -width => 640, -height => 480, -init => SDL_INIT_VIDEO);

pass 'did this pass';

my $rect = SDL::Rect->new(0,0, $app->w, $app->h);


	my $blue = SDL::Color->new(
		0x00,
		0x00,
		0xff,
	);

$app->fill_rect($rect,$blue);


diag('This is in surface : '.SDL::Surface::get_pixels($app));

pass 'did this pass';

