#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "defines.h"

#include <SDL.h>

Uint32 add_timer_cb (Uint32 interval, void* param )
{
	Uint32 ret_interval;
	ENTER_TLS_CONTEXT;
	dSP;

	int count;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(interval)));
	PUTBACK;

	count = call_pv(param,G_SCALAR);

	SPAGAIN;

	if (count != 1 ) croak("callback returned more than 1 value\n");	
		ret_interval = POPi;

	PUTBACK;
	FREETMPS;
	LEAVE;
	LEAVE_TLS_CONTEXT;

	return ret_interval;
}

MODULE = SDL::Time 	PACKAGE = SDL::Time    PREFIX = time_

SDL_TimerID
time_add_timer ( interval, cmd )
	Uint32 interval
	char *cmd
	CODE:
		GET_TLS_CONTEXT;
		RETVAL = SDL_AddTimer(interval, add_timer_cb, (void *)cmd);
	OUTPUT:
		RETVAL

int
time_remove_timer ( id)
	SDL_TimerID id
	CODE:
		RETVAL = SDL_RemoveTimer((SDL_TimerID) id);
	OUTPUT:
		RETVAL

