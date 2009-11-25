#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Mouse 	PACKAGE = SDL::Mouse    PREFIX = mouse_

SDL_Cursor *
mouse_create_cursor(data, mask, w, h, x ,y )
	AV* data
	AV* mask
	int w
	int h
	int x
	int y
	PREINIT:
		char* CLASS = "SDL::Cursor";
	CODE:
		int len = av_len(data);
		Uint8 *_data = (Uint8 *)safemalloc(sizeof(Uint8)*(len));
		Uint8 *_mask = (Uint8 *)safemalloc(sizeof(Uint8)*(len));
		int i;
		for ( i = 0; i < len + 1; i++ )
		{
			SV ** temp1 = av_fetch(data,i,0);
			SV ** temp2 = av_fetch(mask,i,0);
			if( temp1 != NULL)
			{
				_data[i] = (Uint8)SvIV( *temp1 );
			}
			else
			{
				_data[i] = 0;
			}

			if( temp2 != NULL)
			{
				_mask[i] = (Uint8)SvIV( *temp2 );
			}
			else
			{
				_mask[i] = 0;
			}
		}

		RETVAL = SDL_CreateCursor(_data, _mask, w, h, x, y);
		safefree(_data);
		safefree(_mask);
	OUTPUT:
		RETVAL

void
mouse_warp_mouse ( x, y )
	Uint16 x
	Uint16 y
	CODE:
		SDL_WarpMouse(x,y);

void
mouse_free_cursor ( cursor )
	SDL_Cursor *cursor
	CODE:
		SDL_FreeCursor(cursor);

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



