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
    plan( tests => 6 );
}

my @done =qw/
pixel_color
/;

use_ok('SDL');
use_ok('SDL::Surface');
use_ok('SDL::GFX::Primitives');

my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );
my $pixel   = SDL::Video::map_RGB( $display->format, 0, 0, 0 );
SDL::Video::fill_rect( $display, SDL::Rect->new( 0, 0, $display->w, $display->h ), $pixel );


if(!$display)
{
	plan skip_all => 'Couldn\'t set video mode: ' . SDL::get_error();
}


SDL::Video::lock_surface($display) if(SDL::Video::MUSTLOCK($display));

my $col = 0xFF00FF00;

for(0..256)
{
	$col++;
	SDL::GFX::Primitives::pixel_color($display, 5 + $_, 5 + $_, $col); 
}
is( SDL::GFX::Primitives::pixel_color($display, 5, 5, 0xFF00FFFF), 0,   'pixel_color' );

SDL::Video::unlock_surface($display) if(SDL::Video::MUSTLOCK($display));

SDL::Video::update_rect($display, 0, 0, 640, 480); 

SDL::delay(100);

my @left = qw/
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


