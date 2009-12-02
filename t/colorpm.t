#!perl
use strict;
use warnings;
use Test::More tests => 15;
use_ok('SDL::Color');

# check empty: black
my $black = SDL::Color->new( 0, 0, 0 );
isa_ok( $black, 'SDL::Color' );
is( $black->r(), 0, 'black r is 0' );
is( $black->g(), 0, 'black g is 0' );
is( $black->b(), 0, 'black b is 0' );

# check full: white
my $white = SDL::Color->new( 0xff, 0xff, 0xff );
isa_ok( $white, 'SDL::Color' );
is( $white->r(), 255, 'white r is 255' );
is( $white->g(), 255, 'white g is 255' );
is( $white->b(), 255, 'white b is 255' );

# check setting a value
my $orange = $white;
$orange->r(254);
$orange->g(153);
$orange->b(0);
is( $orange->r(), 254, 'orange_notcloned r is 254' );
is( $orange->g(), 153, 'orange_notcloned g is 153' );
is( $orange->b(), 0,   'orange_notcloned b is 0' );

# check that copies also change
is( $white->r(), 254, 'white (now orange) r is 254' );
is( $white->g(), 153, 'white (now orange) g is 154' );
is( $white->b(), 0,   'white (now orange) b is 0' );

sleep(2);
