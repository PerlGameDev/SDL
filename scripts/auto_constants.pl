#!perl
use strict;
use warnings;

my $head_loc = `sdl-config --cflags`;
   $head_loc = (split ' ', $head_loc)[0];
   $head_loc =~ s/-I//;
print "# Getting header constants from $head_loc\n";


#my @header = <$head_loc/*>;
my @header = <$head_loc/SDL_events.h>;

my $is_enum  = 0;
my $enum_val = -1;

foreach (@header)
{
	print "\n# from $_:\n";
	open FH, $_;
	while(<FH>)
	{
		# found an enum
		if($_ =~ /^typedef\s+enum\s*{\s*$/)
		{
			$is_enum  = 1;
			$enum_val = -1;
			print("\n#{\n");
		}
		
		# closed enum
		if($is_enum && $_ =~ /^\s*}\s+(\w+)\s*;\s*$/)
		{
			$is_enum = 0;
			printf("#} enum %s\n\n", $1);
		}
	
		# inside an enum (without value)
		printf("sub %s{ return %s; }\n", $1, ++$enum_val)    if($is_enum && $_ =~ /^\s*(\w+)\s*,{0,1}\s*(\/.*){0,1}$/);
		
		# inside an enum (decimal)
		printf("sub %s{ return %s; }\n", $1, $enum_val = $2) if($is_enum && $_ =~ /^\s*(\w+)\s*=\s*(\d+)\s*,{0,1}.*$/i);
		
		# inside an enum (hex)
		printf("sub %s{ return %s; }\n", $1, $2)             if($is_enum && $_ =~ /^\s*(\w+)\s*=\s*(0x[\dA-F]+)\s*,{0,1}.*$/i);
		
		# inside an enum (function)
		printf("sub %s{ return %s; }\n", $1, $2)             if($is_enum && $_ =~ /^\s*(\w+)\s*=\s*([A-Z_\(\)\|]+)\s*,{0,1}.*$/i);
		
		# pattern: "#define SDL_RELEASED 0" (decimal or hex)
		printf("sub %s{ return %s; }\n", $1, $2)             if($_ =~ /^#define\s+([^_]\w+)\s+(\d+|0x[\dA-F]+)\s*$/i);
	}
	close FH;
}
