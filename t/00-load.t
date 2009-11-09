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
/;
    plan tests => scalar @modules;

    use_ok $_ foreach @modules;
 }
