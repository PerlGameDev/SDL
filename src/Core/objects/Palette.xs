#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Palette 	PACKAGE = SDL::Palette    PREFIX = palette_

=for documentation

SDL_Palette -- Color palette for 8-bit pixel formats 

  typedef struct{
	int ncolors;
	SDL_Color *colors
  } SDL_Palette;

=cut

int
palette_ncolors ( palette )
	SDL_Palette *palette
	CODE:
		RETVAL = palette->ncolors;
	OUTPUT:
		RETVAL

AV *
palette_colors ( palette )
	SDL_Palette *palette
	CODE:
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		int i;
		for(i = 0; i < palette->ncolors; i++)
		{
			av_push(RETVAL,newSViv( PTR2IV( palette->colors + i ) ) );
		}
	OUTPUT:
		RETVAL		


SDL_Color *
palette_color_index ( palette, index )
	SDL_Palette *palette
	int index
	PREINIT:
		char * CLASS = "SDL::Color";
	CODE:
		RETVAL = (SDL_Color *)(palette->colors + index);
	OUTPUT:
		RETVAL



