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

SDL_UserEvent *
uevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_UserEvent));
		RETVAL->type = SDL_USEREVENT;
	OUTPUT:
		RETVAL

Uint8
uevent_type ( event )
	SDL_UserEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL

int
uevent_code ( event, ... )
	SDL_UserEvent *event
	CODE: 
		if( items > 1 )
		{
			event->code = SvIV( ST(1) );

		}
		RETVAL = (int)event->code;
	OUTPUT:
		RETVAL

SV*
uevent_data1 ( event, ... )
	SDL_UserEvent *event	
	CODE: 
		if( items > 1 )
		{
			event->data1 = (void *)SvIV(ST(1));
		}
		RETVAL = event->data1;
	OUTPUT:
		RETVAL


SV*
uevent_data2 ( event, ... ) 
	SDL_UserEvent *event	
	CODE: 
		if( items > 1 )
		{
			event->data1 = (void *) ST(1);
		}
		RETVAL = event->data1;
	OUTPUT:
		RETVAL


void
uevent_DESTROY(self)
	SDL_UserEvent *self
	CODE:
		safefree( (char *)self );
