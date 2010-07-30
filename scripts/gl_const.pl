#!/usr/bin/env perl
#

open XS,  "< opengl_words.txt";
open CPP, "| cpp - > OpenGL.cx";

print CPP <<HEADER;
#include <GL/gl.h>
#include <GL/glu.h>

--cut--
HEADER

while (<XS>) {
	chomp();
	print CPP "#$_ $_\n";
	$words{$_} = 0;
}

close XS;
close CPP;

my $text;
open FP, "< OpenGL.cx"
	or die "Couldn't open OpenGL.cx\n";
{
	local $/ = undef;
	$text = <FP>;
}

my ( $junk, $goodstuff ) = split "--cut--", $text;

$goodstuff =~ s/#(GL[U]?_[A-Z0-9_]+)\s+([0-9xa-fA-F]+)/sub main::$1 { $2 }/g;

for ( split "\n", $goodstuff ) {
	if (/sub main::(GL[U]?_[A-Z0-9_]+)/) {
		push @words, $1;
	}
}

for (@words) {
	$words{$_} = 1;
}

for ( keys %words ) {
	print STDERR "Failed to find word $_" unless ( $words{$_} );
}

open OGL, "> ../lib/SDL/OpenGL/Constants.pm";

$words = join( " ", @words );

print OGL <<HERE;
# SDL::OpenGL::Constants
#
# This is an autogenerate file, don't bother editing.
# Names are read from a list in opengl_words.txt and written by gl_const.pl.
#
# Copyright (C) 2003 David J. Goehrig <dave\@sdlperl.org>

package SDL::OpenGL::Constants;

$goodstuff

1;

HERE

system("rm OpenGL.cx");
