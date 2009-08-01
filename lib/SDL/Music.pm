#	Music.pm
#
#	a SDL_mixer data module
#
#	Copyright (C) 2000,2002 David J. Goehrig

package SDL::Music;
use strict;
use SDL;

sub new {
	my $proto = shift;	
	my $class = ref($proto) || $proto;
	my $filename = shift;
	my $self = \SDL::MixLoadMusic($filename);
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::MixFreeMusic($$self);
}

1;

__END__;

=pod

=head1 NAME

SDL::Music - a perl extension

=head1 DESCRIPTION

L<SDL::Music> is used to load music files for use with L<SDL::Mixer>.
To load a music file one simply creates a new object passing the filename 
to the constructor:

	my $music = new SDL::Music 'my_song.ogg';


=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl> L<SDL::Mixer>

=cut
