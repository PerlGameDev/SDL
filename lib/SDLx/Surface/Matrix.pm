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
	return  $_[0]->{offset} if $_[0]->{offset};
	my ($self, $x, $y) = @_;
	
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
	tie my @array, "Tie::Simple", undef, (
		FETCH => sub {
			my $y = $_[1];
			tie my @row, "Tie::Simple", undef, (
				FETCH => sub {
					my $x = $_[1];
					$self->get_pixel( $x, $y );
				},
				STORE => sub {
					my $x = $_[1];
					my $new_value = $_[2];
					$self->set_pixel( $x, $y, $new_value );
				},
			);
			return \@row;
		},
	);

	return \@array;
}

1;
