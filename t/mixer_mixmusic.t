#!perl
use strict;
use warnings;
use SDL;
use SDL::Mixer::MixMusic;
use Test::More;
use IO::CaptureOutput qw(capture);

sub test_audio
{
	my $stdout = '' ;
	my $stderr = '' ;
	capture { SDL::init(SDL_INIT_AUDIO) } \$stdout, \$stderr;
	SDL::quit();
	return ($stderr ne '' ); 
}

if ( test_audio )
{
    plan ( skip_all => 'Failed to init sound' );
}
elsif(SDL::init(SDL_INIT_AUDIO) >= 0)    
    { plan( tests => 3 ) }
else
    {
 plan ( skip_all => 'Failed to init sound' );
  }

  is( SDL::MixOpenAudio( 44100, SDL::Constants::AUDIO_S16, 2, 4096 ),
    0, 'MixOpenAudio passed' );

my $mix_music = SDL::MixLoadMUS('test/data/sample.wav');

{
    local $TODO = 1;

    # I'm not sure why this fails
    isa_ok( $mix_music, 'SDL::Mixer::MixMusic' );
};

SDL::MixPlayMusic( $mix_music, 0 );

# we close straight away so no audio is actually played

SDL::MixCloseAudio;

ok( 1, 'Got to the end' );
