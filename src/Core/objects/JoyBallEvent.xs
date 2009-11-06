#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::JoyBallEvent 	PACKAGE = SDL::JoyBallEvent    PREFIX = jtevent_

=for documentation

SDL_JoyBallEvent -- Joystick trackball motion event structure

 typedef struct{
  Uint8 type;
  Uint8 which;
  Uint8 ball;
  Sint16 xrel, yrel;
 } SDL_JoyBallEvent;


=cut

Uint8
jtevent_type ( event, ... )
	SDL_JoyBallEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL

Uint8
jtevent_which ( event, ... )
	SDL_JoyBallEvent *event
	CODE: 
		RETVAL = event->which;
	OUTPUT:
		RETVAL

Uint8
jtevent_ball ( event, ... )
	SDL_JoyBallEvent *event
	CODE: 
		RETVAL = event->ball;
	OUTPUT:
		RETVAL

Sint16
jtevent_xrel ( event, ... )
	SDL_JoyBallEvent *event
	CODE: 
		RETVAL = event->xrel;
	OUTPUT:
		RETVAL

Sint16
jtevent_yrel ( event, ... )
	SDL_JoyBallEvent *event
	CODE: 
		RETVAL = event->yrel;
	OUTPUT:
		RETVAL
