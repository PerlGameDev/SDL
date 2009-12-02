#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Audio;
use SDL::AudioSpec;
use Test::More;
use Devel::Peek;

use lib 't/lib';
use SDL::TestTool;

if ( !SDL::TestTool->init(SDL_INIT_AUDIO) ) {
    plan( skip_all => 'Failed to init sound' );
} else {
    plan( tests => 17 );
}
my @done = qw/
    audio_spec
    open
    pause
    close
    get_status
    lock
    unlock
    /;


my $desired = SDL::AudioSpec->new;
   $desired->freq(44100);
is( $desired->freq, 44100, '[audiospec] can set freq' );
$desired->format(SDL::Constants::AUDIO_S16);
is( $desired->format, SDL::Constants::AUDIO_S16,
    '[audiospec] can set format' );
$desired->channels(2);
is( $desired->channels, 2, '[audiospec] can set channels' );
$desired->samples(4096);
is( $desired->samples, 4096, '[audiospec] can set samples' );

is( SDL::Audio::get_status, SDL_AUDIO_STOPPED, '[get_status stopped]' );

my $obtained = SDL::AudioSpec->new;
is( SDL::Audio::open( $desired, $obtained ),
    0, '[open returned success]' );
isa_ok( $obtained, 'SDL::AudioSpec', 'Created a new AudioSpec' );

is( SDL::Audio::get_status, SDL_AUDIO_PAUSED, '[get_status paused]' );

SDL::Audio::pause(0);

is( SDL::Audio::get_status, SDL_AUDIO_PLAYING, '[get_status playing]' );

SDL::Audio::lock();
SDL::Audio::unlock();

SDL::Audio::close();

is( SDL::Audio::get_status, SDL_AUDIO_STOPPED, '[get_status stopped]' );



    # I'm not sure why this does give us the correct params
    my $wav_ref =  SDL::Audio::load_wav( 'test/data/sample.wav', $obtained ); 
    #printf Dump  @wav_ref;

    isa_ok( $wav_ref, 'ARRAY', "Got and Array Out of load_wav. $wav_ref");
    my ( $wav_spec, $audio_buf, $audio_len ) = @{$wav_ref};
    isa_ok( $wav_spec,  'SDL::AudioSpec', '[load_wav] got Audio::Spec back out ');
    is( $audio_len, 481712, '[load_wav] length is correct' );
    SDL::Audio::free_wav($audio_buf);


my @left = qw/
    audio_cvt
    build_audio_cvt
    convert_audio
    mix_audio
    /;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    fail "Not Implmented $_" foreach (@left)

}
diag $why;
sleep(2);
