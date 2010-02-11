#!/usr/bin/perl -w
use strict;
use threads;
use threads::shared;
use SDL;
use SDL::Audio;
use SDL::AudioSpec;
use Test::More;
use Devel::Peek;

use lib 't/lib';
use SDL::TestTool;

unless ( $ENV{AUTOMATED_TESTING} or $ENV{RELEASE_TESTING} ) {
	plan( skip_all => "author tests not required for installation" );
}


if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
    plan( skip_all => 'Failed to init sound' );
}
else {
    plan( tests => 1);
}
my $obtained = SDL::AudioSpec->new;   
my $p :shared = 0;
my $f :shared = 0;

my $desired = SDL::AudioSpec->new;
   $desired->freq(44100);
   $desired->format(SDL::Constants::AUDIO_S8);
   $desired->channels(1);
   $desired->samples(4096);
   $desired->callback('main::callback');

sub callback{
  my ($int_size, $len, $streamref) = @_;

  for (my $i = 0; $i < $len; $i++) {
    use bytes;
    substr($$streamref, $i, 1, chr($p));

    if ($f && $p++ > 200) {
      $f = 0;
    } elsif (!$f && $p-- < 0) {
      $f = 1;
    }
  }


}   die 'AudioMixer, Unable to open audio: '. SDL::get_error() if( SDL::Audio::open($desired, $obtained) <0 );
   
   
   SDL::Audio::pause(0);

	sleep(1);

   SDL::Audio::close();

   isnt $p, 0,  '[callback] tested ';


