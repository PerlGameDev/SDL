#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

my @done = qw//;

TODO:
{
  local $TODO = "Tests for SDL::TTF::Font object";
  my $font; #uncomment the next line after we get TTF::Font
 # my $font = TTF::Font->new(); #use TTF_OpenFont

  isa_ok( $font, 'TTF::Font', '[Font] Constructs');
  my $rwops; #uncomment next line after we get RWops
  # my $rwops = SDL::RWops->new_from_file('../test/data/aircut3.ttf');  
  #$font = TTF::Font->new_rw($rwops, 1, 16); #use TTF_OpenFontRW
  isa_ok( $font, 'TTF::Font', '[Font] Constructs from RWops');

  #$font = TTF::Font->new_index('../test/data/aircut3.ttf', 16, 0); #use TTF_OpenFontIndex
  isa_ok( $font, 'TTF::Font', '[Font] Constructs from file with index');

  #$font = TTF::Font->new_rw_index($rwops, 1, 16, 0); #use TTF_OpenFontIndexRW
  isa_ok( $font, 'TTF::Font', '[Font] Constructs from file with index with RW');

}

my @left = qw/
linked_version	  	
init	  	
was_init	  	
quit	  	
set_error	  	
get_error	  	
byte_swapped_unicode	  	
get_font_style	  	
set_font_style	  	
get_font_outline	  	
set_font_outline	  	
get_font_hinting	  	
set_font_hinting	  	
get_font_kerning	  	
set_font_kerning	  	
font_height	  	
font_ascent	  	
font_descent	  	
font_lineskip	  	
font_faces	  	
font_face_is_fixedwidth	  	
font_face_family_name	  	
font_face_style_name	  	
glyph_is_provided	  	
glyph_metrics	  	
size_text	  	
size_UTF8	  	
size_UNICODE	  	
render_utf8_solid	  	
render_unicode_solid	  	
render_glyph_solid	  	
render_text_shaded	  	
render_utf8_shaded	  	
render_unicode_shaded	  	
render_glyph_shaded	  	
render_text_blended	  	
render_utf8_blended	  	
render_unicode_blended	  	
render_glyph_blended	  
/;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    fail "Not Implmented $_" foreach(@left)
    
}
diag $why;

done_testing;
