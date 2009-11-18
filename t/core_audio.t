#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Audio;
use SDL::AudioSpec;
use Test::More;
use Devel::Peek;

use lib 't/lib';
use SDL::TestTool;

if ( SDL::TestTool->init_audio ) {
    plan( skip_all => 'Failed to init sound' );
} else {
    plan( tests => 17 );
}
my @done = qw/
    audio_spec
    open_audio
    pause_audio
    close_audio
    get_audio_status
    lock_audio
    unlock_audio
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

is( SDL::Audio::get_audio_status, SDL_AUDIO_STOPPED,
    '[get_audio_status stopped]' );

my $obtained = SDL::AudioSpec->new;
is( SDL::Audio::open_audio( $desired, $obtained ),
    0, '[open_audio returned success]' );
isa_ok( $obtained, 'SDL::AudioSpec', 'Created a new AudioSpec' );

is( SDL::Audio::get_audio_status, SDL_AUDIO_PAUSED,
    '[get_audio_status paused]' );

SDL::Audio::pause_audio(0);

is( SDL::Audio::get_audio_status, SDL_AUDIO_PLAYING,
    '[get_audio_status playing]' );

SDL::Audio::lock_audio();
SDL::Audio::unlock_audio();

SDL::Audio::close_audio();

is( SDL::Audio::get_audio_status, SDL_AUDIO_STOPPED,
    '[get_audio_status stopped]' );



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


