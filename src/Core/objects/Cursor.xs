#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Cursor 	PACKAGE = SDL::Cursor    PREFIX = cursor_

=for documentation

SDL_Cursor -- Cursor object

=cut

SDL_Cursor *
cursor_new(CLASS, data, mask, w, h, x ,y )
	char* CLASS
	AV* data
	AV* mask
	int w
	int h
	int x
	int y
	PREINIT:
		int len;
		Uint8 *_data;
		Uint8 *_mask;
		int i;
	CODE:
		len = av_len(data);
		_data = (Uint8 *)safemalloc(sizeof(Uint8)*(len));
		_mask = (Uint8 *)safemalloc(sizeof(Uint8)*(len));
		for ( i = 0; i < len + 1; i++ )
		{
			SV ** temp1 = av_fetch(data,i,0);
			SV ** temp2 = av_fetch(mask,i,0);
			if( temp1 != NULL)
				_data[i] = (Uint8)SvIV( *temp1 );
			else
				_data[i] = 0;

			if( temp2 != NULL)
				_mask[i] = (Uint8)SvIV( *temp2 );
			else
				_mask[i] = 0;
		}

		RETVAL = SDL_CreateCursor(_data, _mask, w, h, x, y);
		safefree(_data);
		safefree(_mask);
	OUTPUT:
		RETVAL

void
cursor_DESTROY(self)
	SDL_Cursor *self
	CODE:
		SDL_FreeCursor(self);
