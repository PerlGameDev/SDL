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
	
