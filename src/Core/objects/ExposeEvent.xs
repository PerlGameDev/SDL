#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::ExposeEvent 	PACKAGE = SDL::ExposeEvent    PREFIX = weevent_

=for documentation

SDL_ExposeEvent -- Window expose event

 typedef struct{
  Uint8 type;
 } SDL_ExposeEvent;


=cut

SDL_ExposeEvent *
weevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_ExposeEvent));
		RETVAL->type = SDL_VIDEOEXPOSE;
	OUTPUT:
		RETVAL

Uint8
weevent_type ( event, ... )
	SDL_ExposeEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL

void
weevent_DESTROY(self)
	SDL_ExposeEvent *self
	CODE:
		safefree( (char *)self );
