use strict;
use warnings;

package SDL::Tutorial::Pong::Paddle;
use SDL::Rect;
use SDL::Color;

sub new {
    my $class = shift;
    my $self = { rect => SDL::Rect->new(@_) };
    bless $self, $class;
}

sub update {
    my ($self, $total_height) = (@_);
    my $offset = $self->{direction};

    # if we are supposed to move,
    # move *only* if we are inside bounds
    # (there should be a collision check for this
    #  inside SDLX::Rect
    if (defined $offset 
        and $self->{rect}->y + $offset > 0
        and $self->{rect}->y + $offset < ($total_height - $self->{rect}->h)
    ) {
        $self->{rect}->y($self->{rect}->y + $offset)
    }

}

package SDL::Tutorial::Pong::Ball;
use SDL::Rect;
use SDL::Color;

sub new {
    my $class = shift;
    my $self = {
        'rect'  => SDL::Rect->new(220, 120, 20, 20),
        'dir_x' => 1,
        'dir_y' => 1,
    };
    bless $self, $class;
}

sub update {
    my ($self, $player1, $player2) = (@_);
    my ($x, $y) = ($self->{rect}->x, $self->{rect}->y);
    my ($new_x, $new_y) = ($x + $self->{dir_x}, $y + $self->{dir_y});

    # someone scored a goal
    if (($new_x > 640) or ($new_x < 0)) {
        ($new_x, $new_y) = (220, 120);
        print STDERR "OOOOOOOOOOOOOOO\n";  #FIXME <<<<---- the ball doesn't go back!
    }
    # ball hit a wall, bounce back
    elsif ($new_y > 480 or $new_y < 0) {
        $self->{dir_y} = -$self->{dir_y};
        $new_y = $y + $self->{dir_y};
    }
    #TODO ball hit player1
    #TODO ball hit player2
    $self->{rect}->x($new_x);
    $self->{rect}->y($new_y);
    print STDERR "x: " . $self->{rect}->x;
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
my $ball  = SDL::Tutorial::Pong::Ball->new;

my $back     = SDL::Rect->new( 0, 0, $app->w, $app->h);
my $player   = SDL::Tutorial::Pong::Paddle->new(100, 30, 20, 90);
my $nemesis  = SDL::Tutorial::Pong::Paddle->new(540, 30, 20, 90);
my $fg_color = SDL::Color->new(0xcc, 0xcc, 0xcc);
my $bg_color = SDL::Color->new(0x00, 0x00, 0x00);


sub check_events {
    while ( SDL::Events::poll_event($event) > 0 ) {
        my $type = $event->type;
        my $key  = SDL::Events::get_key_name($event->key_sym);
        exit if $type == SDL_QUIT;

        if ($type == SDL_KEYDOWN) {
			if($key eq 'down') {
                $player->{direction} = +2;
			}
			if(SDL::Events::get_key_name($event->key_sym) eq 'up') {
                $player->{direction} = -2;
			}
        }
		elsif ($type == SDL_KEYUP) {
            $player->{direction} = undef;
		}
    }
}

sub game_loop {

    check_events();

    # move the ball
    $ball->update;

    # move the player
    $player->update($app->h);

    #move the nemesis
    my $nemesis_direction;
    if ($ball->{rect}->y > $nemesis->{rect}->y) {
        $nemesis->{direction} = +2; 
    }
    elsif ($ball->{rect}->y < ($nemesis->{rect}->y + $nemesis->{rect}->h)) {
        $nemesis->{direction} = -2;
    }
    else {
        $nemesis->{direction} = undef;
    }
    $nemesis->update($app->h);



	draw_screen();
}

sub draw_screen { 
    SDL::Video::fill_rect($app, $back, map_color( $bg_color) );
    SDL::Video::fill_rect($app, $player->{rect}, map_color( $fg_color));
    SDL::Video::fill_rect($app, $nemesis->{rect}, map_color( $fg_color));
    SDL::Video::fill_rect($app, $ball->{rect}, map_color( $fg_color ));
    $app->sync();
}

sub map_color{
  return SDL::Video::map_RGB( $app->format,  $_[0]->r, $_[0]->b, $_[0]->g);
}

game_loop() while 1;

__END__

