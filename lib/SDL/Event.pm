#	Event.pm
#
#	A package for handling SDL_Event *
#
#	Copyright (C) 2000,2001,2002 David J. Goehrig
#
#	see the file COPYING for terms of use
#

package SDL::Event;
use strict;
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

Create a new event object.

=head2 type()

Returns the type of the event, see list of exported symbols for which are
available.

=head2 pump()

=head2 poll()

=head2 wait()

Waits for an event end returns then. Always returns true.

=head2 set( type, state )

Set the state for all events of the given event's type

=head2 set_unicode( toggle )

Toggle unicode on the event.

=head2 set_key_repeat( delay, interval)

Sets the delay and intervall of the key repeat rate (e.g. when a user
holds down a key on the keyboard).

=head2 active_gain()

=head2 active_state()

=head2 key_state()

=head2 key_sym()

=head2 key_name()

=head2 key_mod()

=head2 key_unicode()

=head2 key_scancode()

=head2 motion_state()

=head2 motion_x()

Returns the motion of the mouse in X direction as an absolute value.

=head2 motion_y()

Returns the motion of the mouse in Y direction as an absolute value.

=head2 motion_xrel()

Returns the motion of the mouse in X direction as a relative value.

=head2 motion_yrel()

Returns the motion of the mouse in Y direction as a relative value.

=head2 button_state()

Returns the state of the mouse buttons.

=head2 button_x()

=head2 button_y()

=head2 button()

=head1 AUTHOR

David J. Goehrig
Documentation by Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<perl> L<SDL::App>

=cut
