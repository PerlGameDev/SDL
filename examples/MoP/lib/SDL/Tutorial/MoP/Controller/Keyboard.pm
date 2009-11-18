package SDL::Tutorial::MoP::Controller::Keyboard;

use strict;
use warnings;

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
    while(SDL::Events::poll_event($sdl_event)) #get the first one
    {
	    my $event_type = $sdl_event->type;
	    my $key        = $self->{last_key} || $sdl_event->key_sym;
	
	    if ( $key eq 'down' ) { # TODO: left, right
	        # store last pressed key, so the blocks 
	        # will continue sliding next time
	        $self->{last_key} = $key;
	    }
	
	    if($event_type == SDL_KEYUP)
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
	        'up'     => { name => 'CharactorMoveRequest', direction => 'ROTATE_C' },
	        'space'  => { name => 'CharactorMoveRequest', direction => 'ROTATE_CC' },
	        'down'   => { name => 'CharactorMoveRequest', direction => 'DIRECTION_DOWN' },
	        'left'   => { name => 'CharactorMoveRequest', direction => 'DIRECTION_LEFT' },
	        'right'  => { name => 'CharactorMoveRequest', direction => 'DIRECTION_RIGHT' },
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
