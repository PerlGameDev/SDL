#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

plan ( tests => 3 );

use_ok( 'SDL' ); 

my @done =qw/ none /;

#can_ok ('SDL', @done); 


my @left = qw/
	init
	init_sub_system
	quit_sub_system
	quit
	was_init
	get_error
	set_error
	error
	clear_error
	load_object
	load_function
	unload_fuction
	unload_object
	envvars
	VERSION
	linked_version
	version
	/;

my $why = '[Percentage Completion] '.int( 100 * $#done / ($#done + $#left) ) ."\% implementation. $#done / ".($#done+$#left); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
	if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 


pass 'Are we still alive? Checking for segfaults';
