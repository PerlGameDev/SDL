package SDLx::Music;
use strict;
use warnings;

use SDL::Mixer ();
use SDL::Mixer::Music ();
use SDLx::Mixer;
use SDLx::Music::Data;
use Carp ();

our $_Default = SDLx::Music::Data->new unless $_Default;
our $_Last_Played;

sub new {
	my $class = shift;
	my $self = bless {}, ref $class || $class;
	SDLx::Mixer::init() unless SDLx::Mixer::status();
	$self->{default} = SDLx::Music::Data->new;
	$self->data(@_) if @_;
	return $self;
}

sub data {
	my $self = shift;
	if(@_ == 1) {
		my ($arg) = @_;
		return $self->{data}{$arg->name} ||= $arg if eval { $arg->isa('SDLx::Music::Data') };
		return $self->{data}{$arg}       ||= SDLx::Music::Data->new($arg);
	}
	if(@_) {
		my %arg = @_;
		while(my ($name, $value) = each %arg) {
			my $data = SDLx::Music::Data->new($name, $value);
			$self->{data}{$name}
		}
		return $self;
	}
	return $self->{data} ||= {};
}
sub data_for {
	my $self = shift;
	$self->data($_) for @_;
	return $self;
}
sub has_data {
	my $self = shift;
	if(@_ == 1)  {
		my ($arg) = @_;
		return exists ${{ reverse %{$self->data} }}{$arg} && $arg if eval { $arg->isa('SDLx::Music::Data') };
		return $self->data->{$arg};
	}
	unless(@_) {
		return scalar keys %{$self->data};
	}
	return;
}

sub default {
	my $self = shift;
	my $default = ref $self ? $self->{default} : $_Default;
	return $default->params(@_) if @_;
	return $default;
}

sub load {
	my $self = shift;
	if(ref $self) {
		if(@_) {
			_load_data(
				eval { $_->isa('SDLx::Music::Data') } ? $_ : $self->data($_)
			) for @_;
		}
		else {
			_load_data($_) for values %{$self->data};
		}
	}
	else {
		_load_data($_) for @_;
	}
	return $self;
}
sub _load_data {
	my ($data) = @_;
	unless($data->loaded) {
		my $file = $data->file;
		my $loaded = $SDLx::Music::Data::loaded{$file} || SDL::Mixer::Music::load_MUS($file);
		return $data->loaded($loaded) if $loaded;
		Carp::cluck("Couldn't SDL::Mixer::Music::load_MUS($file) for data name $name: ", SDL::get_error());
	}
}

sub unload {
	my $self = shift;
	if(!ref $self) {
		if(@_) {
			(
				eval { $_->isa('SDLx::Music::Data') } ? $_ : $self->data($_)
			)->loaded(undef) for @_;
		}
		else {
			$_->loaded(undef) for values %{$self->data};
		}
	}
	else {
		$_->loaded(undef) for @_;
	}
	return $self;
}

sub clear {
	my $self = shift;
	if(@_) {
		delete $self->data->{$_} for @_;
	}
	else {
		delete $self->{data};
	}
	return $self;
}

sub play {
	my $self = shift;
	if(@_) {
		my ($arg, %params);
		my $data = !ref $self || eval { $arg->isa('SDLx::Music::Data') } ? $arg : $self->data($arg);
		SDLx::Music->load($data);
		my $fade_in = (defined $params{fade_in} ? $params{fade_in} : $data->fade_in) / 1000;
		my $loops   = (defined $params{loops}   ? $params{loops}   : $data->loops) || -1;
		if(
			defined $fade_in
				? SDL::Mixer::Music::fade_in_music($data->loaded, $loops, $fade_in)
				: SDL::Mixer::Music::play_music($data->loaded, $loops)
		) {
			Carp::cluck("Couldn't play $name: ", SDL::get_error());
		}
		else {
			$_Last_Played = $data;
			SDLx::Music->vol($data, $params{vol}, $params{vol_portion});
			SDLx::Music->pos($data, $params{pos});
			#TODO: finished callback
		}
	}
	else {
		SDL::Mixer::Music::resume_music();
	}
	return $self;
}
sub pause {
	my ($self) = @_;
	SDL::Mixer::Music::pause_music();
	return $self;
}
sub stop {
	my ($self) = @_;
	SDL::Mixer::Music::halt_music();
	return $self;
}

sub last_played {
	return $_Last_Played;
}
sub playing {
	return SDL::Mixer::Music::playing() ? SDLx::Music->last_played : ();
}
sub paused {
	return SDL::Mixer::Music::paused()  ? SDLx::Music->last_played : ();
}

sub fade_out {
	my ($self, $arg, $fade_out) = @_;
		SDL::Mixer::Music::fade_out($fade_out * 1000)
	if defined $fade_out
	or defined($fade_out = eval { $arg->isa('SDLx::Music::Data') } ? $arg->fade_out : $arg);
	return $self;
}
sub fading {
	my $fading = SDL::Mixer::Music::fading_music();
	return
		$fading == SDL::Mixer::MIX_NO_FADING  ?  0 :
		$fading == SDL::Mixer::MIX_FADING_IN  ? -1 :
#		$fading == SDL::Mixer::MIX_FADING_OUT ?  1 :
		                                         1
	;
}

sub vol {
	my $self = shift;
	if(@_) {
		my ($arg, $vol, $vol_portion) = @_;
		if(defined $vol) {
			if(defined $vol_portion) {
				SDL::Mixer::Music::volume_music($vol * $vol_portion);
			}
			else {
				$vol *= $arg->vol_portion if eval { $arg->isa('SDLx::Music::Data') } and defined $arg->
			}
		}
		else {
			$arg = eval { $arg->isa('SDlx::Music::Data') } ? $arg->fade_out : $arg;
			SDL::Mixer::Music::fade_out($arg * 1000) if defined $arg;
		}
		return $self;
	}
	return SDL::Mixer::Music::volume_music(-1);
}

sub pos {
	my ($self, $arg, $pos) = @_;
		SDL::Mixer::Music::set_music_position($pos)
	if defined $pos
	or defined($pos = eval { $arg->isa('SDLx::Music::Data') } ? $arg->pos : $arg);
	return $self;
}
sub rewind {
	my ($self) = @_;
	SDL::Mixer::Music::rewind_music();
	return $self;
}

# TODO: (maybe)
	# SDL::Mixer::Music::hook_music( $callback, $position );
	# my $position = SDL::Mixer::Music::get_music_hook_data();

1;
