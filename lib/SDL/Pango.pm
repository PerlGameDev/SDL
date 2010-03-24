package SDL::Pango;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Pango;

use base 'Exporter';

our @EXPORT = qw(
	SDLPANGO_DIRECTION_LTR
	SDLPANGO_DIRECTION_RTL
	SDLPANGO_DIRECTION_WEAK_LTR
	SDLPANGO_DIRECTION_WEAK_RTL
	SDLPANGO_DIRECTION_NEUTRAL
);

our %EXPORT_TAGS = 
(
	direction => [qw(
		SDLPANGO_DIRECTION_LTR
		SDLPANGO_DIRECTION_RTL
		SDLPANGO_DIRECTION_WEAK_LTR
		SDLPANGO_DIRECTION_WEAK_RTL
		SDLPANGO_DIRECTION_NEUTRAL
	)]
);

use constant{
	SDLPANGO_DIRECTION_LTR      => 0,
	SDLPANGO_DIRECTION_RTL      => 1,
	SDLPANGO_DIRECTION_WEAK_LTR => 2,
	SDLPANGO_DIRECTION_WEAK_RTL => 3,
	SDLPANGO_DIRECTION_NEUTRAL  => 4
}; # SDLPango_Direction

# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;
