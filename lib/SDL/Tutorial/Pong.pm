use strict;
use warnings;

package Ball;
#use SDL::Game::Rect;

sub new {
    my $class = shift;
    my $self = {
        'rect'      => SDL::Game::Rect->new(20, 20, 10, 10),
        'speed'     => 4,
        'direction' => 5,
        'color' => SDL::Color->new(-r => 0x00, -g => 0xcc, -b => 0x00),
    };
    bless $self, $class;
}

sub update {
    
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
my $back = SDL::Rect->new( 0, 0, $app->width, $app->height);
my $player = SDL::Rect->new( 100, 30, 20, 90);
my $fg_color = SDL::Color->new( -r => 0xcc, -g => 0xcc, -b => 0xcc );

event_loop() while 1;


sub event_loop {
	my $held_down_key = undef;
    while ($event->poll || defined $held_down_key) {
        my $type = $event->type;
        exit if $type == SDL_QUIT;

        if ($type == SDL_KEYDOWN || defined $held_down_key) {
				if($event->key_name eq 'down' || $held_down_key eq 'down')
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
