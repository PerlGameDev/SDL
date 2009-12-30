#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Audio;
use SDL::AudioSpec;
use Test::More;


use lib 't/lib';
use SDL::TestTool;

if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
    plan( skip_all => 'Failed to init sound' );
} else {
    plan( tests => 1);
}
my $obtained = SDL::AudioSpec->new;   
my $desired = SDL::AudioSpec->new;
   $desired->freq(44100);
   $desired->format(SDL::Constants::AUDIO_S8);
   $desired->channels(1);
   $desired->samples(4096);
   $desired->callback('main::callback');
my $pass = 0;
  
  sub callback
  {
   my ($int_size, $len, $stream) = @_;

   $pass = 1 if $pass == 0;
   #foreach(0..$len)
   #{
#	my $new = rand()*120;
# 	substr($stream, $_*$int_size, $int_size, pack('i', $new));

 #  } 
 #pack needs to be fixed

  }
   
   die 'AudioMixer, Unable to open audio: '. SDL::get_error() if( SDL::Audio::open($desired, $obtained) <0 );
   
   
   SDL::Audio::pause(0);

	sleep(1);

   SDL::Audio::close();

   is $pass, 1,  '[callback] tested';


