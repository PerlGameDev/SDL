#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

my @done = qw//;

my @left = qw/
audio_spec 
open_audio 
pause_audio 
get_audio_status 
load_wav 
free_wav 
audio_cvt 
build_audio_cvt 
convert_audio 
mix_audio 
lock_audio 
unlock_audio 
close_audio 
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
