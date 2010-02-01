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


MODULE = SDL::Mixer::Samples 	PACKAGE = SDL::Mixer::Samples    PREFIX = mixsam_

=for documentation

SDL_mixer bindings

See: http://www.libsdl.org/projects/SDL_mixer/docs/SDL_mixer.html

=cut

#ifdef HAVE_SDL_MIXER

int 
mixsam_get_num_chunk_decoders ()
	CODE:
		RETVAL = Mix_GetNumChunkDecoders();
	OUTPUT:
		RETVAL

#endif
