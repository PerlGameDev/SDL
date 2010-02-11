#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_MIXER
#include <SDL_mixer.h>
#endif

#ifdef HAVE_SMPEG
#include <smpeg/smpeg.h>
#ifdef HAVE_SDL_MIXER
static int sdl_perl_use_smpeg_audio = 0;
#endif
#endif



MODULE = SDL::Mixer::Effects 	PACKAGE = SDL::Mixer::Effects    PREFIX = mixeff_

=for documentation

SDL_mixer bindings

See: http://www.libsdl.org/projects/SDL_mixer/docs/SDL_mixer.html

=cut

#ifdef HAVE_SDL_MIXER

#if SDL_MIXER_MAJOR_VERSION >	1 || SDL_MIXER_MINOR_VERSION > 2 || (  SDL_MIXER_MAJOR_VERSION == 1 && SDL_MIXER_MINOR_VERSION == 2 && SDL_MIXER_PATCHLEVEL >= 10 )

void
mixeff_register_effect()
	CODE:
		warn ("Todo: Add 1.2.10 methods here");

#endif

void
mixeff_set_post_mix ( func, arg )
	void *func
	void *arg
	CODE:
		Mix_SetPostMix(func,arg);


int
mixeff_set_panning ( channel, left, right )
	int channel
	int left
	int right
	CODE:
		RETVAL = Mix_SetPanning(channel, left, right);
	OUTPUT:
		RETVAL


#endif
