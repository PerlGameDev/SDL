#!/usr/bin/env perl
#

open XS, "< sdl_words.txt" or die "could not open sdl_words.txt\n";
open CPP, "| cpp `sdl-config --cflags` - > SDL.cx"
	or die "Could not pipe to cpp, $!\n";

print CPP <<HEADER;
#include <SDL.h>
#define TEXT_SOLID	1
#define TEXT_SHADED	2
#define TEXT_BLENDED	4
#define UTF8_SOLID	8
#define UTF8_SHADED	16	
#define UTF8_BLENDED	32
#define UNICODE_SOLID	64
#define UNICODE_SHADED	128
#define UNICODE_BLENDED	256

--cut--
HEADER

while (<XS>) {
	chomp();
	print CPP "#$_ $_\n";
	$words{$_} = 0;
}

close XS;
close CPP;

#
# ENUMS AREN'T CPPed we got to do this the hard way
#

open FP, "> sdl_const.c" or die "Could not write to sdl__const.c\n";

print FP <<HERE;
#include <SDL.h>
#include <SDL_image.h>
#include <SDL_mixer.h>
#include <SDL_ttf.h>
#include <SDL_net.h>
#include <smpeg/smpeg.h>
#define TEXT_SOLID	1
#define TEXT_SHADED	2
#define TEXT_BLENDED	4
#define UTF8_SOLID	8
#define UTF8_SHADED	16	
#define UTF8_BLENDED	32
#define UNICODE_SOLID	64
#define UNICODE_SHADED	128
#define UNICODE_BLENDED	256

int
main ( int argc, char **argv ) {

HERE

for ( grep { $words{$_} == 0 } keys %words ) {
	print FP <<THERE;
	fprintf(stdout,"sub main::$_ { \%i }\n", $_);
THERE

}

print FP <<HERE;
}
HERE

system("gcc `sdl-config --cflags --libs` -o sdl_const sdl_const.c");

my $enums;
open ENUMS, "./sdl_const |";
{
	local $/ = undef;
	$enums = <ENUMS>;
}
close ENUMS;

$goodstuff .= "\n$enums";

for ( split "\n", $goodstuff ) {
	if (/sub\s+main::([A-Za-z0-9_]+)/) {
		$words{$1} = 1;
	}
}

for ( keys %words ) {
	print STDERR "Failed to find $_\n" unless $words{$_};
}

(@words) = grep { $words{$_} == 1 } keys %words;

$words = join( " ", @words );

open CONST, "> ../lib/SDL/Constants.pm";

print CONST <<HERE;
# SDL::Constants
#
# This is an automatically generated file, don't bother editing.
# Names are read from a list in sdl_words.txt and written by sdl_const.pl.
#
# Copyright (C) 2003 David J. Goehrig <dave\@sdlperl.org>
#

package SDL::Constants;

$goodstuff

1;

HERE

system("rm -f SDL.cx sdl_const sdl_const.c");
