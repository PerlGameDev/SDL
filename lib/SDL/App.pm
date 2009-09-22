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
use SDL::Event;
use SDL::Surface;
use SDL::Rect;

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
	
	 SDL::Init($init);

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
		SDL::GLSetAttribute(SDL::SDL_GL_RED_SIZE(),$r) if ($r);	
		SDL::GLSetAttribute(SDL::SDL_GL_GREEN_SIZE(),$g) if ($g);	
		SDL::GLSetAttribute(SDL::SDL_GL_BLUE_SIZE(),$b) if ($b);	
		SDL::GLSetAttribute(SDL::SDL_GL_ALPHA_SIZE(),$a) if ($a);	

		SDL::GLSetAttribute(SDL::SDL_GL_RED_ACCUM_SIZE(),$ras) if ($ras);	
		SDL::GLSetAttribute(SDL::SDL_GL_GREEN_ACCUM_SIZE(),$gas) if ($gas);	
		SDL::GLSetAttribute(SDL::SDL_GL_BLUE_ACCUM_SIZE(),$bas) if ($bas);	
		SDL::GLSetAttribute(SDL::SDL_GL_ALPHA_ACCUM_SIZE(),$aas) if ($aas);	
		
		SDL::GLSetAttribute(SDL::SDL_GL_DOUBLEBUFFER(),$db) if ($db);
		SDL::GLSetAttribute(SDL::SDL_GL_BUFFER_SIZE(),$bs) if ($bs);
		SDL::GLSetAttribute(SDL::SDL_GL_DEPTH_SIZE(),$d);
	} else {
		$SDL::App::USING_OPENGL = 0;
	}

	my $self = \SDL::SetVideoMode($w,$h,$d,$f)
		or croak SDL::GetError();
	
	if ($ic and -e $ic) {
	   my $icon = new SDL::Surface -name => $ic;
	   SDL::WMSetIcon($$icon);	   
	}

	SDL::WMSetCaption($t,$it);
	
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
		SDL::WMSetCaption($title,$icon);
	}
	return SDL::WMGetCaption();
}

sub delay ($$) {
	my $self = shift;
	my $delay = shift;
	SDL::Delay($delay);
}

sub ticks {
	return SDL::GetTicks();
}

sub error {
	return SDL::GetError();
}

sub warp ($$$) {
	my $self = shift;
	SDL::WarpMouse(@_);
}

sub fullscreen ($) {
	my $self = shift;
	SDL::WMToggleFullScreen($$self);
}

sub iconify ($) {
	my $self = shift;
	SDL::WMIconifyWindow();
}

sub grab_input ($$) {
	my ($self,$mode) = @_;
	SDL::WMGrabInput($mode);
}

sub loop ($$) {
	my ($self,$href) = @_;
	my $event = new SDL::Event;
	while ( $event->wait() ) {
		if ( ref($$href{$event->type()}) eq "CODE" ) {
			&{$$href{$event->type()}}($event);			
		}
	}
}

sub sync ($) {
	my $self = shift;
	if ($SDL::App::USING_OPENGL) {
		SDL::GLSwapBuffers()
	} else {
		$self->flip();
	}
}

sub attribute ($$;$) {
	my ($self,$mode,$value) = @_;
	return undef unless ($SDL::App::USING_OPENGL);
	if (defined $value) {
		SDL::GLSetAttribute($mode,$value);
	}
	my $returns = SDL::GLGetAttribute($mode);	
	croak "SDL::App::attribute failed to get GL attribute" if ($$returns[0] < 0);
	$$returns[1];	
}

1;

__END__;

=pod

=head1 NAME

SDL::App - a SDL perl extension

=head1 SYNOPSIS
		
	use SDL;
	use SDL::Event; 
	use SDL::App; 
	 
	my $app = new SDL::App ( 
	-title => 'Application Title', 
	-width => 640, 
	-height => 480, 
	-depth => 32 ); 

This is the manual way of doing things	

	my $event = new SDL::Event;             # create a new event 

	$event->pump();
	$event->poll();

	while ($event->wait()) { 
	  my $type = $event->type();      # get event type 
	  print $type; 
	  exit if $type == SDL_QUIT; 
	  }
An alternative to the manual Event processing is the L<SDL::App::loop> .

=head1 DESCRIPTION

L<SDL::App> controls the root window of the of your SDL based application.
It extends the L<SDL::Surface> class, and provides an interface to the window
manager oriented functions.

=head1 METHODS

=head2 new

C<SDL::App::new> initializes the SDL, creates a new screen,
and initializes some of the window manager properties.
C<SDL::App::new> takes a series of named parameters:

=over 4

=item *

-title

=item *

-icon_title

=item *

-icon

=item *

-width

=item *

-height

=item *

-depth

=item *

-flags

=item *

-resizeable

=back

=head2 title

C<SDL::App::title> takes 0, 1, or 2  arguments.  It returns the current
application window title.  If one parameter is passed, both the window
title and icon title will be set to its value.  If two parameters are
passed the window title will be set to the first, and the icon title
to the second.

=head2 delay

C<SDL::App::delay> takes 1 argument, and will sleep the application for
that many ms.

=head2 ticks

C<SDL::App::ticks> returns the number of ms since the application began.

=head2 error

C<SDL::App::error> returns the last error message set by the SDL.

=head2 resize

C<SDL::App::resize> takes a new height and width of the application
if the application was originally created with the -resizable option.

=head2 fullscreen

C<SDL::App::fullscreen> toggles the application in and out of fullscreen mode.

=head2 iconify

C<SDL::App::iconify> iconifies the applicaiton window.

=head2 grab_input

C<SDL::App::grab_input> can be used to change the input focus behavior of
the application.  It takes one argument, which should be one of the following:

=over 4

=item *
SDL_GRAB_QUERY

=item *
SDL_GRAB_ON

=item *
SDL_GRAB_OFF

=back

=head2 loop

C<SDL::App::loop> is a simple event loop method which takes a reference to a hash
of event handler subroutines.  The keys of the hash must be SDL event types such
as SDL_QUIT(), SDL_KEYDOWN(), and the like.  The event method recieves as its parameter 
the event object used in the loop.
 
  Example:

	my $app = new SDL::App  -title => "test.app", 
				-width => 800, 
				-height => 600, 
				-depth => 32;
	
	my %actions = (
		SDL_QUIT() => sub { exit(0); },
		SDL_KEYDOWN() => sub { print "Key Pressed" },
	);

	$app->loop(\%actions);

=head2 sync

C<SDL::App::sync> encapsulates the various methods of syncronizing the screen with the
current video buffer.  C<SDL::App::sync> will do a fullscreen update, using the double buffer
or OpenGL buffer if applicable.  This is prefered to calling flip on the application window.

=head2 attribute ( attr, [value] )

C<SDL::App::attribute> allows one to set and get GL attributes.  By passing a value
in addition to the attribute selector, the value will be set.  C<SDL:::App::attribute>
always returns the current value of the given attribute, or croaks on failure.

=head1 AUTHOR

David J. Goehrig
Kartik Thakore

=head1 SEE ALSO

L<perl> L<SDL::Surface> L<SDL::Event>  L<SDL::OpenGL>

=cut	
