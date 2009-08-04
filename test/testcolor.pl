#!/usr/bin/env perl
#

use SDL;
use SDL::App;
use SDL::Event;

use vars qw/ $app /;

print STDERR <<USAGE;
	Right click on any pixel to get its color values
	Left click on any pixel to set its value to the last selected
USAGE

$app = new SDL::App -width => 320, -height => 240, -depth => 8;

my %colors = (
	red => (new SDL::Color -r => 255, -g => 0, -b => 0 ),
	green => (new SDL::Color -r => 0, -g => 255, -b => 0),
	blue => (new SDL::Color -r => 0, -g => 0, -b => 255),
	yellow => (new SDL::Color -r => 255, -g => 255, -b => 0),
	purple => (new SDL::Color -r => 255, -g => 0, -b => 255),
	white => (new SDL::Color -r => 255, -g => 255, -b => 255)
);


$x = 0; $y = 0;
$rect = new SDL::Rect -x => $x, -y => $y, 
	-w => $app->width / scalar(keys %colors), -h => $app->height();

print "Sorted colors:\n";

for ( sort keys %colors ) {
	print "$_ " . join (",",$colors{$_}->r(), $colors{$_}->g(), 
		$colors{$_}->b()) . "\n";
}

for ( sort keys %colors ) {
	$rect->x($x);
	$x += $rect->width();
	$app->fill($rect,$colors{$_});
}

$app->sync();

$last = new SDL::Color -r => 128, -g => 128, -b => 128;

$app->sync();
$app->loop( {
	SDL_QUIT() => sub { exit(0); },
	SDL_KEYDOWN() => sub { $app->fullscreen(); },
	SDL_MOUSEBUTTONDOWN() => sub { 
		my $e = shift; 
		if ($e->button == 3) {
			$last = $app->pixel($e->button_x(),$e->button_y());
			print STDERR "X: ", $e->button_x(), " Y: ", $e->button_y(), 
				" R: ", $last->r(), " G: ", $last->g(), 
				" B: ", $last->b(), "\n";
		} else {
			$app->pixel($e->button_x(),$e->button_y(),$last);
		}
	},
});
