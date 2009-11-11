#!perl
use strict;
use warnings;

my $head_loc = `sdl-config --cflags`;
   $head_loc = (split ' ', $head_loc)[0];
   $head_loc =~ s/-I//;
print "# Getting header constants from $head_loc\n";


my @header = qw/ SDL.h SDL_events.h /;

foreach (@header)
{
	print "# from $_:\n";
	open FH, "$head_loc/$_";
	while(<FH>)
	{
		if($_ =~ /#define SDL_/)
		{
			my $line = $_;
			my @cop = (split ' ', $line);
			print  'sub '.$cop[1].' {return '.$cop[2].'}'."\n" ;
		}
		
		# pattern: "#define SDL_RELEASED	0"
		printf("sub %s{ return %s; }\n", $1, $2) if($_ =~ /^#define\s+(\w+)\s+(\w+)\s*$/);
	}
	close FH;
}
