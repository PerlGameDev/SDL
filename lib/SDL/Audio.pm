package SDL::Audio;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::Audio';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

our $VERSION = 2.548;

bootstrap SDL::Audio;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::Audio'} };
our %EXPORT_TAGS = (
	all    => \@EXPORT,
	format => $SDL::Constants::EXPORT_TAGS{'SDL::Audio/format'},
	status => $SDL::Constants::EXPORT_TAGS{'SDL::Audio/status'}
);

1;
