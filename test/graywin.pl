#!/usr/bin/perl

use strict;
use warnings;

use SDL ':init';
use SDL::Video ':all';
use SDL::Events ':all';
use SDL::Rect;
use SDL::Event;
use SDL::Surface;

SDL::init(SDL_INIT_VIDEO);

my $width  = 800;
my $height = 600;

my $screen_surface = SDL::Video::set_video_mode( $width, $height, 32, SDL_SWSURFACE );

my $event = SDL::Event->new;

while (1) {

	while ( SDL::Events::poll_event($event) ) {
		exit(0) if $event->type == SDL_QUIT;

		if ( $event->type == SDL_MOUSEBUTTONDOWN ) {

			my $mapped_color = SDL::Video::map_RGB(
				$screen_surface->format(), rand_color(),
				rand_color(),              rand_color()
			);

			SDL::Video::fill_rect(
				$screen_surface,
				SDL::Rect->new( $event->button_x, $event->button_y, 20, 10 ),
				$mapped_color
			);

		}

	}

	SDL::Video::update_rect( $screen_surface, 0, 0, $width, $height );
	SDL::delay(20);
}

sub rand_color {
	return int( rand(256) );
}
