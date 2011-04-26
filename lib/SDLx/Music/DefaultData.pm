package SDLx::Music::DefaultData;
use strict;
use warnings;

use Carp ();

sub new { bless {} }

sub dir {
	my $self = shift;
		$self->{dir} = $_[0],
		return $self
	if @_;
	return $self->{dir};
}
sub ext {
	my $self = shift;
		$self->{ext} = $_[0],
		return $self
	if @_;
	return $self->{ext};
}
sub loops {
	my $self = shift;
		$self->{loops} = $_[0],
		return $self
	if @_;
	return $self->{loops};
}
sub fade_in {
	my $self = shift;
		$self->{fade_in} = $_[0],
		return $self
	if @_;
	return $self->{fade_in};
}
sub volume {
	my $self = shift;
		$self->{volume} = $_[0],
		return $self
	if @_;
	return $self->{volume};
}
sub pos {
	my $self = shift;
		$self->{pos} = $_[0],
		return $self
	if @_;
	return $self->{pos};
}
sub finished {
	#TODO
	...;
	my $self = shift;
	if(@_) {
		$self->{finished} = $_[0];
		return $self;
	}
	return $self->{finished};
}

1;
