#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::QuitEvent 	PACKAGE = SDL::QuitEvent    PREFIX = qevent_

=for documentation

SDL_QuitEvent -- Quit requested event

 typedef struct{
  Uint8 type;
 } SDL_QuitEvent;


=cut

SDL_QuitEvent *
qevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_QuitEvent));
		RETVAL->type = SDL_QUIT;
	OUTPUT:
		RETVAL

Uint8
qevent_type ( event, ... )
	SDL_QuitEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL
