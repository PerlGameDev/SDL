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
    return $#{$arr_ref};
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

1;    #not 42 man!

__END__


