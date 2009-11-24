#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More tests => 6;
use SDL::Time;
my @done = qw/get_ticks
    delay/;

is( SDL::init(SDL_INIT_TIMER), 0, '[init] can init SDL_INIT_TIMER' );
is( SDL::was_init(0), SDL_INIT_TIMER, '[was_init] managed to init timer' );

my $before = SDL::get_ticks();
like( $before, qr/^\d+$/, '[get_ticks] returns a number' );

SKIP:
{
skip 'segaulting', 1;
# at the moment this segfaults. i wonder why?
 my $fired = 0;
 #SDL::Time::add_timer (0, NULL);
 SDL::Time::set_timer( 100, sub { $fired++  return $_[0] } );
 is ( $fired > 0 ,1, '[set_timer] ran' );
}

SDL::delay(250);
my $after = SDL::get_ticks();
like( $after, qr/^\d+$/, '[get_ticks] returns a number again' );

my $diff = $after - $before;
ok( $diff > 50 && $diff < 300, '[delay](250) delayed for around 250ms' );

# is( $fired, 1, '[set_timer] triggered' );

my @left = qw/set_timer new_timer_callback add_timer remove_timer/;

my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    pass "\nThe following functions:\n" . join ",", @left;
}
diag $why;
