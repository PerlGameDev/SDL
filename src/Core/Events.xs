#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_events.h>

/* Static Memory for event filter call back */
static SV * eventfiltersv;


int eventfilter_cb( const void * event)
{

	dSP;
	int count;
	int filter_signal;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	
	XPUSHs( sv_setref_pv(' ', 'SDL::Event', event) );

	PUTBACK;
	
	filter_signal = call_sv(eventfiltersv, G_SCALAR);

	SPAGAIN;

	if (count != 1 ) croak("callback returned more than 1 value\n");
	
	filter_signal = POPi;

	FREETMPS;
	LEAVE;

	return filter_signal;
}
	




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
		if(action != (action & (SDL_ADDEVENT | SDL_PEEKEVENT | SDL_GETEVENT)))
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
		RETVAL = -1;
		if (  event != NULL )
		RETVAL = SDL_PollEvent(event);
	OUTPUT:
		RETVAL

int
events_push_event(event)
	SDL_Event *event
	CODE:
		RETVAL = -1;
		if ( &event != NULL )
		RETVAL = SDL_PushEvent(event);
	OUTPUT:
		RETVAL

int
events_wait_event(event = NULL)
	SDL_Event *event
	CODE:
		RETVAL = SDL_WaitEvent(event);
	OUTPUT:
		RETVAL

void
events_set_event_filter(callback)
	SV* callback
	CODE:
	eventfiltersv = callback;
	SDL_SetEventFilter( (SDL_EventFilter*)eventfilter_cb);
