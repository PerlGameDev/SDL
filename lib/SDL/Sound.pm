#
#	Sound.pm
#
#	a SDL_mixer data module
#
#	Copyright (C) 2000,2002 David J. Goehrig

package SDL::Sound;
use strict;

sub new {
	my $proto = shift;	
	my $class = ref($proto) || $proto;
	my $filename = shift;
	my $self = \SDL::MixLoadWAV($filename);
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::MixFreeChunk($$self);
}

sub volume {
	my $self = shift;
	my $volume = shift;
	return SDL::MixVolumeChunk($$self,$volume);
}

1;

__END__;

=pod



=head1 NAME

SDL::Sound - a perl extension

=head1 DESCRIPTION

L<SDL::Sound> is a module for loading WAV files for sound effects.
The file can be loaded by creating a new L<SDL::Sound> object by
passing the filename to the constructor;

	my $sound = new SDL::Sound 'my_sfx.wav';

=head1 METHODS

=head2 volume ( value )

Sets the volume of the sample.

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl> L<SDL::Mixer>

=cut
