#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Surface;
use SDL::Config;
use Devel::Peek;
use Data::Dumper;
use Test::More;
use SDL::Rect;

plan ( tests => 10 );

use_ok( 'SDL::Video' ); 

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
	/;
can_ok ('SDL::Video', @done); 

#testing get_video_surface
SDL::Init(SDL_INIT_VIDEO);                                                                          
                                                                                                    
my $display = SDL::SetVideoMode(640,480,32, SDL_SWSURFACE );

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




my @left = qw/
	set_colors
	set_palette
	set_gamma
	get_gamma_ramp
	set_gmmma_ramp
	map_RGB
	map_RGBA
	get_RGB
	get_RGBA
	create_RGB_surface_from
	lock_surface
	unlock_surface
	convert_surface
	display_format
	display_format_alpha
	load_BMP
	save_BMP
	set_color_key
	set_alpha
	set_clip_rect
	get_clip_rect
	blit_surface
	fill_rect
	GL_load_library
	GL_get_proc_address
	GL_get_attribute
	GL_set_attribute
	GL_swap_buffers
	GL_attr
	lock_YUV_overlay
	unlock_YUV_overlay
	display_YUV_overlay
	/;

my $why = '[Percentage Completion] '.int( 100 * $#done / ($#done + $#left) ) ."\% implementation. $#done / ".($#done+$#left); 

TODO:
{
	local $TODO = 'Implementation not completed';
	pass $why."\nThe following functions:\n".join "\n", @left; 
}

