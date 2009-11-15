#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

my @done = qw//;

my @left = qw/
cd_num_drives
cd_name
cd_open
cd_status
cd_play
cd_play_tracks
cd_pause
cd_resume
cd_stop
cd_eject
cd_close
cd
cd_track
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
