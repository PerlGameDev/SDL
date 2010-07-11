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

use SDL::TTF ':all';
use SDL::TTF::Font;
use SDL::RWOps;
use SDL::Version;
use Encode;

my $videodriver       = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};



my $lv = SDL::TTF::linked_version();
my $cv = SDL::TTF::compile_time_version();

isa_ok($lv, 'SDL::Version', '[linked_version] returns a SDL::Version object');
isa_ok($cv, 'SDL::Version', '[compile_time_version] returns a SDL::Version object');
printf("got version: %d.%d.%d/%d.%d.%d\n", $lv->major, $lv->minor, $lv->patch, $cv->major, $cv->minor, $cv->patch);

is( TTF_HINTING_NORMAL,                                   0, 'TTF_HINTING_NORMAL should be imported' );
is( TTF_HINTING_NORMAL(),                                 0, 'TTF_HINTING_NORMAL() should also be available' );
is( TTF_HINTING_LIGHT,                                    1, 'TTF_HINTING_LIGHT should be imported' );
is( TTF_HINTING_LIGHT(),                                  1, 'TTF_HINTING_LIGHT() should also be available' );
is( TTF_HINTING_MONO,                                     2, 'TTF_HINTING_MONO should be imported' );
is( TTF_HINTING_MONO(),                                   2, 'TTF_HINTING_MONO() should also be available' );
is( TTF_HINTING_NONE,                                     3, 'TTF_HINTING_NONE should be imported' );
is( TTF_HINTING_NONE(),                                   3, 'TTF_HINTING_NONE() should also be available' );
is( TTF_STYLE_NORMAL,                                     0, 'TTF_STYLE_NORMAL should be imported' );
is( TTF_STYLE_NORMAL(),                                   0, 'TTF_STYLE_NORMAL() should also be available' );
is( TTF_STYLE_BOLD,                                       1, 'TTF_STYLE_BOLD should be imported' );
is( TTF_STYLE_BOLD(),                                     1, 'TTF_STYLE_BOLD() should also be available' );
is( TTF_STYLE_ITALIC,                                     2, 'TTF_STYLE_ITALIC should be imported' );
is( TTF_STYLE_ITALIC(),                                   2, 'TTF_STYLE_ITALIC() should also be available' );
is( TTF_STYLE_UNDERLINE,                                  4, 'TTF_STYLE_UNDERLINE should be imported' );
is( TTF_STYLE_UNDERLINE(),                                4, 'TTF_STYLE_UNDERLINE() should also be available' );
is( TTF_STYLE_STRIKETHROUGH,                              8, 'TTF_STYLE_STRIKETHROUGH should be imported' );
is( TTF_STYLE_STRIKETHROUGH(),                            8, 'TTF_STYLE_STRIKETHROUGH() should also be available' );

is( SDL::TTF::was_init(),                                 0,                   "[was_init] returns false" );
is( SDL::TTF::init(),                                     0,                   "[init] succeeded" );
is( SDL::TTF::was_init(),                                 1,                   "[was_init] returns true" );
is( SDL::TTF::quit(),                  			  undef,               "[quit] ran" );
is( SDL::TTF::was_init(),                                 0,                   "[was_init] returns false" );
is( SDL::TTF::init(),                                     0,                   "[init] succeeded" );
is( SDL::TTF::byte_swapped_unicode(0),                    undef,               "[ttf_byte_swapped_unicode] on" );
is( SDL::TTF::byte_swapped_unicode(1),                    undef,               "[ttf_byte_swapped_unicode] off" );
my $font = SDL::TTF::open_font('test/data/aircut3.ttf', 24);
isa_ok( $font,                                            'SDL::TTF::Font',    "[open_font]" );
isa_ok( SDL::TTF::open_font_index('test/data/aircut3.ttf', 8, 0), 'SDL::TTF::Font', "[open_font_index]" );
my $file = SDL::RWOps->new_file('test/data/aircut3.ttf', 'r');
isa_ok( $file,                                            'SDL::RWOps',        "[new_file]");
isa_ok( SDL::TTF::open_font_RW($file, 0, 12),             'SDL::TTF::Font',    "[open_font_RW]" );
$file = SDL::RWOps->new_file('test/data/aircut3.ttf', 'r');
isa_ok( SDL::TTF::open_font_index_RW($file, 0, 16, 0),    'SDL::TTF::Font',    "[open_font_index_RW]" );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_NORMAL,    "[get_font_style] returns TTF_STYLE_NORMAL" );
is( SDL::TTF::set_font_style($font, TTF_STYLE_BOLD),      undef,               "[set_font_style] to TTF_STYLE_BOLD" );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_BOLD,      "[get_font_style] returns TTF_STYLE_BOLD" );
is( SDL::TTF::set_font_style($font, TTF_STYLE_ITALIC),    undef,               "[set_font_style] to TTF_STYLE_ITALIC" );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_ITALIC,    "[get_font_style] returns TTF_STYLE_ITALIC" );
is( SDL::TTF::set_font_style($font, TTF_STYLE_UNDERLINE), undef,               "[set_font_style] to TTF_STYLE_UNDERLINE" );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_UNDERLINE, "[get_font_style] returns TTF_STYLE_UNDERLINE" );
is( SDL::TTF::set_font_style($font, TTF_STYLE_NORMAL),    undef,               "[set_font_style] to TTF_STYLE_NORMAL" );
is( SDL::TTF::get_font_style($font),                      TTF_STYLE_NORMAL,    "[get_font_style] returns TTF_STYLE_NORMAL" );

SKIP:
{
	skip("Version 2.0.10 (or better) needed", 10) unless $cv->major >= 2 && $cv->minor >= 0 && $cv->patch >= 10
	                                                  && $lv->major >= 2 && $lv->minor >= 0 && $lv->patch >= 10;
	my $font_outline = SDL::TTF::get_font_outline($font);
	ok( $font_outline >= 0,                                                    "[get_font_outline] is $font_outline" );
	$font_outline++;
	SDL::TTF::set_font_outline($font, $font_outline);                     pass "[set_font_outline] to $font_outline";
	is( SDL::TTF::get_font_outline($font),                $font_outline,       "[get_font_outline] is $font_outline" );
	SKIP:
	{
		skip("Font hinting is buggy in SDL_ttf", 3);
		is( SDL::TTF::get_font_hinting($font),                TTF_HINTING_NORMAL,  "[get_font_hinting] is TTF_HINTING_NORMAL" );
		SDL::TTF::set_font_hinting($font, TTF_HINTING_LIGHT);                 pass "[set_font_hinting] to TTF_HINTING_LIGHT";
		is( SDL::TTF::get_font_hinting($font),                TTF_HINTING_LIGHT,   "[get_font_hinting] is TTF_HINTING_LIGHT" );
	}
	my $kerning_allowed = SDL::TTF::get_font_kerning($font);
	like( $kerning_allowed,                               '/^[01]$/',          "[get_font_kerning] is " . ($kerning_allowed ? 'allowed' : 'not allowed'));
	SDL::TTF::set_font_kerning($font, 0);                                 pass "[set_font_kerning to not allowed] ";
	$kerning_allowed = SDL::TTF::get_font_kerning($font);
	is( $kerning_allowed,                                 0,                   "[get_font_kerning] is " . ($kerning_allowed ? 'allowed' : 'not allowed'));
	ok( SDL::TTF::glyph_is_provided($font, "\0M") > 0,                         "[glyph_is_provided] is true for character 'M'");
}

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

my @glyph_metrics = @{ SDL::TTF::glyph_metrics($font, "\0M") };
is( scalar @glyph_metrics,                                5,                   "[glyph_metrics] (minx, maxx, miny, maxy, advance) = (" . join(', ', @glyph_metrics) . ")" );

my ($width, $height) = @{ SDL::TTF::size_text($font, 'Hallo World!') };
ok( $width > 0 && $height > 0,                                                 "[size_text] width=$width height=$height" );

($width, $height) = @{ SDL::TTF::size_utf8($font, "Hallo World!") };
ok( $width > 0 && $height > 0,                                                 "[size_utf8] width=$width height=$height" );
SKIP:
{
	skip('Unicode::String is needed for this', 2) unless eval 'use Unicode::String qw(latin1 utf8); 1';
	my $unicode = latin1("Hallo World!");
	($width, $height) = @{ SDL::TTF::size_unicode($font, $unicode->utf16be) };
	ok( $width > 0 && $height > 0,                                                 "[size_unicode] width=$width height=$height" );
}

SKIP:
{
	skip('We need video support for this', 15) unless SDL::TestTool->init(SDL_INIT_VIDEO);
	
	my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );

	my $y          = 0;
	my $text_fg    = SDL::Color->new( 0xFF,0xFF,0xFF );
	my $utf8_fg    = SDL::Color->new( 0x80,0x80,0xFF );
	my $glyph_fg   = SDL::Color->new( 0x80,0xFF,0x80 );
	my $unicode_fg = SDL::Color->new( 0xFF,0x80,0x80 );
	my $bg         = SDL::Color->new( 0x80,0x80,0x80 );
	my $black      = SDL::Video::map_RGB( $display->format, 0x00,0x00,0x00 );
	SDL::Video::fill_rect( $display, SDL::Rect->new(0, 0, 640, 480), $black );

	my $render_text_solid = SDL::TTF::render_text_solid($font, 'render_text_solid', $text_fg);
	isa_ok( $render_text_solid, 'SDL::Surface', "[render_text_solid]" );
	SDL::Video::blit_surface( $render_text_solid, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	my $render_text_shaded = SDL::TTF::render_text_shaded($font, 'render_text_shaded', $text_fg, $bg);
	isa_ok( $render_text_shaded, 'SDL::Surface', "[render_text_shaded]" );
	SDL::Video::blit_surface( $render_text_shaded, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	my $render_text_blended = SDL::TTF::render_text_blended($font, 'render_text_blended', $text_fg);
	isa_ok( $render_text_blended , 'SDL::Surface', "[render_text_blended]" );
	SDL::Video::blit_surface( $render_text_blended, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	my $render_utf8_solid = SDL::TTF::render_utf8_solid($font, "render_utf8_solid", $utf8_fg);
	isa_ok( $render_utf8_solid, 'SDL::Surface', "[render_utf8_solid]" );
	SDL::Video::blit_surface( $render_utf8_solid, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	my $render_utf8_shaded = SDL::TTF::render_utf8_shaded($font, "render_utf8_shaded", $utf8_fg, $bg);
	isa_ok( $render_utf8_shaded, 'SDL::Surface', "[render_utf8_shaded]" );
	SDL::Video::blit_surface( $render_utf8_shaded, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );

	my $render_utf8_blended = SDL::TTF::render_utf8_blended($font, "render_utf8_blended", $utf8_fg);
	isa_ok( $render_utf8_blended, 'SDL::Surface', "[render_utf8_blended]" );
	SDL::Video::blit_surface( $render_utf8_blended, SDL::Rect->new(0, 0,640, 480), $display, SDL::Rect->new(5, $y += 27, 640, 480) );
	
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

END
{

if($videodriver)
{
	$ENV{SDL_VIDEODRIVER} = $videodriver;
}
else
{
	delete $ENV{SDL_VIDEODRIVER};
}

done_testing;
}
