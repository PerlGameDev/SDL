#!/usr/bin/env perl
#
# OpenGL.pm
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
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
#	David J. Goehrig
#	dgoehrig@cpan.org
#

package SDL::OpenGL;

use strict;
use warnings;
use Carp;

require Exporter;
require DynaLoader;
use vars qw(
	@EXPORT
	@ISA
);
@ISA=qw(Exporter DynaLoader);

use SDL;

bootstrap SDL::OpenGL;
for ( keys %SDL::OpenGL:: ) {
	if (/^gl/) {
		push @EXPORT,$_;
	}
}

use SDL::OpenGL::Constants;

sub import {
	  my $self = shift;
	   
	    $self->export_to_level(1, @_);
      SDL::OpenGL::Constants->export_to_level(1);
      }



1;

