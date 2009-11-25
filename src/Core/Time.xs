#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#ifdef USE_THREADS
#define HAVE_TLS_CONTEXT
#endif

/* For windows  */
#ifndef SDL_PERL_DEFINES_H
#define SDL_PERL_DEFINES_H

#ifdef HAVE_TLS_CONTEXT
PerlInterpreter *parent_perl = NULL;
extern PerlInterpreter *parent_perl;
#define GET_TLS_CONTEXT parent_perl =  PERL_GET_CONTEXT;
#define ENTER_TLS_CONTEXT \
        PerlInterpreter *current_perl = PERL_GET_CONTEXT; \
            PERL_SET_CONTEXT(parent_perl); { \
                                PerlInterpreter *my_perl = parent_perl;
#define LEAVE_TLS_CONTEXT \
                                        } PERL_SET_CONTEXT(current_perl);
#else
#define GET_TLS_CONTEXT         /* TLS context not enabled */
#define ENTER_TLS_CONTEXT       /* TLS context not enabled */
#define LEAVE_TLS_CONTEXT       /* TLS context not enabled */
#endif

#endif


#include <SDL.h>

SV* cb; 

STATIC void perl_call ( pTHX_ Uint32 interval, void* param)
{
		
	dSP;
	PUSHMARK(SP);
	call_sv( (SV*)cb, G_DISCARD);     
	
}

Uint32 add_timer_cb (Uint32 interval, void* param )
{
//	ENTER_TLS_CONTEXT
	dTHX;
		perl_call(aTHX_ interval, param);

//	LEAVE_TLS_CONTEXT

     	return interval; 
}

MODULE = SDL::Time 	PACKAGE = SDL::Time    PREFIX = time_

SDL_TimerID
time_add_timer ( interval, cmd )
	Uint32 interval
	SV *cmd
	CODE:

	 cb = newSVsv(cmd);

		RETVAL = SDL_AddTimer(interval,add_timer_cb,(void *)cmd);
		fprintf( stderr, "Timer %d  \n Return = %x \n error = %s \n ", interval, (int)RETVAL, SDL_GetError() );

	OUTPUT:
		RETVAL


