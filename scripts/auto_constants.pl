#!perl
use strict;
use warnings;

my $head_loc = `sdl-config --cflags`;
$head_loc = ( split ' ', $head_loc )[0];
$head_loc =~ s/-I//;
print "# Getting header constants from $head_loc\n";

my @header = <$head_loc/*.h>;

my $is_enum    = 0;
my $is_comment = 0;
my $enum_val   = -1;
my $line       = '';
my @names      = ();
my @values     = ();
my $maxNameLen = 0;

foreach (@header) {

	#print "\n# from $_:\n";
	open( FH, $_ ) || die "Can not open file $_: $!";
	while (<FH>) {
		$_ =~ s/\/\*.*\*\///g;
		$_ =~ s/\/\/.*$//g;
		$_ =~ s/^\s+//;
		$_ =~ s/\s+$//;

		#print $_;

		if ( $_ =~ /\/\*/ ) {
			$line .= $_;
			$line =~ s/\/\*.*//;
			$is_comment = 1;

			#print(__LINE__);
		}

		if ( $is_comment && $_ =~ /\*\// ) {
			$_ =~ s/.*\*\///;
			$line .= $_;

			#print "heureka$line";
			$is_comment = 0;

			#print(__LINE__);
			next;
		}

		next if ( $is_comment && $_ !~ /\*\// );

		# if we are inside an enum, and there is an linebreak in value
		if (   $is_enum
			&& $line !~ /,\s*$/
			&& $_ !~ /,\s*$/
			&& $_ !~ /^\s*}\s+(\w+)\s*;\s*$/
			&& $line !~ /^typedef\s+enum\s*{\s*$/ )
		{
			$line .= $_;

			#$line =~ s/\s+/ /g;

			next;
		}

		#elsif($is_enum && $line !~ /,\s*$/ && $_ =~ /,\s*$/ && $_ !~ /^\s*}\s+(\w+)\s*;\s*$/ && $line !~ /^typedef\s+enum\s*{\s*$/)
		elsif ($is_enum
			&& $line !~ /,\s*$/
			&& $_ =~ /,\s*$/
			&& $line !~ /^typedef\s+enum\s*{\s*$/ )
		{
			$line .= $_;

			#print(__LINE__);
			#make_constant($line);
			#$line =~ s/\s+/ /g;
		} elsif ( $is_enum && $line !~ /,\s*$/ && $_ =~ /^\s*}\s+(\w+)\s*;\s*$/ ) {

			#print(__LINE__);
			make_constant($line);

			#print(__LINE__);
			make_constant($_);
			$line = $_;

			#next;
		}

		#		elsif($is_enum && $_ =~ /,\s*$/)
		#		{
		#			print(__LINE__); make_constant($_);
		#			$line = $_;
		#		}
		#else
		{

			#print(__LINE__);
			make_constant($line);
			$line = $_;
		}

		#make_constant($line);
	}

	close FH;
}

for ( my $i = 0; $i < $#names; $i++ ) {
	print("use constant {\n") unless $i;

	print("};\n\nuse constant {\n")
		if 'enum' eq $names[$i] && 'open' eq $values[$i];

	print("}; # $values[$i]\n\nuse constant {\n")
		if 'enum' eq $names[$i] && 'open' ne $values[$i];

	printf( "\t%-" . $maxNameLen . "s => %s,\n", $names[$i], $values[$i] )
		if 'CRAP!' ne $values[$i] && 'enum' ne $names[$i];

	print("};\n") if ( $i == $#names - 1 );
}

sub make_constant {
	my $_line = shift;
	my $name  = '';
	my $value = '';

	# found an enum
	if ( $_line =~ /^typedef\s+enum\s*{\s*$/ ) {
		$is_enum  = 1;
		$enum_val = -1;
		push( @names,  'enum' );
		push( @values, 'open' );
	}

	# closed enum
	if ( $is_enum && $_line =~ /^\s*}\s+(\w+)\s*;\s*$/ ) {
		$is_enum = 0;
		push( @names,  'enum' );
		push( @values, $1 );
	}

	# inside an enum (without value)
	if ( $is_enum && $_line =~ /^\s*(\w+)\s*,{0,1}\s*$/ ) {
		$name  = $1;
		$value = ++$enum_val;
	}

	# inside an enum (decimal)
	if ( $is_enum && $_line =~ /^\s*(\w+)\s*=\s*([+-]{0,1}\d+)\s*,{0,1}\s*$/i ) {
		$name     = $1;
		$value    = $2;
		$enum_val = $2;
	}

	# inside an enum (hex)
	if ( $is_enum && $_line =~ /^\s*(\w+)\s*=\s*(0x[\dA-F]+)\s*,{0,1}\s*$/i ) {
		$name  = $1;
		$value = $2;
	}

	# inside an enum (function)
	if ( $is_enum && $_line =~ /^\s*(\w+)\s*=\s*([\w\(\)\|]+)\s*,{0,1}\s*$/i ) {
		$name  = $1;
		$value = $2;
	}

	# pattern: "#define SDL_RELEASED 0" (decimal or hex or name)
	if ( $_line =~ /^#define\s+([^_]\w+)\s+([+-]{0,1}\d+|0x[\dA-F]+|[\w\(\)\|]+)\s*$/i ) {
		$name  = $1;
		$value = $2;
	}

	if ( $name !~ /^(_.*||[a-z_]+)$/ && $value !~ /^(_.*||[a-z_]+)$/ ) {
		my $index = index_of( $name, @names );

		if ( $index >= 0 && $name ne 'enum' ) {
			$values[$index] = 'CRAP!' if $value ne $values[$index];
		} else {
			while ( $value =~ /(\w*)/g ) {
				my $index2 = index_of( $1, @names );

				if ( $index2 >= 0 ) {
					$value =~ s/$1/$values[$index2]/;
				}
			}

			$maxNameLen = length($name) if $maxNameLen < length($name);
			push( @names,  $name );
			push( @values, $value );
		}
	}

}

sub index_of {
	my $needle = shift;
	my @array  = @_;

	for ( my $i = 0; $i <= $#array; $i++ ) {
		return $i if $needle eq $array[$i];
	}

	return -1;
}
