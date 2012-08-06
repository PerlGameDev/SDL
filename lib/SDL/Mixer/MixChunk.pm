package SDL::Mixer::MixChunk;
use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants qw(:SDL::Mixer :SDL::Audio);
our @ISA = qw(Exporter DynaLoader);

our $VERSION    = '2.541_09';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Mixer::MixChunk;

use base 'Exporter';
our @EXPORT = (
	@{ $SDL::Constants::EXPORT_TAGS{'SDL::Mixer'} },
	@{ $SDL::Constants::EXPORT_TAGS{'SDL::Audio'} }
);
our %EXPORT_TAGS = (
	all      => \@EXPORT,
	init     => $SDL::Constants::EXPORT_TAGS{'SDL::Mixer/init'},
	defaults => $SDL::Constants::EXPORT_TAGS{'SDL::Mixer/defaults'},
	fading   => $SDL::Constants::EXPORT_TAGS{'SDL::Mixer/fading'},
	type     => $SDL::Constants::EXPORT_TAGS{'SDL::Mixer/type'},
	format   => $SDL::Constants::EXPORT_TAGS{'SDL::Audio/format'},
	status   => $SDL::Constants::EXPORT_TAGS{'SDL::Audio/status'}
);

1;
