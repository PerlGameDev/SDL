package SDL::GFX::Rotozoom;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::GFX::Rotozoom;

use base 'Exporter';

our @EXPORT = qw(
	SMOOTHING_OFF
	SMOOTHING_ON
);

our %EXPORT_TAGS = 
(
	smoothing => [qw(
		SMOOTHING_OFF
		SMOOTHING_ON
	)]
);

use constant{
	SMOOTHING_OFF => 0,
	SMOOTHING_ON  => 1,
}; # smoothing

# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;
