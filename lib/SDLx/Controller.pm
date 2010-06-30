package SDLx::Controller;
use strict;
use warnings;
use SDL;
use SDL::Event;
use SDL::Events;
use SDLx::Controller::Timer;

sub new {
    my $class = shift;
    my $self = bless {@_}, $class;
    $self->{delta} = SDLx::Controller::Timer->new();
    $self->{delta}->start();    # should do this after on_load
    $self->{dt} = 0.1 unless $self->{dt};

    return $self;
}

sub run {
    my $self = shift;
    $self->{quit} = 0;
    my $accumulator = 0;
    while ( !$self->{quit} ) {
        $self->_event;
        my $delta_time = $self->{delta}->get_ticks();
        $accumulator += $delta_time;

        while ( $accumulator >= $self->{dt} && !$self->{quit} ) {
            $self->_move( $self->{dt} );
            $accumulator -= $self->{dt};

            #update how much real time we have animated
        }
        $self->{delta}->start();
        $self->_show($delta_time);
    }
}

sub _event {
    my $self = shift;

    $self->{event} = SDL::Event->new() unless $self->{event};
    while ( SDL::Events::poll_event( $self->{event} ) ) {
        SDL::Events::pump_events();
        foreach my $event_handler ( @{ $self->{event_handlers} } ) {
            $self->quit unless $event_handler->( $self->{event} );
        }
    }
}

sub _move {
    my $self        = shift;
    my $delta_ticks = shift;
    foreach my $move_handler ( @{ $self->{move_handlers} } ) {
        $move_handler->($delta_ticks);
    }
}

sub _show {
    my $self        = shift;
    my $delta_ticks = shift;
    foreach my $event_handler ( @{ $self->{show_handlers} } ) {
        $event_handler->($delta_ticks);
    }
}

sub quit { shift->{quit} = 1 }

sub _add_handler {
    my ( $arr_ref, $handler ) = @_;
    push @{$arr_ref}, $handler;
    return $#{$arr_ref}
}

sub add_move_handler {
    $_[0]->{move_handlers} = [] if !$_[0]->{move_handlers};
    return _add_handler( $_[0]->{move_handlers}, $_[1] );
}

sub add_event_handler {
    $_[0]->{event_handlers} = [] if !$_[0]->{event_handlers};
    return _add_handler( $_[0]->{event_handlers}, $_[1] );
}

sub add_show_handler {
    $_[0]->{show_handlers} = [] if !$_[0]->{show_handlers};
    return _add_handler( $_[0]->{show_handlers}, $_[1] );
}

sub _remove_handler {
    my ( $arr_ref, $id ) = @_;
    return splice( @{$arr_ref}, $id, 1 );
}

sub remove_move_handler {
    return _remove_handler( $_[0]->{move_handlers}, $_[1] );
}

sub remove_event_handler {
    return _remove_handler( $_[0]->{event_handlers}, $_[1] );
}

sub remove_show_handler {
    return _remove_handler( $_[0]->{show_handlers}, $_[1] );
}

sub remove_all_handlers {
    $_[0]->{move_handlers}  = [];
    $_[0]->{event_handlers} = [];
    $_[0]->{show_handlers}  = [];
}

sub remove_all_move_handlers {
    $_[0]->{move_handlers} = [];
}

sub remove_all_event_handlers {
    $_[0]->{event_handlers} = [];
}

sub remove_all_show_handlers {
    $_[0]->{show_handlers} = [];
}


1; #not 42 man!

__END__

=head1 NAME

SDLx::Controller - Handles the loops for event, movement and rendering

=head1 SYNOPSIS

  use SDLx::Controller

  # create our controller object
  my $app = SDLx::Controller->new;

  # register some callbacks
  $app->add_event_handler( \&on_event );
  $app->add_move_handler( \&on_move );
  $app->add_show_handler( &on_show );

  # run our game loop
  $app->run;


=head2 DESCRIPTION

The core of a SDL application/game is the main loop, where you handle events
and display your elements on the screen until something signals the end of
the program. This usually goes in the form of:

  while (1) {
      ...
  }

The problem most developers face, besides the repetitive work, is to ensure
the screen update is independent of the frame rate. Otherwise, your game will
run at different speeds on different machines and this is never good (old
MS-DOS games, anyone?).

One way to circumveint this is by capping the frame rate so it's the same no
matter what, but this is not the right way to do it as it penalizes better
hardware.

This module provides an industry-proven standard for frame independent
movement. It calls the movement handlers based on time (tick counts) rather
than frame rate. You can add/remove handlers and control your main loop with
ease.

=head1 METHODS

=head2 new

=head2 new( dt => 0.5 )

Controller construction. Optional C<dt> parameter indicates delta t times
in which to call the movement handlers, and defaults to 0.1.

Returns the new object.

=head2 run

After creating and setting up your handlers (see below), call this method to
activate the main loop. The main loop will run until an event handler returns
undef.

All hooked functions will be called during the main loop, in this order:

=over 4

=item 1. Events

=item 2. Movements

=item 3. Displaying

=back

Please refer to each handler below for information on received arguments.

=head2 add_event_handler

Register a callback to handle events. You can add as many subs as you need.
Whenever a SDL::Event occurs, all registered callbacks will be triggered in
order. Returns the order queue number of the added callback.

The first (and only) argument passed to registered callbacks is the
L<< SDL::Event >> object itself, so you can test for C<< $event->type >>, etc.

Each event handler is B<required> to return a defined value for the main loop
to continue. To exit the main loop (see "run" above), return C<undef> or
nothing at all.


=head2 add_move_handler

Register a callback to update your objects. You can add as many subs as
you need. Returns the order queue number of the added callback.

All registered callbacks will be triggered in order for as many
C<dt> as have happened between calls. You should use these handlers to update
your in-game objects, check collisions, etc.

The first (and only) argument passed is a reference to the dt value itself,
so you can check and/or update it as necessary.

Any returned values are ignored.


=head2 add_show_handler

Register a callback to render objects. You can add as many subs as you need.
Returns the order queue number of the added callback.

All registered callbacks will be triggered in order, once per run of the main
loop. The first (and only) argument passed is the number of ticks since
the previous round.

=head2 quit

Exits the main loop. Calling this method will cause C<< run >> to return.

=head2 remove_move_handler( $index )

=head2 remove_event_handler( $index )

=head2 remove_show_handler( $index )

Removes the handler with the given index from the respective calling queue.

Returns the removed handler.

=head2 remove_all_move_handlers

=head2 remove_all_event_handlers

=head2 remove_all_show_handlers

Removes all handlers from the respective calling queue.

=head2 remove_all_handlers

Quick access to removing all handlers at once.


=head1 AUTHORS

Kartik Thakore

Breno G. de Oliveira

=head2 ACKNOWLEGDEMENTS

The idea and base for this module comes from Lazy Foo's L<< Frame Independent
Movement|http://www.lazyfoo.net/SDL_tutorials/lesson32/index.php >> tutorial,
and Glenn Fiedler's L<< Fix Your Timestep|http://gafferongames.com/game-physics/fix-your-timestep/ >> article on timing.




