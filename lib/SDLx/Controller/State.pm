package SDLx::Controller::State;
use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA);

our @ISA = qw(Exporter DynaLoader);

our $VERSION    = '2.541_09';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDLx::Controller::State;

1;
