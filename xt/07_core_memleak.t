#!perl
use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Rect;

# Don't run tests for installs
use Test::More;

sub leaky() {

    SDL::Rect->new( 0, 0, 10, 10 );

}

eval 'use Test::Valgrind';
plan skip_all =>
  'Test::Valgrind is required to test your distribution with valgrind'
  if $@;

leaky();

sleep(2);
