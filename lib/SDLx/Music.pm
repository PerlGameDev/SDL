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
	my $class = shift;
	my %params = @_;

	my $self = bless { %params }, $class;

    return $self;
}

sub data {
	my $self = shift;
	my %data = @_;
	# loop through keys
    foreach( keys %data )
	{
		my $datum = $data{$_};

		#If SCALAR is Simple
		 if( defined $datum )
			{
  				 if ( ref $datum eq 'HASH' ) { 
					$self->{data}->{$_} = $datum;
					$self->{data}->{$_}->{_content} = SDL::Mixer::Music::load_MUS( $datum->{file} );
					} 
				 else{ 
					$self->{data}->{$_}->{_content} = SDL::Mixer::Music::load_MUS( $datum );
				 } 
			}
				

	}

	return 1;
}

1;

