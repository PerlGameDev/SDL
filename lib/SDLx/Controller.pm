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
use Scalar::Util 'refaddr';

# inside out, so this can work as the superclass of another
# SDL::Surface subclass
my %_dt;
my %_min_t;
my %_current_time;
my %_stop;
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
		my $a;
		$self = bless \$a, $self;
	}
	
	$_dt{ refaddr $self}                 = defined $args{dt}    ? $args{dt}    : 0.1;
	$_min_t{ refaddr $self}              = defined $args{min_t} ? $args{min_t} : 1 / 60;
#	$_current_time{ refaddr $self}       = $args{current_time} || 0; #no point
	$_stop{ refaddr $self}               = $args{stop};
	$_event{ refaddr $self}              = $args{event} || SDL::Event->new();
	$_event_handlers{ refaddr $self}     = $args{event_handlers};
	$_move_handlers{ refaddr $self}      = $args{move_handlers};
	$_show_handlers{ refaddr $self}      = $args{show_handlers};

	return $self;
}

sub DESTROY {
	my $self = shift;

	delete $_dt{ refaddr $self};
	delete $_min_t{ refaddr $self};
	delete $_current_time{ refaddr $self};
	delete $_stop{ refaddr $self};
	delete $_event{ refaddr $self};
	delete $_event_handlers{ refaddr $self};
	delete $_move_handlers{ refaddr $self};
	delete $_show_handlers{ refaddr $self};
}

sub run {
	my ($self)       = @_;
	my $dt           = $_dt{ refaddr $self};
	my $min_t        = $_min_t{ refaddr $self};
	my $t            = 0.0;
	$_current_time{ refaddr $self} = Time::HiRes::time;
	while ( !$_stop{ refaddr $self} ) {
		$self->_event;

		my $new_time   = Time::HiRes::time;
		my $delta_time = $new_time - $_current_time{ refaddr $self};
		next if $delta_time < $min_t;
		$_current_time{ refaddr $self} = $new_time;
		my $delta_copy = $delta_time;

		while ( $delta_copy > $dt ) {
			$self->_move( 1, $t ); #a full move
			$delta_copy -= $dt;
			$t += $dt;
		}
		my $step = $delta_copy / $dt;
		$self->_move( $step, $t ); #a partial move
		$t += $dt * $step;
		
		$self->_show( $delta_time );
		
		$dt    = $_dt{ refaddr $self};    #these can change
		$min_t = $_min_t{ refaddr $self}; #during the cycle
	}

}

sub pause {
	my ($self, $callback) = @_;
	$callback ||= sub {1};
	my $event = SDL::Event->new();
	while(1) {
		SDL::Events::wait_event($event) or Carp::confess("pause failed waiting for an event");
		if($callback->($event, $self)) {
			$_current_time{ refaddr $self} = Time::HiRes::time; #so run doesn't catch up with the time paused
			last;
		}
	}
}

sub _event {
	my ($self) = shift;
	while ( SDL::Events::poll_event( $_event{ refaddr $self} ) ) {
		SDL::Events::pump_events();
		foreach my $event_handler ( @{ $_event_handlers{ refaddr $self} } ) {
			next unless $event_handler;
			$event_handler->( $_event{ refaddr $self}, $self );
		}
	}
}

sub _move {
	my ($self, $move_portion, $t) = @_;
	foreach my $move_handler ( @{ $_move_handlers{ refaddr $self} } ) {
		next unless $move_handler;
		$move_handler->( $move_portion, $self, $t );
	}
}

sub _show {
	my ($self, $delta_ticks) = @_;
	foreach my $show_handler ( @{ $_show_handlers{ refaddr $self} } ) {
		next unless $show_handler;
		$show_handler->( $delta_ticks, $self );
	}
}

sub stop { $_stop{ refaddr $_[0] } = 1 }

sub _add_handler {
	my ( $arr_ref, $handler ) = @_;
	push @{$arr_ref}, $handler;
	return $#{$arr_ref};
}

sub add_move_handler {
	$_[0]->remove_all_move_handlers if !$_move_handlers{ refaddr $_[0] };
	return _add_handler( $_move_handlers{ refaddr $_[0]}, $_[1] );
}

sub add_event_handler {
	Carp::confess 'SDLx::App or a Display (SDL::Video::get_video_mode) must be made'
		unless SDL::Video::get_video_surface();
	$_[0]->remove_all_event_handlers if !$_event_handlers{ refaddr $_[0] };
	return _add_handler( $_event_handlers{ refaddr $_[0]}, $_[1] );
}

sub add_show_handler {
	$_[0]->remove_all_show_handlers if !$_show_handlers{ refaddr $_[0] };
	return _add_handler( $_show_handlers{ refaddr $_[0]}, $_[1] );
}

sub _remove_handler {
	my ( $arr_ref, $id ) = @_;
	if ( ref $id ) {
		($id) = grep { 
					$id eq $arr_ref->[$_]
				} 0..$#{$arr_ref};
				
		if ( !defined $id ) {
			Carp::cluck("$id is not currently a handler of this type");
			return;
		}
	}
	elsif(!defined $arr_ref->[$id]) {
		Carp::cluck("$id is not currently a handler of this type");
		return;
	}
	return delete( $arr_ref->[$id] );
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

sub current_time {
	my ($self, $arg) = @_;
	
	$_current_time{ refaddr $self} = $arg if defined $arg;
	
	$_current_time{ refaddr $self};
}

1; #not 42 man!

__END__


