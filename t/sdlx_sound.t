#!perl -T
#
# Copyright (C) 2010 Ricardo Filipo
#
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
#
# Please feel free to send questions, suggestions or improvements to:
#
#	Ricardo Filipo
#	ricardo.filipo at gmail.com


# basic testing of SDLx::Sound

use Test::More tests => 8;
use lib 't/lib';
use lib 'lib';

my $fase2 = 1;

# load
use_ok( 'SDLx::Sound' );

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
