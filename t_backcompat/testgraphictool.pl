#!/usr/bin/env perl

use strict;
use warnings;

use SDL;
use SDL::Surface;
use SDL::App;
use SDL::Tool::Graphic;

my $app = new SDL::App(-title	=> "Graphic Tool Test",
		       -width	=> 640,
		       -height	=> 480,
		       -depth	=> 16,
		       -fullscreen => 0);
my $app_rect = new SDL::Rect(	-x=>0,
				-y=>0,
				-width=>$app->width,
				-height=>$app->height);

my $sprite = new SDL::Surface(-name => "data/logo.png");
$sprite->display_format();

#Test Zoom
my $graphicTool = new SDL::Tool::Graphic();
$graphicTool->zoom($sprite, .5, .5, 1);

my $sprite_rect = new SDL::Rect(	-x=>0,
				-y=>0,
				-width=>$sprite->width,
				-height=>$sprite->height);
$sprite->blit($sprite_rect, $app, $sprite_rect);
$app->flip();
sleep 4;
$app->fill($app_rect, $SDL::Color::black);


#Test Rotate
$graphicTool->rotoZoom($sprite, 90, 1, 1);

$sprite_rect = new SDL::Rect(	-x=>0,
				-y=>0,
				-width=>$sprite->width,
				-height=>$sprite->height);
$sprite->blit($sprite_rect, $app, $sprite_rect);
$app->flip();
sleep 4;

+print "GrayScaling\n";
+$app->fill($app_rect, $SDL::Color::black);

#Test GrayScale
$graphicTool->grayScale($sprite);

$sprite->blit($sprite_rect, $app, $sprite_rect);
$app->flip();
sleep 4;



