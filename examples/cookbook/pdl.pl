use strict;
use warnings;
use SDL 2.408;

use SDLx::App;    #this is in the github repo.
use SDL::Event;
use SDL::Events;
use SDL::Rect;
use SDL::Video;
use SDL::Surface;
use SDL::PixelFormat;
use SDL::Palette;
use SDL::Color;
use Devel::Peek;

use PDL;

my $app = SDLx::App->new(
    -title  => 'Application Title',
    -width  => 640,
    -height => 480,
    -depth  => 32
);
my $mapped_color = SDL::Video::map_RGB( $app->format(), 50, 50, 50 );    # blue

load_app();

my ( $piddle, $surface ) = surf_piddle();
my $ref = $surface->get_pixels_ptr();

my $event = SDL::Event->new;    # create a new event

while (1) {
    SDL::Events::pump_events();

    while ( SDL::Events::poll_event($event) ) {
        my $type = $event->type();    # get event type
        exit if $type == SDL_QUIT;
    }
    update($piddle);

    SDL::Video::update_rect( $app, 0, 0, $app->w, $app->h );
}

sub load_app {

    SDL::Video::fill_rect( $app, SDL::Rect->new( 0, 0, $app->w, $app->h ),
        $mapped_color );
    return $app;
}

sub surf_piddle {
    my ( $bytes_per_pixel, $width, $height ) = ( 4, 400, 200 );
    my $piddle  = zeros( byte, $bytes_per_pixel, $width, $height );
    my $pointer = $piddle->get_dataref();
    my $surface = SDL::Surface->new_from( $pointer, $width, $height, 32,
        $width * $bytes_per_pixel );

    warn "Made surface of $width, $height and "
      . $surface->format->BytesPerPixel;
    return ( $piddle, $surface );

}

sub update {
    my $piddle = shift;
    load_app();

    SDL::Video::lock_surface($surface);

    $piddle->mslice(
        'X',
        [ rand(400), rand(400), 1 ],
        [ rand(200), rand(200), 1 ]
    ) .= pdl( rand(225), rand(225), rand(255), 255 );

    SDL::Video::unlock_surface($surface);

    my $b = SDL::Video::blit_surface(
        $surface,
        SDL::Rect->new( 0, 0, $surface->w, $surface->h ),
        $app,
        SDL::Rect->new(
            ( $app->w - $surface->w ) / 2, ( $app->h - $surface->h ) / 2,
            $app->w, $app->h
        )
    );
    die "Could not blit: " . SDL::get_error() if ( $b == -1 );
}
