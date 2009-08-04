#!/usr/bin/env perl

use SDL;
use Carp;

croak "Could not initialize SDL: ", SDL::GetError()
	if ( 0 > SDL::Init(SDL_INIT_AUDIO()));

$ARGV[0] ||= 'data/sample.wav';

croak "usage: $0 [wavefile]\n"
	if ( in $ARGV[0], qw/ -h --help -? /);

my ($wav_spec,$wav_buffer,$wav_len,$wav_pos) = (0,0,0,0);

my $done = 0;

$fillerup  = sub {
	my ($data,$len) = @_;

	$wav_ptr = $wav_buffer + $wav_pos;
	$wav_remainder = $wav_len - $wav_pos;

	while ( $wav_remainder <= $len ) {
		SDL::MixAudio($data,$wav_ptr,$wav_remainder,SDL_MIX_MAXVOLUME);
		$data += $wav_remainder;
		$len -= $wav_remainder;
		$wav_ptr = $wav_buffer;	
		$wav_remainder = $wav_len;
		$wav_pos = 0;
	}
	SDL::MixAudio($data,$wav_ptr,$len,SDL_MIX_MAXVOLUME);
	$wav_pos += $len;
};

$poked = sub {
	$done = 1;
};

$SIG{HUP} = $poked;
$SIG{INT} = $poked;
$SIG{QUIT} = $poked;
$SIG{TERM} = $poked;

$spec = SDL::NewAudioSpec(44100,AUDIO_S16,2,4096);

$wave = SDL::LoadWAV($ARGV[0],$spec);

($wav_spec,$wav_buffer,$wav_len) = @$wave;

croak "Could not load wav file $ARGV[0], ", SDL::GetError(), "\n" unless ( $wav_len );

croak "Could not open audio ", SDL::GetError()
	if (0 > SDL::OpenAudio($wav_spec,$fillerup));

SDL::PauseAudio(0);

print "Using audio driver: ", SDL::AudioDriverName(), "\n";
	
while (! $done && ( SDL::GetAudioStatus() == SDL_AUDIO_PLAYING())) {
	SDL::Delay(1000);
}


