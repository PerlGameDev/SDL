#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::KeyboardEvent 	PACKAGE = SDL::KeyboardEvent    PREFIX = kbevent_

=for documentation

SDL_KeyboardEvent --Keyboard event structure

 typedef struct{
  Uint8 type;
  Uint8 state;
  SDL_keysym keysym;
 } SDL_KeyboardEvent;


=cut

SDL_KeyboardEvent *
kbevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_KeyboardEvent));
		RETVAL->type = SDL_KEYDOWN | SDL_KEYUP;
	OUTPUT:
		RETVAL

Uint8
kbevent_type ( event, ... )
	SDL_KeyboardEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL


Uint8
kbevent_state ( event, ... )
	SDL_KeyboardEvent *event
	CODE: 
		if( items > 1 )
		{
			event->state = SvIV( ST(1) );

		}

		RETVAL = event->state;
	OUTPUT:
		RETVAL

SDL_keysym *
kbevent_keysym ( event, ... )
	SDL_KeyboardEvent *event
	PREINIT:
		char* CLASS = "SDL::keysym";
	CODE: 
		if( items > 1 )
		{
			SDL_keysym * ksp = (SDL_keysym * )SvPV( ST(1), PL_na) ;
			event->keysym = *ksp;

		}

		RETVAL = &(event->keysym);
	OUTPUT:
		RETVAL

void
kbevent_DESTROY(self)
	SDL_KeyboardEvent *self
	CODE:
		safefree( (char *)self );

