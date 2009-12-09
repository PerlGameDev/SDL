
@files = @ARGV;

foreach (@files)
{
   my $filename = $_;
   my $file = $_;
   $filename  =~ s/\:\:/\//g;
   $filename = 'lib/'.$filename.'.pm';
   print "Writing to $filename \n";
   open FH, ">$filename" or die 'Error '.$!;
   print FH 
"package $file;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our \@ISA = qw(Exporter DynaLoader);
bootstrap $file;
1;";
   close FH;
}


