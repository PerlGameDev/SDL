#!/usr/bin/env perl

use SDL;
use SDL::Timer;

die "usage: $0\n" if in($ARGV[0], qw/ -? -h --help/);

SDL::Init(SDL_INIT_EVERYTHING());

print STDERR "Waiting 4 seconds\n";
SDL::Delay(4000);

$a = new SDL::Timer sub { my $timer = shift;
			  print STDERR "Timer A: $$timer{-times} runs\n" }, 
		-delay => 1000, 
		-times => 10;

$b = new SDL::Timer sub { print STDERR "Timer B: ", ++$i,"\n" }, -delay => 3000;
			
$c = new SDL::Timer sub { print STDERR "Timer C: restarting Timer A\n"; $a->run(1000,10) },
		-delay => 19000,
		-times => 1;

SDL::Delay(30000);

print STDERR "Cleaning up...\n";
SDL::Delay(300);

SDL::Quit();

