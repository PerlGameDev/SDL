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
  $self->{supported} = _initMixer();
  return $self;
}

sub _initAudio {
    SDL::Mixer::open_audio( 44100, AUDIO_S16SYS, 2, 4096 );
    my ($status, $freq, $format, $channels) = @{ SDL::Mixer::query_spec() };
    $audioInited = 1 if $status == 1;
    return ($status, $freq, $format, $channels); #TODO: Save this information in $self;
}

sub _initMixer {
    my $init_flags = SDL::Mixer::init( MIX_INIT_MP3 | MIX_INIT_MOD | MIX_INIT_FLAC | MIX_INIT_OGG );	  
 
    my %init = ();

	# Short circuit if we have and older version of SDL_Mixer
	return \%$init unless $init_flags;

     $init{ mp3 }  = 1  if $init_flags & MIX_INIT_MP3;
     $init{ mod }  = 1  if $init_flags & MIX_INIT_MOD;
     $init{ flac } = 1  if $init_flags & MIX_INIT_FLAC;
     $init{ ogg }  = 1  if $init_flags & MIX_INIT_OGG;

     return \%$init
}

sub load {
    my $self = shift;
     $self->{files} = {@_};
}

sub unload {
    my $self = shift;
     $self->{files} = {};
}

sub play {
    my $self = shift;
    $self->{files} = {@_} if $#_ > 0 &&  @_;
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
       carp("No newline ".$self->{files}."\n".$_[0]."\n");
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
