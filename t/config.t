# t/002_config.t - test config() functionality

use strict;
use warnings;
use Test::More tests => 2;

BEGIN { use_ok('SDL::Config'); }

print "Testing SDL::Config\n";
print "Has SDL                 = " . SDL::Config->has('SDL') . "\n";
print "Has SDL_mixer           = " . SDL::Config->has('SDL_mixer') . "\n";
print "Has SDL_image           = " . SDL::Config->has('SDL_image') . "\n";
print "Has SDL_ttf             = " . SDL::Config->has('SDL_ttf') . "\n";
print "Has SDL_gfx_framerate   = " . SDL::Config->has('SDL_gfx_framerate') . "\n";
print "Has SDL_gfx_imagefilter = " . SDL::Config->has('SDL_gfx_imagefilter') . "\n";
print "Has SDL_gfx_primitives  = " . SDL::Config->has('SDL_gfx_primitives') . "\n";
print "Has SDL_gfx_rotozoom    = " . SDL::Config->has('SDL_gfx_rotozoom') . "\n";
print "Has SDL_net             = " . SDL::Config->has('SDL_net') . "\n";
print "Has SDL_Pango           = " . SDL::Config->has('SDL_Pango') . "\n";
print "Has SDL_sound           = " . SDL::Config->has('SDL_sound') . "\n";
print "Has SDL_svg             = " . SDL::Config->has('SDL_svg') . "\n";
print "Has smpeg               = " . SDL::Config->has('smpeg') . "\n";
print "Has png                 = " . SDL::Config->has('png') . "\n";
print "Has jpeg                = " . SDL::Config->has('jpeg') . "\n";
print "Has tiff                = " . SDL::Config->has('tiff') . "\n";

# we assume that the following are always present
is( SDL::Config->has('SDL'), 1 );
