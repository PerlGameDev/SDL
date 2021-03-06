package SDL::Rect;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::Video';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

our $VERSION = 2.548;

bootstrap SDL::Rect;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::Video'} };
our %EXPORT_TAGS = (
	all     => \@EXPORT,
	color   => $SDL::Constants::EXPORT_TAGS{'SDL::Video/color'},
	surface => $SDL::Constants::EXPORT_TAGS{'SDL::Video/surface'},
	video   => $SDL::Constants::EXPORT_TAGS{'SDL::Video/video'},
	overlay => $SDL::Constants::EXPORT_TAGS{'SDL::Video/overlay'},
	grab    => $SDL::Constants::EXPORT_TAGS{'SDL::Video/grab'},
	palette => $SDL::Constants::EXPORT_TAGS{'SDL::Video/palette'},
	gl      => $SDL::Constants::EXPORT_TAGS{'SDL::Video/gl'}
);

1;
