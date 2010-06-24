package SDLx::Surface::Matrix;
use Moose;
use SDL;
use SDL::Video;
use SDL::Rect;
use SDL::Surface;
use SDL::PixelFormat;
use Tie::Simple;
use overload (
	'@{}' => '_array',
);

has surface => (
	is => 'rw',
	isa => 'SDL::Surface',
	default => sub {

		_create_surf()

	}
);

has _tied_array => (
	is => 'rw',
	);

sub _create_surf
{

	my $surface = SDL::Surface->new( SDL_ANYFORMAT, 100,100,32, 0,0,0,0 );
	my $mapped_color =
	SDL::Video::map_RGB( $surface ->format(), 0, 0, 0 );    # blue

	SDL::Video::fill_rect( $surface ,
		SDL::Rect->new( 0, 0,$surface->w,  $surface->h ), $mapped_color );
	return $surface;
}

sub load {
	my ($self, $data) = @_;
	{
		$self->surface ( $data );
	}
}

sub calc_offset {
	my ($self, $y, $x) = @_;

	my $offset = ( $self->surface->pitch * $y )/$self->surface->format->BytesPerPixel;
	$offset +=  $x;	
	$_[0]->{offset} = $offset;
	return $offset;
}

sub get_pixel {
	my ($self, $x, $y) = @_;
	return $self->surface->get_pixel( $self->calc_offset($x, $y) );
}

sub set_pixel {
	my ($self, $x, $y, $new_value) = @_;
	my $old = $self->surface->get_pixel($self->calc_offset($x, $y));
	$self->surface->set_pixels($self->calc_offset($x, $y), $new_value);
	return $old;
}

sub _array {
	my $self = shift;

	my $array = $self->_tied_array;

	unless( $array ) {
		tie my @array, 'TiedMatrix', $self;
		$array = \@array;
		$self->_tied_array( $array );
	}
	return $array;
}

1;

package TiedMatrix;
use strict;
use warnings;
use base 'Tie::Array';

sub new {
	my $class = shift;
	my $matrix = shift;
	my $self = {
		matrix => $matrix,
		rows => [],
	};
	return bless $self, $class;
}

sub TIEARRAY {
	return TiedMatrix->new( $_[1] );
}

sub FETCH {
	my ($self, $y) = @_;

	unless( $self->{rows}[$y] ) {
		tie my @row, 'TiedMatrixRow', $self->{matrix}, $y;
		$self->{rows}[$y] = \@row;
	}
	return $self->{rows}[$y];
}

1;

package TiedMatrixRow;
use strict;
use warnings;
use base 'Tie::Array';

sub new {
	my $class = shift;
	my $matrix = shift;
	my $y = shift;

	my $self = {
		matrix => $matrix,
		y => $y,
	};

	return bless $self, $class;
}

sub TIEARRAY {
	return TiedMatrixRow->new( $_[1], $_[2] );
}

sub FETCH {
	my ($self, $x) = @_;
	$self->{matrix}->get_pixel( $x, $self->{y} );
}

sub STORE {
	my ($self, $x, $new_value) = @_;
	$self->{matrix}->set_pixel( $x, $self->{y}, $new_value );
}

1;

