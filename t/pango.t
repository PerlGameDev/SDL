#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;
use SDL::Color;
use SDL::Surface;
use SDL::Overlay;
use SDL::Rect;
use SDL::Video;

BEGIN
{
	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

	if( !SDL::Config->has('SDL_Pango') )
	{
	    plan( skip_all => 'SDL_Pango support not compiled' );
	}
}

use SDL::Pango;
use SDL::Pango::Context;
use SDL::Version;

is( SDL::Pango::was_init(),                                 0,                   "[was_init] returns false" );
is( SDL::Pango::init(),                                     0,                   "[init] succeeded" );
is( SDL::Pango::was_init(),                                -1,                   "[was_init] returns true" );

done_testing;

sleep(1);
