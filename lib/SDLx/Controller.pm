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
my %_delay;
my %_eoq;
my %_paused;
my %_time;
my %_eoq_handler;

sub new {
	my ($self, %args) = @_;
	if(ref $self) {
		bless $self, ref $self;
	}
	else {
		my $a;
		$self = bless \$a, $self;
	}

	my $ref = refaddr $self;

	$_dt{ $ref }                 = defined $args{dt}    ? $args{dt}    : 0.1;
	$_min_t{ $ref }              = defined $args{min_t} ? $args{min_t} : 1 / 60;
#	$_current_time{ $ref }       = $args{current_time} || 0;                               #no point
#	$_stop{ $ref }               = $args{stop};                                            #shouldn't be allowed
	$_event{ $ref }              = $args{event} || SDL::Event->new();
	$_event_handlers{ $ref }     = $args{event_handlers} || [];
	$_move_handlers{ $ref }      = $args{move_handlers}  || [];
	$_show_handlers{ $ref }      = $args{show_handlers}  || [];
	$_delay{ $ref }              = (defined $args{delay} && $args{delay} >= 1 ? $args{delay} / 1000 : $args{delay}) || 0; #phasing out ticks, but still accepting them. Remove whenever we break compat
	$_eoq{$ref}                  = $args{exit_on_quit} || $args{eoq};
#	$_paused{ $ref }             = $args{paused};                                          #no point
	$_time{ $ref }               = $args{time} || 0;
	$_eoq_handler{ $ref }        = $args{exit_on_quit_handler} || $args{eoq_handler} || \&_default_exit_on_quit_handler;

	return $self;
}

sub DESTROY {
	my $self = shift;
	my $ref = refaddr $self;

	delete $_dt{ $ref};
	delete $_min_t{ $ref};
	delete $_current_time{ $ref};
	delete $_stop{ $ref};
	delete $_event{ $ref};
	delete $_event_handlers{ $ref};
	delete $_move_handlers{ $ref};
	delete $_show_handlers{ $ref};
	delete $_delay { $ref};
	delete $_eoq{ $ref}; 
	delete $_paused{ $ref};
	delete $_time{ $ref};
	delete $_eoq_handler{ $ref};
}

sub run {
	my ($self)       = @_;
	my $ref          = refaddr $self;
	my $dt           = $_dt{ $ref };
	my $min_t        = $_min_t{ $ref };

	#Allows us to do stop and run
	$_stop{ $ref } = 0;

	$_current_time{ $ref } = Time::HiRes::time;
	while ( !$_stop{ $ref } ) {
		$self->_event($ref);

		my $new_time   = Time::HiRes::time;
		my $delta_time = $new_time - $_current_time{ $ref };
		next if $delta_time < $min_t;
		$_current_time{ $ref} = $new_time;
		my $delta_copy = $delta_time;

		while ( $delta_copy > $dt ) {
			$self->_move( $ref, 1, $_time{ $ref} ); #a full move
			$delta_copy -= $dt;
			$_time{ $ref} += $dt;
		}
		my $step = $delta_copy / $dt;
		$self->_move( $ref, $step, $_time{ $ref} ); #a partial move
		$_time{ $ref} += $dt * $step;

		$self->_show( $ref, $delta_time );

		$dt    = $_dt{ $ref};    #these can change
		$min_t = $_min_t{ $ref}; #during the cycle
		
		Time::HiRes::sleep( $_delay{ $ref } ) if $_delay{ $ref };
	}

}
sub stop { $_stop{ refaddr $_[0] } = 1 }

sub pause {
	my ($self, $callback) = @_;
	my $ref = refaddr $self;
	$_paused{ $ref} = 1;
	while(1) {
		SDL::Events::wait_event($_event{ $ref}) or Carp::confess("pause failed waiting for an event");
		if(
			$_eoq{ $ref} && do { $_eoq_handler{ $ref}->( $_event{ $ref}, $self ); $_stop{ $ref} }
			or !$callback or $callback->($_event{ $ref}, $self)
		) {
			$_current_time{ $ref} = Time::HiRes::time; #so run doesn't catch up with the time paused
			last;
		}
	}
	delete $_paused{ $ref};
}
sub paused {
	#why would you ever want to set this? Internally set only
	$_paused{ refaddr $_[0]};
}

sub _event {
	my ($self, $ref) = @_;
	SDL::Events::pump_events();
	while ( SDL::Events::poll_event( $_event{ $ref} ) ) {
		$_eoq_handler{ $ref}->( $_event{ $ref}, $self ) if $_eoq{ $ref};
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

sub current_time {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_current_time{ $ref} = $arg if defined $arg;

	$_current_time{ $ref};
}

sub delay {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_delay{ $ref} = $arg if defined $arg;

	$_delay{ $ref};
}

sub exit_on_quit {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_eoq{ $ref} = $arg if defined $arg;

	$_eoq{ $ref};
}
*eoq = \&exit_on_quit;  # alias

sub exit_on_quit_handler {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_eoq_handler{ $ref} = $arg if defined $arg;

	$_eoq_handler{ $ref};
}
*eoq_handler = \&exit_on_quit_handler; #alias

sub _default_exit_on_quit_handler {
   my ($self, $event) = @_;

    $self->stop() if $event->type == SDL_QUIT;
}

sub event {
	my ($self, $arg) = @_;
	my $ref = refaddr $self;
	$_event{ $ref} = $arg if defined $arg;

	$_event{ $ref};
}

#replacements for SDLx::App->get_ticks() and delay()
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


