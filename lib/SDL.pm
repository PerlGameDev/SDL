#!/usr/bin/env perl
#
# SDL.pm
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
# Copyright (C) 2010 Kartik Thakore   <kthakore@cpan.org>
# ------------------------------------------------------------------------------
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ------------------------------------------------------------------------------
#
# Please feel free to send questions, suggestions or improvements to:
#
#	Kartik Thakore
#	kthakore@cpan.org
#

package SDL;

use strict;
use warnings;
use Carp;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;

use SDL_perl;
use SDL::Constants ':SDL';

#use SDL::Internal::Loader; See TODO near END{}
our @ISA = qw(Exporter DynaLoader);

use base 'Exporter';
our @EXPORT = @{ $SDL::Constants::EXPORT_TAGS{SDL} };
push @EXPORT, 'NULL';
our %EXPORT_TAGS = (
	all      => \@EXPORT,
	init     => $SDL::Constants::EXPORT_TAGS{'SDL/init'},
	defaults => $SDL::Constants::EXPORT_TAGS{'SDL/defaults'}
);

our $VERSION = '2.531';
$VERSION = eval $VERSION;

print "$VERSION" if ( defined( $ARGV[0] ) && ( $ARGV[0] eq '--SDLperl' ) );

$SDL::DEBUG = 0;

sub NULL {
	return 0;
}

# workaround, doing putenv from perl instead of sdl's:
#int
#putenv (variable)
#	char *variable
#	CODE:
#		RETVAL = SDL_putenv(variable);
#	OUTPUT:
#		RETVAL
sub putenv {
	my $cmd = shift;
	if ( $cmd =~ /^(\w+)=(.*)$/ ) {
		$ENV{$1} = $2;
		return 0;
	}

	return -1;
}

# workaround as:
# extern DECLSPEC void SDLCALL SDL_SetError(const char *fmt, ...);
sub set_error {
	my ( $format, @arguments ) = @_;
	SDL::set_error_real( sprintf( $format, @arguments ) );
}


# Hints for Inline.pm
sub Inline
{
    my $language = shift;
    if ($language ne 'C') {
	warn "Warning: SDL.pm does not provide Inline hints for the $language language\n";
	return
    }

	require Alien::SDL;
    require File::Spec;
	my $libs = Alien::SDL->config('libs');
	#This should be added in ldd flags section but it is only doing SDL_main for some reason.
	$libs .= ' '.File::Spec->catfile(Alien::SDL->config('prefix'),'lib','libSDL.dll.a')	if( $^O =~ /Win32/ig );
	my $cflags = Alien::SDL->config('cflags');
	my $path;
	my $sdl_typemap = File::Spec->catfile( 'SDL', 'typemap' );
	 grep { my $find = File::Spec->catfile( $_, $sdl_typemap );
			$path = $find if -e $find } @INC;
    return {
	LIBS => $libs,
	CCFLAGS => $cflags,	
	TYPEMAPS => $path,
	AUTO_INCLUDE => '#include <SDL.h>'
    };



}

1;
