use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDL::Color;
use SDLx::Sprite::Animated;
use lib 't/lib';
use SDL::TestTool;

can_ok(
	'SDLx::Sprite::Animated',
	qw( new rect clip load surface x y w h draw alpha_key
		step_x step_y type max_loops ticks_per_frame current_frame current_loop
		set_sequences sequence next previous reset start stop draw)
);

TODO: {
	local $TODO = 'methods not implemented yet';
	can_ok( 'SDLx::Sprite', qw( add remove zoom ) );
}

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
} elsif ( !SDL::Config->has('SDL_image') ) {
	plan( skip_all => 'SDL_image support not compiled' );
}

my $disp = SDL::Video::set_video_mode( 300, 300, 32, SDL_ANYFORMAT );

my $sprite = SDLx::Sprite::Animated->new(
	width  => 48,
	height => 48
);

isa_ok( $sprite, 'SDLx::Sprite' );
isa_ok( $sprite, 'SDLx::Sprite::Animated' );

my $clip = $sprite->clip;
ok( $clip, 'clip defined upon raw initialization' );
isa_ok( $clip, 'SDL::Rect', 'spawned clip isa SDL::Rect' );
is( $clip->x, 0,  'clip->x init' );
is( $clip->y, 0,  'clip->y init' );
is( $clip->w, 48, 'clip->w init' );
is( $clip->h, 48, 'clip->h init' );

my $rect = $sprite->rect;
ok( $rect, 'rect defined upon raw initialization' );
isa_ok( $rect, 'SDL::Rect', 'spawned rect isa SDL::Rect' );
is( $rect->x, 0,  'rect->x init' );
is( $rect->y, 0,  'rect->y init' );
is( $rect->w, 48, 'rect->w init' );
is( $rect->h, 48, 'rect->h init' );

my ( $x, $y ) = ( $sprite->x, $sprite->y );
is( $x, 0, 'no x defined upon raw initialization' );
is( $y, 0, 'no y defined upon raw initialization' );

my ( $w, $h ) = ( $sprite->w, $sprite->h );
is( $w, 48, 'w defined upon raw initialization' );
is( $h, 48, 'h defined upon raw initialization' );

isa_ok(
	$sprite->load('test/data/hero.bmp'),
	'SDLx::Sprite::Animated', '[load] works'
);

isa_ok(
	$sprite->alpha_key( SDL::Color->new( 0xfc, 0x00, 0xff ) ),
	'SDLx::Sprite::Animated', '[alpha_key] works'
);

isa_ok(
	$sprite->alpha(0xcc), 'SDLx::Sprite::Animated',
	'[alpha] integer works '
);

isa_ok(
	$sprite->alpha(0.3), 'SDLx::Sprite::Animated',
	'[alpha] percentage works'
);

is( $clip->x, 0,  'clip->x after load' );
is( $clip->y, 0,  'clip->y after load' );
is( $clip->w, 48, 'clip->w after load' );
is( $clip->h, 48, 'clip->h after load' );

is( $rect->x, 0,  'rect->x after load' );
is( $rect->y, 0,  'rect->y after load' );
is( $rect->w, 48, 'rect->w after load' );
is( $rect->h, 48, 'rect->h after load' );

$sprite->set_sequences( left => [ [ 1, 0 ], [ 1, 1 ], [ 1, 2 ] ], );

my ( $clip_w, $clip_h ) = ( $sprite->clip->w, $sprite->clip->h );
$sprite->alpha_key( SDL::Color->new( 0xfc, 0x00, 0xff ) );
is( $sprite->clip->w, $clip_w, 'alpha_key() does not change clip width' );
is( $sprite->clip->h, $clip_h, 'alpha_key() does not change clip height' );

$sprite->sequence('left');

is( $sprite->current_frame, 1, 'sprite->current_frame after sequence' );
is( $sprite->current_loop,  1, 'sprite->current_loop after sequence' );

is( $clip->x, 48, 'clip->x after sequence' );
is( $clip->y, 0,  'clip->y after sequence' );
is( $clip->w, 48, 'clip->w after sequence' );
is( $clip->h, 48, 'clip->h after sequence' );

is( $rect->x, 0,  'rect->x after sequence' );
is( $rect->y, 0,  'rect->y after sequence' );
is( $rect->w, 48, 'rect->w after sequence' );
is( $rect->h, 48, 'rect->h after sequence' );

$sprite->next;
is( $sprite->current_frame, 2, 'sprite->current_frame after next' );
is( $sprite->current_loop,  1, 'sprite->current_loop after next' );

is( $clip->x, 48, 'clip->x after next' );
is( $clip->y, 48, 'clip->y after next' );
is( $clip->w, 48, 'clip->w after next' );
is( $clip->h, 48, 'clip->h after next' );

is( $rect->x, 0,  'rect->x after next' );
is( $rect->y, 0,  'rect->y after next' );
is( $rect->w, 48, 'rect->w after next' );
is( $rect->h, 48, 'rect->h after next' );

$sprite->next;
is( $sprite->current_frame, 3, 'sprite->current_frame after second next' );
is( $sprite->current_loop,  1, 'sprite->current_loop after second next' );

is( $clip->x, 48, 'clip->x after second next' );
is( $clip->y, 96, 'clip->y after second next' );
is( $clip->w, 48, 'clip->w after second next' );
is( $clip->h, 48, 'clip->h after second next' );

is( $rect->x, 0,  'rect->x after second next' );
is( $rect->y, 0,  'rect->y after second next' );
is( $rect->w, 48, 'rect->w after second next' );
is( $rect->h, 48, 'rect->h after second next' );

$sprite->next;
is( $sprite->current_frame, 1, 'sprite->current_frame after third next' );
is( $sprite->current_loop,  2, 'sprite->current_loop after second next' );

is( $clip->x, 48, 'clip->x after third next' );
is( $clip->y, 0,  'clip->y after third next' );
is( $clip->w, 48, 'clip->w after third next' );
is( $clip->h, 48, 'clip->h after third next' );

is( $rect->x, 0,  'rect->x after third next' );
is( $rect->y, 0,  'rect->y after third next' );
is( $rect->w, 48, 'rect->w after third next' );
is( $rect->h, 48, 'rect->h after third next' );

is( $sprite->next, $sprite, 'next() returns the object' );

is( $sprite->current_frame, 2, 'sprite->current_frame after next' );

is( $sprite->previous, $sprite, 'previous() returns the object' );

is( $sprite->current_frame, 1, 'sprite->current_frame after previous' );

$sprite->next;
is( $sprite->current_frame, 2, 'sprite->current_frame before reset' );

is( $clip->x, 48, 'clip->x before reset' );
is( $clip->y, 48, 'clip->y before reset' );
is( $clip->w, 48, 'clip->w before reset' );
is( $clip->h, 48, 'clip->h before reset' );

is( $sprite->reset, $sprite, 'reset() returns the object' );

is( $sprite->current_frame, 1, 'sprite->current_frame after reset' );

is( $clip->x, 48, 'clip->x after reset' );
is( $clip->y, 0,  'clip->y after reset' );
is( $clip->w, 48, 'clip->w after reset' );
is( $clip->h, 48, 'clip->h after reset' );

$sprite = SDLx::Sprite::Animated->new(
	image => 'test/data/hero.bmp',
	rect  => SDL::Rect->new( 40, 50, 48, 48 ),
);

$clip = $sprite->clip;
is( $clip->x, 0,  'clip->x after new with image and rect' );
is( $clip->y, 0,  'clip->y after new with image and rect' );
is( $clip->w, 48, 'clip->w after new with image and rect' );
is( $clip->h, 48, 'clip->h after new with image and rect' );

$rect = $sprite->rect;
is( $rect->x, 40, 'rect->x after new with image and rect' );
is( $rect->y, 50, 'rect->y after new with image and rect' );
is( $rect->w, 48, 'rect->w after new with image and rect' );
is( $rect->h, 48, 'rect->h after new with image and rect' );

$sprite = SDLx::Sprite::Animated->new(
	image => 'test/data/hero.bmp',
	clip  => SDL::Rect->new( 0, 0, 48, 48 ),
);

$clip = $sprite->clip;
is( $clip->x, 0,  'clip->x after new with image and clip' );
is( $clip->y, 0,  'clip->y after new with image and clip' );
is( $clip->w, 48, 'clip->w after new with image and clip' );
is( $clip->h, 48, 'clip->h after new with image and clip' );

$rect = $sprite->rect;
is( $rect->x, 0,  'rect->x after new with image and clip' );
is( $rect->y, 0,  'rect->y after new with image and clip' );
is( $rect->w, 48, 'rect->w after new with image and clip' );
is( $rect->h, 48, 'rect->h after new with image and clip' );

$sprite = SDLx::Sprite::Animated->new(
	image  => 'test/data/hero.bmp',
	rect   => SDL::Rect->new( 40, 50, 48, 48 ),
	step_x => 50,
	step_y => 50,
);
$sprite->set_sequences(
	left  => [ [ 1, 0 ], [ 1, 1 ], ],
	right => [ [ 3, 0 ], [ 3, 1 ], ],
);
$sprite->sequence('left');

$clip = $sprite->clip;
is( $clip->x, 50, 'clip->x after new with step_x, step_y' );
is( $clip->y, 0,  'clip->y after new with step_x, step_y' );
is( $clip->w, 48, 'clip->w after new with step_x, step_y' );
is( $clip->h, 48, 'clip->h after new with step_x, step_y' );

$sprite->next;
$clip = $sprite->clip;
is( $clip->x, 50, 'clip->x after first next' );
is( $clip->y, 50, 'clip->y after first next' );
is( $clip->w, 48, 'clip->w after first next' );
is( $clip->h, 48, 'clip->h after first next' );

$sprite->next;
$clip = $sprite->clip;
is( $clip->x, 50, 'clip->x after second next' );
is( $clip->y, 0,  'clip->y after second next' );
is( $clip->w, 48, 'clip->w after second next' );
is( $clip->h, 48, 'clip->h after second next' );

$sprite->sequence('right');
$clip = $sprite->clip;
is( $clip->x, 150, 'clip->x after sequence change' );
is( $clip->y, 0,   'clip->y after sequence change' );
is( $clip->w, 48,  'clip->w after sequece change' );
is( $clip->h, 48,  'clip->h after sequence change' );

$sprite->next;
$clip = $sprite->clip;
is( $clip->x, 150, 'clip->x after first next' );
is( $clip->y, 50,  'clip->y after first next' );
is( $clip->w, 48,  'clip->w after first next' );
is( $clip->h, 48,  'clip->h after first next' );

$sprite->next;
$clip = $sprite->clip;
is( $clip->x, 150, 'clip->x after second next' );
is( $clip->y, 0,   'clip->y after second next' );
is( $clip->w, 48,  'clip->w after second next' );
is( $clip->h, 48,  'clip->h after second next' );

$sprite = SDLx::Sprite::Animated->new(
	image     => 'test/data/hero.bmp',
	rect      => SDL::Rect->new( 40, 50, 48, 48 ),
	max_loops => 2,
);
$sprite->set_sequences( up => [ [ 0, 0 ], [ 0, 1 ], ], );
$sprite->sequence('up');
$clip = $sprite->clip;
is( $clip->y, 0, 'clip->y after new with max_loops' );

$sprite->next;
is( $clip->y, 48, 'clip->y after first next' );

$sprite->next;
is( $clip->y, 0, 'clip->y after second next' );

$sprite->next;
is( $clip->y, 48, 'clip->y after third next' );

$sprite->next;
is( $clip->y, 0, 'clip->y after fourth next' );

$sprite->next;
is( $clip->y, 0, 'clip->y after fifth next' );

$sprite = SDLx::Sprite::Animated->new(
	image => 'test/data/hero.bmp',
	rect  => SDL::Rect->new( 40, 50, 48, 48 ),
	type  => 'reverse'
);
$sprite->set_sequences( up => [ [ 0, 0 ], [ 0, 1 ], [ 0, 2 ], ], );
$sprite->sequence('up');
$clip = $sprite->clip;
is( $clip->y, 0, 'clip->y after new with type = reverse' );
is( $sprite->current_loop, 1,
	'sprite->current_loop after new with type = reverse'
);

$sprite->next;
is( $clip->y,               48, 'clip->y after first next' );
is( $sprite->current_frame, 2,  'sprite->current_frame after first next' );
is( $sprite->current_loop,  1,  'sprite->current_loop after first next' );

$sprite->next;
is( $clip->y,               96, 'clip->y after second next' );
is( $sprite->current_frame, 3,  'sprite->current_frame after second next' );
is( $sprite->current_loop,  1,  'sprite->current_loop after second next' );

$sprite->next;
is( $clip->y,               48, 'clip->y after third next' );
is( $sprite->current_frame, 2,  'sprite->current_frame after third next' );
is( $sprite->current_loop,  1,  'sprite->current_loop after third next' );

$sprite->next;
is( $clip->y,               0, 'clip->y after fourth next' );
is( $sprite->current_frame, 1, 'sprite->current_frame after fourth next' );
is( $sprite->current_loop,  2, 'sprite->current_loop after fourth next' );

$sprite->next;
is( $clip->y,               48, 'clip->y after fifth next' );
is( $sprite->current_frame, 2,  'sprite->current_frame after fifth next' );
is( $sprite->current_loop,  2,  'sprite->current_loop after fifth next' );

$sprite->next;
is( $clip->y,               96, 'clip->y after sixth next' );
is( $sprite->current_frame, 3,  'sprite->current_frame after sixth next' );
is( $sprite->current_loop,  2,  'sprite->current_loop after sixth next' );

$sprite->next;
is( $clip->y,               48, 'clip->y after seventh next' );
is( $sprite->current_frame, 2,  'sprite->current_frame after seventh next' );
is( $sprite->current_loop,  2,  'sprite->current_loop after seventh next' );

$sprite = SDLx::Sprite::Animated->new(
	image => 'test/data/hero.bmp',
	rect  => SDL::Rect->new( 40, 50, 48, 48 ),
);
$sprite->set_sequences( up => [ [ 0, 0 ], [ 0, 1 ], ], );
$sprite->sequence('up');
$clip = $sprite->clip;
is( $clip->y, 0, 'clip->y after new' );

$sprite->previous;
is( $clip->y, 48, 'clip->y after first previous' );

$sprite->previous;
is( $clip->y, 0, 'clip->y after second previous' );

$sprite->previous;
is( $clip->y, 48, 'clip->y after third previous' );

$sprite = SDLx::Sprite::Animated->new(
	image => 'test/data/hero.bmp',
	rect  => SDL::Rect->new( 40, 50, 48, 48 ),
	type  => 'reverse'
);
$sprite->set_sequences( up => [ [ 0, 0 ], [ 0, 1 ], [ 0, 2 ], ], );
$sprite->sequence('up');
$clip = $sprite->clip;
is( $clip->y, 0, 'clip->y after new with type = reverse' );

$sprite->previous;
is( $clip->y,               96, 'clip->y after first previous' );
is( $sprite->current_frame, 3,  'sprite->current_frame after first previous' );

$sprite->previous;
is( $clip->y,               48, 'clip->y after second previous' );
is( $sprite->current_frame, 2,  'sprite->current_frame after second previous' );

$sprite->previous;
is( $clip->y,               0, 'clip->y after third previous' );
is( $sprite->current_frame, 1, 'sprite->current_frame after third previous' );

$sprite->previous;
is( $clip->y,               48, 'clip->y after fourth previous' );
is( $sprite->current_frame, 2,  'sprite->current_frame after fourth previous' );

$sprite->previous;
is( $clip->y,               96, 'clip->y after fifth previous' );
is( $sprite->current_frame, 3,  'sprite->current_frame after fifth previous' );

$sprite->previous;
is( $clip->y,               48, 'clip->y after sixth previous' );
is( $sprite->current_frame, 2,  'sprite->current_frame after sixth previous' );

$sprite->previous;
is( $clip->y,               0, 'clip->y after seventh previous' );
is( $sprite->current_frame, 1, 'sprite->current_frame after seventh previous' );

$sprite = SDLx::Sprite::Animated->new(
	image     => 'test/data/hero.bmp',
	rect      => SDL::Rect->new( 40, 50, 48, 48 ),
	clip      => SDL::Rect->new( 48, 48, 48, 48 ),
	sequences => { up => [ [ 0, 0 ], [ 0, 1 ] ] },
	sequence  => 'up',
);
$clip = $sprite->clip;
is( $clip->x, 48, 'clip->x after new with clip' );
is( $clip->y, 48, 'clip->y after new with clip' );

$sprite->next();
is( $clip->x, 48, 'clip->x after first next' );
is( $clip->y, 96, 'clip->y after first next' );

$sprite->next();
is( $clip->x, 48, 'clip->x after second next' );
is( $clip->y, 48, 'clip->y after second next' );

$sprite = SDLx::Sprite::Animated->new(
	image => 'test/data/hero.bmp',
	rect  => SDL::Rect->new( 40, 50, 48, 48 ),
);
$clip = $sprite->clip;
is( $clip->x, 0, 'clip->x after new with no sequences' );
is( $clip->y, 0, 'clip->y after new with no sequences' );

my $sequences = [
	[ 0, 0 ],  [ 48, 0 ],  [ 96, 0 ],  [ 144, 0 ],  [ 192, 0 ],
	[ 0, 48 ], [ 48, 48 ], [ 96, 48 ], [ 144, 48 ], [ 192, 48 ],
	[ 0, 96 ], [ 48, 96 ], [ 96, 96 ], [ 144, 96 ], [ 192, 96 ],
];

foreach my $count ( 1 .. 20 ) {
	$sprite->next;
	my $s = $sequences->[ $count % @$sequences ];
	is( $clip->x, $s->[0], 'clip->x after ' . $count . '-th next' );
	is( $clip->y, $s->[1], 'clip->y after ' . $count . '-th next' );
}

done_testing;

#reset the old video driver
if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

