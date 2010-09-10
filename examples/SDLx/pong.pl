use strict;
use warnings;
use Carp;
use SDL;
use SDL::Video;
use SDL::Surface;
use SDL::Rect;
use SDL::Event;
use SDL::Events;
use Data::Dumper;
use Math::Trig;

use lib 'lib';
use SDLx::Controller;

my $app = init();

my $paddle = {
	x     => 0,
	y     => 0,
	w     => 20,
	h     => 80,
	vel   => 250,
	y_vel => 0,
};

my $paddle2 = {
	x     => $app->w - 20,
	y     => 0,
	w     => 20,
	h     => 80,
	vel   => 250,
	y_vel => 0,
};

my $r_ball = {
	x     => $app->w / 2,
	y     => $app->w / 2,
	w     => 20,
	h     => 20,
	x_vel => (150),
	y_vel => (150),
};

sub ball_confine {
	my ( $w, $h, $x, $y, $ws, $hs ) = @_;

	my ( $m_x, $m_y ) = ( 1, 1 );
	$m_x = -1 if $x + $ws >= $w || $x <= 0;
	$m_y = -1 if $y + $hs >= $h || $y <= 0;

	return [ $m_x, $m_y ];
}

sub paddle_confine {

	#return if $_[0]->{y_vel} == 0;
	my ( $p, $dt, $h ) = @_;
	if ( $p->{y} < 0 ) {
		$p->{y} = 2;
		return;
	} elsif ( $p->{y} + $p->{h} + 2 > $h ) {
		$p->{y} = $h - $p->{h} - 2;
		return;
	}

	$p->{y} += $p->{y_vel} * $dt;
}

sub init {

	# Initing video
	# Die here if we cannot make video init
	croak 'Cannot init  ' . SDL::get_error()
		if ( SDL::init(SDL_INIT_VIDEO) == -1 );

	# Create our display window
	# This is our actual SDL application window
	my $a = SDL::Video::set_video_mode(
		800, 600, 32,
		SDL_HWSURFACE | SDL_DOUBLEBUF | SDL_HWACCEL
	);

	croak 'Cannot init video mode 800x600x32: ' . SDL::get_error()
		unless $a;

	return $a;
}

my $game = SDLx::Controller->new( dt => 0.1 );

sub on_move {
	my $dt = shift;
	$dt = $dt / 1000;
	paddle_confine( $paddle,  $dt, $app->h );
	paddle_confine( $paddle2, $dt, $app->h );

	# Period = $r_ball->{vel}

	# cc_speed = 2 * pi * r / T

	my $transform = ball_confine(
		$app->w,      $app->h,      $r_ball->{x},
		$r_ball->{y}, $r_ball->{w}, $r_ball->{h}
	);
	$r_ball->{x_vel} *= $transform->[0];
	$r_ball->{y_vel} *= $transform->[1];

	$r_ball->{x} += $r_ball->{x_vel} * $dt;
	$r_ball->{y} += $r_ball->{y_vel} * $dt;

	# "AI" for the other paddle
	if ( $r_ball->{y} > $paddle2->{y} ) {
		$paddle2->{y_vel} = $paddle2->{vel};
	} elsif ( $r_ball->{y} < $paddle2->{y} ) {
		$paddle2->{y_vel} = -1 * $paddle2->{vel};
	} else {
		$paddle2->{y_vel} = 0;
	}

	return 1;
}

sub on_event {
	my $event = shift;

	if ( $event->type == SDL_KEYDOWN ) {
		my $key = $event->key_sym;
		if ( $key == SDLK_PRINT ) {
			my $screen_shot_index = 1;
			map { $screen_shot_index = $1 + 1 if $_ =~ /Shot(\d+)\.bmp/ && $1 >= $screen_shot_index } <Shot*\.bmp>;
			SDL::Video::save_BMP(
				$app,
				sprintf( "Shot%04d.bmp", $screen_shot_index )
			);
		}
		$paddle->{y_vel} -= $paddle->{vel} if $key == SDLK_UP;
		$paddle->{y_vel} += $paddle->{vel} if $key == SDLK_DOWN;
		$r_ball->{rot_vel} += 50 if $key == SDLK_SPACE;

	} elsif ( $event->type == SDL_KEYUP ) {
		my $key = $event->key_sym;
		$paddle->{y_vel} += $paddle->{vel} if $key == SDLK_UP;
		$paddle->{y_vel} -= $paddle->{vel} if $key == SDLK_DOWN;
	} elsif ( $event->type == SDL_QUIT ) {
		return 0;
	}

	return 1;
}

#
# New subroutine "show_paddle" extracted - Thu Mar 18 15:28:02 2010.
#
sub show_paddle {
	my $app    = shift;
	my $paddle = shift;

	SDL::Video::fill_rect(
		$app,
		SDL::Rect->new(
			$paddle->{x}, $paddle->{y}, $paddle->{w}, $paddle->{h}
		),
		SDL::Video::map_RGB( $app->format, 0, 0, 255 )
	);

	return ();
}

sub on_show {
	SDL::Video::fill_rect(
		$app,
		SDL::Rect->new( 0, 0, $app->w, $app->h ),
		SDL::Video::map_RGB( $app->format, 0, 0, 0 )
	);

	show_paddle( $app, $paddle );

	show_paddle( $app, $paddle2 );

	SDL::Video::fill_rect(
		$app,
		SDL::Rect->new(
			$r_ball->{x}, $r_ball->{y}, $r_ball->{w}, $r_ball->{h}
		),
		SDL::Video::map_RGB( $app->format, 255, 0, 0 )
	);

	SDL::Video::flip($app);

	return 0;
}

my $move_id  = $game->add_move_handler( \&on_move );
my $event_id = $game->add_event_handler( \&on_event );
my $show_id  = $game->add_show_handler( \&on_show );

print <<'EOT';
In this example, you should see two blue rectangles in the edges
of the screen, and a red square bouncing by. This is a very simple
and incomplete clone of pong, where you control the left paddle
with the up and down keys, while the right paddle is controlled
by the computer. However, you'll soon notice the "ball" goes right
through both paddles, even though it bounces in the screen. In fact,
this demo confines both paddles and the bouncing square into the
screen.

As with the other example, "print screen" should work if your
system propagates it.

To exit the demo, just close the window normally.
EOT

$game->run();
