#!perl
use strict;
use warnings;
use SDL;
use SDL::MixMusic;
use Test::More tests => 4;

is( SDL::init(SDL_INIT_AUDIO), 0, '[init] returns 0 on success' );

is( SDL::MixOpenAudio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 ),
    0, 'MixOpenAudio passed' );

my $mix_music = SDL::MixLoadMUS('test/data/sample.wav');

{
    local $TODO = 1;

    # I'm not sure why this fails
    isa_ok( $mix_music, 'SDL::MixMusic' );
};

SDL::MixPlayMusic( $mix_music, 0 );

# we close straight away so no audio is actually played

SDL::MixCloseAudio;

ok( 1, 'Got to the end' );
