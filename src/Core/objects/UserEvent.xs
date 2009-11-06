#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::UserEvent 	PACKAGE = SDL::UserEvent    PREFIX = uevent_

=for documentation

SDL_UserEvent -- A user-defined event type

 typedef struct{
  Uint8 type;
  int code;
  void* data1;
  void* data2; 
 } SDL_UserEvent;


=cut
Uint8
uevent_type ( event, ... )
	SDL_UserEvent *event
	CODE: 
		if( items > 2)
		{
			event->type = SvIV(ST(1));
		}
		RETVAL = event->type;
	OUTPUT:
		RETVAL

int
uevent_code ( event, ... )
	SDL_UserEvent *event
	CODE: 
		if( items > 2 )
		{
			event->code = SvIV(ST(1));
		}
		RETVAL = event->code;
	OUTPUT:
		RETVAL

void
uevent_data1 ( event, data )
	SDL_UserEvent *event	
	IV data
	CODE:
		void * dataP = INT2PTR( void *, data);
		event->data1 = dataP;


void
uevent_data2 ( event, data )
	SDL_UserEvent *event	
	IV data
	CODE:
		void * dataP = INT2PTR( void *, data);
		event->data2 = dataP;
