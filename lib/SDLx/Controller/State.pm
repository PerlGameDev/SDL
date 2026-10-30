package SDLx::Controller::State;
use strict;
use warnings;

our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

our $VERSION = 2.548;

bootstrap SDLx::Controller::State;

1;
