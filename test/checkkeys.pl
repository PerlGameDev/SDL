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

my $screen_surface = SDL::Video::set_video_mode( 800, 600, 32, SDL_SWSURFACE );

my $event = SDL::Event->new();
my ( $r, $g, $b ) = ( 0, 0, 0 );
while (1) {
    while ( SDL::Events::poll_event($event) ) {

        exit(0) if $event->type == SDL_QUIT;

        if ( $event->type == SDL_KEYDOWN ) {

            print STDERR SDL::Events::get_key_name( $event->key_sym ), "\n";
            ( $r, $g, $b ) = ( rand_num(), rand_num(), rand_num() );
        }
    }

    my $color = SDL::Video::map_RGB( $screen_surface->format(), $r, $g, $b );

    SDL::Video::fill_rect( $screen_surface, SDL::Rect->new( 0, 0, 800, 600, ),
        $color );

    SDL::Video::update_rect( $screen_surface, 0, 0, 800, 600 );

    SDL::delay(20);
}

sub rand_num {
    return int( rand(256) );
}

