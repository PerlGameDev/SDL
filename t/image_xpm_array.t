#!/usr/bin/perl -Iblib/lib -Iblib -Iblib/arch
#

use SDL;
use SDL::Config;
use SDL::Rect;
use SDL::Video;
use SDL::Image;
use SDL::Surface;

use Test::More;
use lib 't/lib';
use SDL::TestTool;
if( !SDL::TestTool->init(SDL_INIT_VIDEO))
{
    plan( skip_all => 'Failed to init video' );
}
elsif( !SDL::Config->has('SDL_image') )
{
    plan( skip_all => 'SDL_image support not compiled' );
}


my $screen_width   = 800;
my $screen_height  = 600;

SDL::init(SDL_INIT_VIDEO);


# setting video mode
my $screen = SDL::Video::set_video_mode($screen_width, $screen_height, 32, SDL_SWSURFACE);
#
#

my @test= (
'30 30 9 1'."\n",
' 	c #FFFFFF'."\n",
'.	c #EFEFEF'."\n",
'+	c #CFCFCF'."\n",
'@	c #9F9F9F'."\n",
'#	c #808080'."\n",
'$	c #505050'."\n",
'%	c #202020'."\n",
'&	c #000000'."\n",
'*	c #303030'."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'           .+@##@+.           '."\n",
'          .@$%&&%$@.          '."\n",
'         .@*&&&&&&*@.         '."\n",
'         +$&&&&&&&&$+         '."\n",
'         @%&&&&&&&&%@         '."\n",
'         #&&&&&&&&&&#         '."\n",
'         #&&&&&&&&&&#         '."\n",
'         @%&&&&&&&&%@         '."\n",
'         +$&&&&&&&&$+         '."\n",
'         .@*&&&&&&*@.         '."\n",
'          .@$%&&%$@.          '."\n",
'           .+@##@+.           '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
'                              '."\n",
);


my $mapped_color   = SDL::Video::map_RGB($screen->format(), 43, 43, 255); #
SDL::Video::fill_rect(  $screen,
			SDL::Rect->new(0, 0,
			$screen->w, $screen->h), $mapped_color);


my $picture = SDL::Image::read_XPM_from_array(\@test);



warn SDL::get_error."\n" if(!$picture);
SKIP:
{
	skip "picture not comming from XPM", 1 unless $picture;
 SDL::Video::blit_surface( $picture, SDL::Rect->new(0, 0, $picture->w, $picture->h),
		           $screen,  SDL::Rect->new(0, 0, $screen->w,  $screen->h) );



SDL::Video::flip( $screen);

pass 'ok';
SDL::delay(1000);
}
done_testing;
