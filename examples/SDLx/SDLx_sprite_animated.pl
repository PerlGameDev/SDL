use strict;
use SDL;
use SDL::Video;
use SDL::Color;
use SDL::Rect;

use SDLx::Sprite::Animated;

SDL::init(SDL_INIT_VIDEO);

my $disp = SDL::Video::set_video_mode( 300, 300, 32, SDL_ANYFORMAT );

my $pixel = SDL::Video::map_RGB( $disp->format, 0, 0, 0 );
SDL::Video::fill_rect(
	$disp, SDL::Rect->new( 0, 0, $disp->w, $disp->h ),
	$pixel
);

my $sprite = SDLx::Sprite::Animated->new(
	image           => 'test/data/hero.bmp',
	rect            => SDL::Rect->new( 48, 0, 48, 48 ),
	ticks_per_frame => 6,
);
$sprite->set_sequences( left => [ [ 1, 0 ], [ 1, 1 ], [ 1, 2 ] ], );
$sprite->alpha_key( SDL::Color->new( 0xff, 0x00, 0xff ) );
$sprite->sequence('left');
$sprite->start();
my $x     = 0;
my $ticks = 0;

while ( $x++ < 30 ) {
	SDL::Video::fill_rect(
		$disp, SDL::Rect->new( 0, 0, $disp->w, $disp->h ),
		$pixel
	);

	$sprite->x( $x * 10 );
	$sprite->next();
	$sprite->draw($disp);

	SDL::Video::update_rect( $disp, 0, 0, 0, 0 );

	SDL::delay(100);
}

