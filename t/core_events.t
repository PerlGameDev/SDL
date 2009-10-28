#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

plan ( tests => 4 );

my @done =qw/ none /;


SKIP:
{
skip 'Not implemented', 2; 
use_ok( 'SDL::Events' ); 
can_ok ('SDL::Events', @done); 
}

my @left = qw/
pumpevents 
peepevents 
pollevent 
waitevent 
pushevent 
seteventfilter 
eventstate 
getkeystate 
getmodstate 
setmodstate 
getkeyname 
enableunicode 
enablekeyrepeat 
getmousestate 
getrelativemousestate 
getappstate 
joystickeventstate 
StartTextInput 
StopTextInput 
SetTextInputRect 
/;

my $why = '[Percentage Completion] '.int( 100 * $#done / ($#done + $#left) ) ."\% implementation. $#done / ".($#done+$#left); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
	if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 


pass 'Are we still alive? Checking for segfaults';
