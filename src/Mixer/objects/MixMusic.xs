#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_mixer.h>

MODULE = SDL::Mixer::MixMusic 	PACKAGE = SDL::Mixer::MixMusic    PREFIX = mixmusic_

=for documentation

SDL_mixmusic - This is an opaque data type used for Music data

  typedef struct _Mix_Music Mix_Music;

=cut

void
mixmusic_DESTROY(mixmusic)
	Mix_Music *mixmusic
	CODE:
		Mix_FreeMusic(mixmusic);
