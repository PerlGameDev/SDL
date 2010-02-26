package SDL::Mixer::Groups;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Mixer::Groups;

1;