use strict;
use warnings;
use Test::More tests => 6;
use SDL;
use SDL::Surface;
use SDLx::Surface;

my $surface = SDL::Surface->new( SDL_SWSURFACE, 400,200, 32);
my $a = SDLx::Surface->new(  surface => $surface);

isa_ok ( $a, 'SDLx::Surface');

isa_ok ( $a->surface(), 'SDL::Surface');

my $color =  $a->[0][0];
is ( $color , 0, 'Right color returned');

 $a->[0][0] = 0x00FF00FF;
is ( $a->[0][0] , 0x00FF00FF, 'Right color returned');

is ( @{$a} , 200 , 'Correct Y value');

is ( @{$a->[0]} , 400 , 'Correct X value');
