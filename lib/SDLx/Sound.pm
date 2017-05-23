package SDLx::Sound;

use strict;
use warnings;
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
	_initAudio() unless $audioInited; # only once per module load
	$self->{supported} = _initMixer();
	return $self;
}

sub _initAudio {
    SDL::Mixer::open_audio( 44100, AUDIO_S16SYS, 2, 4096 );
    my ($status, $freq, $format, $channels) = @{ SDL::Mixer::query_spec() };
    $audioInited = 1 if $status == 1;
    return ($status, $freq, $format, $channels); # being passed back to $self
}

sub _initMixer {
    my $init_flags = SDL::Mixer::init( MIX_INIT_MP3 | MIX_INIT_MOD | MIX_INIT_FLAC | MIX_INIT_OGG );	  
 
    my %init = ();

	# Short circuit if we have and older version of SDL_Mixer
	return \%init unless $init_flags;

     $init{ mp3 }  = 1  if $init_flags & MIX_INIT_MP3;
     $init{ mod }  = 1  if $init_flags & MIX_INIT_MOD;
     $init{ flac } = 1  if $init_flags & MIX_INIT_FLAC;
     $init{ ogg }  = 1  if $init_flags & MIX_INIT_OGG;

     return \%init
}

sub load {
	my $self = shift;
	$self->{files} = { @_ }; # user passes key/value pairs

	for my $name (keys %{ $self->{files} }){
		my $obj = {};
		# allow user to pass hash-refs
		unless( ref($self->{files}->{$name}) ){
			# print "load: preparing sound object: $name \n";
			$obj = {
				file	=> $self->{files}->{$name},
				volume	=> 100,
				loops	=> 1,
			};
			$self->{files}->{$name} = $obj;


		}

		if (-e $obj->{file}){
			$obj->{load_ref} = SDL::Mixer::Music::load_MUS($obj->{file}) or Carp::croak "Sound file $obj->{file} not found: " . SDL::get_error();
			$obj->{is_loaded} = 1;
		}else{
			carp("Sound file ".$obj->{file}." not found\n");
			next;
		}
	}

}

sub unload {
    my $self = shift;
     $self->{files} = {};
}

sub play {
	my $self = shift;
#	$self->{files} = {@_} if $#_ > 0 &&  @_;

	my ($name, %override) = @_;

	my $obj;
	if($name){
		unless( exists($self->{files}->{$name}) && $self->{files}->{$name}->{is_loaded} ){
			carp("Sound file with name $name not loaded, autoload with name = path (which is $name) \n");

			$self->load( $name => $name );
		}
		$obj = $self->{files}->{$name};
	}else{
		# if user calls play() do something
		($name, $obj) = each %{ $self->{files} };

		unless( $name ){
			carp("No sound file loaded, either call load() first or pass a file-path to play()\n");
			return 0;
		}
	}

	## execute play
	SDL::Mixer::Music::volume_music( (defined($override{volume}) ? $override{volume} : $obj->{volume}) );

	if(	SDL::Mixer::Music::play_music(
			$obj->{load_ref},
			( defined($override{loops}) ? $override{loops} : $obj->{loops} )
		) < 0
	){
		carp("Error calling play_music: ". SDL::get_error()."\n");
		return 0;
	}

	return 1;
}

sub playing {
	return SDL::Mixer::Music::playing_music();
}
sub is_playing {
	return SDL::Mixer::Music::playing_music();
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

sub loud {
}

sub fade {
}

1; # End of SDLx::Sound
