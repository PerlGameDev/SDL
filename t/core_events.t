#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Event;
use SDL::Events;
use SDL::ActiveEvent;
use SDL::ExposeEvent;
use SDL::JoyAxisEvent;
use SDL::JoyBallEvent;
use SDL::JoyButtonEvent;
use SDL::JoyHatEvent;
use SDL::KeyboardEvent;
use SDL::MouseButtonEvent;
use SDL::MouseMotionEvent;
use SDL::QuitEvent;
use SDL::ResizeEvent;
use SDL::SysWMEvent;
use SDL::UserEvent;
use SDL::Video;
use Test::More;

plan ( tests => 111 );

my @done =qw/
pump_events 
peep_events 
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

use_ok( 'SDL::Events' ); 
use_ok( 'SDL::Event' ); 
use_ok( 'SDL::ActiveEvent' ); 
use_ok( 'SDL::ExposeEvent' ); 
use_ok( 'SDL::JoyAxisEvent' ); 
use_ok( 'SDL::JoyBallEvent' ); 
use_ok( 'SDL::JoyButtonEvent' ); 
use_ok( 'SDL::JoyHatEvent' ); 
use_ok( 'SDL::KeyboardEvent' ); 
use_ok( 'SDL::keysym' ); 
use_ok( 'SDL::MouseButtonEvent' ); 
use_ok( 'SDL::MouseMotionEvent' ); 
use_ok( 'SDL::QuitEvent' ); 
use_ok( 'SDL::ResizeEvent' ); 
use_ok( 'SDL::SysWMEvent' ); 
use_ok( 'SDL::UserEvent' ); 
can_ok( 'SDL::Events',           @done); 
can_ok( 'SDL::Event',            @done_event);
can_ok( 'SDL::ActiveEvent',      qw/type gain state/);
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

SDL::init(SDL_INIT_VIDEO);                                                                          

SDL::Video::set_video_mode(640,480,32, SDL_SWSURFACE);

is(SDL::Events::pump_events(), undef,  '[pump_events] Returns undef');

my $event   = SDL::Event->new();
my $aevent  = SDL::ActiveEvent->new(); 
my $weevent = SDL::ExposeEvent->new(); 
my $jaevent = SDL::JoyAxisEvent->new(); 
my $jtevent = SDL::JoyBallEvent->new(); 
my $jbevent = SDL::JoyButtonEvent->new(); 
my $jhevent = SDL::JoyHatEvent->new(); 
my $kbevent = SDL::KeyboardEvent->new(); 
my $keysym  = SDL::keysym->new(); 
my $mbevent = SDL::MouseButtonEvent->new(); 
my $mmevent = SDL::MouseMotionEvent->new(); 
my $qevent  = SDL::QuitEvent->new(); 
my $wrevent = SDL::ResizeEvent->new(); 
my $wmevent = SDL::SysWMEvent->new(); 
my $uevent  = SDL::UserEvent->new(); 

#isa_ok( $event,   'SDL::Event',            '[SDL::Event::new] is creating an Event');
isa_ok( $aevent,  'SDL::ActiveEvent',      '[SDL::ActiveEvent::new] is creating an ActiveEvent');
isa_ok( $weevent, 'SDL::ExposeEvent',      '[SDL::ExposeEvent::new] is creating an ExposeEvent');
isa_ok( $jaevent, 'SDL::JoyAxisEvent',     '[SDL::JoyAxisEvent::new] is creating an JoyAxisEvent');
isa_ok( $jtevent, 'SDL::JoyBallEvent',     '[SDL::JoyBallEvent::new] is creating an JoyBallEvent');
isa_ok( $jbevent, 'SDL::JoyButtonEvent',   '[SDL::JoyButtonEvent::new] is creating an JoyButtonEvent');
isa_ok( $jhevent, 'SDL::JoyHatEvent',      '[SDL::JoyHatEvent::new] is creating an JoyHatEvent');
isa_ok( $kbevent, 'SDL::KeyboardEvent',    '[SDL::KeyboardEvent::new] is creating an KeyboardEvent');
isa_ok( $keysym,  'SDL::keysym',           '[SDL::keysym::new] is creating an keysym');
isa_ok( $mbevent, 'SDL::MouseButtonEvent', '[SDL::MouseButtonEvent::new] is creating an MouseButtonEvent');
isa_ok( $mmevent, 'SDL::MouseMotionEvent', '[SDL::MouseMotionEvent::new] is creating an MouseMotionEvent');
isa_ok( $qevent,  'SDL::QuitEvent',        '[SDL::QuitEvent::new] is creating an QuitEvent');
isa_ok( $wrevent, 'SDL::ResizeEvent',      '[SDL::ResizeEvent::new] is creating an ResizeEvent');
isa_ok( $wmevent, 'SDL::SysWMEvent',       '[SDL::SysWMEvent::new] is creating an SysWMEvent');
isa_ok( $uevent,  'SDL::UserEvent',        '[SDL::UserEvent::new] is creating an UserEvent');

# checking constants
is(SDL_NOEVENT,          0, 'Constant SDL_NOEVENT');         # Unused
is(SDL_ACTIVEEVENT,      1, 'Constant SDL_ACTIVEVENT');      # Application loses/gains visibility
is(SDL_KEYDOWN,          2, 'Constant SDL_KEYDOWN');         # Keys pressed
is(SDL_KEYUP,            3, 'Constant SDL_KEYUP');           # Keys released
is(SDL_MOUSEMOTION,      4, 'Constant SDL_MOUSEMOTION');     # Mouse moved
is(SDL_MOUSEBUTTONDOWN,  5, 'Constant SDL_MOUSEBUTTONDOWN'); # Mouse button pressed
is(SDL_MOUSEBUTTONUP,    6, 'Constant SDL_MOUSEBUTTONUP');   # Mouse button released
is(SDL_JOYAXISMOTION,    7, 'Constant SDL_JOYAXISMOTION');   # Joystick axis motion
is(SDL_JOYBALLMOTION,    8, 'Constant SDL_JOYBALLMOTION');   # Joystick trackball motion
is(SDL_JOYHATMOTION,     9, 'Constant SDL_JOYHATMOTION');    # Joystick hat position change
is(SDL_JOYBUTTONDOWN,   10, 'Constant SDL_JOYBUTTONDOWN');   # Joystick button pressed
is(SDL_JOYBUTTONUP,     11, 'Constant SDL_JOYBUTTONUP');     # Joystick button released
is(SDL_QUIT,            12, 'Constant SDL_QUIT');            # User-requested quit
is(SDL_SYSWMEVENT,      13, 'Constant SDL_SYSWMEVENT');      # System specific event
is(SDL_EVENT_RESERVEDA, 14, 'Constant SDL_EVENT_RESERVEDA'); # Reserved for future use..
is(SDL_EVENT_RESERVEDB, 15, 'Constant SDL_EVENT_RESERVEDB'); # Reserved for future use..
is(SDL_VIDEORESIZE,     16, 'Constant SDL_VIDEORESIZE');     # User resized video mode
is(SDL_VIDEOEXPOSE,     17, 'Constant SDL_VIDEOEXPOSE');     # Screen needs to be redrawn
is(SDL_EVENT_RESERVED2, 18, 'Constant SDL_EVENT_RESERVED2'); # Reserved for future use..
is(SDL_EVENT_RESERVED3, 19, 'Constant SDL_EVENT_RESERVED3'); # Reserved for future use..
is(SDL_EVENT_RESERVED4, 20, 'Constant SDL_EVENT_RESERVED4'); # Reserved for future use..
is(SDL_EVENT_RESERVED5, 21, 'Constant SDL_EVENT_RESERVED5'); # Reserved for future use..
is(SDL_EVENT_RESERVED6, 22, 'Constant SDL_EVENT_RESERVED6'); # Reserved for future use..
is(SDL_EVENT_RESERVED7, 23, 'Constant SDL_EVENT_RESERVED7'); # Reserved for future use..
is(SDL_USEREVENT,       24, 'Constant SDL_USEREVENT');
is(SDL_NUMEVENTS,       32, 'Constant SDL_NUMEVENTS');

# checking eventmasks
is(SDL_ACTIVEEVENTMASK,     SDL_EVENTMASK(SDL_ACTIVEEVENT),     'Constant SDL_ACTIVEVENTMASK');
is(SDL_KEYDOWNMASK,         SDL_EVENTMASK(SDL_KEYDOWN),         'Constant SDL_KEYDOWNMASK');
is(SDL_KEYUPMASK,           SDL_EVENTMASK(SDL_KEYUP),           'Constant SDL_KEYUPMASK');
is(SDL_KEYEVENTMASK,        SDL_EVENTMASK(SDL_KEYDOWN)|
                            SDL_EVENTMASK(SDL_KEYUP),           'Constant SDL_KEYEVENTMASK');
is(SDL_MOUSEMOTIONMASK,     SDL_EVENTMASK(SDL_MOUSEMOTION),     'Constant SDL_MOUSEMOTIONMASK');
is(SDL_MOUSEBUTTONDOWNMASK, SDL_EVENTMASK(SDL_MOUSEBUTTONDOWN), 'Constant SDL_MOUSEBUTTONDOWNMASK');
is(SDL_MOUSEBUTTONUPMASK,   SDL_EVENTMASK(SDL_MOUSEBUTTONUP),   'Constant SDL_MOUSEBUTTONUPMASK');
is(SDL_MOUSEEVENTMASK,      SDL_EVENTMASK(SDL_MOUSEMOTION)|
                            SDL_EVENTMASK(SDL_MOUSEBUTTONDOWN)|
                            SDL_EVENTMASK(SDL_MOUSEBUTTONUP),   'Constant SDL_MOUSEEVENTMASK');
is(SDL_JOYAXISMOTIONMASK,   SDL_EVENTMASK(SDL_JOYAXISMOTION),   'Constant SDL_JOYAXISMOTIONMASK');
is(SDL_JOYBALLMOTIONMASK,   SDL_EVENTMASK(SDL_JOYBALLMOTION),   'Constant SDL_JOYBALLMOTIONMASK');
is(SDL_JOYHATMOTIONMASK,    SDL_EVENTMASK(SDL_JOYHATMOTION),    'Constant SDL_JOYHATMOTIONMASK');
is(SDL_JOYBUTTONDOWNMASK,   SDL_EVENTMASK(SDL_JOYBUTTONDOWN),   'Constant SDL_JOYBUTTONDOWNMASK');
is(SDL_JOYBUTTONUPMASK,     SDL_EVENTMASK(SDL_JOYBUTTONUP),     'Constant SDL_JOYBUTTONUPMASK');
is(SDL_JOYEVENTMASK,        SDL_EVENTMASK(SDL_JOYAXISMOTION)|
                            SDL_EVENTMASK(SDL_JOYBALLMOTION)|
                            SDL_EVENTMASK(SDL_JOYHATMOTION)|
                            SDL_EVENTMASK(SDL_JOYBUTTONDOWN)|
                            SDL_EVENTMASK(SDL_JOYBUTTONUP),     'Constant SDL_JOYEVENTMASK');
is(SDL_VIDEORESIZEMASK,     SDL_EVENTMASK(SDL_VIDEORESIZE),     'Constant SDL_VIDEORESIZEMASK');
is(SDL_VIDEOEXPOSEMASK,     SDL_EVENTMASK(SDL_VIDEOEXPOSE),     'Constant SDL_VIDEOEXPOSEMASK');
is(SDL_QUITMASK,            SDL_EVENTMASK(SDL_QUIT),            'Constant SDL_QUITMASK');
is(SDL_SYSWMEVENTMASK,      SDL_EVENTMASK(SDL_SYSWMEVENT),      'Constant SDL_SYSWMEVENTMASK');
is(SDL_ALLEVENTS,           0xFFFFFFFF,                         'Constant SDL_SYSWMEVENTMASK');

# checking the ->type of an event
#is($event->type,   SDL_EVENT, '[SDL::Event->type] returns correctly');
is($aevent->type,  SDL_ACTIVEEVENT, '[SDL::ActiveEvent->type] returns correctly'); 
is($weevent->type, SDL_VIDEOEXPOSE, '[SDL::ExposeEvent->type] returns correctly'); 
is($jaevent->type, SDL_JOYAXISMOTION, '[SDL::JoyAxisEvent->type] returns correctly'); 
is($jtevent->type, SDL_JOYBALLMOTION, '[SDL::JoyBallEvent->type] returns correctly'); 
is((($jbevent->type == SDL_JOYBUTTONDOWN) || ($jbevent->type == SDL_JOYBUTTONUP)), 1, '[SDL::JoyButtonEvent->type] returns correctly'); 
is($jhevent->type, SDL_JOYHATMOTION, '[SDL::JoyHatEvent->type] returns correctly'); 
is((($kbevent->type == SDL_KEYUP) || ($kbevent->type == SDL_KEYDOWN)), 1, '[SDL::KeyboardEvent->type] returns correctly'); 
is((($mbevent->type == SDL_MOUSEBUTTONDOWN) || ($mbevent->type == SDL_MOUSEBUTTONUP)), 1, '[SDL::MouseButtonEvent->type] returns correctly'); 
is($mmevent->type, SDL_MOUSEMOTION, '[SDL::MouseMotionEvent->type] returns correctly'); 
is($qevent->type,  SDL_QUIT, '[SDL::QuitEvent->type] returns correctly'); 
is($wrevent->type, SDL_VIDEORESIZE, '[SDL::ResizeEvent->type] returns correctly'); 
is($wmevent->type, SDL_SYSWMEVENT, '[SDL::SysWMEvent->type] returns correctly'); 
is($uevent->type,  SDL_USEREVENT, '[SDL::UserEvent->type] returns correctly'); 

$uevent->code(200);
is( $uevent->code, 200, '[SDL::UserEvent->code] is set correctly');

my $num_peep_events = SDL::Events::peep_events($event, 127, SDL_PEEKEVENT, SDL_ALLEVENTS);
is($num_peep_events >= 0, 1,  '[peep_events] Size of event queue is ' . $num_peep_events);

TODO:
{
	local $TODO = 'Try to send a Scalar Ref as an IV and return a Scalar Ref';

my $data1 = 'wow';
$uevent->data1(\$data1);
$uevent->data2('notwow');
is( $uevent->data1, 'wow', '[SDL::UserEvent->data1] is set correctly');
is( $uevent->data2, 'notwow','[SDL::UserEvent->data2] is set correctly');
}

=pod

my $events = SDL::Event->new();
my $num_peep_events = SDL::Events::peep_events( SDL::Event->new(), 127, SDL_PEEKEVENT, SDL_ALLEVENTS);
is($num_peep_events >= 0, 1,  '[peep_events] Size of event queue is ' . $num_peep_events);

my $event = SDL::Event->new();
my $value = SDL::Events::poll_event($event);
is(($value == 1) || ($value == 0), 1,  '[poll_event] Returns 1 or 0');


my $event2 = SDL::Event->new();
is(SDL::Events::push_event($event2), 0,  '[push_event] Returns 0 on success');
my $event3 = SDL::Event->new();
is(SDL::Events::push_event($event3), 0,  '[push_event] Returns 0 on success');


my $events2 = SDL::Event->new();
my $num_peep_events2 = SDL::Events::peep_events( $events2, 127, SDL_PEEKEVENT, SDL_ALLEVENTS);
is($num_peep_events2 > $num_peep_events, 1,  '[peep_events] Size of event queue is ' . $num_peep_events2."\t". SDL::get_error());



my $events3 = SDL::Event->new();
$num_peep_events = SDL::Events::peep_events( $events3, 1, SDL_ADDEVENT, SDL_ALLEVENTS);
is($num_peep_events, 1,  '[peep_events] Added 1 event to the back of the queue');

my $events4 = SDL::Event->new();
$num_peep_events = SDL::Events::peep_events( $events4, 1, SDL_GETEVENT, SDL_ALLEVENTS);
is($num_peep_events, 1,  '[peep_events] Got 1 event from the front of the queue');



my $event4 = SDL::Event->new();
is(SDL::Events::wait_event($event4), 1,  '[wait_event] Returns 1 on success');
is(SDL::Events::wait_event(), 1,  '[wait_event] Returns 1 on success');

=cut


my @left = qw/
poll_event
push_event
wait_event
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
