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
	if( items > 1 )
		{
			event->state = SvIV( ST(1) );

		}
		RETVAL = event->state;
	OUTPUT:
		RETVAL

Uint16
mmevent_x ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
	if( items > 1 )
		{
			event->x = SvIV( ST(1) );

		}
		RETVAL = event->x;
	OUTPUT:
		RETVAL

Uint16
mmevent_y ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
	if( items > 1 )
		{
			event->y = SvIV( ST(1) );

		}
		RETVAL = event->y;
	OUTPUT:
		RETVAL

Uint16
mmevent_xrel ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
	if( items > 1 )
		{
			event->xrel = SvIV( ST(1) );

		}
		RETVAL = event->xrel;
	OUTPUT:
		RETVAL


Uint16
mmevent_yrel ( event, ... )
	SDL_MouseMotionEvent *event
	CODE: 
	if( items > 1 )
		{
			event->yrel = SvIV( ST(1) );

		}
		RETVAL = event->yrel;
	OUTPUT:
		RETVAL
