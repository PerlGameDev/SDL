#!perl
use strict;
use warnings;
use Carp;
use SDL;
use SDL::Rect;
use SDL::Config;
use SDL::Video;
use SDL::Surface;
use SDL::GFX::Rotozoom;

my $display = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );
my $pixel = SDL::Video::map_RGB( $display->format, 0, 0, 0 );
SDL::Video::fill_rect( $display,
    SDL::Rect->new( 0, 0, $display->w, $display->h ), $pixel );

croak SDL::get_error if !$display;

my $src = SDL::Video::load_BMP('test/data/picture.bmp');
my $temp_surf;

sub draw {
    SDL::Video::fill_rect( $display,
        SDL::Rect->new( 0, 0, $display->w, $display->h ), $pixel );

    my $surface = $_[0];
    SDL::Video::blit_surface(
        $surface, SDL::Rect->new( 0, 0, $surface->w, $surface->h ),
        $display, SDL::Rect->new( 0, 0, $display->w, $display->w )
    );

    SDL::Video::update_rect( $display, 0, 0, 640, 480 );

    SDL::delay( $_[1] ) if $_[1];

}

# Note: new surface should be less than 16384 in width and height
foreach ( 1 .. 360 ) {

    $temp_surf = SDL::GFX::Rotozoom::surface( $src, $_, $_ / 180, 1 );
    croak SDL::get_error if !$temp_surf;
    draw( $temp_surf, 2 );
}

$temp_surf = SDL::GFX::Rotozoom::surface_xy( $src, 1, 1, 1, 1 );
croak SDL::get_error if !$temp_surf;
draw( $temp_surf, 1000 );

$temp_surf = SDL::GFX::Rotozoom::zoom_surface( $src, 1, 1, 1 );
croak SDL::get_error if !$temp_surf;
draw( $temp_surf, 1000 );

$temp_surf = SDL::GFX::Rotozoom::shrink_surface( $src, 1, 1 );
croak SDL::get_error if !$temp_surf;
draw( $temp_surf, 1000 );

SDL::delay(1000);

