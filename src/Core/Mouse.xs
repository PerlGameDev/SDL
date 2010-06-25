#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Mouse 	PACKAGE = SDL::Mouse    PREFIX = mouse_

void
mouse_warp_mouse ( x, y )
	Uint16 x
	Uint16 y
	CODE:
		SDL_WarpMouse(x,y);

void
mouse_set_cursor ( cursor )
	SDL_Cursor *cursor
	CODE:
		SDL_SetCursor(cursor);

SDL_Cursor *
mouse_get_cursor ()
	PREINIT:
	char* CLASS = "SDL::Cursor";
	CODE:
	RETVAL = SDL_GetCursor();
	OUTPUT:
		RETVAL

int
mouse_show_cursor ( toggle )
	int toggle
	CODE:
		RETVAL = SDL_ShowCursor(toggle);
	OUTPUT: 
		RETVAL



