package SDL::SMPEG;

use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA);
use Carp;
use SDL;
use SDL::Surface;
use SDL::SMPEG::Info;
use Scalar::Util 'refaddr';
use Data::Dumper;
our @ISA = qw(Exporter DynaLoader);

our $VERSION    = '2.541_09';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::SMPEG;

my %_info;

sub new {
	my $class   = shift;
	my %options = @_;

	my $n = $options{-name}
		|| die "SDL::SMPEG must supply a filename to SDL::SMPEG::new\n";
	my $a = $options{'-audio'} ? 1 : 0;
	my $info = SDL::SMPEG::Info->new();

	my $self = NewSMPEG( $n, $info, $a );
	$_info{ refaddr $self } = $info;
	Carp::confess SDL::get_error() unless $self;
	$self->audio(1);
	$self->video(1);
	return $self;
}

sub DESTROY {
	FreeSMPEG( $_[0] );
}

sub error {
	SMPEGError( $_[0] );
}

sub audio {
	SMPEGEnableAudio( $_[0], $_[1] );
}

sub video {
	SMPEGEnableVideo( $_[0], $_[1] );
}

sub volume {
	SMPEGSetVolume( $_[0], $_[1] );
}

sub display {
	Carp::confess "Display requires a SDL::Surface\n"
		unless $_[1]->isa('SDL::Surface');
	SMPEGSetDisplay( $_[0], $_[1], 0 );
}

sub scale {
	return SMPEGScaleXY( $_[0], $_[1], $_[2] ) if ( @_ == 3 );
	return SMPEGScaleXY( $_[0], $_[1]->width(), $_[1]->height() )
		if $_[1]->isa('SDL::Surface');
	SMPEGScale( $_[0], $_[1] );
}

sub play {
	SMPEGPlay( $_[0] );
}

sub pause {
	SMPEGPause( $_[0] );
}

sub stop {
	SMPEGStop( $_[0] );
}

sub rewind {
	SMPEGRewind( $_[0] );
}

sub seek {
	SMPEGSeek( $_[0], $_[1] );
}

sub skip {
	SMPEGSkip( $_[0], $_[1] );
}

sub loop {
	SMPEGLoop( $_[0], $_[1] );
}

sub region {
	Carp::confess "region requires a SDL::Rect\n"
		unless $_[1]->isa('SDL::Rect');
	SMPEGDisplayRegion( $_[0], $_[1] );
}

sub frame {
	SMPEGRenderFrame( $_[0], $_[1] );
}

sub info {

	#	SDL::SMPEG::Info->new( -from => $_[0] );
	$_info{ refaddr $_[0] };
}

sub status {
	SMPEGStatus( $_[0] );
}

1;
