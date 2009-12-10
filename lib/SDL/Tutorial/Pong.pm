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
	my $held_down_key = undef;
    while ( (SDL::Events::poll_event($event) > 0) || defined $held_down_key) {
        my $type = $event->type;
        exit if $type == SDL_QUIT;

        if ($type == SDL_KEYDOWN || defined $held_down_key) {
				if(SDL::Events::get_key_name($event->key_sym) eq 'down' || $held_down_key eq 'down')
				{
						$player->y($player->y + 2) ;	
						$held_down_key = 'down' 						
				}
				if($event->key_name eq 'up' || $held_down_key eq 'up')
				{
						$player->y($player->y - 2) ;
						$held_down_key = 'up' 							
				}
				
        }
		if ($type == SDL_KEYUP)
		{
			$held_down_key = undef;
		}
		 draw_screen();
    }
   

}

sub draw_screen {

   $app->fill($back, $bg_color);
   $app->fill($player, $fg_color);

# if I uncomment this line, the window buttons go away!!! WTF???
  
  $app->sync();
}

__END__
O
