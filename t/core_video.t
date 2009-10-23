#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;
use Devel::Peek;
use Test::More;

plan ( tests => 6 );

use_ok( 'SDL::Video' ); 
  
can_ok ('SDL::Video', qw/
	get_video_surface
	get_video_info
	video_driver_name
	list_modes
	/);

#testing get_video_surface
SDL::Init(SDL_INIT_VIDEO);                                                                          
                                                                                                    
my $display = SDL::SetVideoMode(640,480,32, SDL_SWSURFACE );

diag('Testing SDL::Video');

isa_ok(SDL::Video::get_video_surface(), 'SDL::Surface', '[get_video_surface] Checking if we get a surface ref back'); 

isa_ok(SDL::Video::get_video_info(), 'SDL::VideoInfo', '[get_video_info] Checking if we get videoinfo ref back');

my $driver_name = SDL::Video::video_driver_name();

pass '[video_driver_name] This is your driver name: '.$driver_name;

#Dump( SDL::Video::video_driver_name() );

pass "Are we still alive?";

=skip
	video_mode_ok
	set_video_mode
	update_rect
	update_rects
	flip
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
	/);

