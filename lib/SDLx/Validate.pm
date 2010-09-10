#Interal Module to validate SDLx types
package SDLx::Validate;
use strict;
use warnings;
use Carp;
use Scalar::Util ();

sub surface {
	my ($arg) = @_;
	Carp::confess("Wrong amount of arguments")
		unless @_ == 1;
	if ( Scalar::Util::blessed($arg) and $arg->isa("SDL::Surface") ) {
		return $arg;
	} elsif ( Scalar::Util::blessed($arg) and $arg->isa("SDLx::Surface") ) {
		require SDLx::Surface;
		return $arg->surface();
	} else {
		Carp::confess("Surface must be SDL::Surface or SDLx::Surface");
	}
}

sub surfacex {
	my ($arg) = @_;
	Carp::confess("Wrong amount of arguments")
		unless @_ == 1;
	if ( Scalar::Util::blessed($arg) and $arg->isa("SDL::Surface") ) {
		require SDLx::Surface;
		return SDLx::Surface->new( surface => $arg );
	} elsif ( Scalar::Util::blessed($arg) and $arg->isa("SDLx::Surface") ) {
		return $arg;
	} else {
		Carp::confess("Surface must be SDL::Surface or SDLx::Surface");
	}
}

sub rect {
	my ($arg) = @_;
	Carp::confess("Wrong amount of arguments")
		unless @_ == 1;
	if ( !defined $arg ) {
		return SDL::Rect->new( 0, 0, 0, 0 );
	} elsif ( ref $arg eq "ARRAY" ) {
		Carp::cluck("Rect arrayref had more than 4 values")
			if @$arg > 4;
		require SDL::Rect;
		return SDL::Rect->new( map { $_ || 0 } @$arg[ 0 .. 3 ] );
	} elsif ( Scalar::Util::blessed($arg) and $arg->isa("SDL::Rect") ) {
		return $arg;
	} else {
		Carp::confess("Rect must be arrayref or SDL::Rect or undef");
	}
}

sub _color_number {
	my ( $color, $alpha ) = @_;
	if ( !defined $color || $color < 0 ) {
		Carp::cluck("Color was a negative number") if defined $color && $color < 0;
		if ($alpha) {
			return 0x000000FF;
		} else {
			return 0x000000;
		}
	} else {
		if ( $alpha && $color > 0xFFFFFFFF ) {
			Carp::cluck("Color was number greater than maximum expected: 0xFFFFFFFF");
			return 0xFFFFFFFF;
		} elsif ( !$alpha && $color > 0xFFFFFF ) {
			Carp::cluck("Color was number greater than maximum expected: 0xFFFFFF");
			return 0xFFFFFF;
		}
	}
	return $color;
}

sub _color_arrayref {
	my ( $color, $alpha ) = @_;
	my @valid;
	my $length = $alpha ? 4 : 3;
	foreach my $i ( 0 .. $length - 1 ) {
		Carp::confess("All values in color arrayref must be numbers or undef")
			unless !defined $color->[$i] || Scalar::Util::looks_like_number( $color->[$i] );
		if ( !defined $color->[$i] ) {
			if ( $i == 3 ) { # alpha
				$valid[$i] = 0xFF;
			} else {
				$valid[$i] = 0;
			}
		} elsif ( $color->[$i] > 0xFF ) {
			Carp::cluck("Number in color arrayref was greater than maximum expected: 0xFF");
			$valid[$i] = 0xFF;
		} elsif ( $color->[$i] < 0 ) {
			Carp::cluck("Number in color arrayref was negative");
			$valid[$i] = 0;
		} else {
			$valid[$i] = $color->[$i];
		}
	}
	return \@valid;
}

sub _color_format {
	my ($color) = @_;
	if ( !defined $color || Scalar::Util::looks_like_number($color) ) {
		return 'number';
	} elsif ( ref $color eq "ARRAY" ) {
		return 'arrayref';
	} elsif ( Scalar::Util::blessed($color) || $color->isa("SDL::Color") ) {
		return 'SDLx::Color';
	} else {
		Carp::confess("Color must be number or arrayref or SDLx::Color");
	}
}

sub num_rgb {
	my ($color) = @_;
	my $format = _color_format($color);
	if ( $format eq 'number' ) {
		return _color_number($color);
	} elsif ( $format eq 'arrayref' ) {
		my $c = _color_arrayref($color);
		return ( $c->[0] << 16 ) + ( $c->[1] << 8 ) + ( $c->[2] );
	} elsif ( $format eq 'SDLx::Color' ) {
		return ( $color->r << 16 ) + ( $color->g << 8 ) + $color->b;
	}
}

sub num_rgba {
	my ($color) = @_;
	my $format = _color_format($color);
	if ( $format eq 'number' ) {
		return _color_number( $color, 1 );
	} elsif ( $format eq 'arrayref' ) {
		my $c = _color_arrayref( $color, 1 );
		return ( $c->[0] << 24 ) + ( $c->[1] << 16 ) + ( $c->[2] << 8 ) + ( $c->[3] );
	} elsif ( $format eq 'SDLx::Color' ) {
		return ( $color->r << 24 ) + ( $color->g << 16 ) + ( $color->b << 8 ) + 0xFF;
	}
}

sub list_rgb {
	my ($color) = @_;
	my $format = _color_format($color);
	if ( $format eq 'number' ) {
		my $n = _color_number($color);
		return [ $n >> 16 & 0xFF, $n >> 8 & 0xFF, $n & 0xFF ];
	} elsif ( $format eq 'arrayref' ) {
		return _color_arrayref($color);
	} elsif ( $format eq 'SDLx::Color' ) {
		return [ $color->r, $color->g, $color->b ];
	}
}

sub list_rgba {
	my ($color) = @_;
	my $format = _color_format( $color, 1 );
	if ( $format eq 'number' ) {
		my $n = _color_number( $color, 1 );
		return [ $n >> 24 & 0xFF, $n >> 16 & 0xFF, $n >> 8 & 0xFF, $n & 0xFF ];
	} elsif ( $format eq 'arrayref' ) {
		return _color_arrayref( $color, 1 );
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
