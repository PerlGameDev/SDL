package SDL::Audio;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Audio;

use base 'Exporter';

our @EXPORT = qw(
	AUDIO_U8
	AUDIO_S8
	AUDIO_U16LSB
	AUDIO_S16LSB
	AUDIO_U16MSB
	AUDIO_S16MSB
	AUDIO_U16
	AUDIO_S16 
	AUDIO_U16SYS
	AUDIO_S16SYS
	SDL_AUDIO_STOPPED
	SDL_AUDIO_PLAYING
	SDL_AUDIO_PAUSED
);

our %EXPORT_TAGS = 
(
	format => [qw(
		AUDIO_U8
		AUDIO_S8
		AUDIO_U16LSB
		AUDIO_S16LSB
		AUDIO_U16MSB
		AUDIO_S16MSB
		AUDIO_U16
		AUDIO_S16 
		AUDIO_U16SYS
		AUDIO_S16SYS
	)],
	status => [qw(
		SDL_AUDIO_STOPPED
		SDL_AUDIO_PLAYING
		SDL_AUDIO_PAUSED
	)]
);

use constant{
	AUDIO_U8     => 0x0008,
	AUDIO_S8     => 0x8008,
	AUDIO_U16LSB => 0x0010,
	AUDIO_S16LSB => 0x8010,
	AUDIO_U16MSB => 0x1010,
	AUDIO_S16MSB => 0x9010,
	AUDIO_U16    => 0x0010,
	AUDIO_S16    => 0x8010,
}; # format

use constant{
	SDL_AUDIO_STOPPED => 0,
	SDL_AUDIO_PLAYING => 1,
	SDL_AUDIO_PAUSED  => 2,
}; # status

# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;
