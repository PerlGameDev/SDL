#!perl
use strict;
use warnings;

my $head_loc = `sdl-config --cflags`;
   $head_loc = (split ' ', $head_loc)[0];
   $head_loc =~ s/-I//;
print "# Getting header constants from $head_loc\n";


my @header = <$head_loc/*>;

foreach (@header)
{
	print "# from $_:\n";
	open FH, $_;
	while(<FH>)
	{
		# pattern: "#define SDL_RELEASED 0" (decimal)
		printf("sub %s{ return %s; }\n", $1, $2) if($_ =~ /^#define\s+(\w+)\s+(\d+)\s*$/);
		
		# pattern: "#define SDL_RELEASED 0x1234" (hex)
		printf("sub %s{ return %s; }\n", $1, $2) if($_ =~ /^#define\s+(\w+)\s+(0x\d+)\s*$/);
	}
	close FH;
}
