#!perl
use strict;
use warnings;
use SDL;
use SDL::Rect;
use SDL::Config;
use SDL::Video;
use SDL::Surface;
use SDL::GFX::Primitives;
use Test::More;

use lib 't/lib';
use SDL::TestTool;

if( !SDL::TestTool->init(SDL_INIT_VIDEO) )
{
    plan( skip_all => 'Failed to init video' );
}
elsif( !SDL::Config->has('SDL_gfx') )
{
    plan( skip_all => 'SDL_gfx support not compiled' );
}
else
{
    plan( tests => 34 );
}

my @done =qw/
pixel_color
pixel_RGBA
hline_color
hline_RGBA
vline_color
vline_RGBA
rectangle_color
rectangle_RGBA
box_color
box_RGBA
line_color
line_RGBA
aaline_color
aaline_RGBA
circle_color
circle_RGBA
arc_color
arc_RGBA
aacircle_color
aacircle_RGBA
filled_circle_color
filled_circle_RGBA
ellipse_color
ellipse_RGBA
aaellipse_color
aaellipse_RGBA
filled_ellipse_color
filled_ellipse_RGBA
pie_color
pie_RGBA
filled_pie_color
filled_pie_RGBA
/;

my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );
my $pixel   = SDL::Video::map_RGB( $display->format, 0, 0, 0 );
SDL::Video::fill_rect( $display, SDL::Rect->new( 0, 0, $display->w, $display->h ), $pixel );


if(!$display)
{
	plan skip_all => 'Couldn\'t set video mode: ' . SDL::get_error();
}

SDL::Video::lock_surface($display) if(SDL::Video::MUSTLOCK($display));

for(0..256)
{
	SDL::GFX::Primitives::pixel_color($display, 5 + $_, 5 + $_, 0xFF00FF00 + $_); 
}
is( SDL::GFX::Primitives::pixel_color($display, 5, 5, 0xFF00FFFF), 0,   'pixel_color' );

for(0..256)
{
	SDL::GFX::Primitives::pixel_RGBA($display, 7 + $_, 3 + $_,
	                                 (($_ & 0b11100000) >> 5) * 16,
	                                 (($_ & 0b00011000) >> 3) * 64,
	                                  ($_ & 0b00000111)       * 16,
									 $_); 
}
is( SDL::GFX::Primitives::pixel_RGBA($display, 7, 3, 0xFF, 0x00, 0xFF, 0xFF), 0,   'pixel_RGBA' );

is( SDL::GFX::Primitives::hline_color($display,   9, 263,   3, 0x00FF00FF),             0, 'hline_color' ); # green
is( SDL::GFX::Primitives::hline_RGBA( $display,   5, 261, 261, 0xFF, 0xFF, 0x00, 0xFF), 0, 'hline_RGBA' );  # yellow
is( SDL::GFX::Primitives::vline_color($display,   5, 261,   7, 0x0000FFFF),             0, 'vline_color' ); # blue
is( SDL::GFX::Primitives::vline_RGBA( $display, 263,   3, 259, 0xFF, 0x00, 0x00, 0xFF), 0, 'vline_RGBA' );  # red

is( SDL::GFX::Primitives::rectangle_color($display, 377,   3, 635, 261, 0x00FF00FF),             0, 'rectangle_color' ); # green
is( SDL::GFX::Primitives::rectangle_RGBA( $display, 379,   5, 633, 259, 0xFF, 0xFF, 0x00, 0xFF), 0, 'rectangle_RGBA' );  # yellow

is( SDL::GFX::Primitives::box_color($display, 381,   7, 505, 257, 0x000033FF),             0, 'rectangle_color' ); # dark blue
is( SDL::GFX::Primitives::box_RGBA( $display, 507,   7, 631, 257, 0x33, 0x00, 0x00, 0xFF), 0, 'rectangle_RGBA' );  # dark red

is( SDL::GFX::Primitives::line_color($display, 265,   3, 375, 261, 0xFF00FFFF),             0, 'line_color' ); # pink
is( SDL::GFX::Primitives::line_RGBA( $display, 375,   3, 265, 261, 0x00, 0xFF, 0xFF, 0xFF), 0, 'line_RGBA' );  # turquoise

is( SDL::GFX::Primitives::aaline_color($display, 269,   3, 375, 251, 0xFF00FFFF),             0, 'aaline_color' ); # pink
is( SDL::GFX::Primitives::aaline_RGBA( $display, 371,   3, 265, 251, 0x00, 0xFF, 0xFF, 0xFF), 0, 'aaline_RGBA' );  # turquoise

is( SDL::GFX::Primitives::circle_color($display, 134, 346, 129, 0x00FF00FF),             0, 'circle_color' ); # green
is( SDL::GFX::Primitives::circle_RGBA( $display, 134, 346, 125, 0xFF, 0xFF, 0x00, 0xFF), 0, 'circle_RGBA' );  # yellow

is( SDL::GFX::Primitives::arc_color($display, 134, 346, 121,   5, 175, 0x00FF00FF),             0, 'arc_color' ); # green
is( SDL::GFX::Primitives::arc_RGBA( $display, 134, 346, 121, 185, 355, 0xFF, 0xFF, 0x00, 0xFF), 0, 'arc_RGBA' );  # yellow

is( SDL::GFX::Primitives::aacircle_color($display, 134, 346, 117, 0x00FF00FF),             0, 'aacircle_color' ); # green
is( SDL::GFX::Primitives::aacircle_RGBA( $display, 134, 346, 113, 0xFF, 0xFF, 0x00, 0xFF), 0, 'aacircle_RGBA' );  # yellow

is( SDL::GFX::Primitives::filled_circle_color($display, 134, 346, 107, 0x00FF00FF),             0, 'filled_circle_color' ); # green
is( SDL::GFX::Primitives::filled_circle_RGBA( $display, 134, 346,  75, 0xFF, 0xFF, 0x00, 0xFF), 0, 'filled_circle_RGBA' );  # yellow

is( SDL::GFX::Primitives::pie_color($display, 134, 346, 51, 90, 0, 0xFF0000FF),             0, 'pie_color' ); # red
is( SDL::GFX::Primitives::pie_RGBA( $display, 138, 350, 47, 0, 90, 0x00, 0x00, 0xFF, 0xFF), 0, 'pie_RGBA' );  # blue

is( SDL::GFX::Primitives::filled_pie_color($display, 134, 346, 43, 90, 0, 0xFF0000FF),             0, 'filled_pie_color' ); # red
is( SDL::GFX::Primitives::filled_pie_RGBA( $display, 138, 350, 39, 0, 90, 0x00, 0x00, 0xFF, 0xFF), 0, 'filled_pie_RGBA' );  # blue

is( SDL::GFX::Primitives::ellipse_color($display, 320, 346, 51, 129, 0x00FF00FF),             0, 'ellipse_color' ); # green
is( SDL::GFX::Primitives::ellipse_RGBA( $display, 320, 346, 47, 125, 0xFF, 0xFF, 0x00, 0xFF), 0, 'ellipse_RGBA' );  # yellow

is( SDL::GFX::Primitives::aaellipse_color($display, 320, 346, 43, 121, 0x00FF00FF),             0, 'aaellipse_color' ); # green
is( SDL::GFX::Primitives::aaellipse_RGBA( $display, 320, 346, 39, 117, 0xFF, 0xFF, 0x00, 0xFF), 0, 'aaellipse_RGBA' );  # yellow

is( SDL::GFX::Primitives::filled_ellipse_color($display, 320, 346, 35, 113, 0x00FF00FF),             0, 'filled_ellipse_color' ); # green
is( SDL::GFX::Primitives::filled_ellipse_RGBA( $display, 320, 346, 20, 64, 0xFF, 0xFF, 0x00, 0xFF), 0, 'filled_ellipse_RGBA' );  # yellow



SDL::Video::unlock_surface($display) if(SDL::Video::MUSTLOCK($display));

SDL::Video::update_rect($display, 0, 0, 640, 480); 

SDL::delay(100);

my @left = qw/
trigon_color
trigon_RGBA
aatrigon_color
aatrigon_RGBA
filled_trigon_color
filled_trigon_RGBA
polygon_color
polygon_RGBA
aapolygon_color
aapolygon_RGBA
filled_polygon_color
filled_polygon_RGBA
textured_polygon
filled_polygon_color_MT
filled_polygon_RGBA_MT
textured_polygon_MT
bezier_color
bezier_RGBA
character_color
character_RGBA
string_color
string_RGBA
set_font
/;

my $why = '[Percentage Completion] '.int( 100 * ($#done +1 ) / ($#done + $#left + 2  ) ) .'% implementation. '.($#done +1 ).'/'.($#done+$#left + 2 ); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 

pass 'Are we still alive? Checking for segfaults';

done_testing;


