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

sub color {
	require SDL::Color;
	return SDL::Color->new( @{ list_rgb(@_) } );
}

bootstrap SDLx::Validate;

1;

