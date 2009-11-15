package SDL::Tutorial::Sol::Two;
use strict;
use warnings;
use Carp;

use SDL v2.3;
use SDL::Video;
use SDL::Event;
use SDL::Events;
use SDL::Surface;

my $screen;

sub render
{
	if( SDL::Video::MUSTLOCK( $screen) )
	{
		return if (SDL::Video::lock_surface( $screen ) < 0)
	}

	my $ticks = SDL::get_ticks();
	my ($i, $y, $yofs, $ofs) = (0,0,0,0);
  for ($i = 0; $i < 480; $i++)
  {
    for (my $j = 0, $ofs = $yofs; $j < 640; $j++, $ofs++)
    {
	    $screen->set_pixels( $ofs, (  $i * $i + $j * $j + $ticks ) );
    }
    $yofs += $screen->pitch / 4;
  }

    SDL::Video::unlock_surface($screen) if (SDL::Video::MUSTLOCK($screen));

    SDL::Video::update_rect($screen, 0, 0, 640, 480);    

	return 0;
}

=pod
void render()
{   
  // Lock surface if needed
  if (SDL_MUSTLOCK(screen)) 
    if (SDL_LockSurface(screen) < 0) 
      return;

  // Ask SDL for the time in milliseconds
  int tick = SDL_GetTicks();

  // Declare a couple of variables
  int i, j, yofs, ofs;

  // Draw to screen
  yofs = 0;
  for (i = 0; i < 480; i++)
  {
    for (j = 0, ofs = yofs; j < 640; j++, ofs++)
    {
      ((unsigned int*)screen->pixels)[ofs] = i * i + j * j + tick;
    }
    yofs += screen->pitch / 4;
  }

  // Unlock if needed
  if (SDL_MUSTLOCK(screen)) 
    SDL_UnlockSurface(screen);

  // Tell SDL to update the whole screen
  SDL_UpdateRect(screen, 0, 0, 640, 480);    
}
=cut

sub main
{
  carp 'Unable to init SDL: '.SDL::get_error() if( SDL::init(SDL_INIT_VIDEO) < 0);

  $screen = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE);

  carp 'Unable to set 640x480x32 video'.SDL::get_error() if(!$screen);

  while(1)
  {
	
	render();

	my $event = SDL::Event->new();

	while( SDL::Events::poll_event($event) )
	{
	   my $type = $event->type;
	   return 0 if( $type == SDL_KEYDOWN );
	   return 0 if( $type == SDL_QUIT);
	   	    

	}
	SDL::Events::pump_events();

  }

}

main;

SDL::quit;  

=pod
// Entry point
int main(int argc, char *argv[])
{
  // Initialize SDL's subsystems - in this case, only video.
  if ( SDL_Init(SDL_INIT_VIDEO) < 0 ) 
  {
    fprintf(stderr, "Unable to init SDL: %s\n", SDL_GetError());
    exit(1);
  }

  // Register SDL_Quit to be called at exit; makes sure things are
  // cleaned up when we quit.
  atexit(SDL_Quit);
    
  // Attempt to create a 640x480 window with 32bit pixels.
  screen = SDL_SetVideoMode(640, 480, 32, SDL_SWSURFACE);
  
  // If we fail, return error.
  if ( screen == NULL ) 
  {
    fprintf(stderr, "Unable to set 640x480 video: %s\n", SDL_GetError());
    exit(1);
  }

  // Main loop: loop forever.
  while (1)
  {
    // Render stuff
    render();

    // Poll for events, and handle the ones we care about.
    SDL_Event event;
    while (SDL_PollEvent(&event)) 
    {
      switch (event.type) 
      {
      case SDL_KEYDOWN:
        break;
      case SDL_KEYUP:
        // If escape is pressed, return (and thus, quit)
        if (event.key.keysym.sym == SDLK_ESCAPE)
          return 0;
        break;
      case SDL_QUIT:
        return(0);
      }
    }
  }
  return 0;
}
=cut
