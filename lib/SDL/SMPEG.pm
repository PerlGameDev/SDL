#!perl
package SDL::SMPEG;

use strict;
use warnings;
use Carp;
use SDL;
use SDL::Surface;
use SDL::MPEG;

sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;
	my %options = @_;

	my $n = $options{-name}
		|| die "SDL::SMPEG must supply a filename to SDL::SMPEG::new\n";
	my $a = $options{'-audio'} ? 1 : 0;
	my $info = SDL::MPEG->new();

	my $self = \SDL::NewSMPEG( $n, $$info, $a );
	croak SDL::GetError() unless $$self;
	bless $self, $class;
	$self->audio(1);
	$self->video(1);
	return $self, $info;
}

sub DESTROY {
	SDL::FreeSMPEG( ${ $_[0] } );
}

sub error {
	SDL::SMPEGError( ${ $_[0] } );
}

sub audio {
	SDL::SMPEGEnableAudio( ${ $_[0] }, $_[1] );
}

sub video {
	SDL::SMPEGEnableSMPEG( ${ $_[0] }, $_[1] );
}

sub volume {
	SDL::SMPEGSetVolume( ${ $_[0] }, $_[1] );
}

sub display {
	croak "SDL::SMPEG::Display requires a SDL::Surface\n"
		unless $_[1]->isa('SDL::Surface');
	SDL::SMPEGSetDisplay( ${ $_[0] }, ${ $_[1] }, 0 );
}

sub scale {
	return SDL::SMPEGScaleXY( ${ $_[0] }, $_[1], $_[2] ) if ( @_ == 3 );
	return SDL::SMPEGScaleXY( ${ $_[0] }, $_[1]->width(), $_[1]->height() )
		if $_[1]->isa('SDL::Surface');
	SDL::SMPEGScale( ${ $_[0] }, $_[1] );
}

sub play {
	SDL::SMPEGPlay( ${ $_[0] } );
}

sub pause {
	SDL::SMPEGPause( ${ $_[0] } );
}

sub stop {
	SDL::SMPEGStop( ${ $_[0] } );
}

sub rewind {
	SDL::SMPEGRewind( ${ $_[0] } );
}

sub seek {
	SDL::SMPEGSeek( ${ $_[0] }, $_[1] );
}

sub skip {
	SDL::SMPEGSkip( ${ $_[0] }, $_[1] );
}

sub loop {
	SDL::SMPEGLoop( ${ $_[0] }, $_[1] );
}

sub region {
	croak "SDL::SMPEG::region requires a SDL::Rect\n"
		unless $_[1]->isa('SDL::Rect');
	SDL::SMPEGDisplayRegion( ${ $_[0] }, ${ $_[1] } );
}

sub frame {
	SDL::SMPEGRenderFrame( ${ $_[0] }, $_[1] );
}

sub info {
	new SDL::MPEG-from => $_[0];
}

sub status {
	SDL::SMPEGStatus( ${ $_[0] } );
}

1;
