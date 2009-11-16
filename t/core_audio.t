#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Constants;
use SDL::Audio;
use SDL::AudioSpec;
use Test::More;

my @done = qw/
    audio_spec
    open_audio
    pause_audio
    close_audio
    get_audio_status
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
isa_ok( $obtained, 'SDL::AudioSpec' );

is( SDL::Audio::get_audio_status, SDL_AUDIO_PAUSED,
    '[get_audio_status paused]' );

SDL::Audio::pause_audio(0);

is( SDL::Audio::get_audio_status, SDL_AUDIO_PLAYING,
    '[get_audio_status playing]' );

SDL::Audio::close_audio();

is( SDL::Audio::get_audio_status, SDL_AUDIO_STOPPED,
    '[get_audio_status stopped]' );

my @left = qw/
    load_wav
    free_wav
    audio_cvt
    build_audio_cvt
    convert_audio
    mix_audio
    lock_audio
    unlock_audio
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

done_testing;
