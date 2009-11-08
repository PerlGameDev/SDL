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

 typedef struct{
  Uint8 type;
  Uint8 gain;
  Uint8 state;
 } SDL_ActiveEvent;


=cut

SDL_ActiveEvent *
aevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_ActiveEvent));
		RETVAL->type = SDL_ACTIVEEVENT;
	OUTPUT:
		RETVAL

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
		if( items > 1 )
		{
			event->gain = SvIV( ST(1) );

		}
		RETVAL = event->gain;
	OUTPUT:
		RETVAL

Uint8
aevent_state ( event, ... )
	SDL_ActiveEvent *event
	CODE: 
		if( items > 1 )
		{
			event->state = SvIV( ST(1) );

		}
		
		RETVAL = event->state;
	OUTPUT:
		RETVAL

void
uevent_DESTROY(self)
	SDL_ActiveEvent *self
	CODE:
		safefree( (char *)self );
