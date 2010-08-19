package SDLx::Sound;

use Carp;

use SDL;
#use SDL::Audio;
#use SDL::AudioSpec;
use SDL::Mixer;
use SDL::Mixer::Music;
#use SDL::Mixer::Channels;
#use SDL::Mixer::Samples;
#use SDL::Mixer::MixChunk;

# SDL::Mixer must be inited only one time
my $audioInited = undef;

sub new {
  my $class = shift;
  my $self = {@_};
  bless ($self, $class);
  _initAudio() unless $audio_ok;
  _initMixer();
  return $self;
}

sub _initAudio {
    SDL::Mixer::open_audio( 44100, AUDIO_S16SYS, 2, 4096 );
    my ($status, $freq, $format, $channels) = @{ SDL::Mixer::query_spec() };

    #Carp::carp ' Asked for freq, format, channels ' . join( ' ', ( 44100, AUDIO_S16SYS, 2,) );
    #Carp::carp  ' Got back status,  freq, format, channels ' . join( ' ', ( $status, $freq, $format, $channels ) );

    $audioInited = 1 if $status == 1;
}

sub _initMixer {
    my $init_flags = SDL::Mixer::init( MIX_INIT_MP3 | MIX_INIT_MOD | MIX_INIT_FLAC | MIX_INIT_OGG );
    
    #print("We have MP3 support!\n")  if $init_flags & MIX_INIT_MP3;
    #print("We have MOD support!\n")  if $init_flags & MIX_INIT_MOD;
    #print("We have FLAC support!\n") if $init_flags & MIX_INIT_FLAC;
    #print("We have OGG support!\n")  if $init_flags & MIX_INIT_OGG;
}

sub load {
    my $self = shift;
    my $self->{files} = {@_};
}

sub unload {
    my $self = shift;
    my $self->{files} = {};
}

sub play {
    my $self = shift;
    $self->{files} = {@_} if @_;
    my $play = 1;
    if (-e $_[0]) {
       my $music = SDL::Mixer::Music::load_MUS($_[0])
           or Carp::croak 'Sound file not found: ' . SDL::get_error();
       SDL::Mixer::Music::volume_music(85);
       if (SDL::Mixer::Music::play_music($music, -1)<0) {
           print("Can't play!\n". SDL::get_error()."\n");
           $play = 0;
       }
    } else {
       carp("bacapibungundum! WHAT? ".$self->{files}."\n".$_[0]."\n");
       $play = 0;
    }
    return $play;
}

sub loud {
}

sub pause {
    my $self = shift;
    SDL::Mixer::Music::pause_music();
 
}

sub resume {
    my $self = shift;
    SDL::Mixer::Music::resume_music();
 
}


sub stop {
    my $self = shift;
    SDL::Mixer::Music::halt_music();
    #SDL::Mixer::quit();
}

sub fade {
}



1; # End of SDLx::Sound
