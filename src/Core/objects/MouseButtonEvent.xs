#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::MouseButtonEvent 	PACKAGE = SDL::MouseButtonEvent    PREFIX = mbevent_

=for documentation

SDL_MouseButtonEvent -- Mouse button event structure

 typedef struct{
  Uint8 type;
  Uint8 which;
  Uint8 button;
  Uint8 state;
  Uint16 x, y;
 } SDL_MouseButtonEvent;


=cut

SDL_MouseButtonEvent *
mbevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_MouseButtonEvent));
		RETVAL->type = SDL_MOUSEBUTTONDOWN | SDL_MOUSEBUTTONUP;
	OUTPUT:
		RETVAL

Uint8
mbevent_type ( event, ... )
	SDL_MouseButtonEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL

Uint8
mbevent_which ( event, ... )
	SDL_MouseButtonEvent *event
	CODE: 
		RETVAL = event->which;
	OUTPUT:
		RETVAL

Uint8
mbevent_button ( event, ... )
	SDL_MouseButtonEvent *event
	CODE: 
		RETVAL = event->button;
	OUTPUT:
		RETVAL

Uint8
mbevent_state ( event, ... )
	SDL_MouseButtonEvent *event
	CODE: 
		RETVAL = event->state;
	OUTPUT:
		RETVAL

Uint16
mbevent_x ( event, ... )
	SDL_MouseButtonEvent *event
	CODE: 
		RETVAL = event->x;
	OUTPUT:
		RETVAL

Uint16
mbevent_y ( event, ... )
	SDL_MouseButtonEvent *event
	CODE: 
		RETVAL = event->y;
	OUTPUT:
		RETVAL
