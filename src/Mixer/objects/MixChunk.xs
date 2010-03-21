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

#ifdef HAVE_SDL_MIXER

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
mixchunk_DESTROY(bag)
	SV *bag
	CODE:
		if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			   void** pointers = (void**)(SvIV((SV*)SvRV( bag ))); 
			   Mix_Chunk * mixchunk = (Mix_Chunk*)(pointers[0]);
			   if (PERL_GET_CONTEXT == pointers[1]) {
			       pointers[0] = NULL;
			       safefree( pointers );

			       Mix_FreeChunk(mixchunk);
			   }
		       } else if (bag == 0) {
			   XSRETURN(0);
		       } else {
			   XSRETURN_UNDEF;
		       }


#endif
