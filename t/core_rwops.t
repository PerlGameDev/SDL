#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;
use SDL::RWOps;
my @done = qw//;

my @left = qw/
rw_from_file 
rw_from_fp 
rw_from_mem 
rw_from_const_mem 
alloc_rw 
free_rw 
rw_seek 
rw_tell 
rw_read 
rw_write 
rw_close 
rw_ops 
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
