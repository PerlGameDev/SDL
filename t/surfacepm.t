#!perl
use strict;
use warnings;
use Test::More tests => 11;
use_ok('SDL');
use_ok('SDL::Color');
use_ok('SDL::Rect');
use_ok('SDL::Surface');

my $surface
    = SDL::Surface->new( SDL::SDL_ANYFORMAT(), 640, 320, 0, 0, 0, 0, 0 );
isa_ok( $surface, 'SDL::Surface' );
is( $surface->w, 640, 'surface has width' );
is( $surface->h, 320, 'surface has height' );

my $image = SDL::Surface->load('test/data/logo.png');
is( $image->w, 608, 'image has width' );
is( $image->h, 126, 'image has height' );

$surface->fill_rect( SDL::Rect->new( 0, 0, 32, 32 ),
    SDL::Color->new( 200, 200, 200 ) );
ok( 1, 'Managed to fill_rect' );

my $rect = SDL::Rect->new( 0, 0, 64, 64 );
$image->blit( $rect, $surface, $rect );
ok( 1, 'Managed to blit' );

#my $image_format = $surface->display;
#$surface->update_rect( 0, 0, 32, 32 );
#ok( 1, 'Managed to update_rect' );
#$surface->update_rects( SDL::Rect->new( 0, 0, 32, 32 ) );
#ok( 1, 'Managed to update_rects' );

