#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::ActiveEvent 	PACKAGE = SDL::ActiveEvent    PREFIX = aevent_

=for documentation

SDL_ActiveEvent -- Application visibility event structure

 typedef union{
  Uint8 type;
  Uint8 gain;
  Uint8 state;
 } SDL_Event;


=cut

Uint8
aevent_type ( event, ... )
	SDL_ActiveEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL


Uint8
aevent_gain ( event, ... )
	SDL_ActiveEvent *event
	CODE: 
		RETVAL = event->gain;
	OUTPUT:
		RETVAL

Uint8
aevent_state ( event, ... )
	SDL_ActiveEvent *event
	CODE: 
		RETVAL = event->state;
	OUTPUT:
		RETVAL
