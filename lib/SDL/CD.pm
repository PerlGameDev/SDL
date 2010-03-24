package SDL::CD;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::CD;

our @EXPORT = qw(
	CD_TRAYEMPTY
	CD_STOPPED
	CD_PLAYING
	CD_PAUSED
	CD_ERROR
	CD_FPS
	SDL_MAX_TRACKS
);

our %EXPORT_TAGS = 
(
	status => [qw(
		CD_TRAYEMPTY
		CD_STOPPED
		CD_PLAYING
		CD_PAUSED
		CD_ERROR
	)],
	defaults => [qw(
		CD_FPS
		SDL_MAX_TRACKS
	)]
);

use constant{
	CD_TRAYEMPTY => 0,
	CD_STOPPED   => 1,
	CD_PLAYING   => 2,
	CD_PAUSED    => 3,
	CD_ERROR     => -1,
}; # status

use constant{
	CD_FPS         => 75,
	SDL_MAX_TRACKS => 99,
}; # defaults

# Conversion functions from frames to Minute/Second/Frames and vice versa
sub FRAMES_TO_MSF{
	my $frames = shift;
	my $F = $frames % CD_FPS;
	$frames /= CD_FPS;
	my $S = $frames % 60;
	$frames /= 60;
	my $M = $frames;
	
	return ($M, $S, $F);
}
sub MSF_TO_FRAMES{
	my $M = shift;
	my $S = shift;
	my $F = shift;

	return ($M * 60 * CD_FPS + $S * CD_FPS + $F);
}
# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;
