package SDLx::Surface;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use Carp ();
use SDL;
use SDL::Video;
use SDL::Rect;
use SDL::Surface;
use SDLx::Surface;
use SDLx::Surface::TiedMatrix;
use SDL::PixelFormat;
use Tie::Simple;
use overload (
	'@{}' => '_array',
);
use SDL::Constants ':SDL::Video';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDLx::Surface;

sub new {
    my ($class, %options) = @_;
    my $self = bless {}, ref $class || $class;

    Carp::croak 'A surface must be passed!'
        unless $options{surface};

    $self->surface( exists $options{surface} ? $options{surface}
                    : _create_surf()
                  );

    return $self;
}

sub surface {
    return $_[0]->{surface} unless $_[1];
    my ($self, $surface) = @_;
    Carp::croak 'surface accepts only SDL::Surface objects'
        unless $surface->isa('SDL::Surface');

    $self->{surface} = $surface;
    return $self->{surface};
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

sub get_pixel{
	my ($self, $y, $x) = @_;
	return SDLx::Surface::get_pixel_xs($self->{surface}, $x, $y);
}

sub set_pixel {
	my ($self, $y, $x, $new_value) = @_;
	SDLx::Surface::set_pixel_xs( $self->{surface}, $x , $y, $new_value);	

}

sub _array {
	my $self = shift;

	my $array = $self->_tied_array;

	unless( $array ) {
		tie my @array, 'SDLx::Surface::TiedMatrix', $self;
		$array = \@array;
		$self->_tied_array( $array );
	}
	return $array;
}

1;


