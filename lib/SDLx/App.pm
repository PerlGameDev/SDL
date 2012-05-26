#!/usr/bin/env perl
#
# App.pm
#

package SDLx::App;

use strict;
use warnings;
use Carp;
use SDL;

use SDL::Rect;
use SDL::Video;
use SDL::Event;
use SDL::Events;
use SDL::Surface;
use SDL::PixelFormat;
use SDL::VideoInfo;
use SDLx::Surface;
use Data::Dumper;
use Scalar::Util 'refaddr';
use base qw/SDLx::Surface SDLx::Controller/;

my $screen_w;
my $screen_h;
my $screen_d;

sub new {
	my $proto   = shift;
	my $class   = ref($proto) || $proto;
	my %options = @_;

	unless($screen_w && $screen_h && $screen_d) {
		my $video_info = SDL::Video::get_video_info();
		if($video_info) {
			$screen_w = $video_info->current_w;
			$screen_h = $video_info->current_h;
			$screen_d = $video_info->vfmt->BitsPerPixel;
		}
	}

	# SDL_INIT_VIDEO() is 0, so check defined instead of truth.
	unless ( exists( $options{noinit} ) ) # we shouldn't do init always
	{
		my $init =
			defined $options{init}
			? $options{init}
			: SDL::SDL_INIT_EVERYTHING;

		SDL::init($init);
	}

	my $t   = $options{title}            || $options{t}   || $0;
	my $it  = $options{icon_title}       || $options{it}  || $t;
	my $ic  = $options{icon}             || $options{i}   || "";
	my $w   = $options{width}            || $options{w}   || 800;
	my $h   = $options{height}           || $options{h}   || 600;
	my $d   = $options{depth}            || $options{d}   || 16;
	my $f   = $options{flags}            || $options{f}   || SDL::Video::SDL_ANYFORMAT;
	my $r   = $options{red_size}         || $options{r}   || 5;
	my $g   = $options{green_size}       || $options{g}   || 5;
	my $b   = $options{blue_size}        || $options{b}   || 5;
	my $a   = $options{alpha_size}       || $options{a}   || 0;
	my $ras = $options{red_accum_size}   || $options{ras} || 0;
	my $gas = $options{green_accum_size} || $options{gas} || 0;
	my $bas = $options{blue_accum_size}  || $options{bas} || 0;
	my $aas = $options{alpha_accum_size} || $options{aas} || 0;
	my $db  = $options{double_buffer}    || $options{db}  || 0;

	my $bs = $options{buffer_size}  || $options{bs} || 0;
	my $st = $options{stencil_size} || $options{st} || 0;
	my $async = $options{asyncblit} || 0;

	$f |= SDL::Video::SDL_OPENGL if ( $options{gl} || $options{opengl} );
	$f |= SDL::Video::SDL_FULLSCREEN
		if ( $options{fullscreen} || $options{full} );
	$f |= SDL::Video::SDL_RESIZABLE if ( $options{resizeable} );
	$f |= SDL::Video::SDL_DOUBLEBUF if ($db);
	$f |= SDL::Video::SDL_ASYNCBLIT if ($async);

	if ( $f & SDL::Video::SDL_OPENGL ) {
		$SDLx::App::USING_OPENGL = 1;
		SDL::Video::GL_set_attribute( SDL::Constants::SDL_GL_RED_SIZE(), $r )
			if ($r);
		SDL::Video::GL_set_attribute( SDL::Constants::SDL_GL_GREEN_SIZE(), $g )
			if ($g);
		SDL::Video::GL_set_attribute( SDL::Constants::SDL_GL_BLUE_SIZE(), $b )
			if ($b);
		SDL::Video::GL_set_attribute( SDL::Constants::SDL_GL_ALPHA_SIZE(), $a )
			if ($a);

		SDL::Video::GL_set_attribute(
			SDL::Constants::SDL_GL_RED_ACCUM_SIZE(),
			$ras
		) if ($ras);
		SDL::Video::GL_set_attribute(
			SDL::Constants::SDL_GL_GREEN_ACCUM_SIZE(),
			$gas
		) if ($gas);
		SDL::Video::GL_set_attribute(
			SDL::Constants::SDL_GL_BLUE_ACCUM_SIZE(),
			$bas
		) if ($bas);
		SDL::Video::GL_set_attribute(
			SDL::Constants::SDL_GL_ALPHA_ACCUM_SIZE(),
			$aas
		) if ($aas);

		SDL::Video::GL_set_attribute(
			SDL::Constants::SDL_GL_DOUBLEBUFFER(),
			$db
		) if ($db);
		SDL::Video::GL_set_attribute(
			SDL::Constants::SDL_GL_BUFFER_SIZE(),
			$bs
		) if ($bs);
		SDL::Video::GL_set_attribute( SDL::Constants::SDL_GL_DEPTH_SIZE(), $d );
	} else {
		$SDLx::App::USING_OPENGL = 0;
	}

	my $surface = SDL::Video::set_video_mode( $w, $h, $d, $f )
		or Carp::confess SDL::get_error();
	$options{surface} = $surface;

	my $self = SDLx::Surface->new(%options);

	if ( $ic and -e $ic ) {
		my $icon = SDL::Video::load_BMP($ic);
		SDL::Video::wm_set_icon($icon);
	}

	SDL::Video::wm_set_caption( $t, $it );
	$self = $self->SDLx::Controller::new(%options);
	bless $self, $class;

	return $self;
}

sub resize {
	my ( $self, $w, $h ) = @_;
	my $flags = $self->flags;
	if ( $flags & SDL::Video::SDL_RESIZABLE ) {
		my $bpp = $self->format->BitsPerPixel;
		$self = SDL::Video::set_video_mode( $w, $h, $bpp, $flags )
			or die "SDL cannot set video:" . SDL::get_error;
	} else {
		die "Application surface not resizable";
	}
}

sub title {
	my $self = shift;
	my ( $title, $icon );
	if (@_) {
		$title = shift;
		$icon = shift || $title;
		SDL::Video::wm_set_caption( $title, $icon );
	}
	return SDL::Video::wm_get_caption();
}

sub delay {
	my $self  = shift;
	my $delay = shift;
	SDL::delay($delay);
}

sub ticks {
	return SDL::get_ticks();
}

sub error {
	return SDL::get_error();
}

sub warp {
	my $self = shift;
	SDL::Mouse::warp_mouse(@_);
}

sub fullscreen {
	my $self = shift;
	SDL::Video::wm_toggle_fullscreen($self);
}

sub iconify {
	my $self = shift;
	SDL::Video::wm_iconify_window();
}

sub grab_input {
	my ( $self, $mode ) = @_;
	SDL::Video::wm_grab_input($mode);
}

sub sync {
	my $self = shift;
	if ($SDLx::App::USING_OPENGL) {
		SDL::Video::GL_swap_buffers();
	} else {
		$self->flip();
	}
}

sub attribute {
	my ( $self, $mode, $value ) = @_;
	return undef unless ($SDLx::App::USING_OPENGL);
	if ( defined $value ) {
		SDL::Video::GL_set_attribute( $mode, $value );
	}
	my $returns = SDL::Video::GL_get_attribute($mode);
	Carp::confess "SDLx::App::attribute failed to get GL attribute"
		if ( $$returns[0] < 0 );
	$$returns[1];
}



my %_stash;
sub stash :lvalue{
	my $ref = refaddr($_[0]);
	$_stash{ $ref } = {} unless $_stash{ $ref };
	$_stash{ $ref }
}

sub DESTROY {
	if($screen_w && $screen_h && $screen_d) {
		SDL::Video::set_video_mode( $screen_w, $screen_h, $screen_d, SDL_ANYFORMAT );
	}
}

1;
