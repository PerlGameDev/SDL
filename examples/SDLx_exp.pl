use SDL;
use SDL::Image;
use SDL::Video;
use SDL::Surface;
use SDLx::Surface;
use SDL::Rect;
#use Tie::Array;

use Devel::Peek;
use Data::Dumper;

# the size of the window box or the screen resolution if fullscreen
my $screen_width  = 800;
my $screen_height = 600;

#SDL::init(SDL_INIT_VIDEO);

# setting video mode
my $screen_surface =
  SDL::Surface->new( SDL_ANYFORMAT, 30, 30, 32, 0, 0, 0, 0);
     

#$s = SDL::Image::load('hero.png');
    my $mapped_color =
      SDL::Video::map_RGB( $screen_surface->format(), 0, 255, 0 );    # blue

        SDL::Video::fill_rect( $screen_surface,
        SDL::Rect->new( 0, 0, $screen_width, $screen_height ),
        $mapped_color );


my $surf32_matrix = SDLx::Surface::pixel_array($screen_surface);

my $d = sprintf( "#### %p %p", $surf32_matrix->[1]->[1], $surf32_matrix->[1][1]);
warn $d;
warn  "BEFORE \n";
foo();

warn "\nAFTER \n";
if ( SDL::Video::MUSTLOCK($screen_surface) ) {
    return if ( SDL::Video::lock_surface($screen_surface) < 0 );
}
# 
 my $green = pack 'l*', '11111111000000000000000000000000';
my $ref =$surf32_matrix->[0][0];
vec($$ref, 0, 32) = 0x34343434; 

 foo("vec direct");

substr($$ref, 0, 4) = pack('N', 0x33333333);  # OK
# 
 foo("substr pack");


SDL::Video::unlock_surface($screen_surface)
  if ( SDL::Video::MUSTLOCK($screen_surface) );




sub foo
{
  warn "AT (0,0) using $_[0] \n";
  print Dump $surf32_matrix->[0][0]; 
  warn unpack 'l*', $surf32_matrix->[0][0];
  
}
