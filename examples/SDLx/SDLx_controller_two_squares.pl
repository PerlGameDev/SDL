use strict;
use warnings;
use Carp;
use SDL ;
use SDL::Video ;
use SDL::Surface;
use SDL::Rect;
use SDL::Event;
use SDL::Events ;
use Data::Dumper;
use Math::Trig;

use lib 'lib';
use SDLx::Controller;

my $app = init();

my $ball = {
    x     => 0,
    y     => 0,
    w     => 20,
    h     => 20,
    vel   => 200,
    x_vel => 0,
    y_vel => 0,

};

my $r_ball = {
    x     => 0,
    y     => 0,
    w     => 20,
    h     => 20,
    radians => 0,
    rot_vel => 50,
    radius  => 100,
    c_x   => $app->w/2,
    c_y   => $app->h/2,
};

sub init {

    # Initing video
    # Die here if we cannot make video init
    croak 'Cannot init  ' . SDL::get_error()
      if ( SDL::init(SDL_INIT_VIDEO) == -1 );

    # Create our display window
    # This is our actual SDL application window
    my $a = SDL::Video::set_video_mode( 800, 600, 32,
        SDL_HWSURFACE | SDL_DOUBLEBUF | SDL_HWACCEL );

    croak 'Cannot init video mode 800x600x32: ' . SDL::get_error()
      unless $a;

    return $a;
}

my $game = SDLx::Controller->new();

sub on_move {
    my $dt = shift;
    $dt = $dt / 1000;
    $ball->{x} += $ball->{x_vel} * $dt;

    $ball->{y} += $ball->{y_vel} * $dt;
    
    # Period = $r_ball->{vel}
    # cc_speed = 2 * pi * r / T 
    $r_ball->{radians} += $r_ball->{rot_vel} * $dt;
    $r_ball->{x} = $r_ball->{c_x} + sin( $r_ball->{radians} * pi / 180 ) * $r_ball->{radius}; 
    $r_ball->{y} = $r_ball->{c_y} + cos( $r_ball->{radians} * pi / 180 ) * $r_ball->{radius};

    return 1;
}

sub on_event {
    my $event = shift;

    if ( $event->type == SDL_KEYDOWN ) {
        my $key = $event->key_sym;
		if($key == SDLK_PRINT)
		{
			my $screen_shot_index = 1;
			map{$screen_shot_index = $1 + 1 if $_ =~ /Shot(\d+)\.bmp/ && $1 >= $screen_shot_index} <Shot*\.bmp>;
			SDL::Video::save_BMP($app, sprintf("Shot%04d.bmp", $screen_shot_index ));
		}
        $ball->{y_vel} -= $ball->{vel} if $key == SDLK_UP;
        $ball->{y_vel} += $ball->{vel} if $key == SDLK_DOWN;
        $ball->{x_vel} -= $ball->{vel} if $key == SDLK_LEFT;
        $ball->{x_vel} += $ball->{vel} if $key == SDLK_RIGHT;
        $r_ball->{rot_vel} += 50 if $key == SDLK_SPACE;
     
    }
    elsif ( $event->type == SDL_KEYUP ) {
        my $key = $event->key_sym;
        $ball->{y_vel} += $ball->{vel} if $key == SDLK_UP;
        $ball->{y_vel} -= $ball->{vel} if $key == SDLK_DOWN;
        $ball->{x_vel} += $ball->{vel} if $key == SDLK_LEFT;
        $ball->{x_vel} -= $ball->{vel} if $key == SDLK_RIGHT;
        
    }
    elsif ( $event->type == SDL_QUIT ) {
        return 0;
    }

    return 1;
}

sub on_show {
    SDL::Video::fill_rect(
        $app,
        SDL::Rect->new( 0, 0, $app->w, $app->h ),
        SDL::Video::map_RGB( $app->format, 0, 0, 0 )
    );

    SDL::Video::fill_rect(
        $app,
        SDL::Rect->new( $ball->{x}, $ball->{y}, $ball->{w}, $ball->{h} ),
        SDL::Video::map_RGB( $app->format, 0, 0, 255 )
    );
    
    SDL::Video::fill_rect(
        $app,
        SDL::Rect->new( $r_ball->{x}, $r_ball->{y}, $r_ball->{w}, $r_ball->{h} ),
        SDL::Video::map_RGB( $app->format, 255, 0, 0 )
    );

    SDL::Video::flip($app);

    return 0;
}

my $move_id  = $game->add_move_handler( \&on_move );
my $event_id = $game->add_event_handler( \&on_event );
my $show_id  = $game->add_show_handler( \&on_show );

print <<'EOT';
In this example, you should see two small squares, one blue
and one red. The red square should move around in circles, while
you can control the blue one with the keyboard arrow keys.

Also, if you press the "print screen" key, it will save an image
called shot0001.bmp in your current dir. Pressing it again will
create a new screenshot file, with the index incremented. That is,
assuming your system will propagate the "print screen" event :)

To exit the demo, just close the window normally.
EOT
$game->run();
