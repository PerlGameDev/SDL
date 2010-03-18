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
use SDL::Version;

my $v = SDL::Mixer::linked_version();

isa_ok($v, 'SDL::Version', '[linked_version]');
diag sprintf("got version: %d.%d.%d", $v->major, $v->minor, $v->patch);

SKIP:
{
	skip ( 'Version 1.2.10 needed' , 1) unless ( $v->major >= 1 && $v->minor >= 2 && $v->patch >= 10); 
	my @flags = (MIX_INIT_MP3, MIX_INIT_MOD, MIX_INIT_FLAC, MIX_INIT_OGG);
	my @names = qw/MP3 MOD FLAC OGG/;
	foreach (0...3)
	{
		my $f = $flags[$_];
		my $n = $names[$_];
		( SDL::Mixer::init($f) != $f) ? diag "Tried to init $n". SDL::get_error() : diag "You have $n support"; 
		pass 'Init ran';
	}
}

is( SDL::Mixer::open_audio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 ), 0, '[open_audio] ran');

my $data = SDL::Mixer::query_spec();

my( $status, $freq, $format, $chan ) = @{$data};

isnt ($status, 0, '[query_spec] ran' );
isnt ($freq,   0, '[query_spec] got frequency '. $freq );
isnt ($format, 0, '[query_spec] got format ');
isnt ($chan,   0, '[query_spec] got channels '.$chan);

SDL::Mixer::close_audio(); pass '[close_audio]  ran';

SKIP:
{
	skip ( 'Version 1.2.10 needed' , 1) unless ( $v->major >= 1 && $v->minor >= 2 && $v->patch >= 10); 
	SDL::Mixer::quit(); pass '[quit] ran';
}

done_testing();
