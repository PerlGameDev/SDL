#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_events.h>

PerlInterpreter * perl_for_cb=NULL;
/* Static Memory for event filter call back */
static SV * eventfiltersv;

int eventfilter_cb( const void * event)
{
	

	dSP;
	int count;
	int filter_signal;
	SV * eventref = newSV( sizeof(SDL_Event *) );
	void * copyEvent = safemalloc( sizeof(SDL_Event) );
	memcpy( copyEvent, event, sizeof(SDL_Event) );
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
			 void** pointers = malloc(2 * sizeof(void*));
		  pointers[0] = (void*)copyEvent;
		  pointers[1] = (void*)perl_for_cb;

	XPUSHs( sv_setref_pv( eventref, "SDL::Event", (void *)pointers) );
	PUTBACK;

//	printf ( "Eventref is %p. Event is %p. CopyEvent is %p \n", eventref, event, copyEvent);
	
	count = call_sv(eventfiltersv, G_SCALAR);

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
		RETVAL = SDL_PollEvent(event);
	OUTPUT:
		RETVAL

int
events_push_event(event)
	SDL_Event *event
	CODE:
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
	perl_for_cb = PERL_GET_CONTEXT;
	
	SDL_SetEventFilter((SDL_EventFilter) eventfilter_cb);


AV *
events_get_key_state()
	PREINIT:
	int value;
	CODE:
		Uint8* KeyArray = SDL_GetKeyState(&value);
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		int i;
		for( i = 0; i <value; i++)
		{
			SV* scalar = newSViv( KeyArray[i]  );
			av_push( RETVAL, scalar);
		
		}
	OUTPUT:
		RETVAL
	 
int
events_get_mod_state()
	CODE:
		RETVAL = (int)SDL_GetModState();
	OUTPUT:
		RETVAL

void
events_set_mod_state(mod)
	SDLMod mod
	CODE:
		SDL_SetModState(mod); 

Uint8 
events_event_state(type, state)
	Uint8 type
	int state
	CODE:
		RETVAL=SDL_EventState(type, state);
	OUTPUT:
		RETVAL 

char *
events_get_key_name(key)
	SDLKey key
	CODE:
		RETVAL = SDL_GetKeyName(key);
	OUTPUT:
		RETVAL

int
events_enable_unicode ( enable )
	int enable
	CODE:
		RETVAL = SDL_EnableUNICODE(enable);
	OUTPUT:
		RETVAL

int
events_enable_key_repeat ( delay, interval )
	int delay
	int interval
	CODE:
		RETVAL = SDL_EnableKeyRepeat(delay,interval);
	OUTPUT:
		RETVAL


AV*
events_get_mouse_state ()
	CODE:
		Uint8 mask;
		int x;
		int y;
		mask = SDL_GetMouseState(&x,&y);
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		av_push(RETVAL,newSViv(mask));
		av_push(RETVAL,newSViv(x));
		av_push(RETVAL,newSViv(y));
	OUTPUT:
		RETVAL	

AV*
events_get_relative_mouse_state ()
	CODE:
		Uint8 mask;
		int x;
		int y;
		mask = SDL_GetRelativeMouseState(&x,&y);
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		av_push(RETVAL,newSViv(mask));
		av_push(RETVAL,newSViv(x));
		av_push(RETVAL,newSViv(y));
	OUTPUT:
		RETVAL	

Uint8
events_get_app_state ()
	CODE:
		RETVAL = SDL_GetAppState();
	OUTPUT:
		RETVAL

int
events_joystick_event_state (state)
	int state;
	CODE:
		RETVAL = SDL_JoystickEventState(state);
	OUTPUT:
		RETVAL


