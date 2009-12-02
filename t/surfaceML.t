#!/usr/bin/perl -w
#
# Copyright (C) 2009 Kartik Thakore
#
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
#	kthakore\@cpan.org
#
#
# Memory leaks testing

BEGIN {
	unshift @INC, 'blib/lib', 'blib/arch';
}

use strict;

use Test::More;

# Don't run tests for installs
 unless ( $ENV{AUTOMATED_TESTING} or $ENV{RELEASE_TESTING} ) {
         plan( skip_all => "Author tests not required for installation" );
         }


# This is stolen for Gabor's examples in padre's SDL plugin
sub surface_leak()
{
	use SDL;
	use SDL::App;
	use SDL::Rect;
	use SDL::Color;

	my $window = SDL::App->new(
		-width => 640,
		-height => 480,
		-depth => 16,
		-title => 'SDL Demo',
		-init => SDL_INIT_VIDEO

	);

	my $rect = SDL::Rect->new(0,0, 10, 20);

	my $blue = SDL::Color->new(
		-r => 0x00,
		-g => 0x00,
		-b => 0xff,
	);
	$window->fill($rect, $blue);
	$window->update($rect);

}

eval 'use Test::Valgrind';
plan skip_all => 'Test::Valgrind is required to test your distribution with valgrind' if $@;

surface_leak();



sleep(2);
