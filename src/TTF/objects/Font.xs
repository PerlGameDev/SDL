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


MODULE = SDL::TTF::Font 	PACKAGE = SDL::TTF::Font    PREFIX = ttf_font_

=for documentation

SDL_TTF_Font - The opaque holder of a loaded font

=cut

#ifdef HAVE_SDL_TTF

TTF_Font *
ttf_font_new(CLASS, file, ptsize, index = 0)
	char* CLASS
	char *file
	int ptsize
	long index
	CODE:
		RETVAL = safemalloc(sizeof(TTF_Font *));
		RETVAL = TTF_OpenFontIndex(file, ptsize, index);
	OUTPUT:
		RETVAL


void
ttf_font_DESTROY(ttf_font)
	TTF_Font *ttf_font
	CODE:
		TTF_CloseFont(ttf_font);

#endif
