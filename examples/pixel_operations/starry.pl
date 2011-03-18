use strict;
use warnings;
use SDL;
use SDL::Rect;
use SDL::Event;
use SDL::Events;
use SDL::Image;
use SDL::Surface;
use SDLx::Surface;
use SDLx::App;

my $app = SDLx::App->new( width => 300, height => 400, depth => 32 );

my $quit  = 0;
my $rot   = 0;
my $event = SDL::Event->new();
my @stars = ();

foreach ( 0 .. 40 ) {
	my $x     = rand( $app->w );
	my $y     = rand( $app->h );
	my $speed = rand(4) + 1;

	push( @stars, { x => $x, y => $y, speed => $speed } );
}

my $display_matrix = SDLx::Surface->new( surface => $app );

while ( !$quit ) {

	SDL::Events::pump_events();
	while ( SDL::Events::poll_event($event) ) {
		$quit = 1 if $event->type == SDL_QUIT;
		if ( $event->type == SDL_KEYDOWN
			|| ( $event->key_sym && $event->type != SDL_KEYUP ) )
		{
			$rot += 0.1 if $event->key_sym == SDLK_UP;
			$rot -= 0.1 if $event->key_sym == SDLK_DOWN;

		}
	}

	my @update_rects = ();

	foreach (@stars) {

		$display_matrix->[ $_->{x} ][ $_->{y} ] = 0xFF000000;

		$_->{x} += $_->{speed};
		$_->{y} += $_->{speed} * $rot;
		$_->{x} = 0       if ( $_->{x} >= $app->w );
		$_->{y} = 0       if ( $_->{y} >= $app->h );
		$_->{x} = $app->w if ( $_->{x} < 0 );
		$_->{y} = $app->h if ( $_->{y} < 0 );

		$display_matrix->[ $_->{x} ][ $_->{y} ] = 0xFFFFFFFF;

		#		push @update_rects, SDL::Rect->new($_->{x}, $_->{y}, 2, 2);

	}

	$display_matrix->update();

}

