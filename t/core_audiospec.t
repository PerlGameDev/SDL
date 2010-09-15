#!/usr/bin/perl -w
BEGIN { # http://wiki.cpantesters.org/wiki/CPANAuthorNotes
	use Config;
	if ( !$Config{'useithreads'} ) {
		print("1..0 # Skip: Perl not compiled with 'useithreads'\n");
		exit(0);
	}
}
use strict;
use threads;
use threads::shared;
use SDL;
use SDL::Audio;
use SDL::AudioSpec;
use Test::More;
use Devel::Peek;
use Config;

use lib 't/lib';
use SDL::TestTool;

plan( skip_all => "author tests not required for installation" )
	unless ( $ENV{AUTOMATED_TESTING} or $ENV{SDL_RELEASE_TESTING} );

my $audiodriver = $ENV{SDL_AUDIODRIVER};
$ENV{SDL_AUDIODRIVER} = 'dummy'; # unless $ENV{SDL_RELEASE_TESTING};

plan( skip_all => 'Failed to init sound' )
	unless SDL::TestTool->init(SDL_INIT_AUDIO);

my $obtained   = SDL::AudioSpec->new;
my $p : shared = 0;
my $f : shared = 0;

my $desired = SDL::AudioSpec->new;
$desired->freq(44100);
$desired->format(AUDIO_S8);
$desired->channels(1);
$desired->samples(4096);
$desired->callback('main::callback');

sub callback {
	my ( $int_size, $len, $streamref ) = @_;
	my $chr = chr(0);
	$chr = chr($p) if $p; #Windows is delaying the thread update for some reason
	for ( my $i = 0; $i < $len; $i++ ) {
		use bytes;
		substr( $$streamref, $i, 1, $chr );

		if ( $f && $p++ > 200 ) {
			$f = 0;
		} elsif ( !$f && $p-- < 0 ) {
			$f = 1;
		}
	}
	isnt $p, 0, '[callback] tested $p = ' . $p;

}
die 'AudioMixer, Unable to open audio: ' . SDL::get_error()
	if ( SDL::Audio::open( $desired, $obtained ) < 0 );

SDL::Audio::pause(0);

sleep(1);

SDL::Audio::close();

if ($audiodriver) {
	$ENV{SDL_AUDIODRIVER} = $audiodriver;
} else {
	delete $ENV{SDL_AUDIODRIVER};
}



done_testing();


