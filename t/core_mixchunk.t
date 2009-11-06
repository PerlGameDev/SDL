#!perl
use strict;
use warnings;
use SDL;
use SDL::MixChunk;
use Test::More tests => 6;

is( SDL::init(SDL_INIT_AUDIO), 0, '[init] returns 0 on success' );

is( SDL::MixOpenAudio(
        SDL::MIX_DEFAULT_FREQUENCY(), SDL::MIX_DEFAULT_FORMAT(),
        SDL::MIX_DEFAULT_CHANNELS(),  4096
    ),
    0,
    'MixOpenAudio passed'
);

my $mix_chunk = SDL::MixLoadWAV('test/data/sample.wav');
isa_ok( $mix_chunk, 'SDL::MixChunk' );

is( $mix_chunk->volume, 128, 'Default volume is 128' );
$mix_chunk->volume(100);
is( $mix_chunk->volume, 100, 'Can change volume to 100' );

is( $mix_chunk->alen, 963424, 'Alen is 963424' );
