package SDL::CDTrack;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::CDTrack;

our @EXPORT = qw(
	SDL_AUDIO_TRACK
	SDL_DATA_TRACK
);

our %EXPORT_TAGS = 
(
	type => [qw(
		SDL_AUDIO_TRACK
		SDL_DATA_TRACK
	)]
);

use constant{
	SDL_AUDIO_TRACK => 0,
	SDL_DATA_TRACK  => 4,
}; # type

# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;
