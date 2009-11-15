#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::AudioSpec;
use Test::More;

my @done = qw/
    audio_spec
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

my @left = qw/
    open_audio
    pause_audio
    get_audio_status
    load_wav
    free_wav
    audio_cvt
    build_audio_cvt
    convert_audio
    mix_audio
    lock_audio
    unlock_audio
    close_audio
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
