#!/usr/bin/env perl
#
# App.pm
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

package SDL::App;

use strict;
use warnings;
use Carp;
use SDL;
use SDL::Rect;
use SDL::Video;
use SDL::Event;
use SDL::Events;
use SDL::Surface;

our @ISA = qw(SDL::Surface);
sub DESTROY {

}

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my %options = @_;

	verify (%options, qw/	-opengl -gl -fullscreen -full -resizeable
				-title -t -icon_title -it -icon -i 
				-width -w -height -h -depth -d -flags -f 
				-red_size -r -blue_size -b -green_size -g -alpha_size -a
				-red_accum_size -ras -blue_accum_size -bas 
				-green_accum_sizee -gas -alpha_accum_size -aas
				-double_buffer -db -buffer_size -bs -stencil_size -st
				-asyncblit -init
		/ ) if ($SDL::DEBUG);

	 # SDL_INIT_VIDEO() is 0, so check defined instead of truth.
	 my $init = defined $options{-init} ? $options{-init} :
	SDL_INIT_EVERYTHING();
	
	 SDL::init($init);

	#SDL::Init(SDL::SDL_INIT_EVERYTHING());
	
	my $t = $options{-title} 	|| $options{-t} 	|| $0;
	my $it = $options{-icon_title} 	|| $options{-it} 	|| $t;
	my $ic = $options{-icon} 	|| $options{-i}		|| "";
	my $w = $options{-width} 	|| $options{-w}		|| 800;
	my $h = $options{-height} 	|| $options{-h}		|| 600;
	my $d = $options{-depth} 	|| $options{-d}		|| 16;
	my $f = $options{-flags} 	|| $options{-f}		|| SDL::SDL_ANYFORMAT();
	my $r = $options{-red_size}	|| $options{-r}		|| 5;
	my $g = $options{-green_size}	|| $options{-g}		|| 5;
	my $b = $options{-blue_size}	|| $options{-b}		|| 5;
	my $a = $options{-alpha_size}	|| $options{-a}		|| 0;
	my $ras = $options{-red_accum_size}	|| $options{-ras}		|| 0;
	my $gas = $options{-green_accum_size}	|| $options{-gas}		|| 0;
	my $bas = $options{-blue_accum_size}	|| $options{-bas}		|| 0;
	my $aas = $options{-alpha_accum_size}	|| $options{-aas}		|| 0;
	my $db = $options{-double_buffer} 	|| $options{-db}		|| 0;
 
	my $bs = $options{-buffer_size}		|| $options{-bs}		|| 0;
	my $st	= $options{-stencil_size}	|| $options{-st}		|| 0;
	my $async = $options{-asyncblit} || 0;

	$f |= SDL::SDL_OPENGL() if ($options{-gl} || $options{-opengl});
	$f |= SDL::SDL_FULLSCREEN() if ($options{-fullscreen} || $options{-full});
	$f |= SDL::SDL_RESIZABLE() if ($options{-resizeable});
	$f |= SDL::SDL_DOUBLEBUF() if ($db); 
	$f |= SDL::SDL_ASYNCBLIT() if ($async);

	if ($f & SDL::SDL_OPENGL()) { 
		$SDL::App::USING_OPENGL = 1;
		SDL::Video::GL_set_attribute(SDL::SDL_GL_RED_SIZE(),$r) if ($r);	
		SDL::Video::GL_set_attribute(SDL::SDL_GL_GREEN_SIZE(),$g) if ($g);	
		SDL::Video::GL_set_attribute(SDL::SDL_GL_BLUE_SIZE(),$b) if ($b);	
		SDL::Video::GL_set_attribute(SDL::SDL_GL_ALPHA_SIZE(),$a) if ($a);	

		SDL::Video::GL_set_attribute(SDL::SDL_GL_RED_ACCUM_SIZE(),$ras) if ($ras);	
		SDL::Video::GL_set_attribute(SDL::SDL_GL_GREEN_ACCUM_SIZE(),$gas) if ($gas);	
		SDL::Video::GL_set_attribute(SDL::SDL_GL_BLUE_ACCUM_SIZE(),$bas) if ($bas);	
		SDL::Video::GL_set_attribute(SDL::SDL_GL_ALPHA_ACCUM_SIZE(),$aas) if ($aas);	
		
		SDL::Video::GL_set_attribute(SDL::SDL_GL_DOUBLEBUFFER(),$db) if ($db);
		SDL::Video::GL_set_attribute(SDL::SDL_GL_BUFFER_SIZE(),$bs) if ($bs);
		SDL::Video::GL_set_attribute(SDL::SDL_GL_DEPTH_SIZE(),$d);
	} else {
		$SDL::App::USING_OPENGL = 0;
	}

	my $self = SDL::Video::set_video_mode($w,$h,$d,$f)
		or croak SDL::get_error();
	
	if ($ic and -e $ic) {
	   my $icon = new SDL::Surface -name => $ic;
	   SDL::Video::wm_set_icon($$icon);
	}

	SDL::Video::wm_set_caption($t,$it);
	
	bless $self,$class;
	return $self;
}	

sub resize ($$$) {
	my ($self,$w,$h) = @_;
	my $flags = SDL::SurfaceFlags($$self);
	if ( $flags & SDL::SDL_RESIZABLE()) {
		my $bpp = SDL::SurfaceBitsPerPixel($$self);
		$self = \SDL::SetVideoMode($w,$h,$bpp,$flags);
	}
}

sub title ($;$) {
	my $self = shift;
	my ($title,$icon);
	if (@_) { 
		$title = shift; 
		$icon = shift || $title;
		SDL::Video::wm_set_caption($title,$icon);
	}
	return SDL::Video::wm_get_caption();
}

sub delay ($$) {
	my $self = shift;
	my $delay = shift;
	SDL::delay($delay);
}

sub ticks {
	return SDL::get_ticks();
}

sub error {
	return SDL::get_error();
}

sub warp ($$$) {
	my $self = shift;
	SDL::Mouse::warp_mouse(@_);
}

sub fullscreen ($) {
	my $self = shift;
	SDL::Video::wm_toggle_full_screen($self);
}

sub iconify ($) {
	my $self = shift;
	SDL::Video::wm_iconify_window();
}

sub grab_input ($$) {
	my ($self,$mode) = @_;
	SDL::Video::wm_grab_input($mode);
}

sub loop ($$) {
	my ($self,$href) = @_;
	my $event = SDL::Event->new();
	while ( SDL::Events::wait($event->wait) ) {
		if ( ref($$href{$event->type()}) eq "CODE" ) {
			&{$$href{$event->type()}}($event);			
		}
	}
}

sub sync ($) {
	my $self = shift;
	if ($SDL::App::USING_OPENGL) {
		SDL::Video::GL_swap_buffers()
	} else {
		SDL::Video::flip($self);
	}
}

sub attribute ($$;$) {
	my ($self,$mode,$value) = @_;
	return undef unless ($SDL::App::USING_OPENGL);
	if (defined $value) {
		SDL::Video::GL_set_attribute($mode,$value);
	}
	my $returns = SDL::Video::GL_get_attribute($mode);	
	croak "SDL::App::attribute failed to get GL attribute" if ($$returns[0] < 0);
	$$returns[1];	
}

1;

