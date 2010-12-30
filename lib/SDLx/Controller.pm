package SDLx::Controller;
use strict;
use warnings;
use Carp;
use Time::HiRes;
use SDL;
use SDL::Event;
use SDL::Events;
use SDL::Video;
use SDLx::Controller::Interface;
use SDLx::Controller::State;

sub new {
	my ($class, %args) = @_;
    
    my $self = bless {
        dt             => $args{dt}               || 0.1,
        min_t          => $args{min_t}            || 1 / 60,
        stop           => $args{stop},
        event          => $args{event}            || SDL::Event->new(),
        event_handlers => $args{event_handlers},
        move_handlers  => $args{move_handlers},
        show_handlers  => $args{show_handlers},
    }, ref($class) || $class;

	return $self;
}


sub run {
	my ($self) = @_;
	my $dt     = $self->{dt};
	my $min_t  = $self->{min_t};
	my $t      = 0.0;

	#Allows us to do stop and run 
	$self->{stop} = 0;	

	$self->{current_time} = Time::HiRes::time;
	while ( !$self->{stop} ) {
		$self->_event();

		my $new_time   = Time::HiRes::time;
		my $delta_time = $new_time - $self->{current_time};
		next if $delta_time < $min_t;

		$self->{current_time} = $new_time;
		my $delta_copy = $delta_time;

		while ( $delta_copy > $dt ) {
			$self->_move( 1, $t ); # a full move
			$delta_copy -= $dt;
			$t += $dt;
		}
		my $step = $delta_copy / $dt;
		$self->_move( $step, $t ); # a partial move
		$t += $dt * $step;
		
		$self->_show( $delta_time );
		
		$dt    = $self->{dt};    # these can change
		$min_t = $self->{min_t}; # during the cycle
	}

}

sub pause {
	my ($self, $callback) = @_;
	$callback ||= sub { 1 };
	my $event = SDL::Event->new();

	while(1) {
		SDL::Events::wait_event( $event )
            or Carp::confess "pause failed waiting for an event";

        # so run doesn't catch up with the time paused
		if( $callback->($event, $self) ) {
            $self->{current_time} = Time::HiRes::time;
            last;
		}
	}
}

sub _event {
	my ($self) = @_;

	while ( SDL::Events::poll_event( $self->{event} ) ) {
		SDL::Events::pump_events();
		foreach my $event_handler ( @{ $self->{event_handlers} } ) {
			next unless $event_handler;
			$event_handler->( $self->{event}, $self );
		}
	}
}

sub _move {
	my ($self, $move_portion, $t) = @_;

	foreach my $move_handler ( @{ $self->{move_handlers} } ) {
		next unless $move_handler;
		$move_handler->( $move_portion, $self, $t );
	}
}

sub _show {
	my ($self, $delta_ticks) = @_;

	foreach my $show_handler ( @{ $self->{show_handlers} } ) {
		next unless $show_handler;
		$show_handler->( $delta_ticks, $self );
	}
}

sub stop { $_[0]->{stop} = 1 }

sub _add_handler {
	my ( $arr_ref, $handler ) = @_;

	push @{$arr_ref}, $handler;
	return $#{$arr_ref};
}

sub add_move_handler {
	my ($self, $handler) = @_;
	$self->remove_all_move_handlers unless $self->{move_handlers};

	return _add_handler( $self->{move_handlers}, $handler );
}

sub add_event_handler {
	my ($self, $handler) = @_;

	Carp::confess 'SDLx::App or a Display (SDL::Video::get_video_mode) must be made'
		unless SDL::Video::get_video_surface();

	$self->remove_all_event_handlers unless $self->{event_handlers};

	return _add_handler( $self->{event_handlers}, $handler );
}

sub add_show_handler {
	my ($self, $handler) = @_;

	$self->remove_all_show_handlers unless $self->{show_handlers};

	return _add_handler( $self->{show_handlers}, $handler );
}

sub _remove_handler {
	my ( $arr_ref, $id ) = @_;

	if ( ref $id ) {
		($id) = grep { 
					$id eq $arr_ref->[$_]
				} 0..$#{$arr_ref};
				
		if ( not defined $id ) {
			Carp::cluck("$id is not currently a handler of this type");
			return;
		}
	}
	elsif( not defined $arr_ref->[$id]) {
		Carp::cluck("$id is not currently a handler of this type");
		return;
	}
	return delete( $arr_ref->[$id] );
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
	$_[0]->remove_all_move_handlers;
	$_[0]->remove_all_event_handlers;
	$_[0]->remove_all_show_handlers;
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

sub move_handlers  { $_[0]->{move_handlers}  }
sub event_handlers { $_[0]->{event_handlers} }
sub show_handlers  { $_[0]->{show_handlers}  }

sub dt {
	my ($self, $arg) = @_;

	$self->{dt} = $arg if defined $arg;
	
	return $self->{dt};
}

sub min_t {
	my ($self, $arg) = @_;

	$self->{min_t} = $arg if defined $arg;
	
	return $self->{min_t};
}

sub current_time {
	my ($self, $arg) = @_;

	$self->{current_time} = $arg if defined $arg;
	
	return $self->{current_time};
}

1; #not 42 man!

__END__


