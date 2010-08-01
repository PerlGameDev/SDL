#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include "SDLx/Timer.h"

MODULE = SDLx::Controller::Timer 	PACKAGE = SDLx::Controller::Timer    PREFIX = timerx_

sdlx_timer *
timerx_new (CLASS, ... )
	char* CLASS
	CODE:
		RETVAL = (sdlx_timer *)safemalloc( sizeof(sdlx_timer) );
		RETVAL->started_ticks = 0;
		RETVAL->paused_ticks  = 0;
		RETVAL->started       = 0;
		RETVAL->paused        = 0;
	OUTPUT:
		RETVAL


int
timerx_started_ticks ( timer, ... )
	sdlx_timer *timer
	CODE:
		if (items > 1 ) timer->started_ticks = SvIV(ST(1)); 
		RETVAL = timer->started_ticks;
	OUTPUT:
		RETVAL

int
timerx_paused_ticks ( timer, ... )
	sdlx_timer *timer
	CODE:
		if (items > 1 ) timer->paused_ticks = SvIV(ST(1)); 
		RETVAL = timer->paused_ticks;
	OUTPUT:
		RETVAL

int
timerx_started ( timer, ... )
	sdlx_timer *timer
	CODE:
		if (items > 1 ) timer->started = SvIV(ST(1)); 
		RETVAL = timer->started;
	OUTPUT:
		RETVAL

int
timerx_paused ( timer, ... )
	sdlx_timer *timer
	CODE:
		if (items > 1 ) timer->paused = SvIV(ST(1)); 
		RETVAL = timer->paused;
	OUTPUT:
		RETVAL

void
timerx_start ( timer )
	sdlx_timer *timer
	CODE:
		timer->started = 1;
		timer->started_ticks = SDL_GetTicks();

void
timerx_stop ( timer )
	sdlx_timer *timer
	CODE:
		timer->started = 0;
		timer->paused = 0;

void
timerx_pause ( timer )
	sdlx_timer *timer
	CODE:
		if( timer->started == 1 && timer->paused == 0)
		{
			timer->paused = 1;
			timer->paused_ticks = SDL_GetTicks() - timer->started_ticks;
		}

void
timerx_unpause ( timer )
	sdlx_timer *timer
	CODE:
		timer->paused = 0;
		timer->started_ticks = SDL_GetTicks() - timer->started_ticks;
		timer->paused_ticks = 0;

int
timerx_get_ticks ( timer )
	sdlx_timer *timer
	CODE:
		if(timer->started == 1)
		{
		   if(timer->paused == 1)
		   {
			RETVAL = timer->paused_ticks;
		   }
		   else
		   {
			int update = SDL_GetTicks();
			int diff = update - timer->started_ticks;
			timer->started_ticks = update;
			RETVAL = diff;
		   }
		}
		else
		{
			RETVAL = 0;
		}
	OUTPUT:
		RETVAL


int
timerx_is_started ( timer )
	sdlx_timer *timer
	CODE:
		RETVAL = timer->started;
	OUTPUT:
		RETVAL

int
timerx_is_paused ( timer)
	sdlx_timer *timer
	CODE:
		RETVAL = timer->paused;
	OUTPUT:
		RETVAL


void
timerx_DESTROY(bag)
	SV *bag
	CODE:
		if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			   void** pointers = (void**)(SvIV((SV*)SvRV( bag ))); 
			   sdlx_timer * timer = (sdlx_timer*)(pointers[0]);
			   if (PERL_GET_CONTEXT == pointers[1]) {
			       pointers[0] = NULL;
			       safefree( pointers );

			       safefree(timer);
			   }
		       } else if (bag == 0) {
			   XSRETURN(0);
		       } else {
			   XSRETURN_UNDEF;
		       }
	
