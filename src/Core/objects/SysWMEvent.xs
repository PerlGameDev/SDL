#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::SysWMEvent 	PACKAGE = SDL::SysWMEvent    PREFIX = wmevent_

=for documentation

SDL_SysWMEvent -- Platform-dependent window manager event

 typedef struct{
  Uint8 type; /* Always SDL_SYSWMEVEBT */
  SDL_SysWMmsg *msg;
 } SDL_SysWMEvent;

see also: L<SDL::WindowManagement::sys_WM_event>

=cut

SDL_SysWMEvent *
wmevent_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_SysWMEvent));
		RETVAL->type = SDL_SYSWMEVENT;
	OUTPUT:
		RETVAL

Uint8
wmevent_type ( event, ... )
	SDL_SysWMEvent *event
	CODE: 
		RETVAL = event->type;
	OUTPUT:
		RETVAL

SDL_SysWMmsg *
wmevent_msg ( event, ... )
	SDL_SysWMEvent *event
	PREINIT:
		char* CLASS = "SDL::SysWMmsg";
	CODE: 
		if( items > 1 )
		{
			SDL_SysWMmsg * sysm = (SDL_SysWMmsg * )SvPV( ST(1), PL_na) ;
			event->msg = sysm;

		}

		RETVAL = event->msg;
	OUTPUT:
		RETVAL

void
wmevent_DESTROY ( event)
	SDL_SysWMEvent *event
	CODE:
		safefree( (char *) event);

