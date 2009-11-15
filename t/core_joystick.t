#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

my @done = qw//;

my @left = qw/
num_joysticks  
joystick_name  
joystick_open  
joystick_opened  
joystick_index  
joystick_num_axes  
joystick_num_balls  
joystick_num_hats  
joystick_num_buttons  
joystick_update  
joystick_get_axis  
joystick_get_hat  
joystick_get_button  
joystick_get_ball  
joystick_close 
/;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    fail "Not Implmented $_" foreach(@left)
    
}
diag $why;

done_testing;
