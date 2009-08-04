#!/usr/bin/env perl
#
# Music.pm
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

package SDL::Music;

use strict;
use warnings;
use Carp;
use SDL;

sub new {
	my $proto = shift;	
	my $class = ref($proto) || $proto;
	my $filename = shift;
	my $self = \SDL::MixLoadMusic($filename);
	croak SDL::GetError() unless $$self;
	bless $self,$class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::MixFreeMusic($$self);
}

1;

__END__;

=pod

=head1 NAME

SDL::Music - a perl extension

=head1 DESCRIPTION

L<SDL::Music> is used to load music files for use with L<SDL::Mixer>.
To load a music file one simply creates a new object passing the filename 
to the constructor:

	my $music = new SDL::Music 'my_song.ogg';


=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

L<perl> L<SDL::Mixer>

=cut
