#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;
use Test::Trap;

plan ( tests => 4 );
my @done =qw/ none /;

SKIP:
{
	skip 'Not implemented', 2;
use_ok( 'SDL::Time' ); 
can_ok ('SDL::Time', @done); 
}

my @left = qw/
	add_timer
	delay
	get_ticks
	remove_timer
/;

my $why = '[Percentage Completion] '.int( 100 * $#done / ($#done + $#left) ) ."\% implementation. $#done / ".($#done+$#left); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
	if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 


pass 'Are we still alive? Checking for segfaults';
