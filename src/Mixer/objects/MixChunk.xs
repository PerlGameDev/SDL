#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_mixer.h>

MODULE = SDL::Mixer::MixChunk 	PACKAGE = SDL::Mixer::MixChunk    PREFIX = mixchunk_

=for documentation

SDL_MixChunk - Stores audio data in memory

  typedef struct {
          int allocated;
          Uint8 *abuf;
          Uint32 alen;
          Uint8 volume;
  } Mix_Chunk;

=cut

Uint32
mixchunk_alen ( mixchunk )
	Mix_Chunk *mixchunk
	CODE:
		RETVAL = mixchunk->alen;
	OUTPUT:
		RETVAL

Uint8
mixchunk_volume ( mixchunk, ... )
	Mix_Chunk *mixchunk
	CODE:
		if (items > 1 ) mixchunk->volume = SvIV(ST(1)); 
		RETVAL = mixchunk->volume;
	OUTPUT:
		RETVAL

void
mixchunk_DESTROY(mixchunk)
	Mix_Chunk *mixchunk
	CODE:
		Mix_FreeChunk(mixchunk);
