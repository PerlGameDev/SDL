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

sub _make_color {
	my ( $t, $arg ) = @_;
	Carp::croak("Wrong amount of arguments")
		unless @_ == 2;
	my ( $num_rgb, $num_rgba, $list_rgb, $list_rgba, $error );
	      $t == 0 ? ( $num_rgb   = 1 )
		: $t == 1 ? ( $num_rgba  = 1 )
		: $t == 3 ? ( $list_rgb  = 1 )
		: $t == 4 ? ( $list_rgba = 1 )
		:           ( $error     = 1 );
	Carp::croak("\$t invalid. You shouldn't be calling this directly anyway")
		if $error;
	$t += 3 if $t < 3; #$t is 3 if rgb and 4 if rgba
	my $list = $list_rgb || $list_rgba;
	if ( !defined $arg or Scalar::Util::looks_like_number($arg) ) {

		if ( !defined $arg or $arg < 0 ) {
			Carp::carp("Color was a negative number")
				if defined $arg and $arg < 0;
			if ($num_rgb) {
				return 0;
			} elsif ($num_rgba) {
				return 0xFF;
			} elsif ($list_rgb) {
				return ( 0, 0, 0 );
			} else {
				return ( 0, 0, 0, 0xFF );
			}
		} elsif ( $arg > 0x100**$t - 1 ) {
			Carp::carp( "Color was number greater than maximum expected: 0x" . "FF" x $t );
			return (
				  $num_rgb  ? 0xFFFFFF
				: $num_rgba ? 0xFFFFFFFF
				: (0xFF) x $t
			);
		}
		if ($list_rgb) {
			return ( $arg >> 16 & 0xFF, $arg >> 8 & 0xFF, $arg & 0xFF );
		} elsif ($list_rgba) {
			return (
				$arg >> 24, $arg >> 16 & 0xFF, $arg >> 8 & 0xFF,
				$arg & 0xFF
			);
		} else {
			return $arg;
		}
	} elsif ( Scalar::Util::blessed($arg) and $arg->isa("SDL::Color") ) {
		if ($num_rgb) {
			return ( ( $arg->r << 16 ) + ( $arg->g << 8 ) + ( $arg->b ) );
		} elsif ($num_rgba) {
			return ( ( $arg->r << 24 ) + ( $arg->g << 16 ) + ( $arg->b << 8 ) + (0xFF) );
		} elsif ($list_rgb) {
			return ( $arg->r, $arg->g, $arg->b );
		} else {
			return ( $arg->r, $arg->g, $arg->b, 0xFF );
		}
	} elsif ( ref $arg eq "ARRAY" ) {
		Carp::carp("Color arrayref had more values than maximum expected: $t")
			if @$arg > $t;
		for ( 0 .. $t - 1 ) {
			my $c = \$$arg[$_];
			Carp::croak("All values in color arrayref must be numbers or undef")
				unless !defined $$c
					or Scalar::Util::looks_like_number($$c);
			if ( !defined $$c ) {
				if ( $_ == 3 ) { # $_ is 3 when doing alpha
					$$c = 0xFF;
				} else {
					$$c = 0;
				}
			} elsif ( $$c > 0xFF ) {
				Carp::carp("Number in color arrayref was greater than maximum expected: 0xFF");
				$$c = 0xFF;
			} elsif ( $$c < 0 ) {
				Carp::carp("Number in color arrayref was negative");
				$$c = 0;
			}
		}
		if ($num_rgb) {
			return ( ( $arg->[0] << 16 ) + ( $arg->[1] << 8 ) + ( $arg->[2] ) );
		} elsif ($num_rgba) {
			return ( ( $arg->[0] << 24 ) + ( $arg->[1] << 16 ) + ( $arg->[2] << 8 ) + ( $arg->[3] ) );
		} else {
			return @$arg;
		}
	} else {
		Carp::croak("Color must be number or arrayref or SDLx::Color");
	}
}

sub num_rgb {
	return ( _make_color( 0, @_ ) );
}

sub num_rgba {
	return ( _make_color( 1, @_ ) );
}

sub list_rgb {
	return ( _make_color( 3, @_ ) );
}

sub list_rgba {
	return ( _make_color( 4, @_ ) );
}

sub color {
	require SDL::Color;
	return SDL::Color->new( _make_color( 3, @_ ) );
}

sub map_rgb {
	require SDL::Video;
	return SDL::Video::map_rgb(
		SDLx::Surface::display->format,
		_make_color( 3, @_ )
	);
}

sub map_rgba {
	require SDL::Video;
	return SDL::Video::map_rgba(
		SDLx::Video::get_display->format,
		_make_color( 4, @_ )
	);
}

1;
