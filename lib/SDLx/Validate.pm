#Interal Module to validate SDLx types
package SDLx::Validate;
use strict;
use warnings;
use Carp;
use Scalar::Util ();

sub surface {
	my ($arg) = @_;
	Carp::croak("Wrong amount of arguments")
		unless @_ == 1;
	if ( Scalar::Util::blessed($arg) and $arg->isa("SDL::Surface") ) {
		return $arg;
	} elsif ( Scalar::Util::blessed($arg) and $arg->isa("SDLx::Surface") ) {
		require SDLx::Surface;
		return $arg->surface();
	} else {
		Carp::croak("Surface must be SDL::Surface or SDLx::Surface");
	}
}

sub surfacex {
	my ($arg) = @_;
	Carp::croak("Wrong amount of arguments")
		unless @_ == 1;
	if ( Scalar::Util::blessed($arg) and $arg->isa("SDL::Surface") ) {
		require SDLx::Surface;
		return SDLx::Surface->new( surface => $arg );
	} elsif ( Scalar::Util::blessed($arg) and $arg->isa("SDLx::Surface") ) {
		return $arg;
	} else {
		Carp::croak("Surface must be SDL::Surface or SDLx::Surface");
	}
}

sub rect {
	my ($arg) = @_;
	Carp::croak("Wrong amount of arguments")
		unless @_ == 1;
	if ( !defined $arg ) {
		return SDL::Rect->new( 0, 0, 0, 0 );
	} elsif ( ref $arg eq "ARRAY" ) {
		Carp::carp("Rect arrayref had more than 4 values")
			if @$arg > 4;
		require SDL::Rect;
		return SDL::Rect->new( map { $_ || 0 } @$arg[ 0 .. 3 ] );
	} elsif ( Scalar::Util::blessed($arg) and $arg->isa("SDL::Rect") ) {
		return $arg;
	} else {
		Carp::croak("Rect must be arrayref or SDL::Rect or undef");
	}
}

sub _color_number {
	if ( !defined $_[0] || $_[0] < 0 ) {
		Carp::carp("Color was a negative number") if defined $_[0] && $_[0] < 0;
		if ( $_[1] ) {
			$_[0] = 0x000000FF;
		} else {
			$_[0] = 0x000000;
		}
	} else {
		if ( $_[1] && $_[0] > 0xFFFFFFFF ) {
			Carp::carp("Color was number greater than maximum expected: 0xFFFFFFFF");
			$_[0] = 0xFFFFFFFF;
		} elsif ( !$_[1] && $_[0] > 0xFFFFFF ) {
			Carp::carp("Color was number greater than maximum expected: 0xFFFFFF");
			$_[0] = 0xFFFFFF;
		}
	}
}

sub _color_arrayref {
	my $length = $_[1] ? 4 : 3;
	foreach my $i ( 0 .. $length - 1 ) {
		Carp::croak("All values in color arrayref must be numbers or undef")
			unless !defined $_[0]->[$i] || Scalar::Util::looks_like_number( $_[0]->[$i] );
		if ( !defined $_[0]->[$i] ) {
			if ( $i == 3 ) { # alpha
				$_[0]->[$i] = 0xFF;
			} else {
				$_[0]->[$i] = 0;
			}
		} elsif ( $_[0]->[$i] > 0xFF ) {
			Carp::carp("Number in color arrayref was greater than maximum expected: 0xFF");
			$_[0]->[$i] = 0xFF;
		} elsif ( $_[0]->[$i] < 0 ) {
			Carp::carp("Number in color arrayref was negative");
			$_[0]->[$i] = 0;
		}
	}
}

sub _color_format {
	if ( !defined $_[0] || Scalar::Util::looks_like_number( $_[0] ) ) {
		_color_number(@_);
		return 'number';
	} elsif ( ref $_[0] eq "ARRAY" ) {
		_color_arrayref(@_);
		return 'arrayref';
	} elsif ( Scalar::Util::blessed( $_[0] ) || $_[0]->isa("SDL::Color") ) {
		return 'SDLx::Color';
	} else {
		Carp::croak("Color must be number or arrayref or SDLx::Color");
	}
}

sub num_rgb {
	my ($color) = @_;
	my $format = _color_format($color);
	if ( $format eq 'number' ) {
		return $color;
	} elsif ( $format eq 'arrayref' ) {
		return ( $color->[0] << 16 ) + ( $color->[1] << 8 ) + ( $color->[2] );
	} elsif ( $format eq 'SDLx::Color' ) {
		return ( $color->r << 16 ) + ( $color->g << 8 ) + $color->b;
	}
}

sub num_rgba {
	my ($color) = @_;
	my $format = _color_format( $color, 1 );
	if ( $format eq 'number' ) {
		return $color;
	} elsif ( $format eq 'arrayref' ) {
		return ( $color->[0] << 24 ) + ( $color->[1] << 16 ) + ( $color->[2] << 8 ) + ( $color->[3] );
	} elsif ( $format eq 'SDLx::Color' ) {
		return ( $color->r << 24 ) + ( $color->g << 16 ) + ( $color->b << 8 ) + 0xFF;
	}
}

sub list_rgb {
	my ($color) = @_;
	my $format = _color_format($color);
	if ( $format eq 'number' ) {
		return [ $color >> 16 & 0xFF, $color >> 8 & 0xFF, $color & 0xFF ];
	} elsif ( $format eq 'arrayref' ) {
		return $color;
	} elsif ( $format eq 'SDLx::Color' ) {
		return [ $color->r, $color->g, $color->b ];
	}
}

sub list_rgba {
	my ($color) = @_;
	my $format = _color_format( $color, 1 );
	if ( $format eq 'number' ) {
		return [ $color >> 24 & 0xFF, $color >> 16 & 0xFF, $color >> 8 & 0xFF, $color & 0xFF ];
	} elsif ( $format eq 'arrayref' ) {
		return $color;
	} elsif ( $format eq 'SDLx::Color' ) {
		return [ $color->r, $color->g, $color->b, 0xFF ];
	}
}

sub color {
	require SDL::Color;
	return SDL::Color->new( @{ list_rgb(@_) } );
}

sub map_rgb {
	my ( $color, $format ) = @_;

	require SDL::Video;
	return SDL::Video::map_RGB( $format, @{ list_rgb($color) } );
}

sub map_rgba {
	my ( $color, $format ) = @_;

	require SDL::Video;
	return SDL::Video::map_RGBA( $format, @{ list_rgba($color) } );
}

1;
