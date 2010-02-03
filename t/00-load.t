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
SDL::Time
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
SDL::MultiThread
SDL::PixelFormat
SDL::VideoInfo
SDL::Mixer
SDL::Mixer::Samples
SDL::Mixer::MixChunk
SDL::Mixer::MixMusic
SDL::Version

SDL::GFX::BlitFunc
SDL::GFX::Framerate
SDL::GFX::FPSManager
SDL::GFX::ImageFilter
SDL::GFX::Primitives
SDL::GFX::Rotozoom
SDL::Image

SDL::Net
SDL::Net::TCP
SDL::Net::UDP
SDL::Net::IPaddress
/;
    plan tests => scalar @modules;

    use_ok $_ foreach @modules;
    
 }
