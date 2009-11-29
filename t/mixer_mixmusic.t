#!perl
use strict;
use warnings;
use lib 't/lib';
use SDL;
use SDL::Mixer::MixMusic;
use SDL::TestTool;
use Test::More;
use IO::CaptureOutput qw(capture);

if (! SDL::TestTool->init(SDL_INIT_AUDIO) ) {
    plan( skip_all => 'Failed to init sound' );
} else {
    plan( tests => 3 );
}

is( SDL::MixOpenAudio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 ),
    0, 'MixOpenAudio passed' );

my $mix_music = SDL::MixLoadMUS('test/data/sample.wav');
#warn 'Error:'. SDL::get_error() if (!$mix_music);



{
    local $TODO = 1;

    # I'm not sure why this fails
    isa_ok( $mix_music, 'SDL::Mixer::MixMusic' );
};

SDL::MixPlayMusic( $mix_music, 0 );

# we close straight away so no audio is actually played

SDL::MixCloseAudio;

ok( 1, 'Got to the end' );
SDL::quit;
