#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;

plan( tests => 4 );

my @done = qw/ none /;

use_ok('SDL::MultiThread');
SKIP:
{
	skip 'Not implemented', 1;

	can_ok( 'SDL::MultiThread ', @done );
}

my @left = qw/
	create_thread
	thread_id
	get_thread_id
	wait_thread
	kill_thread
	create_mutex
	destroy_mutex
	mutex_P
	mutex_V
	create_semaphore
	destroy_semaphore
	sem_wait
	sem_try_wait
	sem_wait_timeout
	sem_post
	sem_value
	create_cond
	destroy_cond
	cond_signal
	cond_broadcast
	cond_wait
	cond_wait_timeout
	/;

my $why =
	  '[Percentage Completion] '
	. int( 100 * $#done / ( $#done + $#left ) )
	. "\% implementation. $#done / "
	. ( $#done + $#left );

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n" . join ",", @left;
}
if   ( $done[0] eq 'none' ) { print '0% done 0/' . $#left . "\n" }
else                        { print "$why\n" }

pass 'Are we still alive? Checking for segfaults';
sleep(2);
