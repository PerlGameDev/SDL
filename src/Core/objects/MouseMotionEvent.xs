#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::MouseMotionEvent 	PACKAGE = SDL::MouseMotionEvent    PREFIX = mmevent_

=for documentation

SDL_MouseMotionEvent -- Mouse motion event structure

 typedef struct{
  Uint8 type;
  Uint8 state;
  Uint16 x, y;
  Uint16 xrel, yrel;
 } SDL_MouseMotionEvent;


=cut

SDL_MouseMotionEvent *
mmevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_MouseMotionEvent));
		RETVAL->type = SDL_MOUSEMOTION;
	OUTPUT:
		RETVAL

Uint8
mmevent_type ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL

Uint8
mmevent_state ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
		RETVAL = event->state;
	OUTPUT:
		RETVAL

Uint16
mmevent_x ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
		RETVAL = event->x;
	OUTPUT:
		RETVAL

Uint16
mmevent_y ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
		RETVAL = event->y;
	OUTPUT:
		RETVAL

Uint16
mmevent_xrel ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
		RETVAL = event->xrel;
	OUTPUT:
		RETVAL

Uint16
mmevent_yrel ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
		RETVAL = event->yrel;
	OUTPUT:
		RETVAL
