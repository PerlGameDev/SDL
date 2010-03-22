#!/usr/bin/env perl

use strict;
use SDL;
use SDL::App;
use SDL::Event;
use SDL::Tool::Font;
use SDL::Color;

my (%options,$app,$mode);

die "usage: $0 [-hw] [-fullscreen] [-width 640] [-height 480] [-bpp 24]\n"
	if ( SDL::in ($ARGV[0], qw/ -h -? --help/ ));

chdir 'test' if -d 'test';
die "$0 must be run in the SDL_perl/test/ directory!"
	unless (-d 'data');

for ( 0 .. @ARGV-1 )
{
	$options{$ARGV[$_]} = $ARGV[$_ + 1] || 1;
}

$options{-flags} = SDL_SWSURFACE;
$options{-flags} |= SDL_HWPALETTE if ( $options{-hw} );
$options{-flags} |= SDL_FULLSCREEN if ( $options{-fullscreen} );

$options{-title} = $0;

$options{-width}  ||= 800;
$options{-height} ||= 600;
$options{-depth} ||= $options{-bpp} || 24;

$app = new SDL::App  %options;

my %ttfonts = (
	'aircut3.ttf' => 0,
	'electrohar.ttf' => 0,
);

my %sfonts = (
	'24P_Arial_NeonYellow.png' => 0,
	'24P_Copperplate_Blue.png' => 0,
);

my @fonts;

for ( reverse keys %ttfonts ) {
	for $mode ( qw/ -normal -bold -italic -underline / ) {
		if (-e "data/$_") {
			print STDERR "Loading $_\n";
			$ttfonts{"$_$mode"} = new SDL::Tool::Font 
						$mode => 1,
						-ttfont => "data/$_", 
						-size => 20, 
						-fg => $SDL::Color::black,
						-bg => $SDL::Color::black;
			push @fonts,  $ttfonts{"$_$mode"};
		}
	}
}

%ttfonts = reverse %ttfonts;

for ( reverse keys %sfonts) {
	if (-e "data/$_") {
		print STDERR "Loading $_\n";
		$sfonts{$_} = new SDL::Tool::Font -sfont => "data/$_";
		push @fonts,  $sfonts{$_};
	}
}

%sfonts = reverse %sfonts;

sub DrawFonts {
	$app->fill(0,$SDL::Color::white);
	my ($x,$y) = @_;
	for my $font ( @fonts) {
		$font->print($app,$x,$y,"SDLperl font test. ",
			"This is " . ($ttfonts{$font} || $sfonts{$font}));
		$y += 40;
	}
	$app->flip();
}

DrawFonts(10,10);

$app->loop( {
	SDL_KEYDOWN() => sub { 
		my ($event) = @_;
		$app->warp($options{-width}/2,$options{-height}/2)  if ($event->key_sym() == SDLK_SPACE);
		$app->fullscreen() if ($event->key_sym() == SDLK_f);
		exit(0) if ($event->key_sym() == SDLK_ESCAPE);	
	},
	SDL_QUIT() => sub { exit(0); }
} );





