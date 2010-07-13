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
use SDL::Color;
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

	if( $options{surface} )
	{
		$self->surface( $options{surface} );
	}
	elsif ( $options{width} && $options{height} ) #atleast give a dimension
	{
		$options{depth} |=  32; #default 32
		$options{flags} |= SDL_ANYFORMAT;

			$options{redmask} |= 0xFF000000;
			$options{greenmask} |= 0x00FF0000;
			$options{bluemask} |= 0x0000FF00;
			$options{alphamask} |= 0x000000FF;

		my $surface = SDL::Surface->new( $options{flags}, 
			$options{width}, 
			$options{height}, 
			$options{depth}, 
			$options{redmask},
			$options{greenmask},
			$options{bluemask},
			$options{alphamask}
		);
		$self->surface( $surface );
	}
	else
	{
		Carp::croak 'Provide surface, or atleast width and height';
	}
	return $self;
}

sub get_display {
	my $disp = SDL::Video::get_video_surface;
	return SDLx::Surface->new( surface => $disp ) if $disp;
	my %options = @_;

	if ( $options{width} && $options{height} ) #atleast give a dimension
	{
		$options{depth} |=  32; #default 32
		$options{flags} |= SDL_ANYFORMAT;

		my $surface = SDL::Video::set_video_mode(
			$options{width}, 
			$options{height}, 
			$options{depth}, 
			$options{flags}, 
			);
			SDLx::Surface->new( surface=> $surface );
	}
	else
	{
		Carp::croak 'set_video_mode externally or atleast provide width and height';
	}
	

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

#EXTENSTIONS

sub blit {
	my ($self, $dest, $src_rect, $dest_rect) = @_;

	Carp::croak 'SDLx::Surface or SDL::Surface for dest required' unless ( $dest->isa('SDL::Surface') || $dest->isa('SDLx::Surface') );
		
	my $dest_surface = $dest;
	   $dest_surface = $dest->surface if $dest->isa('SDLx::Surface');

	$src_rect = SDL::Rect->new(0,0, $self->{surface}->w, $self->{surface}->h) unless defined $src_rect ;
	$dest_rect = SDL::Rect->new(0,0, $dest_surface->w, $dest_surface->h) unless defined $dest_rect;	

	Carp::croak 'Array ref or SDL::Rect for source rect required.'
	unless (ref($src_rect) eq 'ARRAY') || $src_rect->isa('SDL::Rect');  
	Carp::croak 'Array ref or SDL::Rect for dest rect required' 
	unless (ref($dest_rect) eq 'ARRAY') || ($dest_rect->isa('SDL::Rect') );

	my $pass_src_rect = $src_rect;
       	SDL::Rect->new( @{$src_rect} ) if ref $src_rect eq 'ARRAY';

	my $pass_dest_rect = $dest_rect;
	SDL::Rect->new( @{$dest_rect} ) if ref $dest_rect eq 'ARRAY';

	Carp::croak 'Destination was not a surface' unless $dest_surface->isa('SDL::Surface');
	SDL::Video::blit_surface( $self->surface(), $pass_src_rect, $dest_surface, $pass_dest_rect);

	return $self

}

sub flip
{
	Carp::croak "surface is not defined" unless $_[0]->surface();
	Carp::croak "Error flipping surface: ".SDL::get_error()  if ( SDL::Video::flip( $_[0]->surface() ) == -1 );
	return $_[0];

}

sub update {
	my ($self, $rects) = @_;

	if ( !defined( $rects ) || ( ref($rects) eq 'ARRAY' && !ref($rects->[0]) ) ) 
	{
		my @pass_rect = ();
		@pass_rect = @{$rects->[0]} if $rects->[0];
		$pass_rect[0] |= 0;
		$pass_rect[1] |= 0;
		$pass_rect[2] |= $self->surface->w;
		$pass_rect[3] |= $self->surface->h;

		SDL::Video::update_rect( $self->surface(), @pass_rect );
	}
	else
	{
		#TODO: Validate each rect? 
		SDL::Video::update_rects($self->surface(), @{$rects});
	}

	return $self;
}

#TODO
=pod
sub draw_rect{
	my ($self, $rect, $color) = @_;

	return $self;
}

sub draw_line{
	my ($self, $start, $end, $color, $antialias) = @_;

	return $self;
}

sub draw_cirle{
	my ($self, $center, $radius, $color, $antialias) = @_;

	return $self;
}
=cut 

1;
