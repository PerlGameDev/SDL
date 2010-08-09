package SDLx::Controller::Timer;

# Implementation of lesson 13 and 14 from http://lazyfoo.net/SDL_tutorials/index.php
#
use strict;
use warnings;
use SDL;

sub new {
	my $class = shift;
	my $self = bless {@_}, $class;

	$self->{started_ticks} = 0;
	$self->{paused_ticks}  = 0;
	$self->{started}       = 0;
	$self->{paused}        = 0;

	return $self;
}

sub start {
	my $self = shift;
	$self->{started}       = 1;
	$self->{started_ticks} = SDL::get_ticks();
}

sub stop {
	my $self = shift;

	$self->{started} = 0;
	$self->{paused}  = 0;
}

sub pause {
	my $self = shift;
	if ( $self->{started} && !$self->{paused} ) {
		$self->{paused}       = 1;
		$self->{paused_ticks} = SDL::get_ticks() - $self->{started_ticks};
	}
}

sub unpause {
	my $self = shift;
	if ( $self->{paused} ) {
		$self->{paused} = 0;

		$self->{started_ticks} = SDL::get_ticks() - $self->{started_ticks};

		$self->{paused_ticks} = 0;
	}
}

sub get_ticks {
	my $self = shift;
	if ( $self->{started} ) {
		if ( $self->{paused} ) {
			return $self->{paused_ticks};
		} else {
			my $update = SDL::get_ticks();
			my $diff   = $update - $self->{started_ticks};
			return $diff;
		}
	}
	return 0;
}

sub is_started {
	my $self = shift;
	return $self->{started};
}

sub is_paused {
	my $self = shift;
	return $self->{paused};
}

1;
