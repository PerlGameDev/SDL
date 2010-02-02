#!perl
use strict;
use warnings;
use SDL;
use SDL::Config;
use SDL::Version;
use SDL::Mixer;
use SDL::Mixer::Samples;
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
    plan( tests => 3 );
}


SDL::Mixer::open_audio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 );

my $version =  SDL::Mixer::linked_version();


SKIP:
{
 skip  'Need version 1.2.10', 2 unless ( $version->major > 1 || $version->minor > 2 || $version->patch >= 10);
 
 is(SDL::Mixer::Samples::get_num_chunk_decoders() >= 0, 1 , '[get_num_chunk_decoders] passed');

 my $stream = SDL::Mixer::Samples::get_chunk_decoder(0);

 is( defined $stream, 1, '[get_chunk_decoder] found decoder '.$stream);

}

pass 'Checking for segfaults';


