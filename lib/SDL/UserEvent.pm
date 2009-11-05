package SDL::UserEvent;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
bootstrap SDL::UserEvent;
1;