#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;
use SDL::Color;
use SDL::Surface;
use SDL::Overlay;
use SDL::Rect;
use SDL::Video;
use SDL::PixelFormat;

BEGIN {
	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

	if ( !SDL::Config->has('SDL_Pango') ) {
		plan( skip_all => 'SDL_Pango support not compiled' );
	}
}

use SDL::Pango;
use SDL::Pango::Context;
use SDL::Version;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

is( SDL::Pango::was_init(), 0, "[was_init] returns false" );
is( SDL::Pango::init(),     0, "[init] succeeded" );
isnt( SDL::Pango::was_init(), 0, "[was_init] returns true" );

my $context = SDL::Pango::Context->new;
isa_ok( $context, 'SDL::Pango::Context', "[new SDL::Pango::Context]" );
my $text = 'Hi <b><span foreground="red"><i>k</i></span>thakore</b> its me, <u>Pango</u>!!';

SDL::Pango::set_default_color( $context, 0xA7C344FF, 0 );
pass "[set_default_color] ran";
SDL::Pango::set_default_color(
	$context, 0xA7, 0xC3, 0x44, 0xFF, 0, 0, 0,
	0x00
);
pass "[set_default_color] ran";
SDL::Pango::set_minimum_size( $context, 640, 0 );
pass "[set_minimum_size] ran";
SDL::Pango::set_text( $context, $text, 20 );
pass "[set_text] ran";
SDL::Pango::set_markup( $context, $text, -1 );
pass "[set_markup] ran";

my $w = SDL::Pango::get_layout_width($context);
ok( $w >= 0, "[get_layout_width] width is $w" );
my $h = SDL::Pango::get_layout_height($context);
ok( $h >= 0, "[get_layout_height] height is $h" );

is( SDLPANGO_DIRECTION_LTR,      0, "constant: SDLPANGO_DIRECTION_LTR" );
is( SDLPANGO_DIRECTION_RTL,      1, "constant: SDLPANGO_DIRECTION_RTL" );
is( SDLPANGO_DIRECTION_WEAK_LTR, 2, "constant: SDLPANGO_DIRECTION_WEAK_LTR" );
is( SDLPANGO_DIRECTION_WEAK_RTL, 3, "constant: SDLPANGO_DIRECTION_WEAK_RTL" );
is( SDLPANGO_DIRECTION_NEUTRAL,  4, "constant: SDLPANGO_DIRECTION_NEUTRAL" );

SDL::Pango::set_base_direction( $context, SDLPANGO_DIRECTION_LTR );
pass "[set_base_direction] to SDLPANGO_DIRECTION_LTR";
SDL::Pango::set_dpi( $context, 48, 48 );
pass "[set_dpi] to x=48 and y=48";
SDL::Pango::set_language( $context, "en" );
pass "[set_language] to 'en'";

SKIP:
{
	skip( 'We need video support for this', 2 )
		unless SDL::TestTool->init(SDL_INIT_VIDEO);

	my $display = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );
	SDL::Pango::draw( $context, $display, ( 640 - $w ) / 2, ( 480 - $h ) / 2 );
	pass "[draw] ran";
	my $bg = SDL::Video::map_RGB( $display->format, 0x12, 0x22, 0x45 );
	SDL::Video::fill_rect( $display, SDL::Rect->new( 0, 0, 640, 480 ), $bg );
	SDL::Pango::set_surface_create_args(
		$context,  SDL_SWSURFACE, 32, 255 << 24,
		255 << 16, 255 << 8,      255
	);
	pass "[set_surface_create_args] ran";
	my $surface = SDL::Pango::create_surface_draw($context);
	isa_ok( $surface, 'SDL::Surface', "[create_surface_draw]" );
	SDL::Video::blit_surface(
		$surface, SDL::Rect->new( 0, 0, 640, 480 ),
		$display,
		SDL::Rect->new( ( 640 - $w ) / 2, ( 480 - $h ) / 2, $w, $h )
	);

	SDL::Video::update_rect( $display, 0, 0, 0, 0 );
	SDL::delay(2000);
}

if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

pass 'Are we still alive? Checking for segfaults';

done_testing;

sleep(1);
