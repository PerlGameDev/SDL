package SDL::Net;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::Net';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Net;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::Net'} };
our %EXPORT_TAGS = (
	all      => \@EXPORT,
	defaults => $SDL::Constants::EXPORT_TAGS{'SDL::Net/defaults'}
);

1;
