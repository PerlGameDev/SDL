#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;
use SDL::Mouse;
use SDL::Cursor;
use SDL::Surface;

my @done = 
qw/
/;

can_ok ('SDL::Video', @left); #change to @done later ... after tests


my @left = qw/
warp_mouse
create_cursor 
free_cursor 
set_cursor 
get_cursor 
show_cursor 
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
