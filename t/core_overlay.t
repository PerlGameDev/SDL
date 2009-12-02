#!perl
use strict;
use warnings;
use Test::More tests => 2;
use SDL;
use SDL::Video;

use_ok('SDL::Overlay');

SDL::init(SDL_INIT_VIDEO);

my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );

my $overlay = SDL::Overlay->new( 100, 100, SDL_YV12_OVERLAY, $display);

isa_ok( $overlay, 'SDL::Overlay');

$overlay = undef;

$display = undef;
sleep(2)



