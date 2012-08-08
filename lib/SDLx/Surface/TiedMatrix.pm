package SDLx::Surface::TiedMatrix;
use strict;
use warnings;
use vars qw($VERSION);
use SDLx::Surface::TiedMatrixRow;
use base 'Tie::Array';

our $VERSION = '2.541_09';
$VERSION = eval $VERSION;

sub new {
	my $class  = shift;
	my $matrix = shift;
	my $self   = {
		matrix => $matrix,
		rows   => [],
	};
	return bless $self, $class;
}

sub TIEARRAY {
	return SDLx::Surface::TiedMatrix->new( $_[1] );
}

sub FETCH {
	my ( $self, $y ) = @_;

	unless ( $self->{rows}[$y] ) {
		tie my @row, 'SDLx::Surface::TiedMatrixRow', $self->{matrix}, $y;
		$self->{rows}[$y] = \@row;
	}
	return $self->{rows}[$y];
}

sub FETCHSIZE {
	my ( $self, $x ) = @_;
	return $self->{matrix}->surface->h;
}

1;
