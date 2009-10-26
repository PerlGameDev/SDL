#!perl
use strict;
use warnings;
use SDL::Config;
use Test::More;

if ( SDL::Config->has('SDL_ttf') ) {
    plan( tests => 10 );
} else {
    plan( skip_all => 'SDL_ttf support not compiled' );
}

use_ok('SDL');
use_ok('SDL::Color');
use_ok('SDL::Surface');
use_ok('SDL::TTF_Font');

SDL::TTF_Init();

my $ttf_font = SDL::TTF_OpenFont( 'test/data/aircut3.ttf', 12 );
isa_ok( $ttf_font, 'SDL::TTF_Font' );
my ( $w, $h ) = @{ SDL::TTF_SizeText( $ttf_font, 'Hello!' ) };
is( ($w == 27) || ($w == 28), 1, '"Hello!" has width 27' );
is( ($h == 14) || ($h == 15), 1, '"Hello!" has width 14' );

my $surface = SDL::TTF_RenderText_Blended( $ttf_font, 'Hello!',
    SDL::Color->new( 255, 0, 0 ) );
isa_ok( $surface, 'SDL::Surface' );
($w,$h) = ( $surface->w, $surface->h) ;
is( ($w == 27) || ($w == 28), 1 ,'Surface has width 27' );
is( ($h == 14) || ($h == 15), 1, 'Surface has width 14' );

SDL::TTF_Quit();
