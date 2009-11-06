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

package SDL::Game::Event;

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
