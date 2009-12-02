#!perl
use strict;
use warnings;
use SDL;
use SDL::Config;
use SDL::Mixer::MixChunk;
use Test::More;

use lib 't/lib';

use SDL::TestTool;

if (! SDL::TestTool->init(SDL_INIT_AUDIO) ) {
    plan( skip_all => 'Failed to init sound' );
}
elsif( !SDL::Config->has('SDL_mixer') )
{
    plan( skip_all => 'SDL_mixer support not compiled' );
}
else
{
    plan( tests => 6 );
}


is( SDL::MixOpenAudio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 ),
    0, 'MixOpenAudio passed' );

my $mix_chunk = SDL::MixLoadWAV('test/data/sample.wav');
isa_ok( $mix_chunk, 'SDL::Mixer::MixChunk' );

is( $mix_chunk->volume, 128, 'Default volume is 128' );
$mix_chunk->volume(100);
is( $mix_chunk->volume, 100, 'Can change volume to 100' );

is( $mix_chunk->alen, 1926848, 'Alen is 1926848' );

SDL::MixPlayChannel( -1, $mix_chunk, 0 );

# we close straight away so no audio is actually played

SDL::MixCloseAudio;

ok( 1, 'Got to the end' );
SDL::quit;
sleep(2);
