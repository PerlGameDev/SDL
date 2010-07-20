use Test::More tests => 87;
use strict;
use SDL;

use_ok('SDLx::Rect');

can_ok(
    'SDLx::Rect', qw/
      new
      x
      y
      width
      height
      w
      h
      top
      left
      centerx
      centery
      /
);

my $rect = SDLx::Rect->new( 0, 0, 0, 0 );

isa_ok( $rect, 'SDLx::Rect', 'new went ok' );

foreach my $attr (
    qw(x y top    left  width   height
    w h bottom right centerx centery)
  )
{
    is( $rect->$attr, 0, "$attr is 0" );
}

# set and get at the same time (and testing method aliases)
is( $rect->left(15), 15, 'left is now 15' );
is( $rect->x,        15, 'x and left point to the same place' );
is( $rect->x(12),    12, 'x is now 12' );
is( $rect->left,     12, 'left is an alias to x' );

is( $rect->top(132), 132, 'top is now 132' );
is( $rect->y,        132, 'y and top point to the same place' );
is( $rect->y(123),   123, 'y is now 123' );
is( $rect->top,      123, 'top is an alias to y' );

is( $rect->w(54),     54, 'w is now 54' );
is( $rect->width,     54, 'w and width point to the same place' );
is( $rect->width(45), 45, 'w is now 45' );
is( $rect->w,         45, 'w is an alias to width' );

is( $rect->h(76),      76, 'h is now 76' );
is( $rect->height,     76, 'h and height point to the same place' );
is( $rect->height(67), 67, 'h is now 67' );
is( $rect->h,          67, 'h is an alias to height' );

# get alone
is( $rect->x(),      12,  'x is 12' );
is( $rect->left(),   12,  'left is 12' );
is( $rect->y(),      123, 'y is 123' );
is( $rect->top(),    123, 'top is 123' );
is( $rect->width(),  45,  'width is 45' );
is( $rect->w(),      45,  'w is 45' );
is( $rect->height(), 67,  'height is 67' );
is( $rect->h(),      67,  'h is 67' );

# other helpers
is( $rect->bottom,      190, 'bottom should be relative to heigth and top' );
is( $rect->bottom(189), 189, 'changing bottom value' );
is( $rect->bottom,      189, 'checking bottom value again' );
is( $rect->top, 122, 'top value should have been updated after bottom change' );
is( $rect->height, 67, 'height should have stayed the same' );

is( $rect->centery,      155, 'checking vertical center' );
is( $rect->centery(154), 154, 'changing centery value' );
is( $rect->centery,      154, 'checking centery value again' );
is( $rect->top, 121,
    'top value should have been updated after centery change' );
is( $rect->height, 67, 'height should have stayed the same' );

is( $rect->right,     57, 'right should be relative to width and left' );
is( $rect->right(56), 56, 'changing right value' );
is( $rect->right,     56, 'checking right value again' );
is( $rect->left, 11,
    'left value should have been updated after bottom change' );
is( $rect->width, 45, 'width should have stayed the same' );

is( $rect->centerx,     33, 'checking horizontal center' );
is( $rect->centerx(32), 32, 'changing centerx value' );
is( $rect->centerx,     32, 'checking centerx value again' );
is( $rect->left, 10,
    'left value should have been updated after bottom change' );
is( $rect->width, 45, 'width should have stayed the same' );

# checking two-valued accessors
can_ok(
    'SDLx::Rect', qw/
      size
      center
      topleft
      midleft
      bottomleft
      topright
      midright
      bottomright
      midtop
      midbottom
      /
);

is_deeply( [ $rect->center ], [ 32, 154 ], 'checking center pair' );
$rect->center( undef, undef );
is( $rect->centerx, 32,  'center() does nothing when passed undef' );
is( $rect->centery, 154, 'center() does nothing when passed undef' );
$rect->center( undef, 200 );
is( $rect->centerx, 32,  'center() does nothing for X when passed undef' );
is( $rect->centery, 200, 'center() works on one-parameter (y)' );
$rect->center( 7, undef );
is( $rect->centerx, 7,   'center() works on one-parameter (x)' );
is( $rect->centery, 200, 'center() does nothing for Y when passed undef' );
$rect->center( 32, 154 );
is( $rect->centerx, 32,  'center() can be used as an acessor for x' );
is( $rect->centery, 154, 'center() can be used as an acessor for y' );

is_deeply( [ $rect->topleft ], [ 121, 10 ], 'checking topleft pair' );
$rect->topleft( undef, undef );
is( $rect->top,  121, 'topleft() does nothing when passed undef' );
is( $rect->left, 10,  'topleft() does nothing when passed undef' );
$rect->topleft( undef, 200 );
is( $rect->top,  121, 'topleft() does nothing for Y when passed undef' );
is( $rect->left, 200, 'topleft() works on one-parameter (x)' );
$rect->topleft( 7, undef );
is( $rect->top,  7,   'topleft() works on one-parameter (y)' );
is( $rect->left, 200, 'topleft() does nothing for X when passed undef' );
$rect->topleft( 121, 10 );
is( $rect->top,  121, 'topleft() can be used as an acessor for y' );
is( $rect->left, 10,  'topleft() can be used as an acessor for x' );

is_deeply( [ $rect->midleft ], [ 154, 10 ], 'checking midleft pair' );
$rect->midleft( undef, undef );
is( $rect->centery, 154, 'midleft() does nothing when passed undef' );
is( $rect->left,    10,  'midleft() does nothing when passed undef' );
$rect->midleft( undef, 200 );
is( $rect->centery, 154, 'midleft() does nothing for Y when passed undef' );
is( $rect->left,    200, 'midleft() works on one-parameter (x)' );
$rect->midleft( 7, undef );
is( $rect->centery, 7,   'midleft() works on one-parameter (y)' );
is( $rect->left,    200, 'midleft() does nothing for X when passed undef' );
$rect->midleft( 154, 10 );
is( $rect->centery, 154, 'midleft() can be used as an acessor for y' );
is( $rect->left,    10,  'midleft() can be used as an acessor for x' );
sleep(2);
