use strict;
use SDL;
use SDL::Rect;
use SDL::Color;
use SDL::Video;
use SDL::Surface;
use SDL::PixelFormat;
use SDL::Palette;
use Test::More;

use Data::Dumper;
use Devel::Peek;

 if (SDL::init(SDL_INIT_VIDEO) > 0)
 {
	 die 'Cannot init video'. SDL::get_error();
 }

my $hwdisplay = SDL::Video::set_video_mode(640,480,8, SDL_HWSURFACE );

my $surface = SDL::Video::convert_surface( $hwdisplay , $hwdisplay->format, 0);
isa_ok( $surface, 'SDL::Surface', '[convert_surface] makes copy of surface correctly'); 
warn SDL::get_error." \n";


done_testing;
