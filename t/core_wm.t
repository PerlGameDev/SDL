#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

plan ( tests => 4 );

my @done =qw/ none /;


SKIP:
{
skip 'Not implemented', 2; 
use_ok( 'SDL::WM' ); 
can_ok ('SDL:WM', @done); 
}

my @left = qw/
get_wminfo
set_caption 
get_caption 
set_icon 
iconify_window 
toggle_fullscreen 
grab_input 	
/;

my $why = '[Percentage Completion] '.int( 100 * $#done / ($#done + $#left) ) ."\% implementation. $#done / ".($#done+$#left); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
	if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 


pass 'Are we still alive? Checking for segfaults';
