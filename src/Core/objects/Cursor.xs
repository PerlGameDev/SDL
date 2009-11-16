#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Cursor 	PACKAGE = SDL::Cursor    PREFIX = cursor_

=for documentation

SDL_Cursor -- Cursor object

=cut

SDL_Cursor *
cursor_new (CLASS, data, mask, x ,y )
	char* CLASS	
	SDL_Surface *data
	SDL_Surface *mask
	int x
	int y
	CODE:
		RETVAL = SDL_CreateCursor((Uint8*)data->pixels,
				(Uint8*)mask->pixels,data->w,data->h,x,y);
	OUTPUT:
		RETVAL

void
cursor_DESTROY(self)
	SDL_Cursor *self
	CODE:
		SDL_FreeCursor(self );
