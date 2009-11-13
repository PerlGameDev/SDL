#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Event;
use SDL::Events;
use SDL::Video;
use Devel::Peek;
use Test::More;


my @done =qw/
pump_events 
peep_events 
push_event
poll_event
wait_event
set_event_filter 
event_state
get_key_state
get_mod_state
set_mod_state
/;

my @done_event =qw/
type
active
key
motion
button
jaxis
jball
jhat
jbutton
resize
expose
quit
user
syswm
/;

can_ok( 'SDL::Events',           @done); 
can_ok( 'SDL::Event',            @done_event);

=pod
can_ok( 'SDL::ExposeEvent',      qw/type/);
can_ok( 'SDL::JoyAxisEvent',     qw/type which axis value/);
can_ok( 'SDL::JoyBallEvent',     qw/type which ball xrel yrel/);
can_ok( 'SDL::JoyButtonEvent',   qw/type which button state/);
can_ok( 'SDL::JoyHatEvent',      qw/type which hat value/);
can_ok( 'SDL::KeyboardEvent',    qw/type state keysym/);
can_ok( 'SDL::keysym',           qw/scancode sym mod unicode/);
can_ok( 'SDL::MouseButtonEvent', qw/type which button state x y/);
can_ok( 'SDL::MouseMotionEvent', qw/type state x y xrel yrel/);
can_ok( 'SDL::QuitEvent',        qw/type/);
can_ok( 'SDL::ResizeEvent',      qw/type w h/);
can_ok( 'SDL::SysWMEvent',       qw/type msg/);
can_ok( 'SDL::UserEvent',        qw/type code data1 data2/);
=cut 

SDL::init(SDL_INIT_VIDEO);                                                                          

my $display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE);

is(SDL::Events::pump_events(), undef,  '[pump_events] Returns undef');

my $event   = SDL::Event->new();

my $aevent = SDL::Event->new();
$aevent->type ( SDL_ACTIVEEVENT );
$aevent->active_gain(1);
$aevent->active_state(SDL_APPINPUTFOCUS);

SDL::Events::push_event($aevent); pass '[push_event] Event can be pushed';

SDL::Events::pump_events(); pass '[pump_event] pumping events';

my $got_event = 0;

while(1)
{
	SDL::Events::pump_events(); 

	my $ret =  SDL::Events::poll_event($event);

	if ($event->type == SDL_ACTIVEEVENT && $event->active_gain == 1 && $event->active_state == SDL_APPINPUTFOCUS )
	{
		$got_event = 1;
		last;
	}

	last if ($ret == 0 );
}

is( $got_event, 1, '[poll_event] Got an Active event back out') ;
is( $event->active_gain() , 1, '[poll_event] Got right active->gain');
is( $event->active_state() , SDL_APPINPUTFOCUS, '[poll_event] Got right active->state');


SDL::Events::push_event($aevent); pass '[push_event] ran';

SDL::Events::pump_events(); 

my $value = SDL::Events::wait_event($event); 

is( $value, 1, '[wait_event] waited for event');

my $num_peep_events = SDL::Events::peep_events($event, 127, SDL_PEEKEVENT, SDL_ALLEVENTS);
is($num_peep_events >= 0, 1,  '[peep_events] Size of event queue is ' . $num_peep_events);

my $callback = sub {  return 1; };
SDL::Events::set_event_filter( $callback );
pass '[set_event_filter] takes a callback';

my $array = SDL::Events::get_key_state();
isa_ok( $array, 'ARRAY', '[get_key_state] returned and array');

my @mods = ( 
	KMOD_NONE, 
	KMOD_LSHIFT,
	KMOD_RSHIFT,
	KMOD_LCTRL ,
	KMOD_RCTRL ,
	KMOD_LALT  ,
	KMOD_RALT  ,
	KMOD_LMETA ,
	KMOD_RMETA ,
	KMOD_NUM   ,
	KMOD_CAPS  ,
	KMOD_MODE  ,
);

foreach(@mods)
{
	SDL::Events::set_mod_state($_); pass '[set_mod_state] set the mod properly';
	is( SDL::Events::get_mod_state(), $_, '[get_mod_state] got the mod properly'); 

}
SDL::quit();


SDL::init(SDL_INIT_VIDEO);

	$display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );

SDL::Video::get_video_info();

SDL::Events::push_event( $aevent );
my $nevent = SDL::Event->new();
SDL::Events::event_state( SDL_ACTIVEEVENT, SDL_IGNORE);
SDL::Events::pump_events();

my $got = 0; 
while( SDL::Events::poll_event($nevent)) 
{
$got = 1 if  $nevent->type == SDL_ACTIVEEVENT;
}
is ( $got, 0, '[event_state] works with SDL_IGNORE on SDL_ACTIVEEVENT');



SDL::Events::event_state( SDL_ACTIVEEVENT, SDL_ENABLE);
SDL::Events::push_event( $aevent );
SDL::Events::pump_events();
my $atleast = 0;
while( SDL::Events::poll_event($nevent)) 
{
 $atleast = 1 if ( $nevent->type == SDL_ACTIVEEVENT)
}
is ( $atleast, 1,  '[event_state] works with SDL_ENABLE on SDL_ACTIVEEVENT');


SDL::quit();

SKIP:
{
	skip "Turn SDL_GUI_TEST on", 1 unless $ENV{'SDL_GUI_TEST'};
	SDL::init(SDL_INIT_VIDEO);
	$display = SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE );
	$event = SDL::Event->new();

	#This filters out all ActiveEvents
	my $filter = sub { if($_[0]->type == SDL_ACTIVEEVENT){ return 0} else{ return 1; }};
	my $filtered = 1;

	SDL::Events::set_event_filter($filter);

	while(1)
	{

		SDL::Events::pump_events();
		if(SDL::Events::poll_event($event))
		{
			if(  $event->type == SDL_ACTIVEEVENT)
			{
				diag 'We should not be in here. The next test will fail!';
				$filtered = 0; #we got a problem!
				print "Hello Mouse!!!\n" if ($event->active_gain && ($event->active_state == SDL_APPMOUSEFOCUS) );
				print "Bye Mouse!!!\n" if (!$event->active_gain && ($event->active_state == SDL_APPMOUSEFOCUS) );
			}
			last if($event->type == SDL_QUIT);
		}
	}
	is( $filtered, 1, '[set_event_filter] Properly filtered SDL_ACTIVEEVENT');

	SDL::quit();
}

my @left = qw/
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

done_testing;

