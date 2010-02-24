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
elsif( !SDL::Config->has('SDL_gfx_primitives') )
{
    plan( skip_all => 'SDL_gfx_primitives support not compiled' );
}
else
{
    plan( tests => 56 );
}

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

# rectangle/box demo
my @box = (['0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
           ['0', '0', '0', '0', '0', '0', '/', '_','\\', '0', '0', '0', '0', '0', '0'],
           ['0', '0', '0', '0', '/', '/', '/', '_','\\','\\','\\', '0', '0', '0', '0'],
           ['0', '0', '0', '/', '/', '/', '/', '_','\\','\\','\\','\\', '0', '0', '0'],
           ['0', '0', '/', '/', '/', '/', '/', '_','\\','\\','\\','\\','\\', '0', '0'],
           ['0', '0', '/', '/', '/', '/', '/', '_','\\','\\','\\','\\','\\', '0', '0'],
           ['0', '/', '/', '/', '/', '/', '/', '_','\\','\\','\\','\\','\\','\\', '0'],
           ['0', '<', '<', '<', '<', '<', '<', '0', '>', '>', '>', '>', '>', '>', '0'],
           ['0','\\','\\','\\','\\','\\','\\', '-', '/', '/', '/', '/', '/', '/', '0'],
           ['0', '0','\\','\\','\\','\\','\\', '-', '/', '/', '/', '/', '/', '0', '0'],
           ['0', '0','\\','\\','\\','\\','\\', '-', '/', '/', '/', '/', '/', '0', '0'],
           ['0', '0', '0','\\','\\','\\','\\', '-', '/', '/', '/', '/', '0', '0', '0'],
           ['0', '0', '0', '0','\\','\\','\\', '-', '/', '/', '/', '0', '0', '0', '0'],
           ['0', '0', '0', '0', '0','\\','\\', '-', '/', '/', '0', '0', '0', '0', '0'],
           ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0']);

for my $y (0..14)
{
	for my $x (0..14)
	{
		my $x_pos = 390 + $x * 8;
		my $y_pos =  53 + $y * 8;
		my $bg_color = (($y & 1) ^ ($x & 1)) ? 0xFFFFFFFF : 0x333333FF;
		my $fg_color = (($y & 1) ^ ($x & 1)) ? 0x333333FF : 0xFFFFFFFF;
		SDL::GFX::Primitives::box_color($display, $x_pos, $y_pos, $x_pos + 7, $y_pos + 7, $bg_color);
		
		if(@{$box[$y]}[$x] =~ /[\-_]/)
		{
			SDL::GFX::Primitives::box_color($display, $x_pos + 1, $y_pos + ($y < 7 ? 5 : 1), $x_pos + 2, $y_pos + ($y < 7 ? 6 : 2), $fg_color);
			SDL::GFX::Primitives::box_color($display, $x_pos + 5, $y_pos + ($y < 7 ? 5 : 1), $x_pos + 6, $y_pos + ($y < 7 ? 6 : 2), $fg_color);
		}
		
		if(@{$box[$y]}[$x] =~ /[<>]/)
		{
			SDL::GFX::Primitives::box_color($display, $x_pos + ($x < 7 ? 5 : 1), $y_pos + 1, $x_pos + ($x < 7 ? 6 : 2), $y_pos + 2, $fg_color);
			SDL::GFX::Primitives::box_color($display, $x_pos + ($x < 7 ? 5 : 1), $y_pos + 5, $x_pos + ($x < 7 ? 6 : 2), $y_pos + 6, $fg_color);
		}
		
		if(@{$box[$y]}[$x] =~ /\\/)
		{
			SDL::GFX::Primitives::box_color($display, $x_pos + 1, $y_pos + 1, $x_pos + 2, $y_pos + 2, $fg_color);
			SDL::GFX::Primitives::box_color($display, $x_pos + 5, $y_pos + 5, $x_pos + 6, $y_pos + 6, $fg_color);
		}
		if(@{$box[$y]}[$x] =~ /\//)
		{
			SDL::GFX::Primitives::box_color($display, $x_pos + 5, $y_pos + 1, $x_pos + 6, $y_pos + 2, $fg_color);
			SDL::GFX::Primitives::box_color($display, $x_pos + 1, $y_pos + 5, $x_pos + 2, $y_pos + 6, $fg_color);
		}
	}
}

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
is( SDL::GFX::Primitives::ellipse_color(       $display,  3, 245, 1, 2, 0xFF0000FF),             0, 'ellipse_color' );        # red
is( SDL::GFX::Primitives::ellipse_RGBA(        $display,  7, 245, 1, 2, 0x00, 0xFF, 0x00, 0xFF), 0, 'ellipse_RGBA' );         # green
is( SDL::GFX::Primitives::aaellipse_color(     $display, 11, 245, 1, 2, 0x0000FFFF),             0, 'aaellipse_color' );      # blue
is( SDL::GFX::Primitives::aaellipse_RGBA(      $display, 15, 245, 1, 2, 0xFF, 0xFF, 0x00, 0xFF), 0, 'aaellipse_RGBA' );       # yellow
is( SDL::GFX::Primitives::filled_ellipse_color($display, 19, 245, 1, 2, 0x00FFFFFF),             0, 'filled_ellipse_color' ); # cyan
is( SDL::GFX::Primitives::filled_ellipse_RGBA( $display, 23, 245, 1, 2, 0xFF, 0x00, 0xFF, 0xFF), 0, 'filled_ellipse_RGBA' );  # magenta

# ellipse/aaellipse/filled_ellipse demo
SDL::GFX::Primitives::aaellipse_color(     $display, 65, 249 + 2 * $_, 60,            2 * $_,  0xFFFFFF80) for(1..25);
SDL::GFX::Primitives::filled_ellipse_RGBA( $display, 65, 405,          60 - 1.2 * $_, 50 - $_, 0xFF, 0x00, 0x00, 0x05) for(0..30);
SDL::GFX::Primitives::filled_ellipse_RGBA( $display, 65, 405,          12,            10,      0x00, 0x00, 0x00, 0xFF);
SDL::GFX::Primitives::aaellipse_RGBA(      $display, 65, 405,          12,            10,      0x00, 0x00, 0x00, 0xFF);

# trigon/aatrigon/filled_trigon tests
is( SDL::GFX::Primitives::trigon_color(       $display, 130, 243, 132, 245, 130, 247, 0xFF0000FF),             0, 'trigon_color' );        # red
is( SDL::GFX::Primitives::trigon_RGBA(        $display, 134, 243, 136, 245, 134, 247, 0x00, 0xFF, 0x00, 0xFF), 0, 'trigon_RGBA' );         # green
is( SDL::GFX::Primitives::aatrigon_color(     $display, 138, 243, 140, 245, 138, 247, 0x0000FFFF),             0, 'aatrigon_color' );      # blue
is( SDL::GFX::Primitives::aatrigon_RGBA(      $display, 142, 243, 144, 245, 142, 247, 0xFF, 0xFF, 0x00, 0xFF), 0, 'aatrigon_RGBA' );       # yellow
is( SDL::GFX::Primitives::filled_trigon_color($display, 146, 243, 148, 245, 146, 247, 0x00FFFFFF),             0, 'filled_trigon_color' ); # cyan
is( SDL::GFX::Primitives::filled_trigon_RGBA( $display, 150, 243, 152, 245, 150, 247, 0xFF, 0x00, 0xFF, 0xFF), 0, 'filled_trigon_RGBA' );  # magenta

# polygon/aapolygon/filled_polygon/textured_polygon/MT/ tests

my $surf = SDL::Video::load_BMP('test/data/pattern_red_white_2x2.bmp');

is( SDL::GFX::Primitives::polygon_color(          $display, [262, 266, 264, 266, 262], [243, 243, 245, 247, 247], 5, 0xFF0000FF),                         0, 'polygon_color' );           # red
is( SDL::GFX::Primitives::polygon_RGBA(           $display, [268, 272, 270, 272, 268], [243, 243, 245, 247, 247], 5, 0x00, 0xFF, 0x00, 0xFF),             0, 'polygon_RGBA' );            # green
is( SDL::GFX::Primitives::aapolygon_color(        $display, [274, 278, 276, 278, 274], [243, 243, 245, 247, 247], 5, 0x0000FFFF),                         0, 'aapolygon_color' );         # blue
is( SDL::GFX::Primitives::aapolygon_RGBA(         $display, [280, 284, 282, 284, 280], [243, 243, 245, 247, 247], 5, 0xFF, 0xFF, 0x00, 0xFF),             0, 'aapolygon_RGBA' );          # yellow
is( SDL::GFX::Primitives::filled_polygon_color(   $display, [286, 290, 288, 290, 286], [243, 243, 245, 247, 247], 5, 0x00FFFFFF),                         0, 'filled_polygon_color' );    # cyan
is( SDL::GFX::Primitives::filled_polygon_RGBA(    $display, [292, 296, 294, 296, 292], [243, 243, 245, 247, 247], 5, 0xFF, 0x00, 0xFF, 0xFF),             0, 'filled_polygon_RGBA' );     # magenta

is( SDL::GFX::Primitives::textured_polygon(       $display, [298, 302, 300, 302, 298], [243, 243, 245, 247, 247], 5, $surf,                  0, 0),       1, 'textured_polygon' );        # texture
is( SDL::GFX::Primitives::filled_polygon_color_MT($display, [304, 308, 306, 308, 304], [243, 243, 245, 247, 247], 5, 0xFF0000FF,             0, 0),       0, 'filled_polygon_color_MT' ); # red
is( SDL::GFX::Primitives::filled_polygon_RGBA_MT( $display, [310, 314, 312, 314, 310], [243, 243, 245, 247, 247], 5, 0x00, 0xFF, 0x00, 0xFF, 0, 0),       0, 'filled_polygon_RGBA_MT' );  # green
is( SDL::GFX::Primitives::textured_polygon_MT(    $display, [316, 320, 318, 320, 316], [243, 243, 245, 247, 247], 5, $surf,                  0, 0, 0, 0), 1, 'textured_polygon_MT' );     # texture

# polygon demo
SDL::GFX::Primitives::filled_polygon_color(   $display, [311, 331, 381, 301, 311, 351], [293, 293, 378, 378, 361, 361], 6, 0xFF000080);    # red
SDL::GFX::Primitives::filled_polygon_color(   $display, [381, 371, 271, 311, 321, 301], [378, 395, 395, 327, 344, 378], 6, 0x00FF0080);    # green
SDL::GFX::Primitives::filled_polygon_color(   $display, [271, 261, 311, 351, 331, 311], [395, 378, 293, 361, 361, 327], 6, 0x0000FF80);    # blue





# bezier test
is( SDL::GFX::Primitives::bezier_color( $display, [390, 392, 394, 396], [243, 255, 235, 247], 4, 20, 0xFF00FFFF),             0, 'polygon_color' );        # red
is( SDL::GFX::Primitives::bezier_RGBA(  $display, [398, 400, 402, 404], [243, 255, 235, 247], 4, 20, 0x00, 0xFF, 0x00, 0xFF), 0, 'polygon_RGBA' );         # green

#character/string tests
is( SDL::GFX::Primitives::character_color($display, 518, 243, 'A', 0xFF0000FF),                         0, 'character_color' );           # red
is( SDL::GFX::Primitives::character_RGBA( $display, 526, 243, 'B', 0x00, 0xFF, 0x00, 0xFF),             0, 'character_RGBA' );            # green
is( SDL::GFX::Primitives::string_color(   $display, 534, 243, 'CD', 0x0000FFFF),                         0, 'string_color' );         # blue
is( SDL::GFX::Primitives::string_RGBA(    $display, 550, 243, 'DE', 0xFF, 0xFF, 0x00, 0xFF),             0, 'string_RGBA' );          # yellow

SKIP:
{
	skip ' test font not found', 1 unless -e 'test/data/5x7.fnt';
	my $font = '';
	open(FH, '<', 'test/data/5x7.fnt');
	binmode(FH);
	read(FH, $font, 2048);
	close(FH);

	is( SDL::GFX::Primitives::set_font($font, 5, 7), undef, 'set_font' );
}

#chracater demo
SDL::GFX::Primitives::character_RGBA( $display, 518 + ($_ % 17) * 7, 251 + int($_ / 17) * 8, chr($_), 0x80 + $_ / 2, 0xFF, 0x00, 0xFF) for(0..255);

SDL::Video::unlock_surface($display) if(SDL::Video::MUSTLOCK($display));

SDL::Video::update_rect($display, 0, 0, 640, 480); 

SDL::delay(10000);

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
