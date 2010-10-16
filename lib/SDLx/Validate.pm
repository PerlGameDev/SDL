#Interal Module to validate SDLx types
package SDLx::Validate;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

$SIG{__WARN__} = sub { warn $_[0] unless $_[0] =~ /Use of uninitialized value in subroutine entry/};

use Carp ();
use Scalar::Util ();

sub surface {
	my ($arg) = @_;
	if ( Scalar::Util::blessed($arg) and $arg->isa("SDL::Surface") ) {
		return $arg;
	}
	Carp::confess("Surface must be SDL::Surface or SDLx::Surface");
}

sub surfacex {
	my ($arg) = @_;
	if ( Scalar::Util::blessed($arg)) {
		if ( $arg->isa("SDLx::Surface") ) {
			return $arg;
		}
		if( $arg->isa("SDL::Surface") ) {
			require SDLx::Surface;
			return SDLx::Surface->new( surface => $arg );
		}
	}
	Carp::confess("Surface must be SDL::Surface or SDLx::Surface");
}

sub num_rgba {
	my ($color) = @_;
	my $format = _color_format($color);
	if ( $format eq 'number' ) {
		no warnings 'uninitialized';
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
		no warnings 'uninitialized';
		my $n = _color_number($color, 0);
		return [ $n >> 16 & 0xFF, $n >> 8 & 0xFF, $n & 0xFF ];
	} elsif ( $format eq 'arrayref' ) {
		return _color_arrayref($color);
	} elsif ( $format eq 'SDLx::Color' ) {
		return [ $color->r, $color->g, $color->b ];
	}
}

sub list_rgba {
	my ($color) = @_;
	my $format = _color_format( $color );
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


bootstrap SDLx::Validate;

1;

