#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Event;
#use SDL::Surface;
#use SDL::Video;
use Test::More;

plan ( tests => 7 );

my @done =qw/
pump_events 
peep_events 
poll_event
/;


use_ok( 'SDL::Events' ); 
can_ok ('SDL::Events', @done); 

SDL::init(SDL_INIT_VIDEO);                                                                          
	
is(SDL::Events::pump_events(), undef,  '[pump_events] Returns undef');

my $events = SDL::Event->new();
my $num_peep_events = SDL::Events::peep_events( $events, 127, SDL_PEEKEVENT, SDL_ALLEVENTS);
is($num_peep_events >= 0, 1,  '[peep_events] Size of event queue is ' . $num_peep_events);

my $event = SDL::Event->new();
my $value = SDL::Events::poll_event($event);
is(($value == 1) || ($value == 0), 1,  '[poll_event] Returns 1 or 0');

my @left = qw/
waitevent 
pushevent 
seteventfilter 
eventstate 
getkeystate 
getmodstate 
setmodstate 
getkeyname 
enableunicode 
enablekeyrepeat 
getmousestate 
getrelativemousestate 
getappstate 
joystickeventstate 
StartTextInput 
StopTextInput 
SetTextInputRect 
/;

my $why = '[Percentage Completion] '.int( 100 * ($#done +1 ) / ($#done + $#left + 2  ) ) .'% implementation. '.($#done +1 ).'/'.($#done+$#left + 2 ); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
	if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 


pass 'Are we still alive? Checking for segfaults';
