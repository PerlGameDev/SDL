#!perl
package SDL::SMPEG;

use strict;
use warnings;
use Carp;
use SDL;
use SDL::Surface;
use SDL::MPEG;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::SMPEG;


sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;
	my %options = @_;

	my $n = $options{-name}
		|| die "SDL::SMPEG must supply a filename to SDL::SMPEG::new\n";
	my $a = $options{'-audio'} ? 1 : 0;
	my $info = SDL::MPEG->new();

	my $self = \SDL::SMPEG::NewSMPEG( $n, $$info, $a );
	Carp::confess SDL::get_error() unless $$self;
	bless $self, $class;
	$self->audio(1);
	$self->video(1);
	return $self;
}

sub DESTROY {
	SDL::SMPEG::FreeSMPEG( ${ $_[0] } );
}

sub error {
	SDL::SMPEG::SMPEGError( ${ $_[0] } );
}

sub audio {
	SDL::SMPEG::SMPEGEnableAudio( ${ $_[0] }, $_[1] );
}

sub video {
	SDL::SMPEG::SMPEGEnableVideo( ${ $_[0] }, $_[1] );
}

sub volume {
	SDL::SMPEG::SMPEGSetVolume( ${ $_[0] }, $_[1] );
}

sub display {
	Carp::confess "SDL::SMPEG::Display requires a SDL::Surface\n"
		unless $_[1]->isa('SDL::Surface');
	SDL::SMPEG::SMPEGSetDisplay( ${ $_[0] },  $_[1] , 0 );
}

sub scale {
	return SDL::SMPEG::SMPEGScaleXY( ${ $_[0] }, $_[1], $_[2] ) if ( @_ == 3 );
	return SDL::SMPEG::SMPEGScaleXY( ${ $_[0] }, $_[1]->width(), $_[1]->height() )
		if $_[1]->isa('SDL::Surface');
	SDL::SMPEG::SMPEGScale( ${ $_[0] }, $_[1] );
}

sub play {
	SDL::SMPEG::SMPEGPlay( ${ $_[0] } );
}

sub pause {
	SDL::SMPEG::SMPEGPause( ${ $_[0] } );
}

sub stop {
	SDL::SMPEG::SMPEGStop( ${ $_[0] } );
}

sub rewind {
	SDL::SMPEG::SMPEGRewind( ${ $_[0] } );
}

sub seek {
	SDL::SMPEG::SMPEGSeek( ${ $_[0] }, $_[1] );
}

sub skip {
	SDL::SMPEG::SMPEGSkip( ${ $_[0] }, $_[1] );
}

sub loop {
	SDL::SMPEG::SMPEGLoop( ${ $_[0] }, $_[1] );
}

sub region {
	Carp::confess "SDL::SMPEG::region requires a SDL::Rect\n"
		unless $_[1]->isa('SDL::Rect');
	SDL::SMPEG::SMPEGDisplayRegion( ${ $_[0] }, ${ $_[1] } );
}

sub frame {
	SDL::SMPEG::SMPEGRenderFrame( ${ $_[0] }, $_[1] );
}

sub info {
	SDL::MPEG->new( -from => $_[0] );
}

sub status {
	SDL::SMPEG::SMPEGStatus( ${ $_[0] } );
}

1;
