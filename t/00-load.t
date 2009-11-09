
use strict;
use warnings;

use Test::Most 'bail';



BEGIN {
    my @modules = 
 
qw /
SDL 
SDL::Video 
SDL::Events 
SDL::Event 
SDL::ActiveEvent 
SDL::ExposeEvent 
SDL::JoyAxisEvent 
SDL::JoyBallEvent 
SDL::JoyButtonEvent 
SDL::JoyHatEvent 
SDL::KeyboardEvent 
SDL::keysym 
SDL::MouseButtonEvent 
SDL::MouseMotionEvent 
SDL::QuitEvent 
SDL::ResizeEvent 
SDL::SysWMEvent 
SDL::UserEvent    			
/;
    plan tests => scalar @modules;

    use_ok $_ foreach @modules;
 }
