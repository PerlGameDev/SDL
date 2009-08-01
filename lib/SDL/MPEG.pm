#
#	MPEG.pm
#
#	A package for manipulating MPEG video 
#
#	Copyright (C) 2004 David J. Goehrig

package SDL::MPEG;

use strict;
use SDL;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %options = @_;

	verify (%options, qw/ -from / ) if $SDL::DEBUG;

	my $self;
	if ( $options{-from} ) {
		die "SDL::MPEG::new -from requires a SDL::Video object\n"
			unless $options{-from}->isa('SDL::Video');

		$self = \SDL::SMPEGGetInfo(${$options{-from}});
	} else {
		$self = \SDL::NewSMPEGInfo();
	}	
	bless $self,$class;
	return $self;
}

sub DESTROY {
	SDL::FreeSMPEGInfo(${$_[0]});
}

sub has_audio {
	SDL::SMPEGInfoHasAudio(${$_[0]});
}

sub has_video {
	SDL::SMPEGInfoHasVideo(${$_[0]});
}

sub width {
	SDL::SMPEGInfoWidth(${$_[0]});
}

sub height {
	SDL::SMPEGInfoHeight(${$_[0]});
}

sub size {
	SDL::SMPEGInfoTotalSize(${$_[0]});
}

sub offset {
	SDL::SMPEGInfoCurrentOffset(${$_[0]});
}

sub frame {
	SDL::SMPEGInfoCurrentFrame(${$_[0]});
}

sub fps {
	SDL::SMPEGInfoCurrentFPS(${$_[0]});
}

sub time {
	SDL::SMPEGInfoCurrentTime(${$_[0]});
}

sub length {
	SDL::SMPEGInfoTotalTime(${$_[0]});
}

1;

__END__;

=pod


=head1 NAME

SDL::MPEG - a SDL perl extension

=head1 SYNOPSIS

  $info = new SDL::MPEG -from => $mpeg;

=head1 DESCRIPTION

C<SDL::MPEG> provides an interface to quering the status
of a SMPEG stream.  

=head2 METHODS 

=over 4

=item *

C<SDL::MPEG::has_audio> returns true if it has audio track

=item *

C<SDL::MPEG::has_video> returns true if it has a video track

=item *

C<SDL::MPEG::width> returns the width of the video in pixels

=item *

C<SDL::MPEG::height> returns the height of the video in pixels

=item *

C<SDL::MPEG::size> returns the total size of the clip in bytes

=item *

C<SDL::MPEG::offset> returns the offset into the clip in bytes

=item *

C<SDL::MPEG::frame> returns the offset into the clip in fames 

=item *

C<SDL::MPEG::fps> returns the play rate in frames per second

=item *

C<SDL::MPEG::time> returns the current play time in seconds

=item *

C<SDL::MPEG::length> returns the total play time in seconds

=back

=head1 AUTHOR

David J. Goehrig

=head1 SEE ALSO

perl(1) SDL::Video(3)

=cut

