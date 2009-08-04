#!/usr/bin/env perl

use SDL;
use SDL::App;
use SDL::Surface;
use SDL::Rect;
use SDL::Event;

my $menu = new SDL::Surface -name => 'data/menu.png';

my $app = new SDL::App -w => $menu->width(), -h => $menu->height(), -resizeable => 1;

my $hilight = new SDL::Surface -name => 'data/highlight.png';

my %menu = (
	'start' => [ 115, 30, 160, 40 ],
	'help' => [ 120, 100, 120, 40 ],
	'giveup' => [ 120, 230, 120, 40 ],
	'spawnserver' => [ 115, 170, 165, 40 ], 
	'credits' => [ 115, 285, 160, 40 ],
);

my $needblit;
sub drawMenu {
	my ($a,$dx,$dy,$no,$hi,%m) = @_;
	for (keys %m) {
		my ($x,$y,$w,$h) = @{$m{$_}};
		next unless $dx >= $x && $dx <= $x+$w
			 && $dy >= $y && $dy <= $y+$h;
		unless ($needblit) {
			my $rect = new SDL::Rect -w => $w, -h => $h, 
					 -x => $x, -y => $y;
			$hi->blit($rect,$a,$rect);
			$needblit = 1;
		}
		return $_;
	}
	$no->blit(NULL,$a,NULL) if $needblit;
	$needblit = 0;
	return 0;
}

sub help {
	print STDERR <<USAGE;
This should print a help message

USAGE

}

sub credits {
	print STDERR <<CREDITS;
David J. Goehrig

CREDITS

}

sub spawnserver {
	print STDERR <<SPAWN;
Spawinging new server...

SPAWN

}

sub start  {
	print STDERR <<START;
This should start the game

START

}

sub giveup {
	print STDERR <<GIVEUP;
Giving up

GIVEUP

	exit(0);
}

my %events = (
	SDL_MOUSEMOTION() =>  sub {
		my ($e) = @_;
		drawMenu($app,
			 $e->motion_x(),
			 $e->motion_y(),
			 $menu,
			 $hilight,
			 %menu);
	},
	SDL_MOUSEBUTTONUP() => sub {
		my ($e) = @_;
		my $routine = drawMenu($app,
			 $e->motion_x(),
			 $e->motion_y(),
			 $menu,
			 $hilight,
			 %menu);
		&{$routine} if ($routine);
	},
	SDL_QUIT() => sub { exit(0); },
	SDL_KEYDOWN() => sub { 
		my ($e) = @_;
		exit(0) if ($e->key_sym() == SDLK_ESCAPE);
	},
);

$menu->blit(NULL,$app,NULL);
$app->sync();
$app->loop(\%events);


