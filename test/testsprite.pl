#!/usr/bin/env perl 
#
# testspite.pl
#
# adapted from SDL-1.2.x/test/testsprite.c

# Usage: testsprite.pl [-bpp N] [-hw] [-flip] [-fast] [-fullscreen] [numsprites]

use strict;
use Getopt::Long;
use Data::Dumper;

use SDL;
use SDL::App;
use SDL::Event;
use SDL::Surface;
use SDL::Color;
use SDL::Rect;

use vars qw/ $app $app_rect $background $event $sprite $sprite_rect $videoflags /;

## User tweakable settings (via cmd-line)
my %settings = (
	'numsprites'    => 75,
	'screen_width'  => 640,
	'screen_height' => 480,
	'video_bpp'     => 8,
	'fast'          => 0,
	'hw'            => 0,
	'flip'          => 1,
	'fullscreen'    => 0,
	'bpp'           => undef,
);

## Process commandline arguments

sub get_cmd_args
{
  GetOptions("width:i"  => \$settings{screen_width},
	     "height:i" => \$settings{screen_height},
	     "bpp:i"    => \$settings{bpp},
	     "fast!"   => \$settings{fast},
	     "hw!"     => \$settings{hw},
	     "flip!"    => \$settings{flip},
	     "fullscreen!" => \$settings{fullscreen},
	     "numsprites=i" => \$settings{numsprites},
	    );
}

## Initialize application options

sub set_app_args
{
  $settings{bpp} ||= 8;  	# default to 8 bits per pix

  $videoflags |= SDL_HWACCEL     if $settings{hw};  
  $videoflags |= SDL_DOUBLEBUF   if $settings{flip};  
  $videoflags |= SDL_FULLSCREEN  if $settings{fullscreen}; 
}

## Setup 

sub  init_game_context
{
  $app = new SDL::App (
		       -width => $settings{screen_width}, 
		       -height=> $settings{screen_height}, 
		       -title => "testsprite",
		       -icon  => "data/icon.bmp",
		       -flags => $videoflags,
			);

  $app_rect= new SDL::Rect(
			   -height => $settings{screen_height}, 
			   -width  => $settings{screen_width},
			  );

  $background = $SDL::Color::black;

  $sprite = new SDL::Surface(-name =>"data/icon.bmp"); 

  # Set transparent pixel as the pixel at (0,0) 
  
  $sprite->display_format();

  $sprite->set_color_key(SDL_SRCCOLORKEY,$sprite->pixel(0,0));	# sets the transparent color to that at (0,0)


  $sprite_rect = new SDL::Rect(-x     => 0, 
			       -y     => 0,
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
  put_sprite(0,0);
  
  if ( ($sprite->flags & SDL_HWACCEL) == SDL_HWACCEL ) {
    printf("Sprite blit uses hardware acceleration\n");
  }
  if ( ($sprite->flags & SDL_RLEACCEL) == SDL_RLEACCEL ) {
    printf("Sprite blit uses RLE acceleration\n");
  }
  
}




sub put_sprite
{
  my ($x,$y) = @_;

  my $dest_rect = new SDL::Rect(-x => $x,
			       -y => $y,
			       -width  => $sprite->width,
			       -height => $sprite->height,
			      );
  $sprite->blit($sprite_rect, $app, $dest_rect);  
}



sub game_loop
{
  my $x=0;
  my $y=$settings{screen_height}>>1;
  my $i=0;

  while (1) 
  {
    # process event queue
    $event->pump;
    $event->poll;
    my $etype=$event->type;      

    # handle user events
    last if ($etype eq SDL_QUIT );
    last if (SDL::GetKeyState(SDLK_ESCAPE));

    #$app->lock() if $app->lockp();  

    # page flip

    # __draw gfx
    
    $app->fill($app_rect, $background);

    foreach (1..$settings{numsprites})
    {
      put_sprite( $_*8, $y + (sin(($i+$_)*0.2)*($settings{screen_height}/3)));
    }
    $i+=30;

    # __graw gfx end
    #$app->unlock();
    $app->flip if $settings{flip};
  }
}

## Main program loop

get_cmd_args();
set_app_args();
init_game_context();
instruments();
game_loop();
exit(0);

