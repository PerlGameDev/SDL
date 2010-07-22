package SDL::Image;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::Image';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Image;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::Image'} };
our %EXPORT_TAGS = (
	all  => \@EXPORT,
	init => $SDL::Constants::EXPORT_TAGS{'SDL::Video/init'}
);

1;
