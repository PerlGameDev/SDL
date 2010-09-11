package SDL::Tutorial::Sol::Two;
use strict;
use warnings;
use Carp;

use SDL v2.3;
use SDL::Video;
use SDL::Event;
use SDL::Events;
use SDL::Surface;

my $screen;

sub putpixel {
	my ( $x, $y, $color ) = @_;
	my $lineoffset = $y * ( $screen->pitch / 4 );
	$screen->set_pixels( $lineoffset + $x, $color );
}

sub render {
	if ( SDL::Video::MUSTLOCK($screen) ) {
		return if ( SDL::Video::lock_surface($screen) < 0 );
	}

	my $ticks = SDL::get_ticks();
	my ( $i, $y, $yofs, $ofs ) = ( 0, 0, 0, 0 );
	for ( $i = 0; $i < 480; $i++ ) {
		for ( my $j = 0, $ofs = $yofs; $j < 640; $j++, $ofs++ ) {
			$screen->set_pixels( $ofs, ( $i * $i + $j * $j + $ticks ) );
		}
		$yofs += $screen->pitch / 4;
	}

	putpixel( 10, 10, 0xff0000 );
	putpixel( 11, 10, 0xff0000 );
	putpixel( 10, 11, 0xff0000 );
	putpixel( 11, 11, 0xff0000 );

	SDL::Video::unlock_surface($screen) if ( SDL::Video::MUSTLOCK($screen) );

	SDL::Video::update_rect( $screen, 0, 0, 640, 480 );

	return 0;
}

sub main {
	Carp::cluck 'Unable to init SDL: ' . SDL::get_error()
		if ( SDL::init(SDL_INIT_VIDEO) < 0 );

	$screen = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );

	Carp::cluck 'Unable to set 640x480x32 video' . SDL::get_error() if ( !$screen );

	while (1) {

		render();

		my $event = SDL::Event->new();

		while ( SDL::Events::poll_event($event) ) {
			my $type = $event->type;
			return 0 if ( $type == SDL_KEYDOWN );
			return 0 if ( $type == SDL_QUIT );

		}
		SDL::Events::pump_events();

	}

}

main;

SDL::quit;

