package SDL::GFX::BlitFunc;
use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::GFX';
our @ISA = qw(Exporter DynaLoader);

our $VERSION    = '2.541_09';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::GFX::BlitFunc;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::GFX'} };
our %EXPORT_TAGS = (
	all       => \@EXPORT,
	smoothing => $SDL::Constants::EXPORT_TAGS{'SDL::GFX/smoothing'}
);

1;
