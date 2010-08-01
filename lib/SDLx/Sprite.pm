package SDLx::Sprite;
use strict;
use warnings;
use Scalar::Util 'refaddr';
use SDL;
use SDL::Video;
use SDL::Image;
use SDL::Rect;
use SDL::Surface;

use base 'SDLx::Surface';

use Carp ();

# Inside out object
my %_surface;
my %_rect;
my %_clip;
my %_alpha_key;
my %_alpha;
my %_angle;

sub new {
	my ( $class, %options ) = @_;

	my $self = bless {}, ref $class || $class;
	if ( exists $options{surface} ) {
		$self->_init_rects(%options);
		$self->_handle_surface( $options{surface} );
	} elsif ( exists $options{image} ) {
		my $surf = _construct_image( $options{image} );
		$self->_init_rects(%options);
		$self->_handle_surface($surf);
	} elsif ( exists $options{width} && $options{height} ) {
		my $surf = SDLx::Surface->new(%options);
		$self->_init_rects(%options);
		$self->_handle_surface($surf);
	} else {

		Carp::croak "Need a surface => SDL::Surface, an image => name, or ( width => ... , height => ...)";
	}

	# short-circuit
	return $self unless %options;

	Carp::croak 'rect cannot be instantiated together with x or y'
		if exists $options{rect} and ( exists $options{x} or exists $options{y} );

	Carp::croak 'image and surface cannot be instantiated together'
		if exists $options{image} and exists $options{surface};

	# note: ordering here is somewhat important. If you change anything,
	# please rerun the test suite to make sure everything still works :)

	$self->x( $options{x} )                 if exists $options{x};
	$self->y( $options{y} )                 if exists $options{y};
	$self->rotation( $options{rotation} )   if exists $options{rotation};
	$self->alpha_key( $options{alpha_key} ) if exists $options{alpha_key};
	$self->alpha( $options{alpha} )         if exists $options{alpha};

	return $self;
}

sub DESTROY {
	my $self = shift;
	delete $_surface{ refaddr $self};
	delete $_rect{ refaddr $self};
	delete $_clip{ refaddr $self};
	delete $_alpha_key{ refaddr $self};
	delete $_alpha{ refaddr $self};
	delete $_angle{ refaddr $self};
}

sub load {
	my ( $self, $image ) = @_;
	my $surf = _construct_image($image);
	$self->_handle_surface($surf);
	return $self;
}

sub _init_rects {
	my ( $self, %options ) = @_;

	# create our two initial rects
	$self->rect(
		exists $options{rect}
		? $options{rect}
		: SDL::Rect->new( 0, 0, 0, 0 )
	);
	$self->clip(
		exists $options{clip}
		? $options{clip}
		: SDL::Rect->new( 0, 0, 0, 0 )
	);

}

sub _construct_image {
	my $filename = shift;
	my $surface  = SDL::Image::load($filename)
		or Carp::croak SDL::get_error;

	return $surface;
}

sub _handle_surface {
	my ( $self, $surface ) = @_;

	# short-circuit
	return $self->surface unless $surface;

	Carp::croak 'surface accepts only SDL::Surface objects'
		unless $surface->isa('SDL::Surface');

	my $old_surface = $_surface{ refaddr $self};
	$_surface{ refaddr $self} = $surface;

	# update our source and destination rects
	$self->rect->w( $surface->w );
	$self->rect->h( $surface->h );
	$self->clip->w( $surface->w );
	$self->clip->h( $surface->h );

	return $old_surface;
}

sub rect {
	my ( $self, $rect ) = @_;

	# short-circuit
	return $_rect{ refaddr $self} unless $rect;

	Carp::croak 'rect accepts only SDL::Rect objects'
		unless $rect->isa('SDL::Rect');

	return $_rect{ refaddr $self} = $rect;
}

sub clip {
	my ( $self, $clip ) = @_;

	# short-circuit
	return $_clip{ refaddr $self} unless $clip;

	Carp::croak 'clip accepts only SDL::Rect objects'
		unless $clip->isa('SDL::Rect');

	return $_clip{ refaddr $self} = $clip;
}

sub surface {
	my ( $self, $surface ) = @_;

	# short-circuit
	return $_surface{ refaddr $self} unless $surface;

	Carp::croak 'clip accepts only SDL::Surface objects'
		unless $surface->isa('SDL::Surface');

	$self->_handle_surface($surface);
	return $surface;
}

sub x {
	my ( $self, $x ) = @_;

	if ( defined $x ) {
		$self->rect->x($x);
	}

	return $self->rect->x;
}

sub y {
	my ( $self, $y ) = @_;

	if ( defined $y ) {
		$self->rect->y($y);
	}

	return $self->rect->y;
}

sub w {
	my ($self) = @_;
	return $self->surface->w;
}

sub h {
	my ($self) = @_;
	return $self->surface->h;
}

sub draw {
	my ( $self, $surface ) = @_;
	Carp::croak 'Surface needs to be defined' unless defined $surface;

	$self->blit( $surface, $self->clip, $self->rect );
	return $self;
}

sub draw_xy {
	my ( $self, $surface, $x, $y ) = @_;
	Carp::croak 'Surface needs to be defined' unless defined $surface;
	$self->x($x);
	$self->y($y);
	return $self->draw($surface);

}

sub alpha_key {
	my ( $self, $color ) = @_;

	Carp::croak 'color must be a SDL::Color'
		unless ref $color and $color->isa('SDL::Color');

	Carp::croak 'SDL::Video::set_video_mode must be called first'
		unless ref SDL::Video::get_video_surface();
	$_alpha_key{ refaddr $self} = $color
		unless $_alpha_key{ refaddr $self}; # keep a copy just in case
	$self->surface( SDL::Video::display_format( $self->surface ) );

	if ( SDL::Video::set_color_key( $self->surface, SDL_SRCCOLORKEY, $color ) < 0 ) {
		Carp::croak ' alpha_key died :' . SDL::get_error;
	}

	return $self;
}

sub alpha {
	my ( $self, $value ) = @_;

	$value = int( $value * 0xff ) if $value < 1 and $value > 0;

	$value = 0    if $value < 0;
	$value = 0xff if $value > 0xff;
	$_alpha{ refaddr $self} = $value; # keep a copy just in case
	$self->surface( SDL::Video::display_format( $self->surface ) );
	my $flags = SDL_SRCALPHA | SDL_RLEACCEL; #this should be predictive
	if ( SDL::Video::set_alpha( $self->surface, $flags, $value ) < 0 ) {
		Carp::croak 'alpha died :' . SDL::get_error;
	}

	return $self;
}

sub rotation {
	my ( $self, $angle, $smooth ) = @_;

	if ( $angle && $_surface{ refaddr $self} ) {

		require SDL::GFX::Rotozoom;

		my $rotated = SDL::GFX::Rotozoom::surface(
			$_surface{ refaddr $self}, #prevents rotting of the surface
			$angle,
			1,                         # zoom
			( defined $smooth && $smooth != 0 )
		) or Carp::croak 'rotation error: ' . SDL::get_error;

		#After rotation the surface is on a undefined background.
		#This causes problems with alpha. So we create a surface with a fill of the src_color.
		#This insures less artifacts.
		if ( $_alpha_key{ refaddr $self} ) {
			my $background = SDLx::Surface::duplicate($rotated);
			$background->draw_rect(
				[ 0, 0, $background->w, $background->h ],
				$_alpha_key{ refaddr $self}
			);
			SDLx::Surface->new( surface => $rotated )->blit($background);

			$self->_handle_surface( $background->surface );
			$self->alpha_key( $_alpha_key{ refaddr $self} );
		} else {
			$self->_handle_surface($rotated);
		}

		$self->alpha( $_alpha{ refaddr $self} ) if $_alpha{ refaddr $self};
		$_angle{ refaddr $self} = $angle;
	}
	return $_angle{ refaddr $self};
}

1;
