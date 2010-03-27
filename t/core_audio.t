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
    plan( tests => 45);
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

is( AUDIO_S16,      32784,  'AUDIO_S16 should be imported' );
is( AUDIO_S16(),    32784,  'AUDIO_S16() should also be available' );
is( AUDIO_S16MSB,   36880,  'AUDIO_S16MSB should be imported' );
is( AUDIO_S16MSB(), 36880,  'AUDIO_S16MSB() should also be available' );
is( AUDIO_S16LSB,   0x8010, 'AUDIO_S16MSB should be imported' );
is( AUDIO_S16LSB(), 0x8010, 'AUDIO_S16MSB() should also be available' );
is( AUDIO_S8,       32776,  'AUDIO_S8 should be imported' );
is( AUDIO_S8(),     32776,  'AUDIO_S8() should also be available' );
is( AUDIO_U16,      16,     'AUDIO_U16 should be imported' );
is( AUDIO_U16(),    16,     'AUDIO_U16() should also be available' );
is( AUDIO_U16MSB,   4112,   'AUDIO_U16MSB should be imported' );
is( AUDIO_U16MSB(), 4112,   'AUDIO_U16MSB() should also be available' );
is( AUDIO_U16LSB,   0x0010, 'AUDIO_U16MSB should be imported' );
is( AUDIO_U16LSB(), 0x0010, 'AUDIO_U16MSB() should also be available' );
is( AUDIO_U8,       8,      'AUDIO_U8 should be imported' );
is( AUDIO_U8(),     8,      'AUDIO_U8() should also be available' );
ok( (SDL::Audio::AUDIO_U16SYS   == AUDIO_U16LSB)   || (SDL::Audio::AUDIO_U16SYS   == AUDIO_U16MSB),     'AUDIO_U16SYS should be imported' );
ok( (SDL::Audio::AUDIO_U16SYS() == AUDIO_U16LSB()) || (SDL::Audio::AUDIO_U16SYS() == AUDIO_U16MSB()),   'AUDIO_U16SYS() should also be available' );

is( SDL_AUDIO_PAUSED,    2, 'SDL_AUDIO_PAUSED should be imported' );
is( SDL_AUDIO_PAUSED(),  2, 'SDL_AUDIO_PAUSED() should also be available' );
is( SDL_AUDIO_PLAYING,   1, 'SDL_AUDIO_PLAYING should be imported' );
is( SDL_AUDIO_PLAYING(), 1, 'SDL_AUDIO_PLAYING() should also be available' );
is( SDL_AUDIO_STOPPED,   0, 'SDL_AUDIO_STOPPED should be imported' );
is( SDL_AUDIO_STOPPED(), 0, 'SDL_AUDIO_STOPPED() should also be available' );

my $driver = SDL::Audio::audio_driver_name();
pass "[audio_driver_name] using audio driver $driver";

my $desired = SDL::AudioSpec->new;
   $desired->freq(44100);
is( $desired->freq, 44100, '[audiospec] can set freq' );
$desired->format(SDL::Audio::AUDIO_S16SYS);
is( $desired->format, SDL::Audio::AUDIO_S16SYS,
    '[audiospec] can set format' );
$desired->channels(2);
is( $desired->channels, 2, '[audiospec] can set channels' );
$desired->samples(4096);
is( $desired->samples, 4096, '[audiospec] can set samples' );
$desired->callback('main::audio_callback');

is( SDL::Audio::get_status, SDL_AUDIO_STOPPED, '[get_status stopped]' );

my $obtained = SDL::AudioSpec->new;
is( SDL::Audio::open( $desired, $obtained ),
    0, '[open returned success]' );
isa_ok( $obtained, 'SDL::AudioSpec', 'Created a new AudioSpec' );



    my $wav_ref =  SDL::Audio::load_wav( 'test/data/sample.wav', $obtained ); 
    isa_ok( $wav_ref, 'ARRAY', "Got and Array Out of load_wav. $wav_ref");
    my ( $wav_spec, $audio_buf, $audio_len ) = @{$wav_ref};
    isa_ok( $wav_spec,  'SDL::AudioSpec', '[load_wav] got Audio::Spec back out ');
    is( $audio_len, 481712, '[load_wav] length is correct' );
    SDL::Audio::free_wav($audio_buf);



is( SDL::Audio::get_status, SDL_AUDIO_PAUSED, '[get_status paused]' );

SDL::Audio::pause(0);

is( SDL::Audio::get_status, SDL_AUDIO_PLAYING, '[get_status playing]' );

SDL::Audio::lock();
pass ('Audio locked');
SDL::Audio::unlock();
pass ('Audio unlocked');
SDL::Audio::close();
pass ('Audio Closed');
is( SDL::Audio::get_status, SDL_AUDIO_STOPPED, '[get_status stopped]' );



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
print "$why\n";
sleep(1);

sub audio_callback
{

}
