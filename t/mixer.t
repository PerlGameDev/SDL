#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;

my $audiodriver;

BEGIN
{
	use Config;
	if (! $Config{'useithreads'}) {
		print("1..0 # Skip: Perl not compiled with 'useithreads'\n");
		exit(0);
	}

	use Test::More;
	use lib 't/lib';
	use SDL::TestTool;

    $audiodriver          = $ENV{SDL_AUDIODRIVER};
    $ENV{SDL_AUDIODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

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
printf("got version: %d.%d.%d\n", $v->major, $v->minor, $v->patch);

is( MIX_DEFAULT_CHANNELS, 2, 'MIX_DEFAULT_CHANNELS should be imported' );
is( MIX_DEFAULT_CHANNELS(), 2,'MIX_DEFAULT_CHANNELS() should also be available' );
is( MIX_DEFAULT_FORMAT, 32784, 'MIX_DEFAULT_FORMAT should be imported' );
is( MIX_DEFAULT_FORMAT(), 32784, 'MIX_DEFAULT_FORMAT() should also be available' );
is( MIX_DEFAULT_FREQUENCY, 22050, 'MIX_DEFAULT_FREQUENCY should be imported' );
is( MIX_DEFAULT_FREQUENCY(), 22050, 'MIX_DEFAULT_FREQUENCY() should also be available' );
is( MIX_FADING_IN,    2,   'MIX_FADING_IN should be imported' );
is( MIX_FADING_IN(),  2,   'MIX_FADING_IN() should also be available' );
is( MIX_FADING_OUT,   1,   'MIX_FADING_OUT should be imported' );
is( MIX_FADING_OUT(), 1,   'MIX_FADING_OUT() should also be available' );
is( MIX_MAX_VOLUME,   128, 'MIX_MAX_VOLUME should be imported' );
is( MIX_MAX_VOLUME(), 128, 'MIX_MAX_VOLUME() should also be available' );
is( MIX_NO_FADING,    0,   'MIX_NO_FADING should be imported' );
is( MIX_NO_FADING(),  0,   'MIX_NO_FADING() should also be available' );

SKIP:
{
	skip ( 'Version 1.2.10 needed' , 1) unless ( $v->major >= 1 && $v->minor >= 2 && $v->patch >= 10); 
	my @flags = (MIX_INIT_MP3, MIX_INIT_MOD, MIX_INIT_FLAC, MIX_INIT_OGG);
	my @names = qw/MP3 MOD FLAC OGG/;
	foreach (0...3)
	{
		my $f = $flags[$_];
		my $n = $names[$_];
		( SDL::Mixer::init($f) != $f) ? print "Tried to init $n". SDL::get_error() . "\n" : print "You have $n support\n"; 
		pass 'Init ran';
	}
}

is( SDL::Mixer::open_audio( 44100, SDL::Audio::AUDIO_S16SYS, 2, 4096 ), 0, '[open_audio] ran');

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

if($audiodriver)
{
	$ENV{SDL_AUDIODRIVER} = $audiodriver;
}
else
{
	delete $ENV{SDL_AUDIODRIVER};
}

done_testing();
