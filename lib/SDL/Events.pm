package SDL::Events;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Events;

our @EXPORT=qw(SDL_EVENTMASK);

sub SDL_EVENTMASK
{
	return 1 << shift;
}

1;
