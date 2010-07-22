#!/usr/bin/perl -w
BEGIN { # http://wiki.cpantesters.org/wiki/CPANAuthorNotes
	use Config;
	if ( !$Config{'useithreads'} ) {
		print("1..0 # Skip: Perl not compiled with 'useithreads'\n");
		exit(0);
	}
}
use threads;
use threads::shared;
use strict;
use SDL;
use Test::More;
use SDL::Time;
use Config;

use lib 't/lib';
use SDL::TestTool;

if ( !SDL::TestTool->init(SDL_INIT_TIMER) ) {
	plan( skip_all => 'Failed to init timer' );
} else {
	plan( tests => 6 );
}

my @done = qw/get_ticks
	delay/;

my $before = SDL::get_ticks();
like( $before, qr/^\d+$/, '[get_ticks] returns a number' );

SDL::delay(250);
my $after = SDL::get_ticks();
like( $after, qr/^\d+$/, '[get_ticks] returns a number again' );

my $diff = $after - $before;
ok( $diff > 100 && $diff < 400, '[delay](250) delayed for ' . $diff . 'ms' );

my $fired : shared = 0;

sub fire { $fired++; return 100 }

my $id = SDL::Time::add_timer( 101, 'main::fire' );

sleep(2);
is( SDL::Time::remove_timer($id), 1, "[remove_timer] removed $id timer" );
isnt( $fired, 0, '[add_timer] ran ' . $fired );

my @left = qw/set_timer new_timer_callback add_timer remove_timer/;

my $why =
	  '[Percentage Completion] '
	. int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
	. "\% implementation. "
	. ( $#done + 1 ) . " / "
	. ( $#done + $#left + 2 );

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n" . join ",", @left;
}
print "$why\n";

sleep(2);
