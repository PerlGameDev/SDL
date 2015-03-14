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

our $def = bless( {}, "SDLx::Music::Default" );

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
    return $self->{data}->{ $_[0] } if $#_ == 0;

    my %data = @_;

    # loop through keys
    foreach ( keys %data ) {
        my $datum = $data{$_};

        #If SCALAR is Simple
        if ( defined $datum ) {
            my $d = {};
            if ( ref $datum eq 'HASH' ) {
                $d = $datum;
            }
            else {
                $d->{file} = $datum;
            }

            my $play_data = bless( $d, "SDLx::Music::Data" );
            $play_data->{to_load} = 1;
            $self->{data}->{$_} = $play_data;
        }

    }

    return 1;
}

sub clear {
    delete $_[0]->{data};

}

sub default : lvalue {
    my $self = shift;
    if   ( defined $self && ref($self) ) { return $self->{default} }
    else                                 { return $SDLx::Music::def; }

}

sub play {
    my $self      = shift;
    my $play_data = shift;
    my %override  = @_;

    return unless defined $play_data;

    my $volume  = $play_data->{volume}  || $override{volume}  || 50;
    my $fade_in = $play_data->{fade_in} || $override{fade_in} || 0;
    my $loops   = $play_data->{loops}   || $override{loops}   || 1;

    if ( $play_data->{to_load} ) {

        $play_data->{_content} =
          SDL::Mixer::Music::load_MUS( $play_data->{file} );
        $play_data->{to_load} = 0;
    }

    SDL::Mixer::Music::volume_music($volume);

    unless ( SDL::Mixer::Music::playing_music() || $fade_in  ) {
        my $played =
          SDL::Mixer::Music::play_music( $play_data->{_content}, $loops );
        if ( defined $played && $played == -1 ) {
            Carp::carp "Cannot play: " . SDL::get_error() . "\n";
        }
    }
    else {
		my $played =  SDL::Mixer::Music::fade_in_music( $play_data->{_content}, $loops, $fade_in );
		 if ( defined $played && $played == -1 ) {
            Carp::carp "Cannot play: " . SDL::get_error() . "\n";
        }	
    }
    return SDL::Mixer::Music::playing_music();
}

sub load {
    my $self = shift;

    foreach ( keys( %{ $self->{data} } ) ) {
        my $data = $self->{data}->{$_};

        if ( $data->{to_load} ) {
            $data->{_content} = SDL::Mixer::Music::load_MUS( $data->{file} );
            $data->{to_load}  = 0;
        }

    }

}

sub playing {
    return SDL::Mixer::Music::playing_music();
}

1;

