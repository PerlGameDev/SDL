#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::JoyHatEvent 	PACKAGE = SDL::JoyHatEvent    PREFIX = jhevent_

=for documentation

SDL_JoyHatEvent -- Joystick hat position change event structure

 typedef struct{
  Uint8 type;
  Uint8 which;
  Uint8 hat;
  Uint8 value;
 } SDL_JoyHatEvent;


=cut

Uint8
jhevent_type ( event, ... )
	SDL_JoyHatEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL

Uint8
jhevent_which ( event, ... )
	SDL_JoyHatEvent *event
	CODE: 
	if( items > 1 )
		{
			event->which = SvIV( ST(1) );

		}

		RETVAL = event->which;
	OUTPUT:
		RETVAL

Uint8
jhevent_hat ( event, ... )
	SDL_JoyHatEvent *event
	CODE:
	if( items > 1 )
		{
			event->hat = SvIV( ST(1) );

		}


		RETVAL = event->hat;
	OUTPUT:
		RETVAL

Uint8
jhevent_value ( event, ... )
	SDL_JoyHatEvent *event
	CODE: 
		if( items > 1 )
		{
			event->value = SvIV( ST(1) );

		}

		RETVAL = event->value;
	OUTPUT:
		RETVAL
