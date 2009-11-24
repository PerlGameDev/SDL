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
 Uint32 retval;
 int back;
 void* data;
 SV* callback;
 } my_cxt_t;

START_MY_CXT

my_cxt_t gcxt; 

Uint32 set_timer_cb( Uint32 interval)
{
	ENTER_TLS_CONTEXT
	dSP;
	int back;
 	SV* cmd = (SV*)(gcxt.callback) ;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(interval)));
	PUTBACK;

	if (0 != (back = call_sv(cmd,G_SCALAR))) {
		SPAGAIN;
		if (back != 1 ) Perl_croak (aTHX_ "Timer Callback failed!");
		gcxt.retval = POPi;	
	} else {
		Perl_croak(aTHX_ "Timer Callback failed!");
	}

	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT
	
	return gcxt.retval;

}


Uint32 
add_timer_cb ( Uint32 interval, void* param )
{
	Uint32 retval;
	int back;
	SV* cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)param;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(interval)));
	PUTBACK;

	if (0 != (back = call_sv(cmd,G_SCALAR))) {
		SPAGAIN;
		if (back != 1 ) Perl_croak (aTHX_ "Timer Callback failed!");
		retval = POPi;	
	} else {
		Perl_croak(aTHX_ "Timer Callback failed!");
	}

	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT
	
	return retval;
}


MODULE = SDL::Time 	PACKAGE = SDL::Time    PREFIX = time_

BOOT:
{
  MY_CXT_INIT;
}


void
time_delay ( ms )
	int ms
	CODE:
		SDL_Delay(ms);

Uint32
time_get_ticks ()
	CODE:
		RETVAL = SDL_GetTicks();
	OUTPUT:
		RETVAL

int
time_set_timer ( interval, callback )
	Uint32 interval
	SV* callback
	PREINIT:
		dMY_CXT;
	CODE:
		MY_CXT.callback = callback;
 		gcxt = MY_CXT;
		RETVAL = SDL_SetTimer(interval, set_timer_cb);
		
	OUTPUT:
		RETVAL

SDL_TimerID
time_add_timer ( interval, cmd )
	Uint32 interval
	void *cmd
	CODE:
		RETVAL = SDL_AddTimer(interval,add_timer_cb,cmd);
	OUTPUT:
		RETVAL

void
CLONE(...)
	CODE:
		MY_CXT_CLONE;




