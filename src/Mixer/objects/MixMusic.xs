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

MODULE = SDL::Mixer::MixMusic 	PACKAGE = SDL::Mixer::MixMusic    PREFIX = mixmusic_

=for documentation

SDL_mixmusic - This is an opaque data type used for Music data

  typedef struct _Mix_Music Mix_Music;

=cut

#ifdef HAVE_SDL_MIXER

void
mixmusic_DESTROY(mixmusic)
	Mix_Music *mixmusic
	CODE:
		Mix_FreeMusic(mixmusic);

#endif
