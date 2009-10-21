use strict;
use warnings;

package Ball;
use base 'SDL::Game::Rect';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->{'velocity'} = [1, -1], #vector of velocity
    return $self;
}

sub reset {
    my $self = shift;

     $self->x($_[0]);
     $self->y($_[1]);
     $self->{'velocity'} = [int(rand(2))*2-1, int(rand(2))*2-1];
}

sub update {
    my $self = shift;
    $self->move( $self->{'velocity'}[0], $self->{'velocity'}[1] );
}

package main;
use SDL;
use SDL::Game::Rect;
use SDL::App;

my $app = SDL::App->new(
    -title  => 'Pong',
	-width  => 640,
	-height => 480,
);
my $event = SDL::Event->new;

# game objects
my $ball    = Ball->new (100, 100, 10, 10);
my $player  = SDL::Game::Rect->new(10, 20, 12, 90);
my $player2 = SDL::Game::Rect->new($app->width - 20, 20, 12, 90);
my $back    = SDL::Rect->new( -x => 0, -y => 0, -w =>$app->width, -h =>$app->height);

my $held = undef;
my $score = [ 0, 0 ];


sub update {
    $ball->update;
    if ($held) {
        $player->y($player->y + 2) if($held eq 'down' && ($player->bottom + 2) <  $app->height - 5) ;
        $player->y($player->y - 2) if($held eq 'up' && ($player->y - 2 ) >  5 );
    
        $player2->y($player2->y + 2) if($held eq 's' && ($player2->bottom + 2) <  $app->height - 5);
        $player2->y($player2->y - 2) if($held eq 'w' && ($player2->y - 2 ) >  5 );
    }
}


sub draw_screen {
    $app->fill($back, $SDL::Color::black);
    $app->fill($player->rect, $SDL::Color::green);
    $app->fill($player2->rect, $SDL::Color::green);
    $app->fill($ball->rect, $SDL::Color::green);
   
    SDL::UpdateRect( $app, $ball->x, $ball->y, $ball->right, $ball->bottom);  
    #$app->update($player, $ball->{'rect'}->rect); fails in windows need redesign branch
}


sub event_loop {    
    while ($event->poll) {
        my $type = $event->type;
        exit if $type == SDL_QUIT;
	
	$held = $event->key_name if ($type == SDL_KEYDOWN);			
	exit if $held eq 'escape';
        $held = undef if ($type == SDL_KEYUP) ;
    }
}


sub check_events {
    event_loop();
    # did ball collide with wall
    if($ball->rect->x > ($app->width - 15 )) {
        $score->[0] = $score->[0] + 1;
        print "player One scores: \n Score is now $score->[0] / $score->[1]  \n";
        $ball->reset($app->width/2, $app->height/2);
    }
    
    if ( $ball->rect->x < 2) {
        $score->[1] =  $score->[1] + 1;
        print "player Two scores: \n Score is now $score->[0] / $score->[1]  \n";
        $ball->reset($app->width/2, $app->height/2);
    }
    
    $ball->{'velocity'}[0] = -1 if $ball->collide_rect($player2);
    $ball->{'velocity'}[0] = 1 if $ball->collide_rect($player);

    $ball->{'velocity'}[1] = -1 if($ball->y > ($app->height - 15));
    $ball->{'velocity'}[1] = 1 if ($ball->y < 2);
}


sub game_loop {
    check_events;
    update;
    draw_screen;
    $app->sync();
}

game_loop while 1;
