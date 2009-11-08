#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::JoyButtonEvent 	PACKAGE = SDL::JoyButtonEvent    PREFIX = jbevent_

=for documentation

SDL_JoyButtonEvent -- Joystick button event structure

 typedef struct{
  Uint8 type;
  Uint8 which;
  Uint8 button;
  Uint8 state;
 } SDL_JoyButtonEvent;


=cut

SDL_JoyButtonEvent *
jbevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_JoyButtonEvent));
		RETVAL->type = SDL_JOYBUTTONDOWN;
	OUTPUT:
		RETVAL

Uint8
jbevent_type ( event )

	SDL_JoyButtonEvent * event

	CODE:
		RETVAL = event->type;
	OUTPUT:
		RETVAL

Uint8
jbevent_which ( event )

	SDL_JoyButtonEvent * event

	CODE: 
		if( items > 1 )
		{
			event->which = SvIV( ST(1) );

		}

		RETVAL = event->which;
	OUTPUT:
		RETVAL

Uint8
jbevent_button ( event )

	SDL_JoyButtonEvent * event

	CODE: 
		if( items > 1 )
		{
			event->button = SvIV( ST(1) );

		}

		RETVAL = event->button;
	OUTPUT:
		RETVAL

Uint8
jbevent_state ( event )

	SDL_JoyButtonEvent * event

	CODE: 
		if( items > 1 )
		{
			event->state = SvIV( ST(1) );

		}

		RETVAL = event->state;
	OUTPUT:
		RETVAL

void
jbevent_DESTROY(self)

	SDL_JoyButtonEvent *self

	CODE:
		safefree( (char *)self );
