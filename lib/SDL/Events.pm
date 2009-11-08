package SDL::Events;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
bootstrap SDL::Events;

our @EXPORT=qw(SDL_EVENTMASK);

sub SDL_EVENTMASK
{
	return 1 << shift;
}

1;
