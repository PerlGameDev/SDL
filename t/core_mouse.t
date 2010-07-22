#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;
use SDL::Mouse;
use SDL::Cursor;
use SDL::Surface;

my @done = qw/
	/;

my @left = qw/
	warp_mouse
	set_cursor
	get_cursor
	show_cursor
	/;
can_ok( 'SDL::Mouse',  @left );          #change to @done later ... after tests
can_ok( 'SDL::Cursor', qw/new DESTROY/ );

my $why =
	  '[Percentage Completion] '
	. int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
	. "\% implementation. "
	. ( $#done + 1 ) . " / "
	. ( $#done + $#left + 2 );

TODO:
{
	local $TODO = $why;
	fail "Not Implmented $_" foreach (@left)

}
print "$why\n";

done_testing;
sleep(2);
