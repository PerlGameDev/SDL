#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>



MODULE = Rect 	PACKAGE = Rect


SDL_Rect *
NewRect ( x, y, w, h )
	Sint16 x
	Sint16 y
	Uint16 w
	Uint16 h
	CODE:
		RETVAL = (SDL_Rect *) safemalloc (sizeof(SDL_Rect));
		RETVAL->x = x;
		RETVAL->y = y;
		RETVAL->w = w;
		RETVAL->h = h;
	OUTPUT:
		RETVAL

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

MODULE = Rect  PACKAGE = SDL_RectPtr  PREFIX = Rect_

void
Rect_DESTROY(rect)
	SDL_Rect *rect
	CODE:
	 	printf("RectPtr::DESTROY\n");
		safefree( rect );


