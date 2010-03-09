#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;

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

my $v = SDL::TTF::linked_version();

isa_ok($v, 'SDL::Version', '[linked_version] returns a SDL::Version object');

diag sprintf("got version: %d.%d.%d", $v->major, $v->minor, $v->patch);
is( SDL::TTF::was_init(),                                 0,                   "[was_init] returns false" );
is( SDL::TTF::init(),                                     0,                   "[init] succeeded" );
is( SDL::TTF::was_init(),                                 1,                   "[was_init] returns true" );
is( SDL::TTF::byte_swapped_unicode(0),                    undef,               "[ttf_byte_swapped_unicode] on" );
is( SDL::TTF::byte_swapped_unicode(1),                    undef,               "[ttf_byte_swapped_unicode] off" );
my $font = SDL::TTF::open_font('test/data/aircut3.ttf', 24);
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
is( scalar @glyph_metrics, 5, "[glyph_metrics] (minx, maxx, miny, maxy, advance) = (" . join(', ', @glyph_metrics) . ")" );
#is( SDL::TTF::size_text(font, text, w, h), 0, "[size_text] " );
#is( SDL::TTF::size_utf8(font, text, w, h), 0, "[size_utf8] " );
#is( SDL::TTF::size_unicode(font, text, w, h), 0, "[size_unicode] " );
#is( SDL::TTF::render_text_solid(font, text, fg), 0, "[render_text_solid] " );
#is( SDL::TTF::render_utf8_solid(font, text, fg), 0, "[render_utf8_solid] " );
#is( SDL::TTF::render_unicode_solid(font, text, fg), 0, "[render_unicode_solid] " );
#is( SDL::TTF::render_glyph_solid(font, ch, fg), 0, "[render_glyph_solid] " );
#is( SDL::TTF::render_text(font, text, fg, bg), 0, "[render_text] " );
#is( SDL::TTF::render_text_shaded(font, text, fg, bg), 0, "[render_text_shaded] " );
#is( SDL::TTF::render_utf8(font, text, fg, bg), 0, "[render_utf8] " );
#is( SDL::TTF::render_utf8_shaded(font, text, fg, bg), 0, "[render_utf8_shaded] " );
#is( SDL::TTF::render_unicode(font, text, fg, bg), 0, "[render_unicode] " );
#is( SDL::TTF::render_unicode_shaded(font, text, fg, bg), 0, "[render_unicode_shaded] " );
#is( SDL::TTF::render_glyph_shaded(font, ch, fg, bg), 0, "[render_glyph_shaded] " );
#is( SDL::TTF::render_text_blended(font, text, fg), 0, "[render_text_blended] " );
#is( SDL::TTF::render_utf8_blended(font, text, fg), 0, "[render_utf8_blended] " );
#is( SDL::TTF::render_unicode_blended(font, text, fg), 0, "[render_unicode_blended] " );
#is( SDL::TTF::render_glyph_blended(font, ch, fg), 0, "[render_glyph_blended] " );

is( SDL::TTF::was_init(),                  1, "[was_init] returns true" );
is( SDL::TTF::quit(),                  undef, "[quit] ran" );
is( SDL::TTF::was_init(),                  0, "[was_init] returns false" );

my @done = qw/
linked_version
init
byte_swapped_unicode
open_font
quit
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
/;

my @left = qw/
open_font_index
open_font_RW
open_font_index_RW
size_text
size_utf8
size_unicode
render_text_solid
render_utf8_solid
render_unicode_solid
render_glyph_solid
render_text
render_text_shaded
render_utf8
render_utf8_shaded
render_unicode
render_unicode_shaded
render_glyph_shaded
render_text_blended
render_utf8_blended
render_unicode_blended
render_glyph_blended
/;

#TODO:
#{
  #local $TODO = "Tests for SDL::TTF::Font object";
  #my $font; #uncomment the next line after we get TTF::Font
 # my $font = TTF::Font->new(); #use TTF_OpenFont

  #isa_ok( $font, 'TTF::Font', '[Font] Constructs');
  #my $rwops; #uncomment next line after we get RWops
  # my $rwops = SDL::RWops->new_from_file('../test/data/aircut3.ttf');  
  #$font = TTF::Font->new_rw($rwops, 1, 16); #use TTF_OpenFontRW
  #isa_ok( $font, 'TTF::Font', '[Font] Constructs from RWops');

  #$font = TTF::Font->new_index('../test/data/aircut3.ttf', 16, 0); #use TTF_OpenFontIndex
  #isa_ok( $font, 'TTF::Font', '[Font] Constructs from file with index');

  #$font = TTF::Font->new_rw_index($rwops, 1, 16, 0); #use TTF_OpenFontIndexRW
  #isa_ok( $font, 'TTF::Font', '[Font] Constructs from file with index with RW');
#}


my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

#TODO:
#{
#    local $TODO = $why;
#    fail "Not Implmented $_" foreach(@left)
#}
diag $why;

done_testing;
