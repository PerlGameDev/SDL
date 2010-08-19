#!perl -T
# basic testing of SDLx::Sound

use Test::More tests => 8;
use lib 't/lib';
use lib 'lib';

my $fase2 = 1;

# load
# NOTE: use ok is tested in t/00-load.t so we can bail out
use SDLx::Sound;

# methods
can_ok(
	'SDLx::Sound', qw/
		new
                load
                unload
                play
                stop
                loud
                fade
		/
);

ok (my $snd = SDLx::Sound->new(), 'Can be instantiated');
ok (my $snd2 = SDLx::Sound->new(), 'Can be instantiated again');

isa_ok( $snd, 'SDLx::Sound', 'snd' );
isa_ok( $snd2, 'SDLx::Sound', 'snd2' );

# load and play a sound
ok ($snd->play('test/data/sample.wav'), 'Can play a wav');

SKIP:
{
skip 'complex tests', 1 unless $fase2;
# in a single act do the wole Sound
ok( my $snd2 = SDLx::Sound->new(
    files => (
        chanell_01 => "test/data/sample.wav",
        chanell_02 => "test/data/tribe_i.wav"

    ),
    loud  => (
        channel_01 => 80,
        channel_02 => 75
    ),
    bangs => (
        chanell_01 => 0,      # start
        chanell_01 => 1256,   # miliseconds
        chanell_02 => 2345
    ),
    fade  => (
        chanell_02 => [2345, 3456, -20]
    )
)->play()
);
}

diag( "Testing SDLx::Sound $SDLx::Sound::VERSION, Perl $], $^X" );           
