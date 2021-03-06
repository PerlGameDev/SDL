package SDL::GFX::FPSManager;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::GFX';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

our $VERSION = 2.548;

bootstrap SDL::GFX::FPSManager;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::GFX'} };
our %EXPORT_TAGS = (
	all       => \@EXPORT,
	smoothing => $SDL::Constants::EXPORT_TAGS{'SDL::GFX/smoothing'}
);

1;
