package SDL::Version;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
bootstrap SDL::Version;

1;
