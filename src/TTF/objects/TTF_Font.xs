#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif


#include <SDL.h>
#ifdef HAVE_SDL_TTF
#include <SDL_ttf.h>
#endif


MODULE = SDL::TTF_Font 	PACKAGE = SDL::TTF_Font    PREFIX = ttf_font_

=for documentation

SDL_TTF_Font - The opaque holder of a loaded font

=cut

#ifdef HAVE_SDL_TTF


void
ttf_font_DESTROY(self)
        TTF_Font *self
        CODE:
                TTF_CloseFont(self);


#endif
