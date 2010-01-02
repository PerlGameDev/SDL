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

static SV* cb; 

static PerlInterpreter * orig_perl=NULL;
static PerlInterpreter * perl_for_cb=NULL;



Uint32 add_timer_cb (Uint32 interval, void* param )
{

	PERL_SET_CONTEXT(orig_perl);
	perl_for_cb = perl_clone(orig_perl, CLONEf_KEEP_PTR_TABLE);
	PERL_SET_CONTEXT(perl_for_cb); 
	
	dSP;
	int count;
	Uint32 ret_interval;
        /*  char* string = (char*)stream;

	SV* sv = newSVpv("a",1);
        SvCUR_set(sv,len * sizeof(Uint8));
	SvLEN_set(sv,len * sizeof(Uint8));
        void* old = SvPVX(sv);
        SvPV_set(sv,string);
	*/

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
 
	XPUSHs(sv_2mortal(newSViv(interval)));
	XPUSHs(sv_2mortal(newSViv( *((int *)param)) ));
 
	PUTBACK;
 	count = call_sv(cb,G_SCALAR);

	if (count != 1 ) croak("callback returned more than 1 value\n");	

	ret_interval = POPi;

	FREETMPS;
	LEAVE;
	
	PERL_SET_CONTEXT(orig_perl); 
	perl_free(perl_for_cb);
	return ret_interval;

}



MODULE = SDL::Time 	PACKAGE = SDL::Time    PREFIX = time_

SDL_TimerID
time_add_timer ( interval, cmd )
	Uint32 interval
	SV *cmd
	CODE:
	  orig_perl = PERL_GET_CONTEXT;
 	  cb = newSVsv(cmd);

		RETVAL = SDL_AddTimer(interval,add_timer_cb,(void *)cmd);
		//fprintf( stderr, "Timer %d  \n Return = %x \n error = %s \n ", interval, (int)RETVAL, SDL_GetError() );

	OUTPUT:
		RETVAL


int
time_remove_timer ( id)
	int id
	CODE:
		RETVAL = SDL_RemoveTimer((SDL_TimerID) id);
	OUTPUT:
		RETVAL

