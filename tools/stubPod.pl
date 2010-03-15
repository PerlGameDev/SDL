use strict;
use warnings;

die "Usage file.pod NAME DESC \@CATEGORY" if $#ARGV < 3;

my ($file, $name, $desc, @category) = @ARGV;

open FH,'>',  $file;

print FH 
"\=pod

\=head1 NAME

$name -- $desc

\=head1 CATEGORY

TODO, ".join ( ', ', @category) ."

\=cut
";

close FH;
