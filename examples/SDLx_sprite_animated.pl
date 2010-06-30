use strict;
use SDL;
use SDL::Video;
use SDL::Color;
use SDL::Rect;
use SDL::Surface;
use SDL::GFX::Rotozoom;

use SDLx::Sprite::Animated;



SDL::init(SDL_INIT_VIDEO);

my $disp = SDL::Video::set_video_mode( 300, 300, 32, SDL_ANYFORMAT);

my $pixel   = SDL::Video::map_RGB( $disp->format, 0, 0, 0 );
SDL::Video::fill_rect( $disp, SDL::Rect->new( 0, 0, $disp->w, $disp->h ), $pixel );


my $sprite = SDLx::Sprite::Animated->new;

 $sprite->load('test/data/hero.png');
 $sprite->alpha_key(SDL::Color->new(0xfc, 0x00, 0xff));
 $sprite->clip( SDL::Rect->new(48,0,48,48) );
 $sprite->step_y(48);

 $sprite->y(150);

 my $x = 0; my $ticks = 0;
 while ($x++ < 30) {
   SDL::Video::fill_rect( $disp, SDL::Rect->new( 0, 0, $disp->w, $disp->h ), $pixel );

     $sprite->x($x * 10);
     $sprite->draw($disp);

     $sprite->next;

     SDL::Video::update_rect($disp, 0, 0, 0, 0);

     SDL::delay( 100 );
 }

