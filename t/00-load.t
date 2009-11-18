use strict;
use warnings;
use Test::Most 'bail';



BEGIN {
    my @modules = 
qw /
SDL 
SDL::Video 
SDL::Color
SDL::Surface
SDL::Config
SDL::Overlay
SDL::Rect
SDL::Events 
SDL::Event 
SDL::Mouse
SDL::Joystick
SDL::Cursor
SDL::Audio
SDL::AudioSpec
SDL::CDROM
SDL::CDTrack
SDL::CD
/;
    plan tests => scalar @modules;

    use_ok $_ foreach @modules;
 }
