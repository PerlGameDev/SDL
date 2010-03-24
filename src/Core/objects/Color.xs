#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Color 	PACKAGE = SDL::Color    PREFIX = color_

=for documentation

SDL_Color -- Format independent color description

  typedef struct{
    Uint8 r;
    Uint8 g;
    Uint8 b;
    Uint8 unused;
  } SDL_Color;

=cut

SDL_Color *
color_new (CLASS, r, g, b )
	char* CLASS
	Uint8 r
	Uint8 g
	Uint8 b
	CODE:
		RETVAL = (SDL_Color *) safemalloc(sizeof(SDL_Color));
		RETVAL->r = r;
		RETVAL->g = g;
		RETVAL->b = b;
	OUTPUT:
		RETVAL

Uint8
color_r ( color, ... )
	SDL_Color *color
	CODE:
		if (items > 1 ) color->r = SvIV(ST(1)); 
		RETVAL = color->r;
	OUTPUT:
		RETVAL

Uint8
color_g ( color, ... )
	SDL_Color *color
	CODE:
		if (items > 1 ) color->g = SvIV(ST(1)); 
		RETVAL = color->g;
	OUTPUT:
		RETVAL

Uint8
color_b ( color, ... )
	SDL_Color *color
	CODE:
		if (items > 1 ) color->b = SvIV(ST(1)); 
		RETVAL = color->b;
	OUTPUT:
		RETVAL

void
color_DESTROY ( color )
	SDL_Color *color
	CODE:
		safefree(color);