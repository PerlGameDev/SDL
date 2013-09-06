#!/usr/bin/perl -w

# basic testing of SDLx::App
use strict;
use warnings;
use SDL;
use SDL::Config;
use SDL::Rect;
use SDLx::Rect;
use SDL::Color;
use SDL::Video;
use Test::More;
use lib 't/lib';
use SDL::TestTool;

plan( tests => 2 );

use SDLx::App;

can_ok(
	'SDLx::App', qw/
		new
		set_video_mode
		stash
		init
		screen_size
		resize
		title
		icon
		error
		warp_cursor
		show_cursor
		fullscreen
		iconify
		grab_input
		sync
		gl_attribute
		/
);

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

SKIP:
{
	skip 'No Video', 1 unless SDL::TestTool->init(SDL_INIT_VIDEO);

	my $app = SDLx::App->new(
		title  => "Test",
		width  => 640,
		height => 480,
		init   => SDL_INIT_VIDEO
	);

	my $rect = SDL::Rect->new( 0, 0, $app->w, $app->h );

	my $pixel_format = $app->format;
	my $blue_pixel   = SDL::Video::map_RGB( $pixel_format, 0x00, 0x00, 0xff );
	my $col_pixel    = SDL::Video::map_RGB( $pixel_format, 0xf0, 0x00, 0x33 );

	my $grect = SDLx::Rect->new( 10, 10, 30, 35 );
	foreach ( 0 .. 80 ) {

		$grect->x($_);
		$grect->centery( $_ * 3 );
		$grect->size( ( $_ / 40 ) * $_, ( $_ / 38 ) * $_ );
		SDL::Video::fill_rect( $app, $rect,  $blue_pixel );
		SDL::Video::fill_rect( $app, $grect, $col_pixel );

		SDL::Video::update_rect( $app, 0, 0, 640, 480 );
		SDL::delay(10);
	}

	SDL::delay(100);
	pass 'Ran';
}

if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

