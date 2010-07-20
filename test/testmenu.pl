#!/usr/bin/env perl

use strict;
use warnings;

use SDL ':init';
use SDL::Video ':all';
use SDL::Events ':all';

use SDL::Rect;
use SDL::Image;
use SDL::Event;
use SDL::Surface;

SDL::init(SDL_INIT_VIDEO);

my $menu = SDL::Image::load('data/menu.png');

die " Image loading errors: " . SDL::get_error() if !$menu;

my $screen =
  SDL::Video::set_video_mode( $menu->w, $menu->h, 32, SDL_SWSURFACE );

my $hilight = SDL::Image::load('data/highlight.png');

my %menu = (
    'start'       => [ 115, 30,  160, 40 ],
    'help'        => [ 120, 100, 120, 40 ],
    'giveup'      => [ 120, 230, 120, 40 ],
    'spawnserver' => [ 115, 170, 165, 40 ],
    'credits'     => [ 115, 285, 160, 40 ],
);

my %item = (
    help        => 'This should print a help message',
    credits     => 'mantovani and kthakore',
    spawnserver => 'Spawinging new server...',
    start       => 'This should start the game',
    giveup      => 'Giving up',
);

die(SDL::get_error) unless $menu;

my $quit  = 0;
my $event = SDL::Event->new();
$event->type(SDL_ACTIVEEVENT);
$event->active_gain(1);

my $sel = 0;
my @select = ( 'start', 'help', 'spawnserver', 'giveup', 'credits' );

while ( !$quit ) {
    while ( SDL::Events::poll_event($event) ) {

        $quit = 1 if $event->type == SDL_QUIT;
        if ( $event->type == SDL_KEYDOWN ) {
            ### PROCESS EVENT HERE
            if ( $event->key_sym == SDLK_DOWN ) {
                $sel++ if $sel < $#select;
            }
            elsif ( $event->key_sym == SDLK_UP ) {
                $sel-- if $sel > 0;
            }
            elsif ( $event->key_sym == SDLK_RETURN ) {
                print $item{ $select[$sel] }, "\n";
                exit(0) if $select[$sel] eq 'giveup';
            }
        }

    }

    SDL::Video::blit_surface(
        $menu,   SDL::Rect->new( 0, 0, $menu->w,   $menu->h ),
        $screen, SDL::Rect->new( 0, 0, $screen->w, $screen->h )
    );

    SDL::Video::blit_surface(
        $hilight, SDL::Rect->new( @{ $menu{ $select[$sel] } } ),
        $screen,  SDL::Rect->new( @{ $menu{ $select[$sel] } } )
    );

    SDL::Video::update_rect( $screen, 0, 0, $menu->w, $menu->h );

}

