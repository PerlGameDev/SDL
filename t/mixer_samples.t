#!/usr/bin/perl -w
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
	}
} #SDL_init(SDL_INIT_AUDIO) + Version bootstrap conflict prevention in windows

#
# To reproduce this bug do
#
# use SDL; use SDL::Version; SDL::init(SDL_INIT_AUDIO);

use SDL::Mixer;
use SDL::Mixer::MixChunk;
use SDL::Mixer::Samples;
use SDL::Mixer::Channels;
use SDL::RWOps;
use SDL::Version;

my @done = qw/
	get_num_chunk_decoders
	get_chunk_decoder
	load_WAV
	volume_chunk
	load_WAV_RW
	/;

my @left = qw/
	quick_load_WAV
	quick_load_RAW
	/;

my $can_open = SDL::Mixer::open_audio( 44100, SDL::Audio::AUDIO_S16SYS, 2, 4096 );

unless ( $can_open == 0 ) {
	plan( skip_all => 'Cannot open audio :' . SDL::get_error() );
}
my $version = SDL::Mixer::linked_version();
printf(
	"got version: %d.%d.%d\n",
	$version->major, $version->minor, $version->patch
);

SKIP:
{
	skip 'Need version 1.2.10', 2 if $version < 1.2.10;

	is( SDL::Mixer::Samples::get_num_chunk_decoders() >= 0,
		1, '[get_num_chunk_decoders] passed'
	);
	my $stream = SDL::Mixer::Samples::get_chunk_decoder(0);
	is( defined $stream, 1, "[get_chunk_decoder] found decoder $stream" );
}

my $sample_chunk = SDL::Mixer::Samples::load_WAV('test/data/sample.wav');
isa_ok( $sample_chunk, 'SDL::Mixer::MixChunk', '[load_WAV]' );

is( SDL::Mixer::Samples::volume_chunk( $sample_chunk, 120 ),
	128, '[volume_chunk] was at max 128 volume on start'
);
is( SDL::Mixer::Samples::volume_chunk( $sample_chunk, 10 ),
	120, '[volume_chunk] is now at 120 volume'
);

my $file = SDL::RWOps->new_file( 'test/data/sample.wav', 'r' );
isa_ok( $file, 'SDL::RWOps', '[new_file]' );
isa_ok(
	SDL::Mixer::Samples::load_WAV_RW( $file, 0 ),
	'SDL::Mixer::MixChunk', '[load_WAV_RW]'
);

my $why =
	  '[Percentage Completion] '
	. int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
	. "\% implementation. "
	. ( $#done + 1 ) . " / "
	. ( $#done + $#left + 2 );

TODO:
{
	local $TODO = $why;
	fail "Not Implmented SDL::Mixer::*::$_" foreach (@left);
}

print "$why\n";

pass 'Checking for segfaults';

if ($audiodriver) {
	$ENV{SDL_AUDIODRIVER} = $audiodriver;
} else {
	delete $ENV{SDL_AUDIODRIVER};
}

done_testing();
