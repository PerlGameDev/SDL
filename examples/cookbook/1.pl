use strict;
use warnings;

use SDL;
use SDL::Rect;
use SDL::Event;
use SDL::Video;
use SDL::Events;
use SDL::Surface;


SDL::init(SDL_INIT_VIDEO);

my $display = SDL::Video::set_video_mode( 320, 320, 32, SDL_SWSURFACE);

my $quit = 0;
while (!$quit)
{
	my $event = SDL::Event->new();

	SDL::Events::pump_events();

	while ( SDL::Events::poll_event($event) )
	{
		
		$quit = 1 if ( $event->type == SDL_QUIT );

	}
	

}
