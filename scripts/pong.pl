use strict;
use warnings;

package Ball;
#use SDL::Game::Rect;

sub new {
    my $class = shift;
    my $self = {
        'rect'      => SDL::Game::Rect->new(100, 100, 10, 10),
        'velocity'  => [1, -1], #vector of velocity
    };
    bless $self, $class;
}

sub reset
{
    my $self = shift;
   
     $self->{'rect'}->x($_[0]);
     $self->{'rect'}->y($_[1]);
     $self->{'velocity'} = [int(rand(2))*2-1, int(rand(2))*2-1];
}

sub update {
my $self = shift;
#get current location
 my $x = $self->{'rect'}->x;
 my $y =  $self->{'rect'}->y;
 my $velocity_x = $self->{'velocity'}[0];
 my $velocity_y = $self->{'velocity'}[1];
 #calculate next location 
 my $nx = $x + $velocity_x;
 my $ny = $y + $velocity_y;
 
 $self->{'rect'}->x($nx);

 $self->{'rect'}->y($ny);


}

package main;
use SDL;
use SDL::Game::Rect;
use SDL::App;


my $app = SDL::App->new(
    -title  => 'Pong',
	-width  => 640,
	-height => 480,
	-depth  => 16,
);

my $event = SDL::Event->new;
my $ball = Ball->new;

my $bg_color = SDL::Color->new( -r => 0x00, -g => 0x00, -b => 0x00 );
my $back = SDL::Rect->new( -x => 0, -y => 0, -w =>$app->width, -h =>$app->height);

my $player = SDL::Rect->new( -x => 10, -y => 20, -w => 12, -h => 90);
my $score = [ 0, 0 ];
my $player2 = SDL::Rect->new( -x => ($app->width - 20), -y => 20, -w => 12, -h => 90);


my $fg_color = SDL::Color->new( -r => 0x22, -g => 0xff, -b => 0x22 );
my $held = undef;


sub update
{
    $ball->update;
    if ($held)
    {
        
    $player->y($player->y + 2) if($held eq 'down' && ($player->y + $player->height + 2) <  $app->height - 5) ;
    $player->y($player->y - 2) if($held eq 'up' && ($player->y - 2 ) >  5 );
    
    $player2->y($player2->y + 2) if($held eq 's' && ($player2->y + $player2->height + 2) <  $app->height - 5);
    $player2->y($player2->y - 2) if($held eq 'w' && ($player2->y - 2 ) >  5 );
    
    }
}



sub draw_screen {

   $app->fill($back, $bg_color);
   $app->fill($player, $fg_color);
   $app->fill($player2, $fg_color);
   $app->fill($ball->{'rect'}->rect, $fg_color);
   
    SDL::UpdateRect( $app, $ball->{'rect'}->x, $ball->{'rect'}->y, $ball->{'rect'}->right, $ball->{'rect'}->bottom);  
    #$app->update($player, $ball->{'rect'}->rect); fails in windows need redesign branch
 
}



sub event_loop {    
    while ($event->poll) {
        my $type = $event->type;
        exit if $type == SDL_QUIT;
	
	$held = $event->key_name if ($type == SDL_KEYDOWN);			
        $held = undef if ($type == SDL_KEYUP) ;
	

    }
   

}

sub check_events
{
    event_loop();
    # did ball collide with wall
    if($ball->{'rect'}->rect->x > ($app->width - 15 ))
    {
        $score->[0] = $score->[0] + 1;
        print "player One scores: \n Score is now $score->[0] / $score->[1]  \n";
        $ball->reset($app->width/2, $app->height/2);
    }
    
    if ( $ball->{'rect'}->rect->x < 2)
    {
        $score->[1] =  $score->[1] + 1;
        print "player Two scores: \n Score is now $score->[0] / $score->[1]  \n";
        $ball->reset($app->width/2, $app->height/2);
    }
    
    $ball->{'velocity'}[0] = -1 if  ($ball->{'rect'}->rect->x > ($player2->x  - 1) ) &&  
                                    ($ball->{'rect'}->rect->y > ($player2->y))     &&
                                    ($ball->{'rect'}->rect->y < ($player2->y + $player2->height));
                                    
    $ball->{'velocity'}[0] = 1  if  ($ball->{'rect'}->rect->x < ($player->x + $player->width + 1)) && 
                                    ($ball->{'rect'}->rect->y > ($player->y))             &&
                                    ($ball->{'rect'}->rect->y < ($player->y + $player->height));
    
    $ball->{'velocity'}[1] = -1 if($ball->{'rect'}->rect->y > ($app->height - 15));
    $ball->{'velocity'}[1] = 1 if ($ball->{'rect'}->rect->y < 2);
}




sub game_loop
{
    check_events;
    update;
    draw_screen;
    $app->sync();
}

game_loop while 1;

__END__

=head1 PONG TUTORIAL

This tutorial is intended to help you build your very own version of the Pong game and/or variations of it, using SDL Perl.

Just in case you live under a rock, Pong is one of the earliest arcade games, a true classic by Atari Inc. The game has two simple rectangles scrolling up and down trying to hit a (square) ball that bounces around, and could be thought of as a table tennis simulation.

=head2 Part 1: We start with a Rect

In Pong, the player controls a rectangle that moves up and down, so creating the rectangle looks like a good place to start:

   my $player = SDL::Game::Rect->new({
                       -top    => 10,
                       -left   => 20,
                       -width  => 6,
                       -height => 32,
                });

That creates a new L<< SDL::Game::Rect >> object, a rectangle, with the given width/height dimensions and in the given top/left position of the screen.

Wait. Did I say... I<<screen>>?

=head2 Part 0: "The Screen"

In SDL Perl, creating a window screen is very easy and straightforward:

  use SDL;
  use SDL::App;

  my $app = SDL::App->new(
                 -title  => 'Pong',  # set window title
                 -width  => 640,     # window width
                 -height => 480,     # window height
          );

That's it. If you run this code, you'll see a window appear and disappear almost instantly. Why doesn't it stay up? Well, the code is processed linearly, like usual programs are, and with no hidden magic. So, you basically said "create a window" and then the program ended - destroying the window. In order to keep it up and running, listening for events, you need an event loop. 

=head3 Creating an (empty) event loop

An event loop is a simple infinite loop that captures events (like a key pressed or released from the keyboard, mouse movement, etc) and either does something about it or dispatches it to any object that might.

For this simple game we don't need a very sofisticated event loop, so let's create a simple one.

  event_loop() while 1;

Yay, an infinite loop! Now we are free to define our very own event loop any way we want. Let's make it an empty sub for starters:

  sub event_loop {
  }

Ok. If you run it, you'll see your C<< $app >> window displayed until you force to shutdown the program by typing C<< Ctrl-C >> or something. Other than that, our event loop doesn't do anything, 

=head2 Part 1 (cont.) - Drawing our Rect on the screen

# TODO

=head2 Part 2 - Our first event: tracking user movement

# TODO

Now let's query some events!

First, we need to use the L<< SDL::Event >> module. Add this to the beginning of our code:

  use SDL::Event;
  my $event = SDL::Event->new;

 
Now let's rewrite the C<< event_loop >> subroutine to take advantage of our event object. The new subroutine should look like this:

  sub event_loop {
      # first we poll if an event occurred...
      while ($event->poll) {

          # if there is an event, we check its type
          my $type = $event->type

          # handle window closing
          exit if $type == SDL_QUIT;
      }
  }


#TODO

=head3 Hey, don't move away from the court! Our first collision detection.

=head2 Part 3 - Enter "the Ball"

#TODO

=head3 Some vetorial background

#TODO

=head2 Part 4 - Collision Detection

#TODO

=head2 Part 5 - Our hero's nemesis appears

#TODO

=head3 (really) basic IA

#TODO

=head2 Part 6 - Counting (and showing) the score

#TODO
