use Test::More tests => 96;
use strict;
use SDL;

use_ok( 'SDL::Game::Rect' ); 
  
can_ok ('SDL::Game::Rect', qw/
	new
	x 
	y 
	width 
	height
	w
	h
	top
	left
	center_x
	center_y
    bottom
    right
	 /);


my $rect = SDL::Game::Rect->new( 0, 0, 0, 0);

isa_ok ($rect, 'SDL::Game::Rect','new went ok');

foreach my $attr (qw(x y top    left  width   height 
                     w h bottom right center_x center_y)
                 ) {
    is ($rect->$attr, 0, "$attr is 0");
}

# set and get at the same time (and testing method aliases)
is ($rect->left(15), 15, 'left is now 15');
is ($rect->x, 15, 'x and left point to the same place');
is ($rect->x(12), 12, 'x is now 12');
is ($rect->left, 12, 'left is an alias to x');

is ($rect->top(132), 132, 'top is now 132');
is ($rect->y, 132, 'y and top point to the same place');
is ($rect->y(123), 123, 'y is now 123');
is ($rect->top, 123, 'top is an alias to y');



is ($rect->w(54), 54, 'w is now 54');
is ($rect->width, 54, 'w and width point to the same place');
is ($rect->width(45), 45, 'w is now 45');
is ($rect->w, 45, 'w is an alias to width');


is ($rect->h(76), 76, 'h is now 76');
is ($rect->height, 76, 'h and height point to the same place');
is ($rect->height(67), 67, 'h is now 67');
is ($rect->h, 67, 'h is an alias to height');

# get alone
is ($rect->x(), 12, 'x is 12');
is ($rect->left(), 12, 'left is 12');
is ($rect->y(), 123, 'y is 123');
is ($rect->top(), 123, 'top is 123');
is ($rect->width(), 45, 'width is 45');
is ($rect->w(), 45, 'w is 45');
is ($rect->height(), 67, 'height is 67');
is ($rect->h(), 67, 'h is 67');

# other helpers
is ($rect->bottom, 190, 'bottom should be relative to heigth and top');
is ($rect->bottom(189), 189, 'changing bottom value');
is ($rect->bottom, 189, 'checking bottom value again');
is ($rect->top, 122, 'top value should have been updated after bottom change');
is ($rect->height, 67, 'height should have stayed the same');

is ($rect->center_y, 155, 'checking vertical center');
is ($rect->center_y(154), 154, 'changing center_y value');
is ($rect->center_y, 154, 'checking center_y value again');
is ($rect->top, 121, 'top value should have been updated after center_y change');
is ($rect->height, 67, 'height should have stayed the same');

is ($rect->right, 57, 'right should be relative to width and left');
is ($rect->right(56), 56, 'changing right value');
is ($rect->right, 56, 'checking right value again');
is ($rect->left, 11, 'left value should have been updated after bottom change');
is ($rect->width, 45, 'width should have stayed the same');

is ($rect->center_x, 33, 'checking horizontal center');
is ($rect->center_x(32), 32, 'changing center_x value');
is ($rect->center_x, 32, 'checking center_x value again');
is ($rect->left, 10, 'left value should have been updated after bottom change');
is ($rect->width, 45, 'width should have stayed the same');

# checking two-valued accessors
can_ok ('SDL::Game::Rect', qw/
    size
	center
	top_left
	mid_left
	bottom_left
	top_right
	mid_right
	bottom_right
	mid_top
	mid_bottom
	 /);


is_deeply ( [$rect->center], [32, 154], 'checking center pair');
$rect->center(undef, undef);
is($rect->center_x, 32, 'center() does nothing when passed undef');
is($rect->center_y, 154, 'center() does nothing when passed undef');
$rect->center(undef, 200);
is($rect->center_x, 32, 'center() does nothing for X when passed undef');
is($rect->center_y, 200, 'center() works on one-parameter (y)');
$rect->center(7, undef);
is($rect->center_x, 7, 'center() works on one-parameter (x)');
is($rect->center_y, 200, 'center() does nothing for Y when passed undef');
$rect->center(32, 154);
is($rect->center_x, 32, 'center() can be used as an acessor for x');
is($rect->center_y, 154, 'center() can be used as an acessor for y');

is_deeply ( [$rect->top_left], [121, 10], 'checking top_left pair');
$rect->top_left(undef, undef);
is($rect->top, 121, 'top_left() does nothing when passed undef');
is($rect->left, 10, 'top_left() does nothing when passed undef');
$rect->top_left(undef, 200);
is($rect->top, 121, 'top_left() does nothing for Y when passed undef');
is($rect->left, 200, 'top_left() works on one-parameter (x)');
$rect->top_left(7, undef);
is($rect->top, 7, 'top_left() works on one-parameter (y)');
is($rect->left, 200, 'top_left() does nothing for X when passed undef');
$rect->top_left(121, 10);
is($rect->top, 121, 'top_left() can be used as an acessor for y');
is($rect->left, 10, 'top_left() can be used as an acessor for x');

is_deeply ( [$rect->mid_left], [154, 10], 'checking mid_left pair');
$rect->mid_left(undef, undef);
is($rect->center_y, 154, 'mid_left() does nothing when passed undef');
is($rect->left, 10, 'mid_left() does nothing when passed undef');
$rect->mid_left(undef, 200);
is($rect->center_y, 154, 'mid_left() does nothing for Y when passed undef');
is($rect->left, 200, 'mid_left() works on one-parameter (x)');
$rect->mid_left(7, undef);
is($rect->center_y, 7, 'mid_left() works on one-parameter (y)');
is($rect->left, 200, 'mid_left() does nothing for X when passed undef');
$rect->mid_left(154, 10);
is($rect->center_y, 154, 'mid_left() can be used as an acessor for y');
is($rect->left, 10, 'mid_left() can be used as an acessor for x');

# checking other methods
can_ok('SDL::Game::Rect', qw/
   copy
   duplicate
   move 
   inflate
   clamp
   clip
   union
   fit
   normalize
   contains
   collide_point
   collide_rect
   collide_list
   collide_list_all
   collide_hash
   collide_hash_all
    /);

# checking legacy accessor
my $vanilla_rect = $rect->rect;
ok (defined $vanilla_rect, '->rect returns a vanilla SDL::Rect object');
isa_ok ($vanilla_rect, 'SDL::Rect');
is($vanilla_rect->x, 10, 'vanilla rect should have same x value');
is($vanilla_rect->y, 121, 'vanilla rect should have same y value');
is($vanilla_rect->w, 45, 'vanilla rect should have same width value');
is($vanilla_rect->h, 67, 'vanilla rect should have same height value');


$rect->move(1, -1);
is($rect->top, 120, 'relative ->move() call should work for y');
is($rect->left, 11, 'relative ->move() call should work for x');
