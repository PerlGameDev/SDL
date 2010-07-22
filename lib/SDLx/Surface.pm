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
use SDL::GFX::Primitives;
use SDL::PixelFormat;
use Tie::Simple;

use overload (
    '@{}'    => '_array',
    fallback => 1,
);
use SDL::Constants ':SDL::Video';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDLx::Surface;

sub new {
    my ( $class, %options ) = @_;
    my $self = bless {}, ref $class || $class;

    if ( $options{surface} ) {
        $self->surface( $options{surface} );
    }
    else {
        my $width  = $options{width}  || $options{w};
        my $height = $options{height} || $options{h};
        if ( $width and $height )    #atleast give a dimension
        {
            $options{flags} ||= SDL_ANYFORMAT;
            $options{depth} ||= 32;

            $options{redmask}   ||= 0xFF000000;
            $options{greenmask} ||= 0x00FF0000;
            $options{bluemask}  ||= 0x0000FF00;
            $options{alphamask} ||= 0x000000FF;

            my $surface = SDL::Surface->new(
                $options{flags},    $width,            $height,
                $options{depth},    $options{redmask}, $options{greenmask},
                $options{bluemask}, $options{alphamask}
            );
            $self->surface($surface);
        }
        else {
            Carp::croak 'Provide surface, or atleast width and height';
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
    if ( $width and $height )    #atleast give a dimension
    {
        $options{depth} ||= 32;
        $options{flags} ||= SDL_ANYFORMAT;

        my $surface =
          SDL::Video::set_video_mode( $width, $height, $options{depth},
            $options{flags}, );
        return SDLx::Surface->new( surface => $surface );
    }
    else {
        Carp::croak
          'set_video_mode externally or atleast provide width and height';
    }

}

sub duplicate {
    my $surface = shift;
    Carp::croak 'SDLx::Surface or SDL::Surface for surface required'
      unless ( $surface->isa('SDL::Surface')
        || $surface->isa('SDLx::Surface') );
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
        $self->{_tied_array} = $array if $array;
    }
    return $self->{_tied_array};
}

sub get_pixel {
    my ( $self, $y, $x ) = @_;
    return SDLx::Surface::get_pixel_xs( $self->{surface}, $x, $y );
}

sub set_pixel {
    my ( $self, $y, $x, $new_value ) = @_;
    SDLx::Surface::set_pixel_xs( $self->{surface}, $x, $y, $new_value );

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

sub surface {
    return $_[0]->{surface} unless $_[1];
    my ( $self, $surface ) = @_;
    Carp::croak 'surface accepts only SDL::Surface objects'
      unless $surface->isa('SDL::Surface');

    $self->{surface} = $surface;
    return $self->{surface};
}

#WRAPPING

sub w {
    $_[0]->surface->w();
}

sub h {
    $_[0]->surface->h();
}

sub format {
    $_[0]->surface->format();
}

sub pitch {
    $_[0]->surface->pitch();
}

sub flags {
    $_[0]->surface->flags();
}

sub clip_rect {

    SDL::Video::set_clip_rect( $_[1] ) if $_[1] && $_[1]->isa('SDL::Rect');
    SDL::Video::get_clip_rect( $_[0]->surface );

}

#EXTENSTIONS

sub blit {
    my ( $self, $dest, $src_rect, $dest_rect ) = @_;

    Carp::croak 'SDLx::Surface or SDL::Surface for dest required'
      unless ( $dest->isa('SDL::Surface') || $dest->isa('SDLx::Surface') );

    my $self_surface = $self;
    $self_surface = $self->surface if $self->isa('SDLx::Surface');

    my $dest_surface = $dest;
    $dest_surface = $dest->surface if $dest->isa('SDLx::Surface');

    $src_rect = SDL::Rect->new( 0, 0, $self_surface->w, $self_surface->h )
      unless defined $src_rect;
    $dest_rect = SDL::Rect->new( 0, 0, $dest_surface->w, $dest_surface->h )
      unless defined $dest_rect;

    Carp::croak 'Array ref or SDL::Rect for source rect required.'
      unless ( ref($src_rect) eq 'ARRAY' ) || $src_rect->isa('SDL::Rect');
    Carp::croak 'Array ref or SDL::Rect for dest rect required'
      unless ( ref($dest_rect) eq 'ARRAY' ) || ( $dest_rect->isa('SDL::Rect') );

    my $pass_src_rect = $src_rect;
    $pass_src_rect = SDL::Rect->new( @{$src_rect} ) if ref $src_rect eq 'ARRAY';

    my $pass_dest_rect = $dest_rect;
    $pass_dest_rect = SDL::Rect->new( @{$dest_rect} )
      if ref $dest_rect eq 'ARRAY';

    Carp::croak 'Destination was not a surface'
      unless $dest_surface->isa('SDL::Surface');
    SDL::Video::blit_surface( $self_surface, $pass_src_rect, $dest_surface,
        $pass_dest_rect );

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

    if ( !defined($rects) || ( ref($rects) eq 'ARRAY' && !ref( $rects->[0] ) ) )
    {
        my @pass_rect = ();
        @pass_rect = @{ $rects->[0] } if $rects->[0];
        $pass_rect[0] |= 0;
        $pass_rect[1] |= 0;
        $pass_rect[2] |= $self->surface->w;
        $pass_rect[3] |= $self->surface->h;

        SDL::Video::update_rect( $self->surface(), @pass_rect );
    }
    else {

        #TODO: Validate each rect?
        SDL::Video::update_rects( $self->surface(), @{$rects} );
    }

    return $self;
}

sub draw_rect {
    my ( $self, $rect, $color ) = @_;
    Carp::croak "Rect needs to be a SDL::Rect or array ref or undef"
      unless !defined($rect)
          || ref($rect) eq 'ARRAY'
          || $rect->isa('SDL::Rect');
    require Scalar::Util;
    if ( Scalar::Util::looks_like_number($color) ) {

    }
    elsif ( $color->isa('SDL::Color') ) {
        $color =
          ( $color->r << 24 ) + ( $color->g << 16 ) + ( $color->b << 8 ) + 0xFF;
    }
    else {
        Carp::croak "Color needs to be a number or a SDL::Color";
    }

    $rect = (
         !defined($rect) ? SDL::Rect->new( 0, 0, $self->w, $self->h )
        : ref($rect) ? SDL::Rect->new( @{$rect} )
        : $rect
    );

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

    my $result;
    if ( Scalar::Util::looks_like_number($color) ) {
        if ($antialias) {
            $result =
              SDL::GFX::Primitives::aaline_color( $self->surface, @$start,
                @$end, $color );
        }
        else {

            $result =
              SDL::GFX::Primitives::line_color( $self->surface, @$start, @$end,
                $color );
        }
    }
    elsif ( ref($color) eq 'ARRAY' && scalar(@$color) >= 4 ) {

        if ($antialias) {
            $result =
              SDL::GFX::Primitives::aaline_RGBA( $self->surface, @$start, @$end,
                @$color );
        }
        else {

            $result =
              SDL::GFX::Primitives::line_RGBA( $self->surface, @$start, @$end,
                @$color );
        }

    }
    else {
        Carp::croak "Color needs to be a number or array ref [r,g,b,a,...]";

    }

    Carp::croak "Error drawing line: " . SDL::get_error() if ( $result == -1 );

    return $self;
}

#TODO

=pod

sub draw_cirle{
	my ($self, $center, $radius, $color, $antialias) = @_;

	return $self;
}
=cut 

1;
