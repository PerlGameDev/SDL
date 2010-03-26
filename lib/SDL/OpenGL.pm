package SDL::OpenGL;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::Video';
use SDL::OpenGL::Constants;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::OpenGL;

use base 'Exporter';
our @EXPORT      = (@{ $SDL::Constants::EXPORT_TAGS{'SDL::Video'} }, @SDL::OpenGL::Constants::EXPORT);
for ( keys %SDL::OpenGL:: ) {
	if (/^gl/) {
		push @EXPORT,$_;
	}
}
our %EXPORT_TAGS = (
	all     => \@EXPORT,
	color   => $SDL::Constants::EXPORT_TAGS{'SDL::Video/color'},
	surface => $SDL::Constants::EXPORT_TAGS{'SDL::Video/surface'},
	video   => $SDL::Constants::EXPORT_TAGS{'SDL::Video/video'},
	overlay => $SDL::Constants::EXPORT_TAGS{'SDL::Video/overlay'},
	grab    => $SDL::Constants::EXPORT_TAGS{'SDL::Video/grab'},
	palette => $SDL::Constants::EXPORT_TAGS{'SDL::Video/palette'},
	gl      => $SDL::Constants::EXPORT_TAGS{'SDL::Video/gl'},
	opengl  => \@SDL::OpenGL::Constants::EXPORT,
);

1;

