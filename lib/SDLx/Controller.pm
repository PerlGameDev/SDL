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
my %_stop;
my %_event;
my %_event_handlers;
my %_move_handlers;
my %_show_handlers;
my %_delay;
my %_paused;
my %_time;
my %_stop_handler;

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
	$_stop{ $ref }               = 1;
	$_event{ $ref }              = $args{event} || SDL::Event->new();
	$_event_handlers{ $ref }     = $args{event_handlers} || [];
	$_move_handlers{ $ref }      = $args{move_handlers}  || [];
	$_show_handlers{ $ref }      = $args{show_handlers}  || [];
	$_delay{ $ref }              = (defined $args{delay} && $args{delay} >= 1 ? $args{delay} / 1000 : $args{delay}) || 0; #phasing out ticks, but still accepting them. Remove whenever we break compat
#	$_paused{ $ref }             = undef;
	$_time{ $ref }               = $args{time} || 0;
	$_stop_handler{ $ref }       = exists $args{stop_handler} ? $args{stop_handler} : \&default_stop_handler;

	return $self;
}

sub DESTROY {
	my $self = shift;
	my $ref = refaddr $self;

	delete $_dt{ $ref};
	delete $_min_t{ $ref};
	delete $_stop{ $ref};
	delete $_event{ $ref};
	delete $_event_handlers{ $ref};
	delete $_move_handlers{ $ref};
	delete $_show_handlers{ $ref};
	delete $_delay { $ref};
	delete $_paused{ $ref};
	delete $_time{ $ref};
	delete $_stop_handler{ $ref};
}

sub run {
	my ($self)       = @_;
	my $ref          = refaddr $self;
	my $dt           = $_dt{ $ref };
	my $min_t        = $_min_t{ $ref };

	# alows us to do stop and run
	delete $_stop{ $ref };
	delete $_paused{ $ref };

	my $current_time = Time::HiRes::time;
	while ( !$_stop{ $ref } ) {
		$self->_event($ref);

		my $new_time   = Time::HiRes::time;
		my $delta_time = $new_time - $current_time;
		if($delta_time < $min_t) {
			Time::HiRes::sleep(0.001); # sleep at least a millisecond
			next;
		}
		$current_time = $new_time;
		my $delta_copy = $delta_time;
		my $time_ref = \$_time{ $ref};

		while ( $delta_copy > $dt ) {
			$self->_move( $ref, 1, $$time_ref ); # a full move
			$delta_copy -= $dt;
			$$time_ref += $dt;
		}
		my $step = $delta_copy / $dt;
		$self->_move( $ref, $step, $$time_ref ); # a partial move
		$$time_ref += $dt * $step;

		$self->_show( $ref, $delta_time );

		# these can change during the cycle
		$dt    = $_dt{ $ref};
		$min_t = $_min_t{ $ref};

		Time::HiRes::sleep( $_delay{ $ref } ) if $_delay{ $ref };
	}

	# pause works by stopping the app and running it again
	if( $_paused{ $ref } ) {
		delete $_stop{ $ref};

		$self->_pause($ref);

		# exit out of this sub before going back in so we don't recurse deeper and deeper
			goto &{ $self->can('run') }
		unless $_stop{ $ref};
	}
}

sub stop {
	my $ref = refaddr $_[0];

	$_stop{ $ref } = 1;

	# if we're going to stop we don't want to pause
	delete $_paused{ $ref };
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

	do {
		SDL::Events::wait_event( $event ) or Carp::confess("pause failed waiting for an event");
	}
	until
		$stop_handler && do { $stop_handler->( $event, $self ); $_stop{ $ref} }
		or !$callback or $callback->( $event, $self )
	;
}
sub pause {
	my ($self, $callback) = @_;
	my $ref = refaddr $self;

	# if we're going to stop we don't want to pause
	return if !$_paused{ $ref} and $_stop{ $ref};

	$_paused{ $ref} = $callback;
	$_stop{ $ref} = 1;
}
sub paused {
	# returns the callback (always true) if the app is paused or about to pause
	$_paused{ refaddr $_[0]};
}

sub _event {
	my ($self, $ref) = @_;
	SDL::Events::pump_events();
	while ( SDL::Events::poll_event( $_event{ $ref} ) ) {
		$_stop_handler{ $ref}->( $_event{ $ref}, $self ) if $_stop_handler{ $ref};
		foreach my $event_handler ( @{ $_event_handlers{ $ref} } ) {
			next unless $event_handler;
			$event_handler->( $_event{ $ref}, $self );
		}
	}
}

sub _move {
	my ($self, $ref, $move_portion, $t) = @_;
	foreach my $move_handler ( @{ $_move_handlers{ $ref} } ) {
		next unless $move_handler;
		$move_handler->( $move_portion, $self, $t );
	}
}

sub _show {
	my ($self, $ref, $delta_ticks) = @_;
	foreach my $show_handler ( @{ $_show_handlers{ $ref} } ) {
		next unless $show_handler;
		$show_handler->( $delta_ticks, $self );
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

sub delay {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_delay{ $ref} = $arg if defined $arg;

	$_delay{ $ref};
}

sub stop_handler {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_stop_handler{ $ref} = $arg if @_ > 1;

	$_stop_handler{ $ref};
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

# replacements for SDLx::App->get_ticks() and delay()
sub time {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_time{ $ref} = $arg if defined $arg;

	$_time{ $ref};
}
sub sleep {
	return Time::HiRes::sleep( $_[1] );
}

1;

__END__


