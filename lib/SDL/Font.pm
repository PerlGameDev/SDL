#!/usr/bin/env perl
#
# Font.pm
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

package SDL::Font;

use strict;
use warnings;
use Carp;
use SDL;
use SDL::SFont;
use SDL::Surface;

use vars qw(@ISA $CurrentFont );
	    

@ISA = qw(SDL::Surface);


sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = \SDL::SFont::NewFont(shift);
	bless $self,$class;
	return $self;	
}

sub DESTROY {
	my $self = shift;
	SDL::FreeSurface($$self);
}

sub use ($) {
	my $self = shift;
	$CurrentFont = $self;
	if ( $self->isa('SDL::Font')) {
		SDL::SFont::UseFont($$self);
	}	
}

1;
