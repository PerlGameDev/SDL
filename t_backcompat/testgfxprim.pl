#!/usr/bin/env perl
#
# testgfxprim.pl
#
# This tests low level usage of the SDL_gfx extension.
# Therefore, you should *not* rely on *any* part of this API.
# It is subject to change, and will eventually 
# be encapsulated by something such as SDL::GraphicTool
#
# (plus, it's a bitch to use like this anyway)
#

# Usage: testgfxprm.pl [-bpp N] [-hw] [-fast] [-fullscreen]

use strict;
use Getopt::Long;
use Data::Dumper;

use SDL;
use SDL::App;
use SDL::Event;
use SDL::Surface;
use SDL::Color;
use SDL::Rect;
use SDL::Config;

use vars qw/ $app $app_rect $background $event $sprite $sprite_rect $videoflags /;

die "Your system is not configured with SDL_gfx support!\n"
	unless (SDL::Config->has('SDL_gfx'));

## User tweakable settings (via cmd-line)
my %settings = (
	'numsprites'		=> 10,
	'screen_width'	=> 640,
	'screen_height' => 480,
	'video_bpp'		 => 8,
	'fast'					=> 0,
	'hw'						=> 0,
	'fullscreen'		=> 0,
	'bpp'					 => undef,
);

## Process commandline arguments

sub get_cmd_args
{
	GetOptions(	"width:i"	=> \$settings{screen_width},
			 "height:i" => \$settings{screen_height},
			 "bpp:i"		=> \$settings{bpp},
			 "fast!"	 => \$settings{fast},
			 "hw!"		 => \$settings{hw},
			 "fullscreen!" => \$settings{fullscreen},
			 "numsprites=i" => \$settings{numsprites},
		);
}

## Initialize application options

sub set_app_args
{
	$settings{bpp} ||= 8;		# default to 8 bits per pix

	$videoflags |= SDL_HWACCEL		 if $settings{hw};	
	$videoflags |= SDL_FULLSCREEN	if $settings{fullscreen}; 
}

## Setup 

sub init_game_context
{
	$app = new SDL::App 
			-width => $settings{screen_width}, 
			-height=> $settings{screen_height}, 
			-title => "testsprite",
			-icon	=> "data/icon.bmp",
			-flags => $videoflags;

	$app_rect= new SDL::Rect
				-height => $settings{screen_height}, 
				-width	=> $settings{screen_width};

	$background = $SDL::Color::black;

	$sprite = new SDL::Surface -name =>"data/icon.bmp"; 

	# Set transparent pixel as the pixel at (0,0) 
	$sprite->set_color_key(SDL_SRCCOLORKEY,$sprite->pixel(0,0));	

	print STDERR "Got past that\n";

	$sprite->display_format();

	$sprite_rect = new SDL::Rect 	
				-x => 0, 
			 	-y => 0,
				-width => $sprite->width,
				-height=> $sprite->height;
	
	$event = new SDL::Event();
}

## Prints diagnostics

sub instruments
{
	if ( ($app->flags & SDL_HWSURFACE) == SDL_HWSURFACE ) {
		printf("Screen is in video memory\n");
	} else {
		printf("Screen is in system memory\n");
	}

	if ( ($app->flags & SDL_DOUBLEBUF) == SDL_DOUBLEBUF ) {
		printf("Screen has double-buffering enabled\n");
	}

	if ( ($sprite->flags & SDL_HWSURFACE) == SDL_HWSURFACE ) {
		printf("Sprite is in video memory\n");
	} else {
		printf("Sprite is in system memory\n");
	}
	
	# Run a sample blit to trigger blit (if posssible)
	# acceleration before the check just after 
	$sprite->blit(0,$app,0);
	
	if ( ($sprite->flags & SDL_HWACCEL) == SDL_HWACCEL ) {
		printf("Sprite blit uses hardware acceleration\n");
	}
	if ( ($sprite->flags & SDL_RLEACCEL) == SDL_RLEACCEL ) {
		printf("Sprite blit uses RLE acceleration\n");
	}
	
}

sub game_loop
{
	my $surf = $$app;
	my $surfWidth=$settings{screen_width};
	my $surfHeight=$settings{screen_height};
	my $surfMidWidth=$settings{screen_width}>>1;;
	my $surfMidHeight=$settings{screen_height}>>1; 
		
	$app->fill($app_rect, $background);

	# TODO: polygon's, GFX*Color

	#lines
	
	SDL::GFXHlineRGBA($surf, 
				 0,$surfWidth, 
				 $surfMidHeight,
				 255,255,255,255);

	SDL::GFXVlineRGBA($surf, 
				 $surfMidWidth, 
				 0,$surfHeight,
				 255,255,255,255);

	# rectangles

	SDL::GFXRectangleRGBA($surf, 
			 0,0,
			 $surfMidWidth/2,$surfMidHeight/2,
			 255,0,0,255);

	SDL::GFXBoxRGBA($surf, 
			 0,0,
			 $surfMidWidth/3,$surfMidHeight/3,
			 0,255,0,255);

	SDL::GFXLineRGBA($surf, 
				0,0,
				$surfWidth,$surfHeight,
				0,255,255,255);
	
	SDL::GFXAalineRGBA($surf, $surfWidth,0,0,$surfHeight,0,255,255,255);
	
	# circles

	SDL::GFXCircleRGBA( $surf,$surfMidWidth*.3, $surfMidHeight,
		$surfMidWidth*.3, 255,255,0,255);


	SDL::GFXAacircleRGBA($surf, $surfMidWidth*.6, $surfMidHeight,
		$surfMidWidth*.3, 255,255,0,255);
	

	SDL::GFXFilledCircleRGBA($surf,$surfMidWidth*.3, $surfMidHeight,
		$surfMidWidth*.25,255,255,0,255);
	

	# ellipses

	SDL::GFXEllipseRGBA($surf,$surfWidth- $surfMidWidth*.3, $surfMidHeight,
		$surfMidWidth*.3,$surfMidHeight*.15, 255,255,0,255);

	SDL::GFXAaellipseRGBA($surf,$surfWidth- $surfMidWidth*.6, $surfMidHeight,
		$surfMidWidth*.3,$surfMidHeight*.15,255,255,0,255);

	SDL::GFXFilledEllipseRGBA($surf,$surfWidth- $surfMidWidth*.3, $surfMidHeight,
		$surfMidWidth*.25,$surfMidHeight*.10,255,255,0,255);

	# pie slices
	SDL::GFXFilledPieRGBA($surf,$surfMidWidth,$surfMidHeight, $surfMidWidth*.1,
		0,90,0,0,255,255);

	SDL::GFXFilledPieRGBA($surf,$surfMidWidth,$surfMidHeight, $surfMidWidth*.1,
		180,270,0,0,255,255);

	# polygons

	# TBD...

	
	# characters & strings

	SDL::GFXCharacterRGBA($surf,$surfMidWidth,0,
		"!",255,255,255,255);

	SDL::GFXStringRGBA($surf,$surfMidWidth,$surfHeight*.75,
		"SDL_Perl Primitive Test.",255,255,255,255);

	$app->flip();

 	$app->loop({ 	
		SDL_QUIT() => sub { exit(0); },
		SDL_KEYDOWN() => sub { exit(0) if (SDL::GetKeyState(SDLK_ESCAPE)); }, 
	});
}

## Main program loop

get_cmd_args();
set_app_args();
init_game_context();
instruments();
game_loop();

