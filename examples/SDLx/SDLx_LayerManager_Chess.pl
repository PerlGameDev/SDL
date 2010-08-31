#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes;

use SDL;
use SDL::Event;
use SDL::Events;
use SDL::Rect;
use SDL::Surface;
use SDL::Video;

use SDLx::SFont;
use SDLx::Surface;
use SDLx::Sprite;

use SDLx::LayerManager;
use SDLx::Layer;
use SDLx::FPS;

SDL::init(SDL_INIT_VIDEO);
my $display         = SDL::Video::set_video_mode( 800, 600, 32, SDL_HWSURFACE | SDL_HWACCEL );
my $layers          = SDLx::LayerManager->new();
my $event           = SDL::Event->new();
my $loop            = 1;
my $last_click      = Time::HiRes::time;
my $fps             = SDLx::FPS->new( fps => 60 );
my @selected_cards  = ();
my $left_mouse_down = 0;
my @rects           = ();

init_surfaces();
$layers->blit($display);
SDL::Video::update_rect( $display, 0, 0, 0, 0 );
game();

sub event_loop {
	my $handler = shift;

	SDL::Events::pump_events();
	while ( SDL::Events::poll_event($event) ) {
		$left_mouse_down = 1 if $event->type == SDL_MOUSEBUTTONDOWN && $event->button_button == SDL_BUTTON_LEFT;
		$left_mouse_down = 0 if $event->type == SDL_MOUSEBUTTONUP   && $event->button_button == SDL_BUTTON_LEFT;

		$handler->{on_quit}->()
			if defined $handler->{on_quit}
				&& ( $event->type == SDL_QUIT || ( $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_ESCAPE ) );
		$handler->{on_drop}->() if defined $handler->{on_drop} && $event->type == SDL_MOUSEBUTTONUP;
		$handler->{on_click}->()
			if defined $handler->{on_click}
				&& $event->type == SDL_MOUSEBUTTONDOWN
				&& Time::HiRes::time- $last_click >= 0.3;

		$last_click = Time::HiRes::time if $event->type == SDL_MOUSEBUTTONDOWN;
	}
}

sub game {
	my @selected_cards = ();
	my $x              = 0;
	my $y              = 0;
	my $handler        = {
		on_quit => sub {
			$loop = 0;
		},
		on_drop => sub {
			if ( scalar @selected_cards ) {
				my $layer = $layers->by_position( $event->button_x, $event->button_y );

				if ( defined $layer ) {
					my @behind = @{ $layer->behind };
					if ( scalar @behind == 1
						&& $behind[0]->data->{id} =~ m/^\w{2}$/ )
					{
						$layer->foreground;
						$layers->detach_xy( $behind[0]->pos->x + 8, $behind[0]->pos->y + 8 );
						printf( "to %s\n", $behind[0]->data->{id} );
					} else {
						$layers->detach_back;
					}
				} else {
					$layers->detach_back;
				}
			}
			@selected_cards = ();
		},
		on_click => sub {
			unless ( scalar @selected_cards ) {
				my $layer = $layers->by_position( $event->button_x, $event->button_y );

				if ( defined $layer
					&& $layer->data->{id} =~ m/^(white|black)$/ )
				{
					@selected_cards = ($layer);
					$layers->attach( $layer, $event->button_x, $event->button_y );
				}
			}
		},
	};

	while ($loop) {
		event_loop($handler);
		@rects = @{ $layers->blit($display) };
		SDL::Video::update_rect( $display, 0, 0, 0, 0 ) if scalar @rects;
		$fps->delay;
	}
}

sub init_surfaces {
	my $white_surface = SDL::Image::load('test/data/wood_light.png');
	my $black_surface = SDL::Image::load('test/data/wood_dark.png');
	my $white_button  = SDL::Image::load('test/data/button_light.png');
	my $black_button  = SDL::Image::load('test/data/button_dark.png');
	for my $x ( 0 .. 7 ) {
		for my $y ( 0 .. 7 ) {
			$layers->add(
				SDLx::Layer->new(
					( $x + $y ) & 1 ? $white_surface : $black_surface,
					144 + 64 * $x,
					44 + 64 * $y,
					{ id => chr( ord('A') + $x ) . ( $y + 1 ) }
				)
			);
		}
	}

	for my $x ( 0 .. 7 ) {
		for my $y ( 0 .. 7 ) {
			if ( $y < 2 ) {
				$layers->add( SDLx::Layer->new( $white_button, 152 + 64 * $x, 52 + 64 * $y, { id => 'white' } ) );
			}

			if ( $y > 5 ) {
				$layers->add( SDLx::Layer->new( $black_button, 152 + 64 * $x, 52 + 64 * $y, { id => 'black' } ) );
			}
		}
	}
}
