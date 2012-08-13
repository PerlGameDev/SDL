package SDLx::Surface;
use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use Carp ();
use SDL;
use SDL::Rect;
use SDL::Video;
use SDL::Image;
use SDL::Color;
use SDL::Config;
use SDL::Surface;
use SDL::PixelFormat;

use SDL::GFX::Primitives;

use Tie::Simple;
use SDLx::Validate;
use SDLx::Surface::TiedMatrix;

use overload (
	'@{}'    => '_array',
	fallback => 1,
);
use SDL::Constants ':SDL::Video';
our @ISA = qw(Exporter DynaLoader SDL::Surface);

our $VERSION    = '2.541_10';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

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
			Carp::confess 'Provide surface, or atleast width and height';
		}
	}
	if ( exists $options{color} ) {
		$self->draw_rect( undef, $options{color} );
	}
	return $self;
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
		Carp::confess 'set_video_mode externally or atleast provide width and height';
	}

}

sub duplicate {
	my $surface = shift;
	SDLx::Validate::surface($surface);
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

	$new_value = SDLx::Validate::num_rgba($new_value);

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

sub width  { $_[0]->w }
sub height { $_[0]->h }

#WRAPPING

sub clip_rect {

	SDL::Video::set_clip_rect( @_[ 0, 1 ] ) if $_[1] && $_[1]->isa('SDL::Rect');
	my $r = $_[1] || SDL::Rect->new( 0, 0, 0, 0 );
	SDL::Video::get_clip_rect( $_[0], $r );
	return $r;

}

sub load {
	my ( $self, $filename, $type ) = @_;
	my $surface;

	# short-circuit if it's a bitmap
	if ( ( $type and lc $type eq 'bmp' )
		or lc substr( $filename, -4, 4 ) eq '.bmp' )
	{
		$surface = SDL::Video::load_BMP($filename)
			or Carp::confess "error loading image $filename: " . SDL::get_error;
	} else {

		# otherwise, make sure we can load first
		#eval { require SDL::Image; 1 }; This doesn't work. As you can still load SDL::Image but can't call any functions.
		#
		Carp::confess 'no SDL_image support found. Can only load bitmaps'
			unless SDL::Config->has('SDL_image'); #this checks if we actually have that library. C Library != SDL::Image

		require SDL::Image;

		if ($type) {                              #I don't understand what you are doing here
			require SDL::RWOps;
			my $file = SDL::RWOps->new_file( $filename, "rb" )
				or Carp::confess "error loading file $filename: " . SDL::get_error;
			$surface = SDL::Image::load_typed_rw( $file, 1, $type )
				or Carp::confess "error loading image $file: " . SDL::get_error;
		} else {
			$surface = SDL::Image::load($filename)
				or Carp::confess "error loading image $filename: " . SDL::get_error;
		}
	}

	my $formated_surface = $surface;
	if (SDL::Video::get_video_surface) {

		#Reduces memory usage for loaded images
		$formated_surface = SDL::Video::display_format_alpha($surface);
	}
	return SDLx::Surface->new( surface => $formated_surface );
}

#EXTENSTIONS

sub blit_by {
	my ( $dest, $src, $src_rect, $dest_rect ) = @_;
	SDLx::Surface::blit( $src, $dest, $src_rect, $dest_rect );
}

sub flip {
	Carp::confess "surface is not defined" unless $_[0];
	Carp::confess "Error flipping surface: " . SDL::get_error()
		if ( SDL::Video::flip( $_[0] ) == -1 );
	return $_[0];

}

sub update {
	my ( $surface, $rects ) = @_;

	if ( !defined($rects) || ( ref($rects) eq 'ARRAY' && !ref( $rects->[0] ) ) ) {
		my @rect;
		@rect = @{$rects} if $rects;
		$rect[0] ||= 0;
		$rect[1] ||= 0;
		$rect[2] ||= $surface->w;
		$rect[3] ||= $surface->h;

		SDL::Video::update_rect( $surface, @rect );
	} else {
		SDL::Video::update_rects( $surface, map { SDLx::Validate::rect($_) } @{$rects} );
	}

	return $surface;
}

sub draw_line {
	my ( $self, $start, $end, $color, $antialias ) = @_;

	Carp::confess "Error start needs an array ref [x,y]"
		unless ref($start) eq 'ARRAY';
	Carp::confess "Error end needs an array ref [x,y]"
		unless ref($end) eq 'ARRAY';

	unless ( SDL::Config->has('SDL_gfx_primitives') ) {
		Carp::cluck("SDL_gfx_primitives support has not been compiled");
		return;
	}

	$color = SDLx::Validate::num_rgba($color);

	my $result;
	if ($antialias) {
		$result = SDL::GFX::Primitives::aaline_color( $self, @$start, @$end, $color );
	} else {
		$result = SDL::GFX::Primitives::line_color( $self, @$start, @$end, $color );
	}

	Carp::confess "Error drawing line: " . SDL::get_error() if ( $result == -1 );

	return $self;
}

sub draw_circle {
	my ( $self, $center, $radius, $color, $antialias ) = @_;

	unless ( SDL::Config->has('SDL_gfx_primitives') ) {
		Carp::cluck("SDL_gfx_primitives support has not been compiled");
		return;
	}

	Carp::cluck "Center needs to be an array of format [x,y]" unless ( ref $center eq 'ARRAY' && scalar @$center == 2 );
	$color = SDLx::Validate::num_rgba($color);

	unless ($antialias) {
		SDL::GFX::Primitives::circle_color( $self, @{$center}, $radius, $color );
	} else {
		SDL::GFX::Primitives::aacircle_color( $self, @{$center}, $radius, $color );
	}
	return $self;
}

sub draw_circle_filled {
	my ( $self, $center, $radius, $color ) = @_;

	unless ( SDL::Config->has('SDL_gfx_primitives') ) {
		Carp::cluck("SDL_gfx_primitives support has not been compiled");
		return;
	}

	Carp::cluck "Center needs to be an array of format [x,y]" unless ( ref $center eq 'ARRAY' && scalar @$center == 2 );
	$color = SDLx::Validate::num_rgba($color);

	SDL::GFX::Primitives::filled_circle_color( $self, @{$center}, $radius, $color );

	return $self;
}

sub draw_trigon {
	my ( $self, $vertices, $color, $antialias ) = @_;

	$color = SDLx::Validate::num_rgba($color);

	if ($antialias) {
		SDL::GFX::Primitives::aatrigon_color(
			$self,             $vertices->[0][0], $vertices->[0][1], $vertices->[1][0],
			$vertices->[1][1], $vertices->[2][0], $vertices->[2][1], $color
		);
	} else {
		SDL::GFX::Primitives::trigon_color(
			$self,             $vertices->[0][0], $vertices->[0][1], $vertices->[1][0],
			$vertices->[1][1], $vertices->[2][0], $vertices->[2][1], $color
		);
	}

	return $self;
}

sub draw_trigon_filled {
	my ( $self, $vertices, $color ) = @_;

	$color = SDLx::Validate::num_rgba($color);

	SDL::GFX::Primitives::filled_trigon_color(
		$self,             $vertices->[0][0], $vertices->[0][1], $vertices->[1][0],
		$vertices->[1][1], $vertices->[2][0], $vertices->[2][1], $color
	);

	return $self;
}

sub draw_polygon_filled {
	my ( $self, $vertices, $color ) = @_;

	$color = SDLx::Validate::num_rgba($color);

	my @vx = map { $_->[0] } @$vertices;
	my @vy = map { $_->[1] } @$vertices;
	SDL::GFX::Primitives::filled_polygon_color( $self, \@vx, \@vy, scalar @$vertices, $color );

	return $self;
}

sub draw_arc {
	my ( $self, $center, $radius, $start, $end, $color ) = @_;

	Carp::cluck "Center needs to be an array of format [x,y]" unless ( ref $center eq 'ARRAY' && scalar @$center == 2 );
	$color = SDLx::Validate::num_rgba($color);

	SDL::GFX::Primitives::arc_color( $self, @$center, $radius, $start, $end, $color );

	return $self;
}

sub draw_ellipse {
	my ( $self, $center, $rx, $ry, $color, $antialias ) = @_;

	Carp::cluck "Center needs to be an array of format [x,y]" unless ( ref $center eq 'ARRAY' && scalar @$center == 2 );
	$color = SDLx::Validate::num_rgba($color);

	if ($antialias) {
		SDL::GFX::Primitives::aaellipse_color( $self, @$center, $rx, $ry, $color );
	} else {
		SDL::GFX::Primitives::ellipse_color( $self, @$center, $rx, $ry, $color );
	}

	return $self;
}

sub draw_ellipse_filled {
	my ( $self, $center, $rx, $ry, $color ) = @_;

	Carp::cluck "Center needs to be an array of format [x,y]" unless ( ref $center eq 'ARRAY' && scalar @$center == 2 );
	$color = SDLx::Validate::num_rgba($color);

	SDL::GFX::Primitives::filled_ellipse_color( $self, @$center, $rx, $ry, $color );

	return $self;
}

sub draw_bezier {
	my ( $self, $vector, $smooth, $color ) = @_;

	$color = SDLx::Validate::num_rgba($color);

	my @vx = map { $_->[0] } @$vector;
	my @vy = map { $_->[1] } @$vector;
	SDL::GFX::Primitives::bezier_color( $self, \@vx, \@vy, scalar @$vector, $smooth, $color );

	return $self;
}

sub draw_gfx_text {
	my ( $self, $vector, $color, $text, $font ) = @_;

	unless ( SDL::Config->has('SDL_gfx_primitives') ) {
		Carp::cluck("SDL_gfx_primitives support has not been compiled");
		return;
	}

	if ($font) {
		if ( ref($font) eq 'HASH' && exists $font->{data} && exists $font->{cw} && exists $font->{ch} ) {
			SDL::GFX::Primitives::set_font( $font->{data}, $font->{cw}, $font->{ch} );
		} else {
			Carp::cluck
				"Set font data as a hash of type \n \$font = {data => \$data, cw => \$cw,  ch => \$ch}. \n Refer to perldoc SDL::GFX::Primitives set_font for initializing this variables.";
		}
	}
	Carp::confess "vector needs to be an array ref of size 2. [x,y] "
		unless ( ref($vector) eq 'ARRAY' && scalar(@$vector) == 2 );

	$color = SDLx::Validate::num_rgba($color);

	my $result = SDL::GFX::Primitives::string_color( $self, $vector->[0], $vector->[1], $text, $color );

	Carp::confess "Error drawing text: " . SDL::get_error() if ( $result == -1 );

	return $self;
}

sub DESTROY {
	my $self = shift;
	delete $_tied_array{$$self};
	SDL::Surface::DESTROY($self);
}

1;
