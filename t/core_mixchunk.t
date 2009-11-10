#!perl
use strict;
use warnings;
use SDL;
use SDL::Mixer::MixChunk;
use Test::More;
use File::Spec;

sub test_audio
{
	my $devnull = File::Spec->devnull();
	`perl -e  "use lib '../'; use SDL; SDL::init(SDL_INIT_AUDIO)" 2>$devnull`;
	return ($? >> 8 );
}

if ( test_audio != 1)
{
    plan ( skip_all => 'Failed to init sound' );
}
else {
    SDL::init(SDL_INIT_AUDIO);
    plan( tests => 3 );
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
