package SDL::Mouse;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

our $VERSION = 2.548;

bootstrap SDL::Mouse;

1;
