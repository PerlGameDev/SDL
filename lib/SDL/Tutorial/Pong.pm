use strict;
use warnings;

package SDL::Tutorial::Pong::Ball;
#use SDL::Game::Rect;
use SDL::Color;

sub new {
    my $class = shift;
    my $self = {
        'rect'      => SDL::Game::Rect->new(20, 20, 10, 10),
        'speed'     => 4,
        'direction' => 5,
        'color' => SDL::Color->new(0x00, 0xcc, 0x00),
    };
    bless $self, $class;
}

sub update {
    
}

package main;
use SDL;
use SDL::Game::Rect;
use SDL::App;
use SDL::Event;
use SDL::Events;

my $app = SDL::App->new(
    -title  => 'Pong',
	-width  => 640,
	-height => 480,
	-depth  => 16,
);

my $event = SDL::Event->new;
my $ball = SDL::Tutorial::Pong::Ball->new;

my $bg_color = SDL::Color->new(0x00, 0x00, 0x00);
my $back = SDL::Rect->new( 0, 0, $app->w, $app->h);
my $player = SDL::Rect->new(100, 30, 20, 90);
my $fg_color = SDL::Color->new(0xcc, 0xcc, 0xcc);

event_loop() while 1;


sub event_loop {
	my $offset = undef;
    while ( (SDL::Events::poll_event($event) > 0) or defined $offset) {
        my $type = $event->type;
        exit if $type == SDL_QUIT;

        if ($type == SDL_KEYDOWN) {
				if(SDL::Events::get_key_name($event->key_sym) eq 'down') {
						$offset = +2;	
				}
				if(SDL::Events::get_key_name($event->key_sym) eq 'up') {
						$offset = -2;
				}
        }
		if ($type == SDL_KEYUP) {
			$offset = undef;
		}
        if (defined $offset) {
            $player->y($player->y + $offset)
        }
		 draw_screen();
    }
   

}

sub draw_screen { 

    

    SDL::Video::fill_rect($app, $back, map_color( $bg_color) );
    SDL::Video::fill_rect($app, $player, map_color( $fg_color));
 
  
  $app->sync();
}

sub map_color{
  return SDL::Video::map_RGB( $app->format,  $_[0]->r, $_[0]->b, $_[0]->g);
}

__END__

