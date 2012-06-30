package SDLx::Controller;
use strict;
use warnings;
use Carp ();
use Time::HiRes ();
use SDL ();
use SDL::Event ();
use SDL::Events ();
use SDL::Video ();
use SDLx::Controller::Interface;
use SDLx::Controller::State;
use Scalar::Util 'refaddr';

# inside out, so this can work as the superclass of another class
my %_dt;
my %_min_t;
my %_max_t;
my %_stop;
my %_event;
my %_event_handlers;
my %_move_handlers;
my %_show_handlers;
my %_delay;
my %_paused;
my %_time;
my %_stop_handler;
my %_before_pause;
my %_after_pause;
my %_event_handler;
my %_move_handler;
my %_show_handler;

use constant {
	STOP  => '1',
	PAUSE => '0', # pause is defined but false
};

sub new {
	my ($self, %args) = @_;

	# if $self is blessed then it has to isa controller, so let's not even bless it to this class
	unless(ref $self) {
		my $a;
		$self = bless \$a, $self;
	}

	my $ref = refaddr $self;

	$_dt{ $ref }                 = defined $args{dt}    ? $args{dt}    : 0.1;
	$_min_t{ $ref }              = defined $args{min_t} ? $args{min_t} : 1 / 60;
	$_max_t{ $ref }          = defined $args{max_t} ? $args{max_t} : 0.1;
	$_stop{ $ref }           = STOP;
	$_event{ $ref }              = $args{event} || SDL::Event->new();
	$_event_handlers{ $ref }     = $args{event_handlers} || [];
	$_move_handlers{ $ref }      = $args{move_handlers}  || [];
	$_show_handlers{ $ref }      = $args{show_handlers}  || [];
	# delay accepts seconds or ticks
	$_delay{ $ref }          = defined $args{delay} ? ($args{delay} >= 1 ? $args{delay} / 1000 : $args{delay}) : 0;
#	$_paused{ $ref }             = undef;
	$_time{ $ref }               = $args{time} || 0;
	$_stop_handler{ $ref }       = exists $args{stop_handler} ? $args{stop_handler} : \&default_stop_handler;
	$_before_pause{ $ref }   = $args{before_pause};
	$_after_pause{ $ref }    = $args{after_pause};
	$_event_handler{ $ref }  = $args{event_handler} || \&default_event_handler;
	$_move_handler{ $ref }   = $args{move_handler}  || \&default_move_handler;
	$_show_handler{ $ref }   = $args{show_handler}  || \&default_show_handler;

	return $self;
}

sub DESTROY {
	my $self = shift;
	my $ref = refaddr $self;

	delete $_dt{ $ref};
	delete $_min_t{ $ref};
	delete $_max_t{ $ref };
	delete $_stop{ $ref};
	delete $_event{ $ref};
	delete $_event_handlers{ $ref};
	delete $_move_handlers{ $ref};
	delete $_show_handlers{ $ref};
	delete $_delay { $ref};
	delete $_paused{ $ref};
	delete $_time{ $ref};
	delete $_stop_handler{ $ref};
	delete $_before_pause{ $ref };
	delete $_after_pause{ $ref };
	delete $_event_handler{ $ref };
	delete $_move_handler{ $ref };
	delete $_show_handler{ $ref };
}

sub run {
	my ($self)       = @_;
	my $ref          = refaddr $self;

	# these keep their old value until the end of the cycle
	my ($dt, $delay, $min_t);

	# you have to stop and rerun the app to update these
	my $event_handler = $_event_handler{ $ref };
	my $move_handler  = $_move_handler{ $ref };
	my $show_handler  = $_show_handler{ $ref };
	my $stop_handler  = $_stop_handler{ $ref };

	# alows us to do stop and run
	delete $_stop{ $ref };
	delete $_paused{ $ref };

	my $current_time = Time::HiRes::time();
	Time::HiRes::sleep( 0.001 ); # sleep at least a millisecond

	until ( defined $_stop{ $ref } ) {
		my $new_time   = Time::HiRes::time();
		my $delta_time = my $delta_copy = $new_time - $current_time;
		$current_time = $new_time;
		$delta_time = $_max_t{ $ref } if $delta_time > $_max_t{ $ref };

		# these can change during the cycle
		$dt    = $_dt{ $ref };
		$delay = $_delay{ $ref };
		$min_t = $_min_t{ $ref };

		# we keep this completely up-to-date
		my $time_ref = \$_time{ $ref};

		my $event = $_event{ $ref };
		SDL::Events::pump_events();
		while ( SDL::Events::poll_event( $event ) ) {
			$stop_handler ->( $event, $self ) if $stop_handler;
			$event_handler->( $event, $self );
		}

		while ( $delta_copy > $dt ) {
			$move_handler->( 1, $self, $$time_ref ); # a full move
			$delta_copy -= $dt;
			$$time_ref += $dt;
		}
		my $step = $delta_copy / $dt;
		$move_handler->( $step, $self, $$time_ref ); # a partial move
		$$time_ref += $dt * $step;

		$show_handler->( $delta_time, $self );

		# one or the other of delay or min_t is good
		Time::HiRes::sleep( $delay ) if $delay > 0;

		if($min_t > 0) {
			my $min_t_delay = $min_t - (Time::HiRes::time - $new_time);
			Time::HiRes::sleep($min_t_delay) if $min_t_delay > 0;
		}
	}

	# pause works by stopping the app and running it again
	if( $_paused{ $ref } ) {
		$_before_pause{ $ref }->($self) if $_before_pause{ $ref };
		$self->_pause($ref);
		$_after_pause{ $ref }->($self) if $_after_pause{ $ref };

		return if $_stop{ $ref };

		# exit out of this sub before going back in so we don't recurse deeper and deeper
		goto $self->can('run');
	}
}

sub stop {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;

	$_stop{ $ref } = @_ > 1 ? $arg : STOP;

	# if we're going to stop we don't want to pause
	delete $_paused{ $ref } if defined $_stop{ $ref } and $_stop{ $ref } eq STOP;
}
sub stopped {
	# returns true if the app is stopped or about to stop
	$_stop{ refaddr $_[0]};
}

sub _pause {
	my ($self, $ref) = @_;
	my $event = $_event{ $ref};
	my $stop_handler = $_stop_handler{ $ref};
	my $callback = $_paused{ $ref};
	my $stop = delete $_stop{ $ref };

	do {
		SDL::Events::pump_events(); # don't know if we need this
		SDL::Events::wait_event( $event ) or Carp::confess("pause failed waiting for an event");
		$stop_handler->( $event, $self ) if $stop_handler;
	}
	until
		$_stop{ $ref } # stop set by stop_handler
		or $callback->( $event, $self )
		or $_stop{ $ref } # stop set by callback
	;

	$_stop{ $ref } ||= $stop if $stop;
	delete $_paused{ $ref };
}
sub pause {
	my ($self, $callback) = @_;
	my $ref = refaddr $self;
	my $stop = $_stop{ $ref };

	unless( $callback ) {
		delete $_paused{ $ref };
		return;
	}

	# if we're going to stop we don't want to pause
	return if !$_paused{ $ref } and defined $stop and $stop eq STOP;

	$_stop{ $ref } = PAUSE unless $stop;
	$_paused{ $ref} = $callback;
}
sub paused {
	# returns the callback (always true) if the app is paused or about to pause
	$_paused{ refaddr $_[0]};
}

sub default_event_handler {
	my ($event, $self) = @_;
	foreach my $event_handler ( @{$_event_handlers{ refaddr $self }} ) {
		$event_handler->( $event, $self ) if $event_handler;
	}
}

sub default_move_handler {
	my ($move_portion, $self, $t) = @_;
	foreach my $move_handler ( @{$_move_handlers{ refaddr $self }} ) {
		$move_handler->( $move_portion, $self, $t ) if $move_handler;
	}
}

sub default_show_handler {
	my ($delta_time, $self) = @_;
	foreach my $show_handler ( @{$_show_handlers{ refaddr $self }} ) {
		$show_handler->( $delta_time, $self ) if $show_handler;
	}
}

sub _add_handler {
	my ( $arr_ref, $handler ) = @_;
	push @{$arr_ref}, $handler;
	return $#{$arr_ref};
}

sub add_move_handler {
	my $ref = refaddr $_[0];
	return _add_handler( $_move_handlers{ $ref}, $_[1] );
}

sub add_event_handler {
	my $ref = refaddr $_[0];
	Carp::confess 'SDLx::App or a Display (SDL::Video::get_video_mode) must be made'
		unless SDL::Video::get_video_surface();
	return _add_handler( $_event_handlers{ $ref}, $_[1] );
}

sub add_show_handler {
	my $ref = refaddr $_[0];
	return _add_handler( $_show_handlers{ $ref}, $_[1] );
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
	@{ $_move_handlers{ refaddr $_[0] } } = ();
}

sub remove_all_event_handlers {
	@{ $_event_handlers{ refaddr $_[0] } } = ();
}

sub remove_all_show_handlers {
	@{ $_show_handlers{ refaddr $_[0] } } = ();
}

sub move_handlers  { $_move_handlers{ refaddr $_[0] } }
sub event_handlers { $_event_handlers{ refaddr $_[0] } }
sub show_handlers  { $_show_handlers{ refaddr $_[0] } }

sub dt {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_dt{ $ref} = $arg if defined $arg;

	$_dt{ $ref};
}

sub min_t {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_min_t{ $ref} = $arg if defined $arg;

	$_min_t{ $ref};
}

sub max_t {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_max_t{ $ref } = $arg if defined $arg;

	$_max_t{ $ref };
}

sub delay {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_delay{ $ref} = $arg if defined $arg;

	$_delay{ $ref};
}

sub event_handler {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_event_handler{ $ref } = $arg if @_ > 1;

	$_event_handler{ $ref };
}

sub move_handler {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_move_handler{ $ref } = $arg if @_ > 1;

	$_move_handler{ $ref };
}

sub show_handler {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_show_handler{ $ref } = $arg if @_ > 1;

	$_show_handler{ $ref };
}

sub stop_handler {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_stop_handler{ $ref} = $arg if @_ > 1;

	$_stop_handler{ $ref};
}

sub before_pause {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_before_pause{ $ref } = $arg if @_ > 1;

	$_before_pause{ $ref };
}

sub after_pause {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_after_pause{ $ref } = $arg if @_ > 1;

	$_after_pause{ $ref };
}

sub default_stop_handler {
	my ($event, $self) = @_;

	$self->stop() if $event->type == SDL::Events::SDL_QUIT;
}

sub event {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_event{ $ref} = $arg if defined $arg;

	$_event{ $ref};
}

# replacements for SDLx::App::get_ticks() and SDLx::App::delay()
sub time {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_time{ $ref} = $arg if defined $arg;

	$_time{ $ref};
}
sub sleep {
	return Time::HiRes::sleep( $_[1] );
}

# deprecated
sub ticks {
	return SDL::get_ticks();
}

1;
