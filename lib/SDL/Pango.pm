package SDL::Pango;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::Pango';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Pango;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::Pango'} };
our %EXPORT_TAGS = (
	all       => \@EXPORT,
	direction => $SDL::Constants::EXPORT_TAGS{'SDL::Pango/direction'},
	align     => $SDL::Constants::EXPORT_TAGS{'SDL::Pango/align'}
);

1;
