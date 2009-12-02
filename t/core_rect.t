#!perl
use strict;
use warnings;
use Test::More tests => 10;
use_ok('SDL::Rect');

my $rect = SDL::Rect->new( 0, 0, 0, 0 );
isa_ok( $rect, 'SDL::Rect' );
is( $rect->x(), 0, 'x is 0' );
is( $rect->y(), 0, 'y is 0' );
is( $rect->w(), 0, 'w is 0' );
is( $rect->h(), 0, 'h is 0' );

$rect->x(1);
$rect->y(2);
$rect->w(3);
$rect->h(4);

is( $rect->x(), 1, 'x is now 1' );
is( $rect->y(), 2, 'y is now 2' );
is( $rect->w(), 3, 'w is now 3' );
is( $rect->h(), 4, 'h is now 4' );
sleep(2);
