#!/usr/bin/env perl
#
# graywin.pl
#
#	adapted from SDL-1.2.x/test/graywin.c
#

use SDL;
use SDL::App;
use SDL::Rect;
use SDL::Event;
use SDL::Color;

my %options;

die <<USAGE if in($ARGV[0], qw/ -h --help -? /);
usage: $0 [-hw] [-fullscreen] [-width 640] [-height 480] [-bpp 24]
USAGE

for ( 0 .. @ARGV-1 )
{
	$options{$ARGV[$_]} = $ARGV[$_ + 1] || 1;
}

$options{-flags} = SDL_SWSURFACE;
$options{-flags} |= SDL_HWPALETTE if ( $options{-hw} );
$options{-flags} |= SDL_FULLSCREEN if ( $options{-fullscreen} );

$options{-title} = $0;

$options{-width} ||= 640;
$options{-height} ||= 480;
$options{-depth} ||= $options{-bpp} || 8;

my $app = new SDL::App %options;

sub DrawBox {
	my ($x,$y) = @_;

	my ($w, $h) = ( int(rand(640)), int(rand(480)) );
	
	my $rect = new SDL::Rect -width => $w, -height => $h, 
			-x => ($x - int($w/2)), -y => ($y - int($h/2));
	
	my $color = new SDL::Color -r => rand(256), -g => rand(256), -b => rand(256);

	$app->fill($rect,$color);
	$app->update($rect);
};

$app->loop( {
	SDL_MOUSEBUTTONDOWN() => sub { 
		my ($event) = @_; 
		DrawBox($event->button_x(),$event->button_y()); 
		},
	SDL_KEYDOWN() => sub { 
		my ($event) = @_;
		$app->warp($options{-width}/2,$options{-height}/2) 
			if ($event->key_sym() == SDLK_SPACE);
		$app->fullscreen()
			if ($event->key_sym() == SDLK_f);
		exit(0) if ($event->key_sym() == SDLK_ESCAPE);	
		},
	SDL_QUIT() => sub { exit(0); }
} );


