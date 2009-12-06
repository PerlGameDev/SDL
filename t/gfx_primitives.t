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

# pixel tests
is( SDL::GFX::Primitives::pixel_color($display, 2, 3, 0xFF0000FF),             0, 'pixel_color' );
is( SDL::GFX::Primitives::pixel_RGBA( $display, 4, 3, 0x00, 0xFF, 0x00, 0xFF), 0, 'pixel_RGBA'  );

# demo for pixel functions
#SDL::GFX::Primitives::rectangle_color($display, 3,   4, 125, 106, 0xCCCCCCFF);
#SDL::GFX::Primitives::rectangle_color($display, 3, 116, 125, 218, 0xCCCCCCFF);

my $max_x              = 120;
my $max_y              = 100;
my $max_iterationen    = 400;
my $punkt_abstand_x    = 0.015;
my $punkt_abstand_y    = 0.015;
my $min_cx             = -2.1;
my $min_cy             = -1.1;
my $max_betrag_quadrat = 4000;

my $r = 0xFF;
my $g = 0x00;
my $b = 0x00;

for(my $x = 0; $x <= $max_x; $x++)
{
	if($x < 20)
	{
		$g += 12.7;
	}
	elsif($x < 40)
	{
		$r -= 12.7;
	}
	elsif($x < 60)
	{
		$r = 0;
		$b += 12.7;
	}
	elsif($x < 80)
	{
		$g -= 12.7;
	}
	elsif($x < 100)
	{
		$g = 0;
		$r += 12.7;
	}
	else
	{
		$b -= 12.7;
	}
	
    for(my $y = 0; $y <= $max_y; $y++)
    {
		# fractal
		my $iteration = mandel_point($min_cx + $x * $punkt_abstand_x, $min_cy + $y * $punkt_abstand_y);
		my $col       = ($iteration / $max_iterationen * 8192) & 0xFF;

		SDL::GFX::Primitives::pixel_RGBA($display, 4 + $x,   5 + $y, $col, 0, 256 - $col, 0xFF);
		
		# color picker
		SDL::GFX::Primitives::pixel_RGBA($display, 4 + $x, 117 + $y, $r, $g, $b, 0xFF - 0xFF * $y / $max_y);
    }
}

# line tests
is( SDL::GFX::Primitives::hline_color( $display, 131, 135,   4,    0x00FF00FF),             0, 'hline_color'  ); # green
is( SDL::GFX::Primitives::hline_RGBA(  $display, 131, 135,   6,    0xFF, 0xFF, 0x00, 0xFF), 0, 'hline_RGBA'   ); # yellow
is( SDL::GFX::Primitives::vline_color( $display, 137,   3,   7,    0x0000FFFF),             0, 'vline_color'  ); # blue
is( SDL::GFX::Primitives::vline_RGBA(  $display, 139,   3,   7,    0xFF, 0x00, 0x00, 0xFF), 0, 'vline_RGBA'   ); # red

# hline/vline demo
#SDL::GFX::Primitives::rectangle_color($display, 131, 55 + $_ * 20, 253, 67 + $_ * 20, 0xCCCCCCFF) for(0..5);
#SDL::GFX::Primitives::rectangle_color($display, 136 + $_ * 20, 50, 148 + $_ * 20, 172, 0xCCCCCCFF) for(0..5);
SDL::GFX::Primitives::hline_color( $display, 132, 252, $_, 0xFF000080) for( 56.. 66);
SDL::GFX::Primitives::hline_color( $display, 132, 252, $_, 0xFFFF0080) for( 76.. 86);
SDL::GFX::Primitives::hline_color( $display, 132, 252, $_, 0x00FF0080) for( 96..106);
SDL::GFX::Primitives::hline_color( $display, 132, 252, $_, 0x00FFFF80) for(116..126);
SDL::GFX::Primitives::hline_color( $display, 132, 252, $_, 0x0000FF80) for(136..146);
SDL::GFX::Primitives::hline_color( $display, 132, 252, $_, 0xFF00FF80) for(156..166);
SDL::GFX::Primitives::vline_color( $display, $_,  51, 171, 0xFF000080) for(137..147);
SDL::GFX::Primitives::vline_color( $display, $_,  51, 171, 0xFFFF0080) for(157..167);
SDL::GFX::Primitives::vline_color( $display, $_,  51, 171, 0x00FF0080) for(177..187);
SDL::GFX::Primitives::vline_color( $display, $_,  51, 171, 0x00FFFF80) for(197..207);
SDL::GFX::Primitives::vline_color( $display, $_,  51, 171, 0x0000FF80) for(217..227);
SDL::GFX::Primitives::vline_color( $display, $_,  51, 171, 0xFF00FF80) for(237..247);

# aaline test
is( SDL::GFX::Primitives::line_color(  $display, 261,   3, 265, 7, 0xFF00FFFF),             0, 'line_color'   ); # pink
is( SDL::GFX::Primitives::line_RGBA(   $display, 261,   7, 265, 3, 0x00, 0xFF, 0xFF, 0xFF), 0, 'line_RGBA'    ); # turquoise
is( SDL::GFX::Primitives::aaline_color($display, 267,   3, 271, 7, 0xFF00FFFF),             0, 'aaline_color' ); # pink
is( SDL::GFX::Primitives::aaline_RGBA( $display, 267,   7, 271, 3, 0x00, 0xFF, 0xFF, 0xFF), 0, 'aaline_RGBA'  ); # turquoise

# aaline demo
my $last_x = 287;
my $last_y = 62;
my @points_x = (309, 333, 355, 372, 380, 380, 371, 354, 332, 308, 286, 269, 261, 261, 270, 287);
my @points_y = (53, 53, 62, 79, 101, 125, 147, 164, 173, 173, 163, 146, 124, 100, 78, 62);

for my $p1 (0..15)
{
	for my $p2 (0..15)
	{
		SDL::GFX::Primitives::aaline_color($display, $points_x[$p1], $points_y[$p1], $points_x[$p2], $points_y[$p2], 0xFFFFFF50);
	}
}

# rectangle/box demo
#SDL::GFX::Primitives::rectangle_RGBA($display, 260 + $_ * 2, 5 + $_ / 120 * 100, 380 - $_ * 2, 105 - $_ / 120 * 100, $_ / 60 * 256, 0, 0, 0xFF) for(0..60);
#SDL::GFX::Primitives::box_RGBA($display, 260 + $_, 117 + $_ / 120 * 100, 380 - $_, 217 - $_ / 120 * 100, $_ / 120 * 256, 0, 0, 0x08) for(0..120);

# rectangle/box test
is( SDL::GFX::Primitives::rectangle_color($display, 390, 3, 394, 7, 0x00FF00FF),             0, 'rectangle_color' ); # green
is( SDL::GFX::Primitives::rectangle_RGBA( $display, 396, 3, 400, 7, 0xFF, 0xFF, 0x00, 0xFF), 0, 'rectangle_RGBA' );  # yellow
is( SDL::GFX::Primitives::box_color(      $display, 402, 3, 406, 7, 0x0000FFFF),             0, 'rectangle_color' ); # blue
is( SDL::GFX::Primitives::box_RGBA(       $display, 408, 3, 412, 7, 0xFF, 0x00, 0x00, 0xFF), 0, 'rectangle_RGBA' );  # red

# circle/arc/aacircle/filled_circle/pie/filled_pie test
is( SDL::GFX::Primitives::circle_color(       $display, 520, 5, 2, 0x00FF00FF),             0, 'circle_color' ); # green
is( SDL::GFX::Primitives::circle_RGBA(        $display, 527, 5, 2, 0xFF, 0xFF, 0x00, 0xFF), 0, 'circle_RGBA' );  # yellow
is( SDL::GFX::Primitives::aacircle_color(     $display, 534, 5, 2, 0x00FF00FF),             0, 'aacircle_color' ); # green
is( SDL::GFX::Primitives::aacircle_RGBA(      $display, 541, 5, 2, 0xFF, 0xFF, 0x00, 0xFF), 0, 'aacircle_RGBA' );  # yellow
is( SDL::GFX::Primitives::filled_circle_color($display, 548, 5, 2, 0x00FF00FF),             0, 'filled_circle_color' ); # green
is( SDL::GFX::Primitives::filled_circle_RGBA( $display, 555, 5, 2, 0xFF, 0xFF, 0x00, 0xFF), 0, 'filled_circle_RGBA' );  # yellow
is( SDL::GFX::Primitives::arc_color(          $display, 562, 5, 2,   5, 175, 0x00FF00FF),             0, 'arc_color' ); # green
is( SDL::GFX::Primitives::arc_RGBA(           $display, 569, 5, 2, 185, 355, 0xFF, 0xFF, 0x00, 0xFF), 0, 'arc_RGBA' );  # yellow
is( SDL::GFX::Primitives::pie_color(          $display, 576, 7, 5, 270, 0, 0xFF0000FF),             0, 'pie_color' ); # red
is( SDL::GFX::Primitives::pie_RGBA(           $display, 583, 7, 5, 270, 0, 0x00, 0x00, 0xFF, 0xFF), 0, 'pie_RGBA' );  # blue
is( SDL::GFX::Primitives::filled_pie_color(   $display, 590, 7, 5, 270, 0, 0xFF0000FF),             0, 'filled_pie_color' ); # red
is( SDL::GFX::Primitives::filled_pie_RGBA(    $display, 597, 7, 5, 270, 0, 0x00, 0x00, 0xFF, 0xFF), 0, 'filled_pie_RGBA' );  # blue

# circle/arc/aacircle/filled_circle/pie/filled_pie demo
SDL::GFX::Primitives::filled_circle_color($display, 553, 137, 36, 0x00FF0080);
SDL::GFX::Primitives::filled_circle_color($display, 601, 137, 36, 0x0000FF80);
SDL::GFX::Primitives::filled_circle_color($display, 577,  87, 36, 0xFF000080);
SDL::GFX::Primitives::arc_color(          $display, 553, 137, 36, 310, 335, 0xFFFFFF80);
SDL::GFX::Primitives::arc_color(          $display, 601, 137, 36, 205, 230, 0xFFFFFF80);
SDL::GFX::Primitives::arc_color(          $display, 577,  87, 36,  75, 105, 0xFFFFFF80);
SDL::GFX::Primitives::arc_color(          $display, 553, 137, 36,  48, 255, 0xFFFFFF80);
SDL::GFX::Primitives::arc_color(          $display, 601, 137, 36, 285, 132, 0xFFFFFF80);
SDL::GFX::Primitives::arc_color(          $display, 577,  87, 36, 155,  25, 0xFFFFFF80);

# ellipse/aaellipse/filled_ellipse tests
is( SDL::GFX::Primitives::ellipse_color(       $display,  3, 245, 1, 2, 0x00FF00FF),             0, 'ellipse_color' );        # green
is( SDL::GFX::Primitives::ellipse_RGBA(        $display,  7, 245, 1, 2, 0xFF, 0xFF, 0x00, 0xFF), 0, 'ellipse_RGBA' );         # yellow
is( SDL::GFX::Primitives::aaellipse_color(     $display, 11, 245, 1, 2, 0x00FF00FF),             0, 'aaellipse_color' );      # green
is( SDL::GFX::Primitives::aaellipse_RGBA(      $display, 15, 245, 1, 2, 0xFF, 0xFF, 0x00, 0xFF), 0, 'aaellipse_RGBA' );       # yellow
is( SDL::GFX::Primitives::filled_ellipse_color($display, 19, 245, 1, 2, 0x00FF00FF),             0, 'filled_ellipse_color' ); # green
is( SDL::GFX::Primitives::filled_ellipse_RGBA( $display, 23, 245, 1, 2, 0xFF, 0xFF, 0x00, 0xFF), 0, 'filled_ellipse_RGBA' );  # yellow

# ellipse/aaellipse/filled_ellipse demo
SDL::GFX::Primitives::aaellipse_color(     $display, 65, 249 + 2 * $_, 60,            2 * $_,  0xFFFFFF80) for(1..25);
SDL::GFX::Primitives::filled_ellipse_RGBA( $display, 65, 405,          60 - 1.2 * $_, 50 - $_, 0xFF, 0x00, 0x00, 0x05) for(0..30);
SDL::GFX::Primitives::filled_ellipse_RGBA( $display, 65, 405,          12,            10,      0x00, 0x00, 0x00, 0xFF);
SDL::GFX::Primitives::aaellipse_RGBA(      $display, 65, 405,          12,            10,      0x00, 0x00, 0x00, 0xFF);

#is( SDL::GFX::Primitives::trigon_color($display, 320, 346, 35, 113, 0x00FF00FF),             0, 'trigon_color' ); # green
#is( SDL::GFX::Primitives::trigon_RGBA( $display, 320, 346, 20, 64, 0xFF, 0xFF, 0x00, 0xFF), 0, 'trigon_RGBA' );  # yellow

SDL::Video::unlock_surface($display) if(SDL::Video::MUSTLOCK($display));

SDL::Video::update_rect($display, 0, 0, 640, 480); 

SDL::delay(5000);

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


sub mandel_point
{
	my $cx = shift;
	my $cy = shift;

	my $betrag_quadrat = 0;
	my $iter           = 0;
	my $x              = 0;
	my $y              = 0;

	while( $betrag_quadrat <= $max_betrag_quadrat && $iter < $max_iterationen )
	{
		my $xt = $x * $x - $y * $y + $cx;
		my $yt = 2 * $x * $y + $cy;
		$x     = $xt;
		$y     = $yt;
		$iter++;
		$betrag_quadrat = $x * $x + $y * $y;
	}

	return $iter;
}
