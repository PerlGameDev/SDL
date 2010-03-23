package SDL::Surface;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Surface;

use base 'Exporter';

our @EXPORT_OK = qw(
	SDL_SWSURFACE
	SDL_HWSURFACE
	SDL_ASYNCBLIT
);

our %EXPORT_TAGS = 
(
	flags => [qw(
		SDL_SWSURFACE
		SDL_HWSURFACE
		SDL_ASYNCBLIT
	)]
);

use constant{
	SDL_SWSURFACE                                       => 0x00000000,
	SDL_HWSURFACE                                       => 0x00000001,
	SDL_ASYNCBLIT                                       => 0x00000004,
}; # flags

# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;
