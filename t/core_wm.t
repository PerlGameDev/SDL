#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

plan ( tests => 3 );

use_ok( 'SDL' ); 

my @done =qw/ none /;

#can_ok ('SDL', @done); 


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
