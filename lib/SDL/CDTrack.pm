package SDL::CDTrack;
use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::CDROM';
our @ISA = qw(Exporter DynaLoader);

our $VERSION    = '2.541_09';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::CDTrack;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::CDROM'} };
our %EXPORT_TAGS = (
	all        => \@EXPORT,
	format     => $SDL::Constants::EXPORT_TAGS{'SDL::CDROM/default'},
	status     => $SDL::Constants::EXPORT_TAGS{'SDL::CDROM/status'},
	track_type => $SDL::Constants::EXPORT_TAGS{'SDL::CDROM/track_type'}
);

1;
