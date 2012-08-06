package SDL::CD;
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

bootstrap SDL::CD;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::CDROM'} };
our %EXPORT_TAGS = (
	all        => \@EXPORT,
	format     => $SDL::Constants::EXPORT_TAGS{'SDL::CDROM/default'},
	status     => $SDL::Constants::EXPORT_TAGS{'SDL::CDROM/status'},
	track_type => $SDL::Constants::EXPORT_TAGS{'SDL::CDROM/track_type'}
);

# Conversion functions from frames to Minute/Second/Frames and vice versa
sub FRAMES_TO_MSF {
	my $frames = shift;
	my $F      = $frames % CD_FPS;
	$frames /= CD_FPS;
	my $S = $frames % 60;
	$frames /= 60;
	my $M = $frames;

	return ( $M, $S, $F );
}

sub MSF_TO_FRAMES {
	my $M = shift;
	my $S = shift;
	my $F = shift;

	return ( $M * 60 * CD_FPS + $S * CD_FPS + $F );
}

1;
