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
ttf_font_DESTROY(bag)
	SV *bag
	CODE:
		if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			   void** pointers = (void**)(SvIV((SV*)SvRV( bag ))); 
			   TTF_Font * ttf_font = (TTF_Font*)(pointers[0]);
			   if (PERL_GET_CONTEXT == pointers[1]) {
			       pointers[0] = NULL;
			       safefree( pointers );
			       TTF_CloseFont(ttf_font);
			   }
		       } else if (bag == 0) {
			   XSRETURN(0);
		       } else {
			   XSRETURN_UNDEF;
		       }


#endif
