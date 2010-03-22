#!/usr/bin/env perl 
#
# testgfxroto.pl
#
# *** WARNING ***
#
# This tests low level usage of the SDL_gfx extension.
# Therefore, you should *not* rely on *any* part of this API.
# It is subject to change, and will eventually 
# be encapsulated by something such as SDL::Surface.
#
# Usage: testsprite.pl [-bpp N] [-hw] [-flip] [-fast] [-fullscreen] [-numsprites=X]

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

## Test for SDL_gfx support

die "Your system was not configured with SDL_gfx support!\n"
	unless SDL::Config->has('SDL_gfx');


## User tweakable settings (via cmd-line)
my %settings = (
	'numsprites'		=> 10,
	'screen_width'	=> 800,
	'screen_height' => 600,
	'video_bpp'		 => 8,
	'fast'					=> 0,
	'hw'						=> 0,
	'flip'					=> 1,
	'fullscreen'		=> 0,
	'bpp'					 => undef,
);

## Process commandline arguments

sub get_cmd_args
{
	GetOptions("width:i"	=> \$settings{screen_width},
			 "height:i" => \$settings{screen_height},
			 "bpp:i"		=> \$settings{bpp},
			 "fast!"	 => \$settings{fast},
			 "hw!"		 => \$settings{hw},
			 "flip!"		=> \$settings{flip},
			 "fullscreen!" => \$settings{fullscreen},
			 "numsprites=i" => \$settings{numsprites},
			);
}

## Initialize application options

sub set_app_args
{
	$settings{bpp} ||= 8;		# default to 8 bits per pix

	$videoflags |= SDL_HWACCEL		 if $settings{hw};	
	$videoflags |= SDL_DOUBLEBUF	 if $settings{flip};	
	$videoflags |= SDL_FULLSCREEN	if $settings{fullscreen}; 
}

## Setup 

sub	init_game_context
{
	$app = new SDL::App (
					 -width => $settings{screen_width}, 
					 -height=> $settings{screen_height}, 
					 -title => "testsprite",
					 -icon	=> "data/logo.png",
					 -flags => $videoflags,
			);

	$app_rect= new SDL::Rect(
				 -height => $settings{screen_height}, 
				 -width	=> $settings{screen_width},
				);

	$background = $SDL::Color::black;

	$sprite = new SDL::Surface -name =>"data/logo.png"; 

	$sprite->display_format();

	$sprite_rect = new SDL::Rect(-x		 => 0, 
						 -y		 => 0,
						 -width => $sprite->width,
						 -height=> $sprite->height,
						);
	
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
	put_sprite_rotated($sprite,
			$settings{screen_width}/2, $settings{screen_height}/2,
			0,0,0);
	
	if ( ($sprite->flags & SDL_HWACCEL) == SDL_HWACCEL ) {
		printf("Sprite blit uses hardware acceleration\n");
	}
	if ( ($sprite->flags & SDL_RLEACCEL) == SDL_RLEACCEL ) {
		printf("Sprite blit uses RLE acceleration\n");
	}
	
}




# this can	get silly in terms of
# memory usage, and maybe key lookup.
# it would be better to 'tie' the hash
# to an object which can
# better manage memory usage.

my %rotate_cache =();

sub generate_sprite_rotated
{
	my ($surface, $angle, $zoom, $smooth) = @_;

	$angle %= 360;
	my $key = "$surface$angle$zoom$smooth";

	if ( $rotate_cache{$key} )
	{
		return $rotate_cache{$key};
	}
	else
	{
		 my $sur = SDL::GFXRotoZoom($surface, $angle, $zoom, $smooth);

		 $rotate_cache{$key}= SDL::DisplayFormat($sur);
	}
	return $rotate_cache{$key};
}

sub put_sprite_rotated
{
	my ($surface, $x, $y, $angle, $zoom, $smooth) = @_;

	my $roto = generate_sprite_rotated($$surface, $angle, $zoom, $smooth);

	die "Failed to create rotozoom surface" unless $roto;

	my ($w,$h) = (SDL::SurfaceW($roto),SDL::SurfaceH($roto));;	 
	

	my $dest_rect = new SDL::Rect
				-x => $x - ($w/2),
				-y => $y - ($h/2),
				-width	=> $w,
				-height => $h;

	SDL::SetColorKey($roto, SDL_SRCCOLORKEY, SDL::SurfacePixel($roto,$w/2,$h/2));
	
	SDL::BlitSurface($roto, 0, $$app, $$dest_rect);	
}


sub game_loop
{
	my $ox=$settings{screen_width}>>1;;
	my $oy=$settings{screen_height}>>1;
	my $sectors = 12;
	my $angleDelta = 360/$sectors;;
	my $zoom	= 1;
	my $smooth =1;

	my $angle	 =0;
	my $radius	=128;

 FRAME:
	while (1) 
	{
		# process event queue
		$event->pump;
		if ($event->poll)
		{
			my $etype=$event->type();			
			
			# handle quit events
			last FRAME if ($etype == SDL_QUIT() );
			last FRAME if (SDL::GetKeyState(SDLK_ESCAPE));
		}

		# needed for HW surface locking
		#$app->lock() if $app->lockp();	
		#$app->unlock();
		$app->flip if $settings{flip};

		################################################
		# do some drawing 
		
		$app->fill($app_rect, $background);

		$angle += 16;

		put_sprite_rotated($sprite, 
			$settings{screen_width}/2, $settings{screen_height}/2,
			$angle, $zoom, $smooth);
			
	}
	print "Cache entries: " . scalar(keys %rotate_cache) . "\n";
}



## Main program loop

get_cmd_args();
set_app_args();
init_game_context();
instruments();
game_loop();
exit(0);

