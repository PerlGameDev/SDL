#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

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

void
palette_colors ( palette )
	SDL_Palette *palette
	INIT:
		int i;	
	PPCODE:
		for(i = 0; i < palette->ncolors; i++)
		{
			XPUSHs( cpy2bag( (SDL_Color *)(palette->colors + i), sizeof(SDL_Color *), sizeof(SDL_Color), "SDL::Color" ) );
		}

SV *
palette_color_index ( palette, index )
	SDL_Palette *palette
	int index
	PREINIT:
		char * CLASS = "SDL::Color";
	CODE:
		RETVAL = cpy2bag( (SDL_Color *)(palette->colors + index), sizeof(SDL_Color *), sizeof(SDL_Color), "SDL::Color" );
	OUTPUT:
		RETVAL

void
palette_DESTROY ( bag )
	SV *bag
	CODE:
		objDESTROY(bag, safefree);
