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
use SDLx::Validate;
use Tie::Simple;

use overload (
	'@{}'    => '_array',
	fallback => 1,
);
use SDL::Constants ':SDL::Video';
our @ISA = qw(Exporter DynaLoader SDL::Surface);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDLx::Surface;

# I won't use a module here for efficiency and simplification of the
# hierarchy.
# Inside out object
my %_tied_array;

sub new {
	my ( $class, %options ) = @_;
	my $self;

	if ( $options{surface} ) {
		$self = bless $options{surface}, $class;
	} else {
		my $width  = $options{width}  || $options{w};
		my $height = $options{height} || $options{h};
		if ( $width and $height ) #atleast give a dimension
		{
			$options{flags} ||= SDL_ANYFORMAT;
			$options{depth} ||= 32;

			$options{redmask}   ||= 0xFF000000;
			$options{greenmask} ||= 0x00FF0000;
			$options{bluemask}  ||= 0x0000FF00;
			$options{alphamask} ||= 0x000000FF;

			$self = bless SDL::Surface->new(
				$options{flags},    $width,            $height,
				$options{depth},    $options{redmask}, $options{greenmask},
				$options{bluemask}, $options{alphamask}
			), $class;
		} else {
			Carp::croak 'Provide surface, or atleast width and height';
		}
	}
	if ( exists $options{color} ) {
		$self->draw_rect( undef, $options{color} );
	}
	return $self;
}

sub DESTROY {
	my $self = shift;
	delete $_tied_array{$$self};
}

sub display {
	my $disp = SDL::Video::get_video_surface;
	return SDLx::Surface->new( surface => $disp ) if $disp;
	my %options = @_;

	my $width  = $options{width}  || $options{w};
	my $height = $options{height} || $options{h};
	if ( $width and $height ) #atleast give a dimension
	{
		$options{depth} ||= 32;
		$options{flags} ||= SDL_ANYFORMAT;

		my $surface = SDL::Video::set_video_mode(
			$width, $height, $options{depth},
			$options{flags},
		);
		return SDLx::Surface->new( surface => $surface );
	} else {
		Carp::croak 'set_video_mode externally or atleast provide width and height';
	}

}

sub duplicate {
	my $surface = shift;
	SDLx::Validate::surface($surface);
	require SDL::PixelFormat;
	return SDLx::Surface->new(
		width  => $surface->w,
		height => $surface->h,
		depth  => $surface->format->BitsPerPixel,
		flags  => $surface->flags
	);

}

### Overloads

sub _tied_array {
	my ( $self, $array ) = @_;
	if ($array) {
		$_tied_array{$$self} = $array if $array;
	}
	return $_tied_array{$$self};
}

sub get_pixel {
	my ( $self, $y, $x ) = @_;
	return SDLx::Surface::get_pixel_xs( $self, $x, $y );
}

sub set_pixel {
	my ( $self, $y, $x, $new_value ) = @_;
	SDLx::Surface::set_pixel_xs( $self, $x, $y, $new_value );
}

sub _array {
	my $self = shift;

	my $array = $self->_tied_array;

	unless ($array) {
		tie my @array, 'SDLx::Surface::TiedMatrix', $self;
		$array = \@array;
		$self->_tied_array($array);
	}
	return $array;
}

#ATTRIBUTE

sub surface { $_[0] }

#WRAPPING

sub clip_rect {

	SDL::Video::set_clip_rect( $_[1] ) if $_[1] && $_[1]->isa('SDL::Rect');
	SDL::Video::get_clip_rect( $_[0] );

}

#EXTENSTIONS

sub blit {
	my ( $self, $dest, $src_rect, $dest_rect ) = @_;

	my $self_surface = $self->surface;

	my $dest_surface = SDLx::Validate::surface($dest);

	$src_rect = SDL::Rect->new( 0, 0, $self_surface->w, $self_surface->h )
		unless defined $src_rect;
	$dest_rect = SDL::Rect->new( 0, 0, $dest_surface->w, $dest_surface->h )
		unless defined $dest_rect;

	my $pass_src_rect = SDLx::Validate::rect($src_rect);

	my $pass_dest_rect = SDLx::Validate::rect($dest_rect);

	SDL::Video::blit_surface(
		$self_surface, $pass_src_rect, $dest_surface,
		$pass_dest_rect
	);

	return $self

}

sub blit_by {
	my ( $self, $src, $src_rect, $dest_rect ) = @_;
	SDLx::Surface::blit( $src, $self, $src_rect, $dest_rect );
}

sub flip {
	Carp::croak "surface is not defined" unless $_[0]->surface();
	Carp::croak "Error flipping surface: " . SDL::get_error()
		if ( SDL::Video::flip( $_[0]->surface() ) == -1 );
	return $_[0];

}

sub update {
	my ( $self, $rects ) = @_;
	my $surface = $self->surface;

	if ( !defined($rects) || ( ref($rects) eq 'ARRAY' && !ref( $rects->[0] ) ) ) {
		my @pass_rect = ();
		@pass_rect = @{ $rects->[0] } if $rects->[0];
		$pass_rect[0] |= 0;
		$pass_rect[1] |= 0;
		$pass_rect[2] |= $surface->w;
		$pass_rect[3] |= $surface->h;

		SDL::Video::update_rect( $surface, @pass_rect );
	} else {

		#TODO: Validate each rect?
		SDL::Video::update_rects( $surface, @{$rects} );
	}

	return $self;
}

sub draw_rect {
	my ( $self, $rect, $color ) = @_;
	$color = SDLx::Validate::num_rgba($color);
	if ( defined $rect ) {
		$rect = SDLx::Validate::rect($rect);
	} else {
		$rect = SDL::Rect->new( 0, 0, $self->w, $self->h );
	}

	SDL::Video::fill_rect( $self->surface, $rect, $color )
		and Carp::croak "Error drawing rect: " . SDL::get_error();
	return $self;
}

sub draw_line {
	my ( $self, $start, $end, $color, $antialias ) = @_;

	Carp::croak "Error start needs an array ref [x,y]"
		unless ref($start) eq 'ARRAY';
	Carp::croak "Error end needs an array ref [x,y]"
		unless ref($end) eq 'ARRAY';
	return unless eval{ require SDL::GFX::Primitives; 1};

	my $result;
	if ( Scalar::Util::looks_like_number($color) ) {
		if ($antialias) {
			$result = SDL::GFX::Primitives::aaline_color(
				$self->surface, @$start,
				@$end,          $color
			);
		} else {

			$result = SDL::GFX::Primitives::line_color(
				$self->surface, @$start, @$end,
				$color
			);
		}
	} elsif ( ref($color) eq 'ARRAY' && scalar(@$color) >= 4 ) {

		if ($antialias) {
			$result = SDL::GFX::Primitives::aaline_RGBA(
				$self->surface, @$start, @$end,
				@$color
			);
		} else {

			$result = SDL::GFX::Primitives::line_RGBA(
				$self->surface, @$start, @$end,
				@$color
			);
		}

	} else {
		Carp::croak "Color needs to be a number or array ref [r,g,b,a,...]";

	}

	Carp::croak "Error drawing line: " . SDL::get_error() if ( $result == -1 );

	return $self;
}

sub draw_circle {
	my ( $self, $center, $radius, $color, $antialias ) = @_;

	return $self;
}

1;
