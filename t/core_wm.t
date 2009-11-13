#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

plan ( tests => 4 );

my @done =qw/ none /;

use_ok( 'SDL::WManagement' ); 

SKIP:
{
skip 'Not implemented', 1; 
can_ok ('SDL:WMangement', @done); 
}

my @left = qw/
get_wminfo
/;

my $why = '[Percentage Completion] '.int( 100 * ($#done+1) / ($#done + $#left +2 ) ) ."\% implementation.". ($#done +1) .' / '.($#done+$#left +2); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
	if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 


pass 'Are we still alive? Checking for segfaults';
