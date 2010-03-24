package SDL::Mixer;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
use vars qw(@ISA @EXPORT);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Mixer;

use base 'Exporter';

our @EXPORT = qw(
	MIX_INIT_FLAC
	MIX_INIT_MOD
	MIX_INIT_MP3
	MIX_INIT_OGG
	MIX_CHANNELS
	MIX_CHANNEL_POST
	MIX_DEFAULT_CHANNELS
	MIX_DEFAULT_FORMAT
	MIX_DEFAULT_FREQUENCY
	MIX_FADING_IN
	MIX_FADING_OUT
	MIX_MAX_VOLUME
	MIX_NO_FADING
	MUS_NONE
	MUS_CMD
	MUS_WAV
	MUS_MOD
	MUS_MID
	MUS_OGG
	MUS_MP3
	MUS_MP3_MAD
	MUS_FLAC
	MUS_MP3_FLAC
);

our %EXPORT_TAGS = 
(
	init => [qw(
		MIX_INIT_FLAC
		MIX_INIT_MOD
		MIX_INIT_MP3
		MIX_INIT_OGG
	)],
	default => [qw(
		MIX_CHANNELS
		MIX_DEFAULT_FORMAT
		MIX_DEFAULT_FREQUENCY
		MIX_DEFAULT_CHANNELS
		MIX_MAX_VOLUME
		MIX_CHANNEL_POST
	)],
	fading => [qw(
		MIX_NO_FADING
		MIX_FADING_OUT
		MIX_FADING_IN
	)],
	type => [qw(
		MUS_NONE
		MUS_CMD
		MUS_WAV
		MUS_MOD
		MUS_MID
		MUS_OGG
		MUS_MP3
		MUS_MP3_MAD
		MUS_MP3_FLAC
	)],
);

use constant{
	MIX_INIT_FLAC => 0x00000001,
    MIX_INIT_MOD  => 0x00000002,
    MIX_INIT_MP3  => 0x00000004,
    MIX_INIT_OGG  => 0x00000008
}; # init

use constant {
	MIX_CHANNELS                                        => 8,
	MIX_DEFAULT_FORMAT                                  => 32784,
	MIX_DEFAULT_FREQUENCY                               => 22050,
	MIX_DEFAULT_CHANNELS                                => 2,
	MIX_MAX_VOLUME                                      => 128,
	MIX_CHANNEL_POST                                    => -2,
};

use constant {
	MIX_NO_FADING                                       => 0,
	MIX_FADING_OUT                                      => 1,
	MIX_FADING_IN                                       => 2,
}; # Mix_Fading

use constant {
	MUS_NONE                                            => 0,
	MUS_CMD                                             => 1,
	MUS_WAV                                             => 2,
	MUS_MOD                                             => 3,
	MUS_MID                                             => 4,
	MUS_OGG                                             => 5,
	MUS_MP3                                             => 6,
	MUS_MP3_MAD                                         => 7,
	MUS_MP3_FLAC                                        => 8,
}; # Mix_MusicType

# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;
