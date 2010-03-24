#!/usr/bin/env perl
#
# SDL.pm
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
# Copyright (C) 2009 Kartik Thakore   <kthakore@cpan.org>
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
use SDL::Constants;
our @ISA = qw(Exporter DynaLoader);

our $VERSION = '2.3_9'; #Development Release
$VERSION = eval $VERSION;

print "$VERSION" if (defined($ARGV[0]) && ($ARGV[0] eq '--SDLperl'));

$SDL::DEBUG=0;

sub NULL {
	return 0;
}

# workaround as:
# extern DECLSPEC void SDLCALL SDL_SetError(const char *fmt, ...);
sub set_error {
	my($format, @arguments) = @_;
	SDL::set_error_real(sprintf($format, @arguments));
}

use base 'Exporter';

our @EXPORT = qw(
	SDL_INIT_AUDIO
	SDL_INIT_CDROM
	SDL_INIT_EVENTTHREAD
	SDL_INIT_EVERYTHING
	SDL_INIT_JOYSTICK
	SDL_INIT_NOPARACHUTE
	SDL_INIT_TIMER
	SDL_INIT_VIDEO
);

our %EXPORT_TAGS = 
(
	init => [qw(
		SDL_INIT_AUDIO
		SDL_INIT_CDROM
		SDL_INIT_EVENTTHREAD
		SDL_INIT_EVERYTHING
		SDL_INIT_JOYSTICK
		SDL_INIT_NOPARACHUTE
		SDL_INIT_TIMER
		SDL_INIT_VIDEO
	)]
);

use constant{
	SDL_INIT_TIMER       => 0x00000001,
	SDL_INIT_AUDIO       => 0x00000010,
	SDL_INIT_VIDEO       => 0x00000020,
	SDL_INIT_CDROM       => 0x00000100,
	SDL_INIT_JOYSTICK    => 0x00000200,
	SDL_INIT_NOPARACHUTE => 0x00100000,
	SDL_INIT_EVENTTHREAD => 0x01000000,
	SDL_INIT_EVERYTHING  => 0x0000FFFF,
};

# add all the other ":class" tags to the ":all" class,
# deleting duplicates
my %seen;
push @{$EXPORT_TAGS{all}},
grep {!$seen{$_}++} @{$EXPORT_TAGS{$_}} foreach keys %EXPORT_TAGS;

1;
