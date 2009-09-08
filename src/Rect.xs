#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>



MODULE = SDL::Rect 	PACKAGE = SDL::Rect

SDL_Rect *
new (CLASS)
	char* CLASS
	CODE:
		RETVAL = (SDL_Rect *) safemalloc (sizeof(SDL_Rect));
		RETVAL->x = 0;
		RETVAL->y = 0;
		RETVAL->w = 0;
		RETVAL->h = 0;
	OUTPUT:
		RETVAL

void
SetRect(rect, x, y, w, h)
	SDL_Rect *rect
	Sint16 x	
	Sint16 y
	Uint16 w
	Uint16 h
	CODE:
		rect->x = x;
		rect->y = y;
		rect->w = w;
		rect->h = h;
		

Sint16
RectX ( rect, ... )
	SDL_Rect *rect
	CODE:
		if (items > 1 ) rect->x = SvIV(ST(1)); 
		RETVAL = rect->x;
	OUTPUT:
		RETVAL

Sint16
RectY ( rect, ... )
	SDL_Rect *rect
	CODE:
		if (items > 1 ) rect->y = SvIV(ST(1)); 
		RETVAL = rect->y;
	OUTPUT:
		RETVAL

Uint16
RectW ( rect, ... )
	SDL_Rect *rect
	CODE:
		if (items > 1 ) rect->w = SvIV(ST(1)); 
		RETVAL = rect->w;
	OUTPUT:
		RETVAL

Uint16
RectH ( rect, ... )
	SDL_Rect *rect
	CODE:
		if (items > 1 ) rect->h = SvIV(ST(1)); 
		RETVAL = rect->h;
	OUTPUT:
		RETVAL


void
DESTROY(self)
	SDL_Rect *self
	CODE:
	 	printf("RectPtr::DESTROY\n");
		safefree( (char *)self );


