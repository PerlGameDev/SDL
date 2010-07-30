#Because not all people have bash.
use strict;
use warnings;
use App::Ack;
use Perl::Tidy;
my @ack = `ack -f --perl`;

foreach (@ack) {
	chomp;
	print "Tidy $_ \n";
	`perltidy -b -pro=perltidyrc $_`;

	unlink "$_.bak" if $ARGV[0];
}

