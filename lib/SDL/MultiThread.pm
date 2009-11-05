package SDL::MultiThread;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
bootstrap SDL::MultiThread;

1;
