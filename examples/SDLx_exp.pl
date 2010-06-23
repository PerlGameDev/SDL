use SDL;
use SDL::Image;
use SDL::Video;
use SDL::Surface;
use SDLx::Surface;
use SDL::Rect;

use Devel::Peek;
use Data::Dumper;

# the size of the window box or the screen resolution if fullscreen
my $screen_width  = 800;
my $screen_height = 600;

SDL::init(SDL_INIT_VIDEO);

# setting video mode
my $screen_surface =
  SDL::Video::set_video_mode( $screen_width, $screen_height, 32,
    SDL_ANYFORMAT );

#$s = SDL::Image::load('hero.png');
    my $mapped_color =
      SDL::Video::map_RGB( $screen_surface->format(), 0, 0, 255 );    # blue

       SDL::Video::fill_rect( $screen_surface,
        SDL::Rect->new( 0, 0, $screen_width, $screen_height ),
        $mapped_color );



clear();



my $surf32_matrix = SDLx::Surface::pixel_array($screen_surface);

print Dump $surf32_matrix->[1][1]; 
print "\n";
print unpack 'L', $surf32_matrix->[1][1]; 



foreach(0..100) {
if ( SDL::Video::MUSTLOCK($screen_surface) ) {
    return if ( SDL::Video::lock_surface($screen_surface) < 0 );
}
	  
	  ${$surf32_matrix->[$_][$_]} = pack 'L', 0x000000FF;

	  print unpack 'L', $surf32_matrix->[$_][$_];

	SDL::Video::unlock_surface($screen_surface) if ( SDL::Video::MUSTLOCK($screen_surface) );

	clear();
	SDL::delay(10);
 }



sub clear {

    # drawing something somewhere
#    SDL::Video::blit_surface( $s, SDL::Rect->new( 0, 0, $s->w, $s->h), $screen_surface, SDL::Rect->new( 0, 0, $screen_width, $screen_height ));
    # update an area on the screen so its visible
    SDL::Video::update_rect( $screen_surface, 0, 0, $screen_width, $screen_height );

}



clear();


