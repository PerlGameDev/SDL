package SDLx::Controller;
use strict;
use warnings;
use SDL;
use SDL::Event;
use SDL::Events;
use SDLx::Controller::Timer;
use Scalar::Util 'refaddr';

# inside out, so this can work as the superclass of another
# SDL::Surface subclass
my %_delta;
my %_dt;
my %_min_ms;
my %_fps;
my %_quit;
my %_event;
my %_event_handlers;
my %_move_handlers;
my %_show_handlers;

sub new {
	my $self = shift;
	my $class = ref $self || $self;
	my $a;
	$self = ref $self ? $self : \$a;
	bless $self, $class;

	my %args = @_;
	$_delta{ refaddr $self} = SDLx::Controller::Timer->new();
	$_delta{ refaddr $self}->start(); # should do this after on_load
	$_dt{ refaddr $self}             = $args{dt}     || 1;
	$_min_ms{ refaddr $self}         = $args{min_ms} || 1;
	$_fps{ refaddr $self}            = SDLx::FPS->new( $args{fps} ) if defined $args{fps};
	$_quit{ refaddr $self}           = $args{quit};
	$_event{ refaddr $self}          = $args{event};
	$_event_handlers{ refaddr $self} = $args{event_handlers};
	$_move_handlers{ refaddr $self}  = $args{move_handlers};
	$_show_handlers{ refaddr $self}  = $args{show_handlers};

	return $self;
}

sub DESTROY {
	my $self = shift;

	delete $_delta{ refaddr $self};
	delete $_dt{ refaddr $self};
	delete $_min_ms{ refaddr $self};
	delete $_fps{ refaddr $self};
	delete $_quit{ refaddr $self};
	delete $_event{ refaddr $self};
	delete $_event_handlers{ refaddr $self};
	delete $_move_handlers{ refaddr $self};
	delete $_show_handlers{ refaddr $self};
}

sub run {
	my $self = shift;
	$_delta{ refaddr $self}->start();
	while ( !$_quit{ refaddr $self} ) {
		$self->_event;
		my $delta_time = $_delta{ refaddr $self}->get_ticks();
		next if $delta_time < $_min_ms{ refaddr $self};
		my $delta_copy = $delta_time;
		
		while ( $delta_copy > $_dt{ refaddr $self} and !$_quit{ refaddr $self} ) {
			$self->_move( 1 ); #a full move
			$delta_copy -= $_dt{ refaddr $self};
		}
		$self->_move( $delta_copy / $_dt{ refaddr $self} ); #a partial move
		
		$_delta{ refaddr $self}->start();
		$self->_show($delta_time);
	}
}

sub run_fps {
	my $self = shift;
	while ( !$_quit{ refaddr $self} ) {
		my $delta_time = $_delta{ refaddr $self}->get_ticks(); #only need this to give to _show()
		$self->_event;
		$self->_move;
		$_delta{ refaddr $self}->start();
		$self->_show($delta_time);
		$_fps{ refaddr $self}->delay();
	}
}

sub _event {
	my $self = shift;

	$_event{ refaddr $self} = SDL::Event->new() unless $_event{ refaddr $self};
	while ( SDL::Events::poll_event( $_event{ refaddr $self} ) ) {
		SDL::Events::pump_events();
		foreach my $event_handler ( @{ $_event_handlers{ refaddr $self} } ) {
			$self->quit unless $event_handler->( $_event{ refaddr $self} );
		}
	}
}

sub _move {
	my $self        = shift;
	my $delta_ticks = shift;
	foreach my $move_handler ( @{ $_move_handlers{ refaddr $self} } ) {
		$move_handler->($delta_ticks);
	}
}

sub _show {
	my $self        = shift;
	my $delta_ticks = shift;
	foreach my $event_handler ( @{ $_show_handlers{ refaddr $self} } ) {
		$event_handler->($delta_ticks);
	}
}

sub quit { $_quit{ refaddr $_[0] } = 1 }

sub _add_handler {
	my ( $arr_ref, $handler ) = @_;
	push @{$arr_ref}, $handler;
	return $#{$arr_ref};
}

sub add_move_handler {
	$_[0]->remove_all_move_handlers if !$_move_handlers{ refaddr $_[0] };
	return _add_handler( $_move_handlers{ refaddr $_[0] }, $_[1] );
}

sub add_event_handler {
	$_[0]->remove_all_event_handlers if !$_event_handlers{ refaddr $_[0] };
	return _add_handler( $_event_handlers{ refaddr $_[0] }, $_[1] );
}

sub add_show_handler {
	$_[0]->remove_all_show_handlers if !$_show_handlers{ refaddr $_[0] };
	return _add_handler( $_show_handlers{ refaddr $_[0] }, $_[1] );
}

sub _remove_handler {
	my ( $handlers_ref, $id ) = @_;
	if ( ref $id ) {
		$id = (
			grep {
				$id eq ${$handlers_ref}[$_] #coderef matches with input
				} 0 .. $#{$handlers_ref}
		)[0];                               #only the first coderef
		if ( !defined $id ) {
			Carp::carp("$id is not currently a handler of this type");
			return;
		}
	}
	return splice( @{$handlers_ref}, $id, 1 );
}

sub remove_move_handler {
	return _remove_handler( $_move_handlers{ refaddr $_[0] }, $_[1] );
}

sub remove_event_handler {
	return _remove_handler( $_event_handlers{ refaddr $_[0] }, $_[1] );
}

sub remove_show_handler {
	return _remove_handler( $_show_handlers{ refaddr $_[0] }, $_[1] );
}

sub remove_all_handlers {
	$_[0]->remove_all_move_handlers;
	$_[0]->remove_all_event_handlers;
	$_[0]->remove_all_show_handlers;
}

sub remove_all_move_handlers {
	$_move_handlers{ refaddr $_[0] } = [];
}

sub remove_all_event_handlers {
	$_event_handlers{ refaddr $_[0] } = [];
}

sub remove_all_show_handlers {
	$_show_handlers{ refaddr $_[0] } = [];
}

sub move_handlers  { $_move_handlers{ refaddr $_[0] } }
sub event_handlers { $_event_handlers{ refaddr $_[0] } }
sub show_handlers  { $_show_handlers{ refaddr $_[0] } }

1; #not 42 man!

__END__


