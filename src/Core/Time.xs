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

#define MY_CXT_KEY "SDL::Time::_guts" XS_VERSION 


 typedef struct {
 void* data;
 SV* callback;
 Uint32 retval;
 } my_cxt_t;

static my_cxt_t gcxt;

START_MY_CXT 


static Uint32 add_timer_cb ( Uint32 interval, void* param )
{
	    
	    ENTER_TLS_CONTEXT
	    dMY_CXT;
	    dSP;
	    int back;
	    fprintf ( stderr, "Timer %d ansd %p \n", interval, MY_CXT.callback );
	    ENTER;
	    SAVETMPS;
	    PUSHMARK(SP);
	    XPUSHs(sv_2mortal(newSViv(interval)));
	    PUTBACK;
	    
	    if (0 != (back = call_sv(MY_CXT.callback,G_SCALAR))) {
		SPAGAIN;
		if (back != 1 ) Perl_croak (aTHX_ "Timer Callback failed!");
		MY_CXT.retval = POPi;     
	    } else {
		Perl_croak(aTHX_ "Timer Callback failed!");
	    }
		
	    FREETMPS;
	    LEAVE;
		
	    LEAVE_TLS_CONTEXT
	    dMY_CXT;
	    return MY_CXT.retval;

}

MODULE = SDL::Time 	PACKAGE = SDL::Time    PREFIX = time_

BOOT:
{
  MY_CXT_INIT;
}


SDL_TimerID
time_add_timer ( interval, cmd )
	Uint32 interval
	void *cmd
	PREINIT:
		dMY_CXT;
	CODE:
		MY_CXT.callback=cmd;	
		gcxt = MY_CXT;
		RETVAL = SDL_AddTimer(interval,add_timer_cb,(void *)cmd);
		fprintf( stderr, "Timer %d  \n Return = %x \n error = %s \n ", interval, (int)RETVAL, SDL_GetError() );

	OUTPUT:
		RETVAL

void
CLONE(...)
  CODE:
    MY_CXT_CLONE;  
