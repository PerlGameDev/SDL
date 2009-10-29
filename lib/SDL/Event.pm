#!/usr/bin/env perl
#
# Event.pm
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

package SDL::Event;

use strict;
use warnings;
use Carp;

use SDL;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self;
	$self = \SDL::NewEvent();
	bless $self, $class;
	return $self;
}

sub DESTROY {
	my $self = shift;
	SDL::FreeEvent($$self);
}

sub type {
	my $self = shift;
	if (@_) {
		SDL::SetEventType($$self,$_[0]);
	}
	return SDL::EventType($$self);
}

sub pump {
	SDL::PumpEvents();
}

sub poll {
	my $self = shift;
	return SDL::PollEvent($$self);
}

sub push {
	my $self = shift;
	return SDL::PushEvent($$self);
}

sub wait {
	my $self = shift;
	return SDL::WaitEvent($$self);
}

sub set { 
	my $self = shift;
	my $state = shift;
	return SDL::EventState($self->type(),$state);
}

sub set_unicode {
	my $self = shift;
	my $toggle = shift;
	return SDL::EnableUnicode($toggle);
}

sub set_key_repeat {
	my $self = shift;
	my $delay = shift;
	my $interval = shift;
	return SDL::EnableKeyRepeat($delay,$interval);
}

sub active_gain {
	my $self = shift;
	return SDL::ActiveEventGain($$self);
}

sub active_state {
	my $self = shift;
	return SDL::ActiveEventState($$self);
}

sub key_state {
	my $self = shift;
	return SDL::KeyEventState($$self);
}

sub key_sym {
	my $self = shift;
	return SDL::KeyEventSym($$self);
}

sub key_name {
	my $self = shift;
	return SDL::GetKeyName(SDL::KeyEventSym($$self));
}

sub key_mod {
	my $self = shift;
	return SDL::KeyEventMod($$self);
}

sub key_unicode {
	my $self = shift;
	return SDL::KeyEventUnicode($$self);
}

sub key_scancode {
	my $self = shift;
	return SDL::KeyEventScanCode($$self);
}

sub motion_state {
	my $self = shift;
	return SDL::MouseMotionState($$self);
}

sub motion_x {
	my $self = shift;
	return SDL::MouseMotionX($$self);
}

sub motion_y {
	my $self = shift;
	return SDL::MouseMotionY($$self);
}

sub motion_xrel {
	my $self = shift;
	return SDL::MouseMotionXrel($$self);
}

sub motion_yrel {
	my $self = shift;
	return SDL::MouseMotionYrel($$self);
}

sub button_state {
	my $self = shift;
	return SDL::MouseButtonState($$self);
}

sub button_x {
	my $self = shift;
	return SDL::MouseButtonX($$self);
}

sub button_y {
	my $self = shift;
	return SDL::MouseButtonY($$self);
}

sub button {
	my $self = shift;
	return SDL::MouseButton($$self);
}

sub resize_w {
	my $self = shift;
	SDL::ResizeEventW($$self);
}

sub resize_h {
	my $self = shift;
	SDL::ResizeEventH($$self);
}

1;

__END__;

=pod

=head1 NAME

SDL::Event - a SDL perl extension

=head1 SYNOPSIS

 use SDL::Event;
 my $event = new SDL::Event;             # create a new event
 $event->pump(); 		   	 # pump all events from SDL Event Queue
 $event->poll();			 # Get the top one from the queue
 while ($event->wait()) {
 	my $type = $event->type();      # get event type
 	# ... handle event
 	exit if $type == SDL_QUIT;
 }
 
=head1 DESCRIPTION

C<SDL::Event> offers an object-oriented approach to SDL events. By creating
an instance of SDL::Event via new() you can wait for events, and then determine
the type of the event and take an appropriate action.

=head1 EXAMPLE

Here is an example of a simple event handler loop routine.
See also L<SDL::App::loop>.

       sub loop {
               my ($self,$href) = @_;
               my $event = new SDL::Event;
               while ( $event->wait() ) {
                       # ... insert here your event handling like:
                       if ( ref($$href{$event->type()}) eq "CODE" ) {
                               &{$$href{$event->type()}}($event);
                               $self->sync();
                       }
               }
       }

=head1 METHODS

=head2 new()

Create a new event object.It returns a SDL::Event.

=head2 type()

Returns the type of the event, see list of exported symbols for which are
available.

=head2 pump()

SDL::Events::pump gathers all the pending input information from devices and places
it on the event queue.
Without calls to pump no events would ever be placed on the queue.
Often the need for calls to pump is hidden from the user 
since C</SDL::Events::poll> and C<SDL::Events::wait_event implicitly call pump. 
However, if you are not polling or waiting for events (e.g. you are filtering them), 
then you must call pump force an event queue update.
pump doesn't return any value and doesn't take any parameters.

Note: You can only call this function in the thread that set the video mode. 


=head2 poll(event)

Polls for currently pending events.
If event is not undef, the next event is removed from the queue and returned as a C< SDL::Event>.
As this function implicitly calls C<SDL::Events::pump>, you can only call this function in the thread that set the video mode. 
it take a SDL::Event as first parameter.

=head2 wait(event)

Waits indefinitely for the next available event, returning undef if there was an error while waiting for events,
a L< SDL::Event> otherwise.
If event is not NULL, the next event is removed.
As this function implicitly calls L<SDL::Events::pump>, you can only call this function in the thread that set the video mode. 
WaitEvent take a SDL::Event as first parameter.

=head2 set( type, state )

Set the state for all events of the given event's type

=head2 set_unicode( toggle )

Toggle unicode on the event.

=head2 set_key_repeat( delay, interval)

Sets the delay and intervall of the key repeat rate (e.g. when a user
holds down a key on the keyboard).

=head2 active_gain(event)

active_gain return the active gain from the SDL::Event given as first parameter.

=head2 active_state(event)

active_state return the active state from the SDL::Event given as first parameter.

=head2 key_state(event)

key_state return the active key state from the SDL::Event given as first parameter.


=head2 key_sym(key)

key_sym return the key pressed/released  information from the SDL::Event given as first parameter.

=head2 get_key_name(key)

get_key_name get the name of an SDL virtual keysym. 
it returns the key name.

=head2 key_mod(event)

key_mod return the mod keys pressed information from the SDL::Event given as first parameter.

=head2 key_unicode(event)

key_unicode return the unicode translated keys pressed/released information from the SDL::Event given as first parameter.

=head2 key_scancode(event) * to move in SDL::Game::Keyboard

key_scancode return the hardware specific keyboard scan code from the SDL::Event given as first parameter.

=head2 motion_state(event) * to move in SDL::Game::Mouse

motion_state return the state of the mouse button from the SDL::Event given as first parameter.

=head2 motion_x(event) * to move in SDL::Game::Mouse

Returns the motion of the mouse in X direction as an absolute value.
It take a SDL::Event as first parameter.

=head2 motion_y(event) * to move in SDL::Game::Mouse

Returns the motion of the mouse in Y direction as an absolute value.
It take a SDL::Event as first parameter.

=head2 motion_xrel(event) * to move in SDL::Game::Mouse

Returns the motion of the mouse in X direction as a relative value.
It take a SDL::Event as first parameter.

=head2 motion_yrel(event) * to move in SDL::Game::Mouse

Returns the motion of the mouse in Y direction as a relative value.
It take a SDL::Event as first parameter.

=head2 button_state(event) * to move in SDL::Game::Mouse

Returns the state of the mouse buttons.
It take a SDL::Event as first parameter.

=head2 button_x(event) * to move in SDL::Game::Mouse

Return the X position of the mouse at keypress.it take a SDL::Event as first parameter.

=head2 button_y(event) * to move in SDL::Game::Mouse

Return the Y position of the mouse at keypress.it take a SDL::Event as first parameter.

=head2 button(event) * to move in SDL::Game::Mouse

Return the mouse button index (SDL_BUTTON_LEFT, SDL_BUTTON_MIDDLE, SDL_BUTTON_RIGHT, SDL_BUTTON_WHEELUP, SDL_BUTTON_WHEELDOWN)

=head1 AUTHOR

David J. Goehrig
Documentation by Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<perl> L<SDL::App>

=cut
