package SDLx::Controller;
use strict;
use warnings;
use Carp;
use Time::HiRes;
use SDL;
use SDL::Event;
use SDL::Events;
use SDL::Video;
use SDLx::Controller::Timer;
use Scalar::Util 'refaddr';
use SDLx::Controller::Interface;
use SDLx::Controller::State;

# inside out, so this can work as the superclass of another
# SDL::Surface subclass
my %_dt;
my %_min_t;
my %_quit;
my %_event;
my %_event_handlers;
my %_move_handlers;
my %_show_handlers;

sub new {
	my ($self, %args) = @_;
	if(ref $self) {
		bless $self, ref $self;
	}
	else {
		$self = bless \my $a, $self;
	}
	
	$_dt{ refaddr $self}             = $args{dt} || 0.1;
	$_min_t{ refaddr $self}          = $args{min_t} || 0;
	$_quit{ refaddr $self}           = $args{quit};
	$_event{ refaddr $self}          = $args{event};
	$_event_handlers{ refaddr $self} = $args{event_handlers};
	$_move_handlers{ refaddr $self}  = $args{move_handlers};
	$_show_handlers{ refaddr $self}  = $args{show_handlers};

	return $self;
}

sub DESTROY {
	my $self = shift;

	delete $_dt{ refaddr $self};
	delete $_quit{ refaddr $self};
	delete $_event{ refaddr $self};
	delete $_event_handlers{ refaddr $self};
	delete $_move_handlers{ refaddr $self};
	delete $_show_handlers{ refaddr $self};
}

sub run {
	my ($self)       = @_;
	my $dt           = $_dt{ refaddr $self};
	my $min_t        = $_min_t{ refaddr $self};
	my $current_time = Time::HiRes::time;
	while ( !$_quit{ refaddr $self} ) {
		$self->_event;

		my $new_time   = Time::HiRes::time;
		my $delta_time = $new_time - $current_time;
		next if $delta_time < $min_t;
		$current_time = $new_time;
		my $delta_copy = $delta_time;

		while ( $delta_copy > $dt ) {
			$self->_move( 1 ); #a full move
			$delta_copy -= $dt;
		}
		$self->_move( $delta_copy / $dt ); #a partial move
		
		$self->_show( $delta_time );
		
		$dt    = $_dt{ refaddr $self};    #these can change
		$min_t = $_min_t{ refaddr $self}; #during the cycle
	}

}

sub _event {
	my ($self) = @_;
	$_event{ refaddr $self} = SDL::Event->new() unless $_event{ refaddr $self};
	while ( SDL::Events::poll_event( $_event{ refaddr $self} ) ) {
		SDL::Events::pump_events();
		foreach my $event_handler ( @{ $_event_handlers{ refaddr $self} } ) {
			$self->quit unless $event_handler->( $_event{ refaddr $self} );
		}
	}
}

sub _move {
	my ($self, $move_portion) = @_;
	foreach my $move_handler ( @{ $_move_handlers{ refaddr $self} } ) {
		$move_handler->( $move_portion );
	}
}

sub _show {
	my ($self, $delta_ticks) = @_;
	foreach my $event_handler ( @{ $_show_handlers{ refaddr $self} } ) {
		$event_handler->($delta_ticks);
	}
}

sub quit { $_quit{ refaddr $_[0] } = 1 }

sub dt {
	my ($self, $arg) = @_;
	
	$_dt{ refaddr $self} = $arg if defined $arg;
	
	$_dt{ refaddr $self};
}

sub min_t {
	my ($self, $arg) = @_;
	
	$_min_t{ refaddr $self} = $arg if defined $arg;
	
	$_min_t{ refaddr $self};
}


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
	Carp::confess 'SDLx::App or a Display (SDL::Video::get_video_mode) must be made'
		unless SDL::Video::get_video_surface();
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
			Carp::cluck("$id is not currently a handler of this type");
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


