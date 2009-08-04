#!/usr/bin/env perl
#
# Video.pm
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

package SDL::Video;

use strict;
use warnings;
use Carp;
use SDL;
use SDL::Surface;
use SDL::MPEG;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %options = @_;

	verify (%options, qw/ -name -audio / ) if $SDL::DEBUG;

	my $n = $options{-name} || die "SDL::Video must supply a filename to SDL::Video::new\n";
	my $a = $options{'-audio'} ? 1 : 0;
	my $info = new SDL::MPEG();
	
	my $self = \SDL::NewSMPEG($n,$$info,$a);
	croak SDL::GetError() unless $$self;
	bless $self,$class;
	$self->audio(1);
	$self->video(1);
	return $self, $info;
}

sub DESTROY {
	SDL::FreeSMPEG(${$_[0]});
}

sub error {
	SDL::SMPEGError(${$_[0]});
}

sub audio {
	SDL::SMPEGEnableAudio( ${$_[0]}, $_[1]);
}

sub video {
	SDL::SMPEGEnableVideo( ${$_[0]}, $_[1]);
}

sub volume {
	SDL::SMPEGSetVolume( ${$_[0]}, $_[1] );
}

sub display {
	croak "SDL::Video::Display requires a SDL::Surface\n" unless $_[1]->isa('SDL::Surface');
	SDL::SMPEGSetDisplay( ${$_[0]}, ${$_[1]}, 0);
}

sub scale {
	return SDL::SMPEGScaleXY(${$_[0]},$_[1],$_[2]) if (@_ == 3 );
	return SDL::SMPEGScaleXY(${$_[0]},$_[1]->width(),$_[1]->height()) if $_[1]->isa('SDL::Surface');
	SDL::SMPEGScale(${$_[0]},$_[1]);
}

sub play {
	SDL::SMPEGPlay(${$_[0]});
}

sub pause {
	SDL::SMPEGPause(${$_[0]});
}

sub stop {
	SDL::SMPEGStop(${$_[0]});
}

sub rewind {
	SDL::SMPEGRewind(${$_[0]});
}

sub seek {
	SDL::SMPEGSeek(${$_[0]},$_[1]);
}

sub skip {
	SDL::SMPEGSkip(${$_[0]},$_[1]);
}

sub loop {
	SDL::SMPEGLoop(${$_[0]},$_[1]);
}

sub region {
	croak "SDL::Video::region requires a SDL::Rect\n" unless $_[1]->isa('SDL::Rect');
	SDL::SMPEGDisplayRegion(${$_[0]},${$_[1]});
}

sub frame {
	SDL::SMPEGRenderFrame(${$_[0]},$_[1]);
}

sub info {
	new SDL::MPEG -from => $_[0];
}

sub status {
	SDL::SMPEGStatus(${$_[0]});
}

1;

__END__;

=pod


=head1 NAME

SDL::Video - a SDL perl extension

=head1 SYNOPSIS

  $video = new SDL::Video ( -name => 'pr0n.mpg' );

=head1 DESCRIPTION

C<SDL::Video> adds support for MPEG video to your
SDL Perl application.  Videos are objects bound to
surfaces, whose playback is controled through the
object's interface.

=head2 METHODS 


=over 4

=item *

C<SDL::Video::error()> returns any error messages associated with playback 

=item * 

C<SDL::Video::audio(bool)> enables or disables audio playback, (on by default)

=item * 

C<SDL::Video::video(bool)> enables or disable video playback, (on by default)

=item * 

C<SDL::Video::loop(bool)> enables or disable playback looping (off by default) 

=item * 

C<SDL::Video::volume(int)> set the volume as per the mixer volume

=item * 

C<SDL::Video:display(surface)> binds the clip to a display surface

=item * 

C<SDL::Video::scale([x,y]|[surface]|int)> scales the clip by either x,y
factors, scales to the image dimensions, or a single scalar.

=item * 

C<SDL::Video::play()> plays the video clip, call C<SDL::Video::display()> before playing

=item * 

C<SDL::Video::pause()> pauses video playback

=item * 

C<SDL::Video::stop()> stops video playback

=item * 

C<SDL::Video::rewind()> resets the clip to the beginning 

=item * 

C<SDL::Video::seek(offset)> seeks to a particular byte offset

=item * 

C<SDL::Video::skip(time)> skips to a particular time

=item * 

C<SDL::Video::region(rect)> takes a SDL::Rect and defines the display area

=item * 

C<SDL::Video::frame(int)> renders a specific frame to the screen

=item * 

C<SDL::Video::info()> returns a new C<SDL::MPEG> object reflecting the current status

=item *

C<SDL::Video::status()> returns either SMPEG_PLAYING or SMPEG_STOPPED or SMPEG_ERROR

=back

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

perl(1) SDL::Surface(3) SDL::MPEG(3)

=cut

