package SDLx::Music;
use strict;
use warnings;
use strict;
use warnings;
use Carp ();
use SDL;
use SDL::Mixer;
use SDL::Mixer::Music;
use SDL::Mixer::Channels;
use SDL::Mixer::Samples;
use SDL::Mixer::MixChunk;


sub new {
	my ($class, %params) = @_;

	my $self = bless { %params }, $class;

    return $self;
}

1;

