use strict;
use warnings;

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
