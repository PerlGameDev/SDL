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

	if( !SDL::Config->has('SDL_ttf') )
	{
	    plan( skip_all => 'SDL_ttf support not compiled' );
	}
}

use SDL::TTF;
use SDL::TTF_Font;
use SDL::Version;
use Encode;

my $v = SDL::TTF::linked_version();

isa_ok($v, 'SDL::Version', '[linked_version] returns a SDL::Version object');
diag sprintf("got version: %d.%d.%d", $v->major, $v->minor, $v->patch);
is( SDL::TTF::was_init(),                                 0,                   "[was_init] returns false" );
is( SDL::TTF::init(),                                     0,                   "[init] succeeded" );
is( SDL::TTF::was_init(),                                 1,                   "[was_init] returns true" );
is( SDL::TTF::byte_swapped_unicode(0),                    undef,               "[ttf_byte_swapped_unicode] on" );
is( SDL::TTF::byte_swapped_unicode(1),                    undef,               "[ttf_byte_swapped_unicode] off" );
my $font = SDL::TTF::open_font('test/data/aircut3.ttf', 24);
#my $font = SDL::TTF::open_font('test/data/arial.ttf', 24);
#my $font = SDL::TTF::open_font('test/data/electrohar.ttf', 24);
isa_ok( $font,                                           'SDL::TTF_Font',      "[open_font]" );
#is( SDL::TTF::open_font_index(file, ptsize, index), 0, "[open_font_index] " );
#is( SDL::TTF::open_font_RW(src, freesrc, ptsize), 0, "[open_font_RW] " );
#is( SDL::TTF::open_font_index_RW(src, freesrc, ptsize, index), 0, "[open_font_index_RW] " );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_NORMAL,    "[get_font_style] returns TTF_STYLE_NORMAL" );
is( SDL::TTF::set_font_style($font, TTF_STYLE_BOLD),      undef,               "[set_font_style] to TTF_STYLE_BOLD" );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_BOLD,      "[get_font_style] returns TTF_STYLE_BOLD" );
is( SDL::TTF::set_font_style($font, TTF_STYLE_ITALIC),    undef,               "[set_font_style] to TTF_STYLE_ITALIC" );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_ITALIC,    "[get_font_style] returns TTF_STYLE_ITALIC" );
is( SDL::TTF::set_font_style($font, TTF_STYLE_UNDERLINE), undef,               "[set_font_style] to TTF_STYLE_UNDERLINE" );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_UNDERLINE, "[get_font_style] returns TTF_STYLE_UNDERLINE" );
is( SDL::TTF::set_font_style($font, TTF_STYLE_NORMAL),    undef,               "[set_font_style] to TTF_STYLE_NORMAL" );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_NORMAL,    "[get_font_style] returns TTF_STYLE_NORMAL" );

my $font_height = SDL::TTF::font_height($font);
ok( $font_height,                                                              "[font_height] is $font_height" );

my $font_ascent = SDL::TTF::font_ascent($font);
like( $font_ascent,                                       '/^[-]?\d+$/',       "[font_ascent] offset from the baseline to the top of the font is $font_ascent" );

my $font_descent = SDL::TTF::font_descent($font);
like( $font_descent,                                      '/^[-]?\d+$/',       "[font_descent] offset from the baseline to the bottom of the font is $font_descent" );

my $font_line_skip = SDL::TTF::font_line_skip($font);
like( $font_line_skip,                                    '/^[-]?\d+$/',       "[font_line_skip] recommended spacing between lines of text is $font_line_skip" );

my $font_faces = SDL::TTF::font_faces($font);
ok( $font_faces,                                                               "[font_faces] font has $font_faces faces" );

my $font_face_is_fixed_width = SDL::TTF::font_face_is_fixed_width($font);
like( $font_face_is_fixed_width,                          '/^[01]$/',          "[font_face_is_fixed_width] is $font_face_is_fixed_width" );

my $font_face_family_name = SDL::TTF::font_face_family_name($font);
ok( $font_face_family_name,                                                    "[font_face_family_name] is $font_face_family_name" );

my $font_face_style_name = SDL::TTF::font_face_style_name($font);
ok( $font_face_style_name,                                                     "[font_face_style_name] is $font_face_style_name" );

my @glyph_metrics = @{ SDL::TTF::glyph_metrics($font, 'M') };
is( scalar @glyph_metrics,                                5,                   "[glyph_metrics] (minx, maxx, miny, maxy, advance) = (" . join(', ', @glyph_metrics) . ")" );

my ($width, $height) = @{ SDL::TTF::size_text($font, 'Hallo World!') };
ok( $width > 0 && $height > 0,                                                 "[size_text] width=$width height=$height" );

SKIP:
{
	skip('Unicode::String is needed for this', 2) unless eval 'use Unicode::String qw(latin1); 1';
	my $unicode = latin1("Hallo World!");
	($width, $height) = @{ SDL::TTF::size_utf8($font, $unicode->utf8) };
	ok( $width > 0 && $height > 0,                                                 "[size_utf8] width=$width height=$height" );

	($width, $height) = @{ SDL::TTF::size_unicode($font, $unicode->utf16be) };
	ok( $width > 0 && $height > 0,                                                 "[size_unicode] width=$width height=$height" );
}

SKIP:
{
	skip('We need video support for this', 15) unless SDL::TestTool->init(SDL_INIT_VIDEO);
	
	my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );

	my $text_fg    = SDL::Color->new( 0xFF,0xFF,0xFF );
	my $utf8_fg    = SDL::Color->new( 0x80,0x80,0xFF );
	my $glyph_fg   = SDL::Color->new( 0x80,0xFF,0x80 );
	my $unicode_fg = SDL::Color->new( 0xFF,0x80,0x80 );
	my $bg         = SDL::Color->new( 0x80,0x80,0x80 );
	my $black      = SDL::Video::map_RGB( $display->format, 0x00,0x00,0x00 );
	SDL::Video::fill_rect( $display, SDL::Rect->new(0, 0, 640, 480), $black );
	
	my $y     = 0;

	my $render_text_solid = SDL::TTF::render_text_solid($font, 'render_text_solid', $text_fg);
	isa_ok( $render_text_solid, 'SDL::Surface', "[render_text_solid]" );
	SDL::Video::blit_surface( $render_text_solid, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	my $render_text_shaded = SDL::TTF::render_text_shaded($font, 'render_text_shaded', $text_fg, $bg);
	isa_ok( $render_text_shaded, 'SDL::Surface', "[render_text_shaded]" );
	SDL::Video::blit_surface( $render_text_shaded, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	my $render_text_blended = SDL::TTF::render_text_blended($font, 'render_text_blended', $text_fg);
	isa_ok( $render_text_blended , 'SDL::Surface', "[render_text_blended]" );
	SDL::Video::blit_surface( $render_text_blended, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	SKIP:
	{
		skip('Unicode::String is needed for this', 3) unless eval 'use Unicode::String qw(latin1); 1';
		my $unicode = latin1("render_utf8_solid");
		my $render_utf8_solid = SDL::TTF::render_utf8_solid($font, $unicode->utf8, $utf8_fg);
		isa_ok( $render_utf8_solid, 'SDL::Surface', "[render_utf8_solid]" );
		SDL::Video::blit_surface( $render_utf8_solid, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

		$unicode = latin1("render_utf8_shaded");
		my $render_utf8_shaded = SDL::TTF::render_utf8_shaded($font, $unicode->utf8, $utf8_fg, $bg);
		isa_ok( $render_utf8_shaded, 'SDL::Surface', "[render_utf8_shaded]" );
		SDL::Video::blit_surface( $render_utf8_shaded, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

		$unicode = latin1("render_utf8_blended");
		my $render_utf8_blended = SDL::TTF::render_utf8_blended($font, $unicode->utf8, $utf8_fg);
		isa_ok( $render_utf8_blended, 'SDL::Surface', "[render_utf8_blended]" );
		SDL::Video::blit_surface( $render_utf8_blended, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );
	}
	
	my $render_glyph_solid = SDL::TTF::render_glyph_solid($font, 'r', $glyph_fg);
	isa_ok( $render_glyph_solid, 'SDL::Surface', "[render_glyph_solid]" );
	SDL::Video::blit_surface( $render_glyph_solid, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	my $render_glyph_shaded = SDL::TTF::render_glyph_shaded($font, 'r', $glyph_fg, $bg);
	isa_ok( $render_glyph_shaded, 'SDL::Surface', "[render_glyph_shaded]" );
	SDL::Video::blit_surface( $render_glyph_shaded, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	my $render_glyph_blended = SDL::TTF::render_glyph_blended($font, 'r', $glyph_fg);
	isa_ok( $render_glyph_blended, 'SDL::Surface', "[render_glyph_blended]" );
	SDL::Video::blit_surface( $render_glyph_blended, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );
	
	SKIP:
	{
		skip('Unicode::String is needed for this', 3) unless eval 'use Unicode::String qw(latin1); 1';
		my $unicode = latin1("render_unicode_solid");
		my $render_unicode_solid = SDL::TTF::render_unicode_solid($font, $unicode->utf16be, $unicode_fg);
		isa_ok( $render_unicode_solid, 'SDL::Surface', "[render_unicode_solid]" );
		SDL::Video::blit_surface( $render_unicode_solid, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

		$unicode = latin1("render_unicode_shaded");
		my $render_unicode_shaded = SDL::TTF::render_unicode_shaded($font, "\xFF\xFE" . $unicode->utf16le, $unicode_fg, $bg);
		isa_ok( $render_unicode_shaded, 'SDL::Surface', "[render_unicode_shaded]" );
		SDL::Video::blit_surface( $render_unicode_shaded, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

		$unicode = latin1("render_unicode_blended");
		my $render_unicode_blended = SDL::TTF::render_unicode_blended($font, $unicode->utf16be, $unicode_fg);
		isa_ok( $render_unicode_blended, 'SDL::Surface', "[render_unicode_blended]" );
		SDL::Video::blit_surface( $render_unicode_blended, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );
	}
	
	SDL::Video::update_rect( $display, 0, 0, 0, 0 );

	SDL::delay(2000);
}
is( SDL::TTF::was_init(),                  1, "[was_init] returns true" );
is( SDL::TTF::quit(),                  undef, "[quit] ran" );
is( SDL::TTF::was_init(),                  0, "[was_init] returns false" );

my @done = qw/
linked_version
init
byte_swapped_unicode
open_font
was_init
get_font_style
set_font_style
font_height
font_ascent
font_descent
font_line_skip
font_faces
font_face_is_fixed_width
font_face_family_Name
font_face_style_name
glyph_metrics
size_text
size_utf8
size_unicode
render_text_solid
render_text_shaded
render_text_blended
render_utf8_solid
render_utf8_shaded
render_utf8_blended
render_glyph_solid
render_glyph_shaded
render_glyph_blended
render_unicode_solid
render_unicode_shaded
render_unicode_blended
quit
/;

my @left = qw/
open_font_index
open_font_RW
open_font_index_RW
/;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

diag $why;

SDL::quit();

done_testing;

sleep(1);
