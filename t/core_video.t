#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Color;
use SDL::Surface;
use SDL::Config;
use SDL::Overlay;
use Test::More;
use SDL::Rect;
use SDL::Video;

use lib 't/lib';
use SDL::TestTool;

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	   plan( skip_all => 'Failed to init video' );
}
else
{
	  plan( tests => 64);
}

my @done =
	qw/ 
	get_video_surface
	get_video_info
	video_driver_name
	list_modes
	set_video_mode
	video_mode_ok
	update_rect
	update_rects
	flip
	set_colors
	set_palette
	set_gamma
	set_gamma_ramp
	map_RGB
	map_RGBA
	unlock_surface
	lock_surface	
	convert_surface
	display_format
	display_format_alpha
	set_color_key
	set_alpha
	get_RGB
	get_RGBA
	load_BMP
	save_BMP
	fill_rect
	blit_surface
	set_clip_rect
	get_clip_rect
	lock_YUV_overlay
	unlock_YUV_overlay
	display_YUV_overlay
	GL_load_library
	GL_get_proc_address
	GL_get_attribute
	GL_set_attribute
	GL_swap_buffers
	get_gamma_ramp
	wm_set_caption
	wm_get_caption
	wm_set_icon
	wm_toggle_fullscreen
	wm_iconify_window
	wm_grab_input
	/;

can_ok ('SDL::Video', @done); 

#testing get_video_surface
#SDL::init(SDL_INIT_VIDEO);                                                                          

#needs to be done before set_video_mode
my $glVal = SDL::Video::GL_load_library('this/should/fail');

is ($glVal, -1, '[GL_load_library] Failed appropriately');

TODO: {
local $TODO = 'These should be tested with OS specific DLL or SO';
is (SDL::Video::GL_load_library('t/realGL.so'), 0, '[GL_load_libary] returns 0 on success');
# this gets set by GL_load_library => SDL_GL_LOADLIBARY. How do we get this from XS though?
# below t/realGL.so needs to use SDL_GL_LOADLIBRARY
isnt(SDL::Video::GL_get_proc_address('t/realGL.so'), NULL, '[GL_get_proc_address] returns not null on success');
is (SDL::Video::GL_set_attribute( SDL_GL_DOUBLEBUFFER, 1) , 0 , '[GL_set_attribute] returns 0 on success');
my $tdisplay = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );
my $value = -3;
SDL::Video::GL_set_attribute( SDL_GL_DOUBLEBUFFER, $value); 
is ($value  , 1 , '[GL_get_attribute] returns 1 on success as set above');

SDL::Video::GL_swap_buffers(); pass ( '[GL_swap_buffers] should work because Double Buffering is turned on');


};


my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );

if(!$display){
	 plan skip_all => 'Couldn\'t set video mode: '. SDL::get_error();
    }

#diag('Testing SDL::Video');

isa_ok(SDL::Video::get_video_surface(), 'SDL::Surface', '[get_video_surface] Checking if we get a surface ref back'); 

isa_ok(SDL::Video::get_video_info(), 'SDL::VideoInfo', '[get_video_info] Checking if we get videoinfo ref back');

my $driver_name = SDL::Video::video_driver_name();

pass '[video_driver_name] This is your driver name: '.$driver_name;



is( ref( SDL::Video::list_modes( $display->format , SDL_SWSURFACE )), 'ARRAY', '[list_modes] Returned an ARRAY! ');

cmp_ok(SDL::Video::video_mode_ok( 100, 100, 16, SDL_SWSURFACE), '>=', 0, "[video_mode_ok] Checking if an integer was return");

isa_ok(SDL::Video::set_video_mode( 100, 100 ,16, SDL_SWSURFACE), 'SDL::Surface', '[set_video_more] Checking if we get a surface ref back'); 


#TODO: Write to surface and check inf pixel in that area got updated.

SDL::Video::update_rect($display, 0, 0, 0, 0);

#TODO: Write to surface and check inf pixel in that area got updated.
SDL::Video::update_rects($display, SDL::Rect->new(0, 10, 20, 20));

my $value = SDL::Video::flip($display);
is( ($value == 0)  ||  ($value == -1), 1,  '[flip] returns 0 or -1'  );

SKIP:
{
	skip( "These negative test may cause older versions of SDL to crash", 2) unless $ENV{NEW_SDL};
$value = SDL::Video::set_colors($display, 0, SDL::Color->new(0,0,0));
is(  $value , 0,  '[set_colors] returns 0 trying to write to 32 bit display'  );
	
	$value = SDL::Video::set_palette($display, SDL_LOGPAL|SDL_PHYSPAL, 0);
 
is(  $value , 0,  '[set_palette] returns 0 trying to write to 32 bit surface'  );
}
SDL::delay(100);

my $zero = [0,0,0,0]; 
SDL::Video::set_gamma_ramp($zero, $zero, $zero);  pass '[set_gamma_ramp] ran';

my($r, $g, $b) = ([], [], []);
SDL::Video::get_gamma_ramp($r, $g, $b);
pass '[get_gamma_ramp] ran got '. @{$r} ;
is(@{$r}, 256, '[get_gamma_ramp] got 256 gamma ramp red back');
is(@{$g}, 256, '[get_gamma_ramp] got 256 gamma ramp green back');
is(@{$b}, 256, '[get_gamma_ramp] got 256 gamma ramp blue back');


SDL::Video::set_gamma( 1.0, 1.0, 1.0 ); pass '[set_gamma] ran ';

my @b_w_colors;

for(my $i=0;$i<256;$i++){
	$b_w_colors[$i] = SDL::Color->new($i,$i,$i);
      }
my $overlay =  SDL::Overlay->new(200 , 220, SDL_IYUV_OVERLAY, $display);  

is( SDL::Video::lock_YUV_overlay($overlay), 0, '[lock_YUV_overlay] returns a 0 on success');
SDL::Video::unlock_YUV_overlay($overlay); pass '[unlock_YUV_overlay] ran';
my $display_at_rect = SDL::Rect->new(0, 0, 100, 100);
is( SDL::Video::display_YUV_overlay( $overlay, $display_at_rect), 0 ,'[display_YUV_overlay] returns 0 on success'); 


my $hwdisplay = SDL::Video::set_video_mode(640,480,8, SDL_HWSURFACE );

if(!$hwdisplay){
	 plan skip_all => 'Couldn\'t set video mode: '. SDL::get_error();
    }

$value = SDL::Video::set_colors($hwdisplay, 0);
is(  $value , 0,  '[set_colors] returns 0 trying to send empty colors to 8 bit surface'  );

$value = SDL::Video::set_palette($hwdisplay, SDL_LOGPAL|SDL_PHYSPAL, 0);

is(  $value , 0,  '[set_palette] returns 0 trying to send empty colors to 8 bit surface'  );


$value = SDL::Video::set_colors($hwdisplay, 0, @b_w_colors);
is( $value , 1,  '[set_colors] returns '.$value  );

$value = SDL::Video::set_palette($hwdisplay, SDL_LOGPAL|SDL_PHYSPAL, 0, @b_w_colors );

is(  $value , 1,  '[set_palette] returns 1'  );

$value = SDL::Video::lock_surface($hwdisplay); pass '[lock_surface] ran returned: '.$value;

SDL::Video::unlock_surface($hwdisplay); pass '[unlock_surface] ran';

is( SDL::Video::map_RGB($hwdisplay->format, 10, 10 ,10) >= 0 , 1, '[map_RGB] maps correctly to 8-bit surface');
is( SDL::Video::map_RGBA($hwdisplay->format, 10, 10 ,10, 10) >= 0 , 1, '[map_RGBA] maps correctly to 8-bit surface');

TODO:
{

local $TODO =  "These test case test a very specific test scenario which might need to be re tought out ...";

isa_ok(SDL::Video::convert_surface( $display , $hwdisplay->format, SDL_SRCALPHA), 'SDL::Surface', '[convert_surface] Checking if we get a surface ref back'); 
isa_ok(SDL::Video::display_format( $display ), 'SDL::Surface', '[display_format] Returns a SDL::Surface');
isa_ok(SDL::Video::display_format_alpha( $display ), 'SDL::Surface', '[display_format_alpha] Returns a SDL::Surface');

}

is(  SDL::Video::set_color_key($display, SDL_SRCCOLORKEY, SDL::Color->new( 0, 10, 0 ) ),
   0,  '[set_color_key] Returns 0 on success' 
   ) ;

is(  SDL::Video::set_alpha($display, SDL_SRCALPHA, 100 ),
   0,  '[set_alpha] Returns 0 on success' 
   ) ;

is_deeply(SDL::Video::get_RGB($display->format, 0), [0,0,0], '[get_RGB] returns r,g,b');

is_deeply(SDL::Video::get_RGBA($display->format, 0), [0,0,0,255], '[get_RGBA] returns r,g,b,a');

my $bmp = 't/core_video.bmp';
unlink($bmp) if -f $bmp;
SDL::Video::save_BMP($display, $bmp);
ok(-f $bmp, '[save_BMP] creates a file');
my $bmp_surface = SDL::Video::load_BMP($bmp);
isa_ok($bmp_surface, 'SDL::Surface', '[load_BMP] returns an SDL::Surface');
unlink($bmp) if -f $bmp;

my $pixel = SDL::Video::map_RGB( $display->format, 255, 127, 0 );
SDL::Video::fill_rect( $display, SDL::Rect->new( 0, 0, 32, 32 ), $pixel );
ok( 1, '[fill_rect] filled rect' );

my $clip_rect = SDL::Rect->new(0, 0, 10, 20);
SDL::Video::get_clip_rect($display, $clip_rect);
is($clip_rect->x, 0, '[get_clip_rect] returns a rect with x 0');
is($clip_rect->y, 0, '[get_clip_rect] returns a rect with y 0');
is($clip_rect->w, 640, '[get_clip_rect] returns a rect with w 640');
is($clip_rect->h, 480, '[get_clip_rect] returns a rect with h 480');
SDL::Video::set_clip_rect($display, SDL::Rect->new(10, 20, 100, 200));
SDL::Video::get_clip_rect($display, $clip_rect);
is($clip_rect->x, 10, '[get_clip_rect] returns a rect with x 10');
is($clip_rect->y, 20, '[get_clip_rect] returns a rect with y 20');
is($clip_rect->w, 100, '[get_clip_rect] returns a rect with w 100');
is($clip_rect->h, 200, '[get_clip_rect] returns a rect with h 200');

my($title, $icon) = @{SDL::Video::wm_get_caption()};
is($title, undef, '[wm_get_caption] title is undef');
is($icon, undef, '[wm_get_caption] icon is undef');
SDL::Video::wm_set_caption('Title text', 'Icon text');
($title, $icon) = @{SDL::Video::wm_get_caption()};
is($title, 'Title text', '[wm_set_caption set title]');
is($icon, 'Icon text', '[wm_set_caption set icon]');

SDL::Video::wm_set_icon($bmp_surface);
pass '[wm_set_icon] ran';



SKIP:
{
	skip 'Turn on SDL_GUI_TEST', 6 unless $ENV{SDL_GUI_TEST};
SDL::Video::wm_grab_input(SDL_GRAB_ON);
pass '[wm_grab_input] ran with SDL_GRAB_ON';

is( SDL::Video::wm_grab_input(SDL_GRAB_QUERY), SDL_GRAB_ON, 
    '[wm_grab_input] Got Correct grab mode back');

SDL::Video::wm_grab_input(SDL_GRAB_OFF);
pass '[wm_grab_input] ran with SDL_GRAB_OFF';

is( SDL::Video::wm_grab_input(SDL_GRAB_QUERY), SDL_GRAB_OFF, 
    '[wm_grab_input] Got Correct grab mode back');

my $ic = SDL::Video::wm_iconify_window();
is( $ic, 1,'[wm_iconify_window] ran');

SDL::Video::wm_toggle_fullscreen($display);
pass '[wm_toggle_fullscreen] ran';
}

my @left = qw/
/;

my $why = '[Percentage Completion] '.int( 100 * ($#done +1) / ($#done + $#left + 2) ) ."\% implementation. ". ($#done +1)." / ".($#done+$#left + 2); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
	diag  $why;


pass 'Are we still alive? Checking for segfaults';

sleep(2);

