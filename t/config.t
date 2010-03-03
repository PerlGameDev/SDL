# t/002_config.t - test config() functionality

use Test::More tests => 3;

BEGIN { use_ok( 'SDL::Config' ); }

diag "Testing SDL::Config";
diag "Has SDL                 = " . SDL::Config->has('SDL');
diag "Has SDL_mixer           = " . SDL::Config->has('SDL_mixer');
diag "Has SDL_image           = " . SDL::Config->has('SDL_image');
diag "Has SDL_ttf             = " . SDL::Config->has('SDL_ttf');
diag "Has SDL_gfx_framerate   = " . SDL::Config->has('SDL_gfx_framerate');
diag "Has SDL_gfx_imagefilter = " . SDL::Config->has('SDL_gfx_imagefilter');
diag "Has SDL_gfx_primitives  = " . SDL::Config->has('SDL_gfx_primitives');
diag "Has SDL_gfx_rotozoom    = " . SDL::Config->has('SDL_gfx_rotozoom');
diag "Has SDL_net             = " . SDL::Config->has('SDL_net');
diag "Has SDL_sound           = " . SDL::Config->has('SDL_sound');
diag "Has smpeg               = " . SDL::Config->has('smpeg');
diag "Has png                 = " . SDL::Config->has('png');
diag "Has jpeg                = " . SDL::Config->has('jpeg');

# we assume that the following are always present
is( SDL::Config->has('SDL'), 1 );
is( SDL::Config->has('SDL_mixer'), 1 );
