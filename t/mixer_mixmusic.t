use strict;
use warnings;
use SDL;
use SDL::Config;

my $audiodriver;

BEGIN {
	use Config;
	if ( !$Config{'useithreads'} ) {
		print("1..0 # Skip: Perl not compiled with 'useithreads'\n");
		exit(0);
	}

	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

	$audiodriver = $ENV{SDL_AUDIODRIVER};
	$ENV{SDL_AUDIODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

	if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
		plan( skip_all => 'Failed to init sound' );
	} elsif ( !SDL::Config->has('SDL_mixer') ) {
		plan( skip_all => 'SDL_mixer support not compiled' );
	} else {
		plan( tests => 6 );
	}
}

use_ok('SDL::Mixer');
use_ok('SDL::Mixer::Music');
use_ok('SDL::Mixer::MixMusic');

is( SDL::Mixer::open_audio( 44100, SDL::Audio::AUDIO_S16SYS, 2, 4096 ),
	0, 'open_audio passed'
);

my $mix_music = SDL::Mixer::Music::load_MUS('test/data/tribe_i.wav')
	; # from Matthew Newman, http://opengameart.org/content/vocal-grunts-tribeiwav

#warn 'Error:'. SDL::get_error() if (!$mix_music);

{

	# I'm not sure why this fails
	isa_ok( $mix_music, 'SDL::Mixer::MixMusic' );
};

SDL::Mixer::Music::play_music( $mix_music, 0 );

# we close straight away so no audio is actually played

SDL::Mixer::close_audio();

ok( 1, 'Got to the end' );

if ($audiodriver) {
	$ENV{SDL_AUDIODRIVER} = $audiodriver;
} else {
	delete $ENV{SDL_AUDIODRIVER};
}

sleep(2);
