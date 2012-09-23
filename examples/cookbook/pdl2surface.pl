#!/usr/bin/perl

use strict;
use warnings;
use SDL;
use SDL::Surface;
use SDLx::App;
use SDLx::Surface;
use PDL;
use Data::Dumper;

my $app = SDLx::App->new(
	title => "PDL and SDL aplication",
	width => 640, height => 640, eoq => 1
);

sub make_surface_piddle {
	my $piddle = rpic('SDL/test/data/picture.jpg');
	my ($bytes_per_pixel,$width,$height) = $piddle->dims;

	my $surface = SDLx::Surface->new( width => $width, height => $height, depth => 32 );

	SDL::Video::lock_surface($surface);

	my @pix = $piddle->list;
	my $y   = $height;
	my $x   = 0;
	while( my @p = splice( @pix, 0, 3 ) ) {
		unless( $x % $width ) {
			$x = 0;
			$y--;
		}
		$surface->set_pixel( $y, $x++, \@p );
	}

	SDL::Video::unlock_surface($surface);

	warn "Made surface of $width, $height and ". $surface->format->BytesPerPixel;

	return ( $piddle, $surface );
}

my ( $piddle, $surface ) = make_surface_piddle();

$app->add_show_handler( sub {
	$surface->blit( $app, [0,0,$surface->w,$surface->h], [10,10,0,0] );
	$app->update();
} );

$app->run();
