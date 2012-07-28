package My::Builder::Unix;
use base 'My::Builder';
use Config;

if ( $^O eq 'cygwin' ) {
	my $ccflags = $Config{ccflags};
	$ccflags =~ s/-fstack-protector//;
	$My::Builder::config = { ld => 'gcc', cc => 'gcc', ccflags => $ccflags };
}

1;
