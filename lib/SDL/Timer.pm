#!/usr/bin/env perl
#
# Timer.pm
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

package SDL::Timer;

use strict;
use warnings;
use Carp;
use SDL;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self = {};
	my $func = shift;
	my (%options) = @_;

	verify(%options,qw/ -delay -times -d -t /);

	croak "SDL::Timer::new no delay specified\n"
		unless ($options{-delay});
	$$self{-delay} = $options{-delay} || $options{-d} || 0;
	$$self{-times} = $options{-times} || $options{-t} || 0;
	if ($$self{-times}) {
		$$self{-routine} = sub { &$func($self); $$self{-delay} if(--$$self{-times}) };
	} else {
		$$self{-routine} = sub { &$func; $$self{-delay}};
	}
	$$self{-timer} = SDL::NewTimer($$self{-delay},$$self{-routine});
	croak "Could not create timer, ", SDL::get_error(), "\n"
		unless ($self->{-timer});
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::RemoveTimer($$self{-timer}) if ($$self{-timer});
	$$self{-timer} = 0;
}

sub run {
	my ($self,$delay,$times) = @_;
	$$self{-delay} = $delay;
	$$self{-times} = $times;
	SDL::RemoveTimer($$self{-timer}) if ($$self{-timer});
	$$self{-timer} = SDL::AddTimer($$self{-delay},SDL::PerlTimerCallback,$$self{-routine});
}

sub stop {
	my ($self) = @_;
	SDL::RemoveTimer($$self{-timer}) if ($$self{-timer});
	$$self{-timer} = 0;
}

1;
