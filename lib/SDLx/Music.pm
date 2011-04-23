package SDLx::Music;
use strict;
use warnings;
use Carp ();
use SDL;
use SDL::Audio;
use SDL::Mixer;
use SDL::Mixer::Music;
use SDL::Mixer::Channels;
use SDL::Mixer::Samples;
use SDL::Mixer::MixChunk;

use Data::Dumper;  
use SDLx::Music::Default;
use SDLx::Music::Data;

our $def = bless ({}, "SDLx::Music::Default");

sub new {
	my $class  = shift;
	my %params = @_;

	my $self = bless {%params}, $class;

# Initialize Audio
	$self->{freq}      = $self->{freq}      || 44100;
	$self->{format}    = $self->{format}    || SDL::Audio::AUDIO_S16SYS;
	$self->{channels}  = $self->{channels}  || 2;
	$self->{chunksize} = $self->{chunksize} || 4096;

	Carp::croak SDL::get_error()
		if (
				SDL::Mixer::open_audio(
					$self->{freq},     $self->{format},
					$self->{channels}, $self->{chunksize}
					)
		   ) != 0;

#Set up the default

	$self->{default} = bless {}, "SDLx::Music::Default";

	return $self;
}

sub data {
	my $self = shift;
	return if $#_ < 0;
	return  $self->{data}->{$_[0]} if $#_ == 0;

	my %data = @_;
# loop through keys
	foreach ( keys %data ) {
		my $datum = $data{$_};

#If SCALAR is Simple
		if ( defined $datum ) {
			my $d = {};
			if ( ref $datum eq 'HASH' ) {
				$d = $datum;
				$d->{_content} =
					SDL::Mixer::Music::load_MUS( $datum->{file} );
			}
			else {
				$d->{_content} =
					SDL::Mixer::Music::load_MUS($datum);
			}

			$self->{data}->{$_}  = bless($d, "SDLx::Music::Data");

		}

	}

	return 1;
}

sub clear {
	delete $_[0]->{data};

}

sub default :lvalue {
	my $self = shift;
	if   ( defined $self && ref($self) ) { return $self->{default} }
	else                                 { return $SDLx::Music::def; }

}


1;

