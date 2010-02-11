#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;

BEGIN
{
	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

	if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
	    plan( skip_all => 'Failed to init sound' );
	}
	elsif( !SDL::Config->has('SDL_mixer') )
	{
	    plan( skip_all => 'SDL_mixer support not compiled' );
	}
} #SDL_init(SDL_INIT_AUDIO) + Version bootstrap conflict prevention in windows
#
# To reproduce this bug do 
#
# use SDL; use SDL::Version; SDL::init(SDL_INIT_AUDIO);
#
use SDL::Mixer;
use SDL::Mixer::MixChunk;
use SDL::Mixer::Samples;
use SDL::Version;

my @done = qw/
get_num_chunk_decoders
get_chunk_decoder
load_WAV
volume_chunk
/;

my @left =qw/
loadwav_rw
quickload_wav
quickload_raw
freechunk 
/	
;


SDL::Mixer::open_audio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 );

my $version =  SDL::Mixer::linked_version();

diag 'got version :'.$version->major.'.'.$version->minor.'.'.$version->patch;

SKIP:
{
 skip  'Need version 1.2.10', 2 unless ( $version->major > 1 || $version->minor > 2 || $version->patch >= 10);
 
 is(SDL::Mixer::Samples::get_num_chunk_decoders() >= 0, 1 , '[get_num_chunk_decoders] passed');

 my $stream = SDL::Mixer::Samples::get_chunk_decoder(0);

 is( defined $stream, 1, '[get_chunk_decoder] found decoder '.$stream);

}

my $sample_chunk = SDL::Mixer::Samples::load_WAV('test/data/sample.wav');
 isa_ok( $sample_chunk,  'SDL::Mixer::MixChunk', '[load_WAV] Can Load a wav file to MixChunk');

 is (SDL::Mixer::Samples::volume_chunk($sample_chunk, 120), 128 ,'[volume_chunk] was at max 128 volume on start');
 is (SDL::Mixer::Samples::volume_chunk($sample_chunk, 10), 120 ,'[volume_chunk] is now at 120 volume');




my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    fail "Not Implmented SDL::Mixer::*::$_" foreach(@left)
    
}
diag $why;
pass 'Checking for segfaults';
done_testing();
