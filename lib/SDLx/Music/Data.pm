package SDLx::Music::Data;
use strict;
use warnings;

use SDL::Mixer ();
use Carp ();

sub new {
	my ($class, %arg) = @_;
	my $self = bless {}, ref $class || $class;

	while(my ($param, $value) = each %arg) {
		$self->$param($value) if defined $value;
	}
	return $self;
}

sub _set {
	my ($self, $param, $value) = @_;
	$self = $_Default unless ref $self;
	defined $value
		? $self->{$param} = $value
		: delete $self->{$param}
	;
	return;
}
sub _get {
	my ($self, $param, $default) = @_;
	return
		  defined $self->{$param}                ? $self->{$param}
		: defined $self->{default}->{$param}     ? $self->{default}->{$param}
		: defined SDLx::Music->default->{$param} ? SDLx::Music->default->{$param}
		: $default
	;
}

sub name {
	my $self = shift;
	return $self->_set("name", $_[0]) if @_;
	return $self->{name}
}
sub file {
	my $self = shift;
	return $self->_set("file", $_[0]) if @_;
	return defined $self->{file} ? $self->{file} : "";
}
sub dir {
	my $self = shift;
	return $self->_set("dir", $_[0]) if @_;
	return $self->_get("dir", "");
}
sub ext {
	my $self = shift;
	return $self->_set("ext", $_[0]) if @_;
	return $self->_get("ext", "");
}
sub loaded {
	#TODO
	...
}
sub loops {
	my $self = shift;
	return $self->_set("loops", $_[0]) if @_;
	return $self->_get("loops", 0);
}
sub fade_in {
	my $self = shift;
	return $self->_set("fade_in", $_[0]) if @_;
	return $self->_get("fade_in", undef);
}
sub volume {
	my $self = shift;
	return $self->_set("volume", $_[0]) if @_;
	return $self->_get("volume", SDL::Mixer::MIX_MAX_VOLUME);
}
sub pos {
	my $self = shift;
	return $self->_set("pos", $_[0]) if @_;
	return $self->_get("pos", undef);
}
sub finished {
	#TODO
	...;
	my $self = shift;
	if(@_) {
		$self->_set("finished", $_[0]);
		return $self;
	}
	return $self->_get("finished", undef);
}

sub path {
	my ($self) = @_;
	$self->dir . $self->file . $self->ext;
}

sub DESTROY {
	my ($self) = @_;
	delete $self->{default};
}

1;
