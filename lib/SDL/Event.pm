package SDL::Event;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
bootstrap SDL::Event;
#sub CLONE_SKIP { 1 };
1;
