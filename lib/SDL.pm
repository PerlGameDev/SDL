#!/usr/bin/env perl
#
# SDL.pm
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
# Copyright (C) 2009 Kartik Thakore   <kthakore@cpan.org>
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
#	Kartik Thakore
#	kthakore@cpan.org
#

package SDL;

use strict;
use warnings;
use Carp;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;

use SDL_perl;
use SDL::Constants;

BEGIN {
	@ISA = qw(Exporter DynaLoader);
	@EXPORT = qw( in verify &NULL );
};

# Give our caller SDL::Constant's stuff as well as ours.
sub import {
  my $self = shift;

  $self->export_to_level(1, @_);
  SDL::Constants->export_to_level(1);
}
$VERSION = '2.2.4';

print "$VERSION" if (defined($ARGV[0]) && ($ARGV[0] eq '--SDLperl'));

$SDL::DEBUG=0;

sub NULL {
	return 0;
}

sub in {
	my ($k,@t) = @_;
	return 0 unless defined $k;
	my $r = ((scalar grep { defined $_ && $_ eq $k } @t) <=> 0);
	return 0 if $r eq '';
	return $r;

} 

sub verify (\%@) {
	my ($options,@valid_options) = @_;
	for (keys %$options) {
		croak "Invalid option $_\n" unless in ($_, @valid_options);
	}
}


1;
__END__

=head1 NAME

SDL_perl - Simple DirectMedia Layer for Perl

=head1 DISCLAIMER

First to clarify:

 THIS IS THE LAST RELEASE OF THIS API. 

That said we are actively redesigning the SDL Bindings on the redesign branch here:

 git://github.com/kthakore/SDL_perl.git  
 
The newrelease will B<break backwards compatibility>. We recommend you try the redesign branch to get a head start on any new code you are developing.

=head1 SYNOPSIS

  use SDL;

=head1 DESCRIPTION

SDL_perl is a package of perl modules that provides both functional and object orient
interfaces to the Simple DirectMedia Layer for Perl 5.  This package does take some
liberties with the SDL API, and attempts to adhere to the spirit of both the SDL
and Perl.  This document describes the low-level functional SDL_perl API.  For the
object oriented programming interface please see the documentation provided on a
per class basis.

=head1 The SDL Perl 2009 Development Team

=head2 Documentation

	Nick: magnet

=head2 Perl Development

	Nick: Garu
	Name: Breno G. de Oliveira
	
	Nick: Dngor
	Name: Rocco Caputo

	Nick: nferraz
	Name: Nelson Ferraz

=head2 Maintainance 
	
	Nick: kthakore
	Name: Kartik Thakore

=head1 MacOSX Experimental Usage

Please get libsdl packages from Fink
	
	perl Build.PL
	perl Build test
	perl Build bundle
	perl Build install

=head2 Running SDL Perl Scripts in MacOSX

First set the PERL5LIB environment variable to the dependencies of your script
	
	%export PERL5LIB=$PERL5LIB:./lib

Use the SDLPerl executable made in the bundle and call your scripts

	%SDLPerl.app/Contents/MacOS/SDLPerl yourScript.pl

=head1 Functions exported by SDL.pm

=head2 Init(flags) 

As with the C language API, SDL_perl initializes the SDL environment through
the C<SDL::Init> subroutine.  This routine takes a mode flag constructed through
the bitwise OR product of the following functions:  

=over 4

=item *
INIT_AUDIO()

=item *
INIT_VIDEO()

=item *
INIT_CDROM()

=item *
INIT_EVERYTHING()

=item *
INIT_NOPARACHUTE() 

=item *
INIT_JOYSTICK()

=item *
INIT_TIMER()

=back

C<SDL::Init> returns 0 on success, or -1 on error.

=head2 GetError()

The last error message set by the SDL library can be retrieved using the subroutine
C<SDL::GetError>, which returns a scalar containing the text of the message if any.

=head2 Delay(ms)

This subroutine allows an application to delay further operations for atleast a
number of milliseconds provided as the argument.  The actual delay may be longer
than the specified depending on the underlying OS.

=head2 GetTicks() 

An application may retrieve the number of milliseconds expired since the initilization
of the application through this subroutine.  This value resets rougly ever 49 days.

=head2 AddTimer(interval,callback,param)

C<AddTimer> will register a SDL_NewTimerCallback function to be executed after
C<interval> milliseconds, with parameter C<param>.  SDL_NewTimerCallback objects
can be constructed with the C<NewTimer> subroutine.   C<SDL::PerlTimerCallback>
will return a valid callback for executing a perl subroutine or closure.
This subroutine returns a SDL_TimerID for the newly registered callback, or NULL 
on error.

=head2 NewTimer(interval,subroutine)

The C<NewTimer> takes an interval in milliseconds and a reference to a subroutine
to call at that interval.  The subroutine will be invoked in a void context
and accepts no parameters.  The callback used is that returned by C<SDL::PerlTimerCallback>.
C<NewTimer> returns the SDL_TimerID for the new timer or NULL on error.

=head2 RemoveTimer(id)

This subroutine taks a SDL_TimerID and removes it from the list of active callbacks.
RemoveTimer returns false on failure.

=head2 SetTimer 

This subroutine is depreciated, please use C<NewTimer> or C<AddTimer> instead.

=head2 CDNumDrives() 

C<SDL::CDNumDrives> returns the number of available CD-ROM drives in the system.

=head2 CDName(drive)

The subroutine C<SDL::CDName> returns the system specific human readable device name
for the given CD-ROM drive.

=head2 CDOpen(drive)

This subroutine opens a CD-ROM drive for access, returning NULL if the drive is busy 
or otherwise unavailable.  On success this subroutine returns a handle to the CD-ROM
drive.

=head2 CDTrackListing(cd)

C<SDL::CDTrackListing> returns a human readable description of a CD-ROM.  For each
track one line will be produced with the following format:

	Track index: %d, id %d, %2d.%2d 

This is provided to ease the creation of human readable descriptions and debugging.

=head2 CDTrackId(track) 

C<CDTrackId> returns the id field of the given SDL_CDtrack structure.

=head2 CDTrackType(track)

C<CDTrackType> returns the type field of the given SDL_CDtrack structure.

=head2 CDTrackLength(track)

C<CDTrackLength> returns the length field of the given SDL_CDtrack structure.

=head2 CDTrackOffset(track)

C<CDTrackOffset> returns the offset field of the given SDL_CDtrack structure.

=head2 CDStatus(cd)

The function C<CDStatus> returns the current status of the given SDL_CDrom.
C<CDStatus>'s return values are:

=over 4

=item *
CD_TRAYEMPTY 

=item *
CD_PLAYING 

=item *
CD_STOPPED

=item *
CD_PAUSED 

=item *
CD_ERROR 

=back

=head2 CDPlayTracks(cd,track,tracks,frame,frames)

To start playing from an arbitrary portion of a CD, one can provide
C<SDL::CDPlayTracks> with a CD, a starting track, the number of tracks,
a starting frame, and the number of frames to be played. 

=head2 CDPlay(cd,track,length) 

C<SDL::CDPlay> plays the next C<length> tracks starting from C<track>

=head2 CDPause(cd) 

This function will pause CD playback until resume is called.

=head2 CDResume(cd) 

This function will resume CD playback if paused.

=head2 CDStop(cd) 

C<SDL::CDStop> will stop CD playback if playing.

=head2 CDEject(cd) 

This function will eject the CD.

=head2 CDClose(cd) 

This function will release an opened CD. 

=head2 CDNumTracks 

This function return the number of tracks on a CD,
it take a SDL_CD as first parameter.

=head2 CDCurTrack 

This function return the number of the current track on a CD,
it take a SDL_CD as first parameter.

=head2 CDCurFrame 

this function return the frame offset within the current track on a CD.
it take a SDL_CD as first parameter.

=head2 CDTrack 

CDtrack stores data on each track on a CD, its fields should be pretty self explainatory.
CDtrack take a SDL::CD as input and  return a SDL_CDTrack. 

=head2 PumpEvents 

Pumps the event loop, gathering events from the input devices.

PumpEvents gathers all the pending input information from devices and places
it on the event queue.
Without calls to PumpEvents no events would ever be placed on the queue.
Often the need for calls to PumpEvents is hidden from the user 
since L</ PollEvent> and WaitEvent implicitly call PumpEvents. 
However, if you are not polling or waiting for events (e.g. you are filtering them), 
then you must call PumpEvents to force an event queue update.
PumpEvents doesn't return any value and doesn't take any parameters.

Note: You can only call this function in the thread that set the video mode. 

=head2 NewEvent 

Create a new event.It return a SDL::Event.

=head2 FreeEvent

FreeEvent delete the SDL::Event given as first parameter.
it doesn't return anything.

=head2 PollEvent 

Polls for currently pending events.
If event is not undef, the next event is removed from the queue and returned as a L< SDL::Event>.
As this function implicitly calls L</ PumpEvents>, you can only call this function in the thread that set the video mode. 
it take a SDL::Event as first parameter.

=head2 WaitEvent 

Waits indefinitely for the next available event, returning undef if there was an error while waiting for events,
a L< SDL::Event> otherwise.
If event is not NULL, the next event is removed.
As this function implicitly calls L</ PumpEvents>, you can only call this function in the thread that set the video mode. 
WaitEvent take a SDL::Event as first parameter.

=head2 EventState 

This function allows you to set the state of processing certain event types.

it take an event type as first argument, and a state as second.

If state is set to SDL_IGNORE, that event type will be automatically 
dropped from the event queue and will not be filtered.
If state is set to SDL_ENABLE, that event type will be processed 
normally.
If state is set to SDL_QUERY, SDL_EventState will return the current 
processing state of the specified event type.

A list of event types can be found in the L</ SDL_Event section>. 

it returns a state(?).

=head2 IGNORE 

=head2 ENABLE 

=head2 QUERY 

=head2 ACTIVEEVENT

=head2 KEYDOWN 

=head2 KEYUP 

=head2 MOUSEMOTION 

=head2 MOUSEBUTTONDOWN 

=head2 MOUSEBUTTONUP 

=head2 QUIT 

=head2 SYSWMEVENT 

=head2 EventType 

EventType return the type of the SDL::Event given as first parameter.

=head2 ActiveEventGain 

ActiveEventGain return the active gain from the SDL::Event given as first parameter.
see L</ SDL::Event> for more informations about the active state. 

=head2 ActiveEventState 

ActiveEventState return the active state from the SDL::Event given as first parameter.
see L</ SDL::Event> for more informations about the active state. 

=head2 APPMOUSEFOCUS 

=head2 APPINPUTFOCUS 

=head2 APPACTIVE 

=head2 KeyEventState

KeyEventState return the active key state from the SDL::Event given as first parameter.
see L</ SDL::Event> for me more informations about the active key.

=head2 SDLK_BACKSPACE 

=head2 SDLK_TAB 

=head2 SDLK_CLEAR 

=head2 SDLK_RETURN 

=head2 SDLK_PAUSE 

=head2 SDLK_ESCAPE 

=head2 SDLK_SPACE 

=head2 SDLK_EXCLAIM 

=head2 SDLK_QUOTEDBL 

=head2 SDLK_HASH 

=head2 SDLK_DOLLAR 

=head2 SDLK_AMPERSAND 

=head2 SDLK_QUOTE 

=head2 SDLK_LEFTPAREN 

=head2 SDLK_RIGHTPAREN 

=head2 SDLK_ASTERISK 

=head2 SDLK_PLUS 

=head2 SDLK_COMMA 

=head2 SDLK_MINUS 

=head2 SDLK_PERIOD 

=head2 SDLK_SLASH 

=head2 SDLK_0 

=head2 SDLK_1 

=head2 SDLK_2 

=head2 SDLK_3 

=head2 SDLK_4 

=head2 SDLK_5 

=head2 SDLK_6 

=head2 SDLK_7 

=head2 SDLK_8 

=head2 SDLK_9 

=head2 SDLK_COLON 

=head2 SDLK_SEMICOLON 

=head2 SDLK_LESS 

=head2 SDLK_EQUALS 

=head2 SDLK_GREATER 

=head2 SDLK_QUESTION 

=head2 SDLK_AT 

=head2 SDLK_LEFTBRACKET 

=head2 SDLK_BACKSLASH 

=head2 SDLK_RIGHTBRACKET 

=head2 SDLK_CARET 

=head2 SDLK_UNDERSCORE 

=head2 SDLK_BACKQUOTE 

=head2 SDLK_a 

=head2 SDLK_b 

=head2 SDLK_c 

=head2 SDLK_d 

=head2 SDLK_e 

=head2 SDLK_f 

=head2 SDLK_g 

=head2 SDLK_h 

=head2 SDLK_i 

=head2 SDLK_j 

=head2 SDLK_k 

=head2 SDLK_l 

=head2 SDLK_m 

=head2 SDLK_n 

=head2 SDLK_o 

=head2 SDLK_p 

=head2 SDLK_q 

=head2 SDLK_r 

=head2 SDLK_s 

=head2 SDLK_t 

=head2 SDLK_u 

=head2 SDLK_v 

=head2 SDLK_w 

=head2 SDLK_x 

=head2 SDLK_y 

=head2 SDLK_z 

=head2 SDLK_DELETE 

=head2 SDLK_KP0 

=head2 SDLK_KP1 

=head2 SDLK_KP2 

=head2 SDLK_KP3 

=head2 SDLK_KP4 

=head2 SDLK_KP5 

=head2 SDLK_KP6 

=head2 SDLK_KP7 

=head2 SDLK_KP8 

=head2 SDLK_KP9 

=head2 SDLK_KP_PERIOD 

=head2 SDLK_KP_DIVIDE 

=head2 SDLK_KP_MULTIPLY 

=head2 SDLK_KP_MINUS 

=head2 SDLK_KP_PLUS 

=head2 SDLK_KP_ENTER 

=head2 SDLK_KP_EQUALS 

=head2 SDLK_UP 

=head2 SDLK_DOWN 

=head2 SDLK_RIGHT 

=head2 SDLK_LEFT 

=head2 SDLK_INSERT 

=head2 SDLK_HOME 

=head2 SDLK_END 

=head2 SDLK_PAGEUP 

=head2 SDLK_PAGEDOWN 

=head2 SDLK_F1 

=head2 SDLK_F2 

=head2 SDLK_F3 

=head2 SDLK_F4 

=head2 SDLK_F5 

=head2 SDLK_F6 

=head2 SDLK_F7 

=head2 SDLK_F8 

=head2 SDLK_F9 

=head2 SDLK_F10 

=head2 SDLK_F11 

=head2 SDLK_F12 

=head2 SDLK_F13 

=head2 SDLK_F14 

=head2 SDLK_F15 

=head2 SDLK_NUMLOCK 

=head2 SDLK_CAPSLOCK 

=head2 SDLK_SCROLLOCK 

=head2 SDLK_RSHIFT 

=head2 SDLK_LSHIFT 

=head2 SDLK_RCTRL 

=head2 SDLK_LCTRL 

=head2 SDLK_RALT 

=head2 SDLK_LALT 

=head2 SDLK_RMETA 

=head2 SDLK_LMETA 

=head2 SDLK_LSUPER 

=head2 SDLK_RSUPER 

=head2 SDLK_MODE 

=head2 SDLK_HELP 

=head2 SDLK_PRINT 

=head2 SDLK_SYSREQ 

=head2 SDLK_BREAK 

=head2 SDLK_MENU 

=head2 SDLK_POWER 

=head2 SDLK_EURO 

=head2 KMOD_NONE 

=head2 KMOD_NUM 

=head2 KMOD_CAPS 

=head2 KMOD_LCTRL 

=head2 KMOD_RCTRL 

=head2 KMOD_RSHIFT 

=head2 KMOD_LSHIFT 

=head2 KMOD_RALT 

=head2 KMOD_LALT 

=head2 KMOD_CTRL 

=head2 KMOD_SHIFT 

=head2 KMOD_ALT 

=head2 KeyEventSym 

KeyEventSym return the key pressed/released  information from the SDL::Event given as first parameter.
see L</ SDL::Event> for more informations about the keyboard events. 

=head2 KeyEventMod 

KeyEventMod return the mod keys pressed information from the SDL::Event given as first parameter.
see L</ SDL::Event> for more informations about the keyboard events. 

=head2 KeyEventUnicode 

KeyEventMod return the unicode translated keys pressed/released information from the SDL::Event given as first parameter.
see L</ SDL::Event> for more informations about the keyboard events. 

=head2 KeyEventScanCode 

=head2 MouseMotionState 

=head2 MouseMotionX 

=head2 MouseMotionY 

=head2 MouseMotionXrel

=head2 MouseMotionYrel 

=head2 MouseButtonState 

=head2 MouseButton 

=head2 MouseButtonX 

=head2 MouseButtonY 

=head2 SysWMEventMsg 

=head2 EnableUnicode 

=head2 EnableKeyRepeat 

=head2 GetKeyName 

=head2 PRESSED 

=head2 RELEASED 

=head2 CreateRGBSurface 

=head2 CreateRGBSurfaceFrom 

=head2 IMG_Load 

=head2 FreeSurface 

=head2 SurfacePalette 

=head2 SurfaceBitsPerPixel 

=head2 SurfaceBy
