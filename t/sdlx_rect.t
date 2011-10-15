use strict;
use warnings;
use SDL;
use SDL::Rect;
use SDLx::Rect;
use Test::More;
use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
}

can_ok(
	'SDLx::Rect', qw/
		width
		w
		height
		h
		left
		x
		top
		y
		bottom
		right
		centerx
		centery
		size
		topleft
		midleft
		bottomleft
		center
		topright
		midright
		bottomright
		midtop
		midbottom
		new
		copy
		duplicate
		move
		move_ip
		inflate
		inflate_ip
		clamp
		clamp_ip
		clip
		clip_ip
		union
		union_ip
		unionall
		unionall_ip
		fit
		fit_ip
		normalize
		contains
		collidepoint
		colliderect
		collidelist
		collidelistall
		collidehash
		collidehashall
		/
);


my ($x, $y, $w, $h) = (0, 1, 2, 3);
my $rect = SDLx::Rect->new($x, $y, $w, $h);
ok($rect, 'new');
isa_ok($rect, 'SDLx::Rect');

is($rect->width,  $w, 'get width');
is($rect->w,      $w, 'get w');
is($rect->height, $h, 'get height');
is($rect->h,      $h, 'get h');
is($rect->left,   $x, 'get left');
is($rect->x,      $x, 'get x');
is($rect->top,    $y, 'get top');
is($rect->y,      $y, 'get y');

is($rect->bottom, $y + $h, 'get bottom');
is($rect->right,  $x + $w, 'get right');

my $copy = $rect->copy();
is($copy->w, $w, 'copy (w)');
is($copy->h, $h, 'copy (h)');
is($copy->x, $x, 'copy (x)');
is($copy->y, $y, 'copy (y)');

my ($dx, $dy) = (4, 5);
my $moved = $rect->move($dx, $dy);
is($moved->w, $w,       'move (w)');
is($moved->h, $h,       'move (h)');
is($moved->x, $x + $dx, 'move (x)');
is($moved->y, $y + $dy, 'move (y)');

my ($dw, $dh) = (6, 7);
my $inflated = $rect->inflate($dw, $dh);
is($inflated->w, $w + $dw,     'inflate (w)');
is($inflated->h, $h + $dh,     'inflate (h)');
is($inflated->x, $x - $dw / 2, 'inflate (x)');
is($inflated->y, $y - $dw / 2, 'inflate (y)');

if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

pass 'Final SegFault test';


done_testing;
