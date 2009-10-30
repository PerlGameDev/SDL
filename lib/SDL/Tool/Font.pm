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

package SDL::Tool::Font;

use strict;
use warnings;
use Carp;

use SDL;
use SDL::Font;
use SDL::TTFont;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	my %option = @_;

	verify (%option, qw/ -sfont -ttfont -size -fg -bg -foreground -background
			  	-normal -bold -italic -underline / ) if $SDL::DEBUG;

	if ($option{-sfont}) {
		$$self{-font} = new SDL::Font $option{-sfont};
	} elsif ($option{-ttfont} || $option{-t}) {
		$option{-size} ||= 12;
		$$self{-font} = new SDL::TTFont 
					-name => $option{-ttfont} || $option{-t},
					-size => $option{-size} || $option{-s},
					-fg => $option{-foreground} || $option{-fg} ,
					-bg => $option{-background} || $option{-bg};
		for (qw/ normal bold italic underline / ) {
			if ($option{"-$_"}) {
				
				SDL::TTFont->can($_)->($$self{-font});
				#&{$sub}($$self{-font});
			}
		}
	} else {
		croak "SDL::Tool::Font requires either a -sfont or -ttfont";	
	}
	bless $self,$class;
	$self;
}

sub DESTROY {

}

sub print {
	my ($self,$surface,$x,$y,@text) = @_;
	croak "Tool::Font::print requires a SDL::Surface\n"
		unless ($surface->isa('SDL::Surface'));
	if ($$self{-font}->isa('SDL::Font')) {
		$$self{-font}->use();
		SDL::SFont::PutString( $$surface, $x, $y, join('',@text));
	} else {
		$$self{-font}->print($surface,$x,$y,@text);
	}
}

1;
