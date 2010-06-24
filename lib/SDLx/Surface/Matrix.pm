package SDLx::Surface::Matrix;
use Carp ();
use SDL;
use SDL::Video;
use SDL::Rect;
use SDL::Surface;
use SDLx::Surface;
use SDL::PixelFormat;
use Tie::Simple;
use overload (
	'@{}' => '_array',
);


sub new {
    my ($class, %options) = @_;
    my $self = bless {}, ref $class || $class;
	
    $self->surface( exists $options{surface} ? $options{surface}
                    : _create_surf()
                  );

    return $self;
}

sub surface {
    my ($self, $surface) = @_;

    # short-circuit
	
    Carp::croak 'surface accepts only SDL::Surface objects'
        unless $surface->isa('SDL::Surface');

    $self->{surface} = $surface;
    $self->{surface_data} = SDLx::Surface::pixel_array($surface);
    return $surface;
}

sub _tied_array {
    my ($self, $array) = @_;

    if ($array) {
        $self->{_tied_array} = $array if $array;
    }
    return $self->{_tied_array};
}

sub _create_surf {
	my $surface = SDL::Surface->new( SDL_ANYFORMAT, 100,100,32, 0,0,0,0 );
	my $mapped_color =
	SDL::Video::map_RGB( $surface->format(), 0, 0, 0 );    # blue

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


sub get_pixel {
	my ($self, $x, $y) = @_;
	
	return SDLx::Surface::get_pixel($self->{surface}, $x, $y);
}

sub set_pixel {
	my ($self, $x, $y, $new_value) = @_;
	#my $old =   $self->get_pixel($x, $y);
	
	 vec(${$self->{surface_data}->[$x][$y]}, 0,  $self->{surface}->format->BitsPerPixel) = $new_value;
	 
	 #return $old;
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
