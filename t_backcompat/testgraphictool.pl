#!/usr/bin/env perl

use strict;
use warnings;

use SDL;
use SDL::Surface;
use SDLx::App;
use SDL::Tool::Graphic;

my $app = SDLx::App->new(
	-title      => "Graphic Tool Test",
	-width      => 640,
	-height     => 480,
	-depth      => 16,
	-fullscreen => 0
);
my $app_rect = SDL::Rect->new(
	-x      => 0,
	-y      => 0,
	-width  => $app->width,
	-height => $app->height
);

my $sprite = SDL::Surface->new( -name => "data/logo.png" );
$sprite->display_format();

#Test Zoom
my $graphicTool = SDL::Tool::Graphic->new();
$graphicTool->zoom( $sprite, .5, .5, 1 );

my $sprite_rect = SDL::Rect->new(
	-x      => 0,
	-y      => 0,
	-width  => $sprite->width,
	-height => $sprite->height
);
$sprite->blit( $sprite_rect, $app, $sprite_rect );
$app->flip();
sleep 4;
$app->fill( $app_rect, $SDL::Color::black );

#Test Rotate
$graphicTool->rotoZoom( $sprite, 90, 1, 1 );

$sprite_rect = SDL::Rect->new(
	-x      => 0,
	-y      => 0,
	-width  => $sprite->width,
	-height => $sprite->height
);
$sprite->blit( $sprite_rect, $app, $sprite_rect );
$app->flip();
sleep 4;

+print "GrayScaling\n";
+$app->fill( $app_rect, $SDL::Color::black );

#Test GrayScale
$graphicTool->grayScale($sprite);

$sprite->blit( $sprite_rect, $app, $sprite_rect );
$app->flip();
sleep 4;

