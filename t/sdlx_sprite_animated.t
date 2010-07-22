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
}
elsif ( !SDL::Config->has('SDL_image') ) {
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

isa_ok( $sprite->load('test/data/hero.bmp'),
    'SDLx::Sprite::Animated', '[load] works' );

isa_ok( $sprite->alpha_key( SDL::Color->new( 0xfc, 0x00, 0xff ) ),
    'SDLx::Sprite::Animated', '[alpha] works' );

isa_ok( $sprite->alpha(0xcc), 'SDLx::Sprite::Animated',
    '[alpha] integer works ' );

isa_ok( $sprite->alpha(0.3), 'SDLx::Sprite::Animated',
    '[alpha]  percentage works' );

is( $clip->x, 0,  'clip->x after load' );
is( $clip->y, 0,  'clip->y after load' );
is( $clip->w, 48, 'clip->w after load' );
is( $clip->h, 48, 'clip->h after load' );

is( $rect->x, 0,  'rect->x after load' );
is( $rect->y, 0,  'rect->y after load' );
is( $rect->w, 48, 'rect->w after load' );
is( $rect->h, 48, 'rect->h after load' );

$sprite->set_sequences( left => [ [ 1, 0 ], [ 1, 1 ], [ 1, 2 ] ], );
$sprite->sequence('left');

is( $clip->x, 48, 'clip->x after sequence' );
is( $clip->y, 0,  'clip->y after sequence' );
is( $clip->w, 48, 'clip->w after sequence' );
is( $clip->h, 48, 'clip->h after sequence' );

is( $rect->x, 0,  'rect->x after sequence' );
is( $rect->y, 0,  'rect->y after sequence' );
is( $rect->w, 48, 'rect->w after sequence' );
is( $rect->h, 48, 'rect->h after sequence' );

$sprite->next;

is( $clip->x, 48, 'clip->x after next' );
is( $clip->y, 48, 'clip->y after next' );
is( $clip->w, 48, 'clip->w after next' );
is( $clip->h, 48, 'clip->h after next' );

is( $rect->x, 0,  'rect->x after next' );
is( $rect->y, 0,  'rect->y after next' );
is( $rect->w, 48, 'rect->w after next' );
is( $rect->h, 48, 'rect->h after next' );

$sprite->next;

is( $clip->x, 48, 'clip->x after second next' );
is( $clip->y, 96, 'clip->y after second next' );
is( $clip->w, 48, 'clip->w after second next' );
is( $clip->h, 48, 'clip->h after second next' );

is( $rect->x, 0,  'rect->x after second next' );
is( $rect->y, 0,  'rect->y after second next' );
is( $rect->w, 48, 'rect->w after second next' );
is( $rect->h, 48, 'rect->h after second next' );

$sprite->next;

is( $clip->x, 48, 'clip->x after third next' );
is( $clip->y, 0,  'clip->y after third next' );
is( $clip->w, 48, 'clip->w after third next' );
is( $clip->h, 48, 'clip->h after third next' );

is( $rect->x, 0,  'rect->x after third next' );
is( $rect->y, 0,  'rect->y after third next' );
is( $rect->w, 48, 'rect->w after third next' );
is( $rect->h, 48, 'rect->h after third next' );

$sprite = SDLx::Sprite::Animated->new(
    image => 'test/data/hero.bmp',
    rect  => SDL::Rect->new( 40, 50, 48, 48 ),
);

$clip = $sprite->clip;
is( $clip->x, 0,  'clip->x after new with image' );
is( $clip->y, 0,  'clip->y after new with image' );
is( $clip->w, 48, 'clip->w after new with image' );
is( $clip->h, 48, 'clip->h after new with image' );

$rect = $sprite->rect;
is( $rect->x, 40, 'rect->x after new with image' );
is( $rect->y, 50, 'rect->y after new with image' );
is( $rect->w, 48, 'rect->w after new with image' );
is( $rect->h, 48, 'rect->h after new with image' );

done_testing;

#reset the old video driver
if ($videodriver) {
    $ENV{SDL_VIDEODRIVER} = $videodriver;
}
else {
    delete $ENV{SDL_VIDEODRIVER};
}

