#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::ResizeEvent 	PACKAGE = SDL::ResizeEvent    PREFIX = wrevent_

=for documentation

SDL_ResizeEvent -- Window resize event structure

 typedef struct{
  Uint8 type;
  Uint w, h;
 } SDL_ResizeEvent;


=cut

SDL_ResizeEvent *
wrevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_ResizeEvent));
		RETVAL->type = SDL_VIDEORESIZE;
	OUTPUT:
		RETVAL

Uint8
wrevent_type ( event, ... )
	SDL_ResizeEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL

int
wrevent_w ( event, ... )
	SDL_ResizeEvent *event
	CODE: 
		if( items > 1 )
		{
			event->w = SvIV( ST(1) );

		}

		RETVAL = event->w;
	OUTPUT:
		RETVAL

int
wrevent_h ( event, ... )
	SDL_ResizeEvent *event
	CODE: 
		if( items > 1 )
		{
			event->h = SvIV( ST(1) );

		}

		RETVAL = event->h;
	OUTPUT:
		RETVAL

void
wrevent_DESTROY ( event)
	SDL_ResizeEvent *event
	CODE:
		safefree( (char *) event);
