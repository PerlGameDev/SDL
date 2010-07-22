use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDL::Color;
use SDLx::Sprite;
use lib 't/lib';
use SDL::TestTool;

can_ok(
	'SDLx::Sprite', qw( new rect clip load surface x y
		w h draw alpha_key)
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

my $sprite = SDLx::Sprite->new( width => 1, height => 1 );

# test initial values
#ok($sprite, 'object defined');
isa_ok( $sprite, 'SDLx::Sprite' );

my $rect = $sprite->rect;
ok( $rect, 'rect defined upon raw initialization' );
isa_ok( $rect, 'SDL::Rect', 'spawned rect isa SDL::Rect' );
is( $rect->x, 0, 'rect->x init' );
is( $rect->y, 0, 'rect->y init' );
is( $rect->w, 1, 'rect->w init' );
is( $rect->h, 1, 'rect->h init' );

my ( $x, $y ) = ( $sprite->x, $sprite->y );
is( $x, 0, 'no x defined upon raw initialization' );
is( $y, 0, 'no y defined upon raw initialization' );

my ( $w, $h ) = ( $sprite->w, $sprite->h );
is( $w, 1, 'w defined upon raw initialization' );
is( $h, 1, 'h defined upon raw initialization' );

isa_ok( $sprite->load('test/data/hero.bmp'), 'SDLx::Sprite', '[load] works' );

isa_ok(
	$sprite->alpha_key( SDL::Color->new( 0xfc, 0x00, 0xff ) ),
	'SDLx::Sprite', '[alpha] works'
);

isa_ok( $sprite->alpha(0xcc), 'SDLx::Sprite', '[alpha] integer works ' );

isa_ok( $sprite->alpha(0.3), 'SDLx::Sprite', '[alpha]  percentage works' );

done_testing;

#reset the old video driver
if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}
