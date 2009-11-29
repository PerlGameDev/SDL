#!/usr/bin/perl -w
use strict;
use SDL;
use Test::More;
use SDL::Time;
use lib 't/lib';
use SDL::TestTool;

if ( !SDL::TestTool->init(SDL_INIT_TIMER) ) {
    plan( skip_all => 'Failed to init timer' );
} else {
    plan( tests => 5 );
}

my @done = qw/get_ticks
    delay/;




my $before = SDL::get_ticks();
like( $before, qr/^\d+$/, '[get_ticks] returns a number' );


SDL::delay(250);
my $after = SDL::get_ticks();
like( $after, qr/^\d+$/, '[get_ticks] returns a number again' );

my $diff = $after - $before;
ok( $diff > 50 && $diff < 300, '[delay](250) delayed for around 250ms' );


SKIP:
{
# local $TODO = 'Multithreaded callback almost working';
 skip 'segfault', 1;
 my $fired = 0;
 SDL::Time::add_timer( 1, sub { $fired++;  return $_[0] } );
 isnt( $fired  , 0, '[set_timer] ran' );
}

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
