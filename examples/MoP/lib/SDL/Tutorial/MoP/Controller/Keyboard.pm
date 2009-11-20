package SDL::Tutorial::MoP::Controller::Keyboard;

use strict;
use warnings;
use Carp;

use base 'SDL::Tutorial::MoP::Base';

use SDL;
use SDL::Event;
use SDL::Events;

sub notify 
{
    my ($self, $event) = (@_);

    print "Notify in C::KB \n" if $self->{EDEBUG};

    #if we did not have a tick event then some other controller needs to do
    #something so game state is still beign process we cannot have new input
    #now
    return if !defined $event or $event->{name} ne 'Tick';

    #if we got a tick event that means we are starting
    #a new iteration of game loop
    #so we can check input now

    my $event_to_process = undef;

    my $sdl_event = SDL::Event->new();

    SDL::Events::pump_events();                #get events from SDL queue
    while(SDL::Events::poll_event($sdl_event) || $self->{last_key}) #get the first one
    {
	    my $event_type = $sdl_event->type;
	    my $key        = $self->{last_key} || '';
	
	    if($event_type == SDL_KEYDOWN)
	    {
	        $key              = 'left'  if $sdl_event->key_sym == SDLK_LEFT;
	        $key              = 'right' if $sdl_event->key_sym == SDLK_RIGHT;
	        $key              = 'up'    if $sdl_event->key_sym == SDLK_UP;
	        $key              = 'down'  if $sdl_event->key_sym == SDLK_DOWN;
		if($sdl_event->key_sym == SDLK_ESCAPE ){ exit;}
	        $self->{last_key} = $key;
	    }
	    elsif($event_type == SDL_KEYUP)
	    {
	        # stop sliding on key up
	        delete $self->{last_key};
	        $key = '';
	    }
	    elsif($event_type == SDL_QUIT)
	    {
	        $key = 'escape';
	    }
	
	    my %event_key =
	    (
	        'escape' => { name => 'Quit' },
	        'down'   => { name => 'MapMoveRequest', direction => 'DOWN' },
	        'left'   => { name => 'MapMoveRequest', direction => 'LEFT' },
	        'right'  => { name => 'MapMoveRequest', direction => 'RIGHT' },
	        'up'     => { name => 'MapMoveRequest', direction => 'UP' },
	    );
	
	    $event_to_process = $event_key{$key} if defined $event_key{$key};
	    
		#print "SDL event type='$event_type', key='$key'\n";
		$self->evt_manager->post($event_to_process) if defined $event_to_process;
	
	    $event_to_process = undef;    #why the hell do I have to do this shouldn't it be destroied now?
    }
}

1;

__END__

=head1 NAME

SDL::Tutorial::MoP::Controller::Keyboard

=head1 DESCRIPTION

This module takes care of keyboard events.

=head2 notify

C<notify> will generate new events depending on the key pressed:

=over

=item esc

=item direction keys

=item space bar

=back
