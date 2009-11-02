#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Video;
use Test::More;

plan ( tests => 9 );
my @done =qw/ 
	init
	quit
	was_init
	get_error
	  /;

use_ok( 'SDL' ); 
can_ok ('SDL', @done); 

is( SDL::init(SDL_INIT_VIDEO), 0, '[init] returns 0 on success');

is( SDL::was_init( 0 ), SDL_INIT_VIDEO, '[was_init] recognizes turned on flags');

my $display =  SDL::Video::set_video_mode(640,480,232, SDL_SWSURFACE );

isnt( SDL::get_error(), '', '[get_error] got error '.SDL::get_error() );

SDL::quit(); pass '[quit] SDL quit with out segfaults or errors';

isnt( SDL::was_init( 0 ), SDL_INIT_VIDEO, '[was_init] recognizes turned off flags');


my @left = qw/
	init_sub_system
	quit_sub_system
	set_error
	error
	clear_error
	load_object
	load_function
	unload_fuction
	unload_object
	envvars
	linked_version
	version
	Version
	/;

my $why = '[Percentage Completion] '.int( 100 * $#done / ($#done + $#left) ) ."\% implementation. $#done / ".($#done+$#left); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
	if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 


pass 'Are we still alive? Checking for segfaults';
