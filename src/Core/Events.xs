#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_events.h>

MODULE = SDL::Events 	PACKAGE = SDL::Events    PREFIX = events_

=for documentation

The Following are XS bindings to the Event category in the SDL API v2.1.13

Describe on the SDL API site.

See: L<http://www.libsdl.org/cgi/docwiki.cgi/SDL_API#head-29746762ba51fc3fe8b888f8d314b13de27610e9>

=cut

void
events_pump_events()
	CODE:
		SDL_PumpEvents();

int
events_peep_events( events, numevents, action, mask )
	SDL_Event *events
	int numevents
	int action
	Uint32 mask
	CODE:
		if(!(action & (SDL_ADDEVENT | SDL_PEEKEVENT | SDL_GETEVENT)))
		{
			croak("Value of 'action' should be SDL_ADDEVENT, SDL_PEEKEVENT or SDL_GETEVENT.");
		}
		RETVAL = SDL_PeepEvents(events,numevents,action,mask);
	OUTPUT:
		RETVAL

int
events_poll_event( event )
	SDL_Event *event
	CODE:
		RETVAL = SDL_PollEvent(event);
	OUTPUT:
		RETVAL
