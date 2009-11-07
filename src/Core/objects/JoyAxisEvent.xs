#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::JoyAxisEvent 	PACKAGE = SDL::JoyAxisEvent    PREFIX = jaevent_

=for documentation

SDL_JoyAxisEvent -- Joystick axis motion event structure

 typedef struct{
  Uint8 type;
  Uint8 which;
  Uint8 axis;
  Sint16 value;
 } SDL_JoyAxisEvent;


=cut

SDL_JoyAxisEvent *
jaevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_JoyAxisEvent));
		RETVAL->type = SDL_JOYAXISMOTION;
	OUTPUT:
		RETVAL

Uint8
jaevent_type ( event, ... )
	SDL_JoyAxisEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL

Uint8
jaevent_which ( event, ... )
	SDL_JoyAxisEvent *event
	CODE: 
		RETVAL = event->which;
	OUTPUT:
		RETVAL

Uint8
jaevent_axis ( event, ... )
	SDL_JoyAxisEvent *event
	CODE: 
		RETVAL = event->axis;
	OUTPUT:
		RETVAL

Sint16
jaevent_value ( event, ... )
	SDL_JoyAxisEvent *event
	CODE: 
		RETVAL = event->value;
	OUTPUT:
		RETVAL
