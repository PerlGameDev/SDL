#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif


#include <SDL.h>
#ifdef HAVE_SDL_TTF
#include <SDL_ttf.h>
void _free_font(void *object)
{
    TTF_CloseFont((TTF_Font *)object);
}
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
		RETVAL = TTF_OpenFontIndex(file, ptsize, index);
	OUTPUT:
		RETVAL

void
ttf_font_DESTROY(bag)
	SV *bag
	CODE:
		objDESTROY(bag, _free_font);

#endif
