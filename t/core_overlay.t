#!perl
use strict;
use warnings;
use Test::More tests => 2;
use SDL;

use_ok('SDL::Overlay');

SDL::Init(SDL_INIT_VIDEO);

my $display = SDL::SetVideoMode(640,480,32, SDL_SWSURFACE );

my $overlay = SDL::Overlay->new( 100, 100, SDL_YV12_OVERLAY, $display);

isa_ok( $overlay, 'SDL::Overlay');



