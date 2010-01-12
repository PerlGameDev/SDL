package SDL::Surface;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
bootstrap SDL::Surface;
#sub CLONE_SKIP { 1 };
1;
