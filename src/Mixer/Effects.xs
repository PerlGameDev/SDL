#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#ifdef USE_THREADS
#define HAVE_TLS_CONTEXT
#endif

#include <SDL.h>

#ifdef HAVE_SDL_MIXER
#include <SDL_mixer.h>

#ifdef HAVE_TLS_CONTEXT
PerlInterpreter *parent_perl = NULL;
extern PerlInterpreter *parent_perl;
#define GET_TLS_CONTEXT parent_perl = PERL_GET_CONTEXT;
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

static SV *cb   = (SV*)NULL; // effect callback for register()
static SV *pmcb = (SV*)NULL; // effect callback for set_post_mix()
static SV *fcb  = (SV*)NULL; // callback when register()-effect has finished

void effect_func(int chan, void *stream, int len, void *udata)
{
	ENTER_TLS_CONTEXT
	Sint16 *buf = (Sint16 *)stream;

	len /= 2;            // 2 bytes ber sample
	
	dSP;                                       /* initialize stack pointer          */
	
	ENTER;                                     /* everything created after here     */
	SAVETMPS;                                  /* ...is a temporary variable.       */

	PUSHMARK(SP);                              /* remember the stack pointer        */
	XPUSHs(sv_2mortal(newSViv(chan)));
	XPUSHs(sv_2mortal(newSViv(len)));
	XPUSHs(sv_2mortal(newSViv(*(int*)udata))); /* push something onto the stack     */
	int i;
	for(i = 0; i < len; i++)
		XPUSHs(sv_2mortal(newSViv(buf[i])));
	
	*(int*)udata = *(int*)udata + len * 2;
	PUTBACK;                                   /* make local stack pointer global   */

	if(cb != (SV*)NULL)
	{
        int count = call_sv(cb, G_ARRAY); /* call the function                 */
		SPAGAIN;                               /* refresh stack pointer             */
		
		if(count > 0)
		{
			memset(buf, 0, len * 2); // clear the buffer
			
			for(i = len - 1; i > 0; i--)
			{
				buf[i] = POPi;
			}
		}

		PUTBACK;
	}

	FREETMPS;                                  /* free that return value            */
	LEAVE;                                     /* ...and the XPUSHed "mortal" args. */
	LEAVE_TLS_CONTEXT
}

void effect_pm_func(void *udata, Uint8 *stream, int len)
{
	ENTER_TLS_CONTEXT
	Sint16 *buf = (Sint16 *)stream;

	len /= 2;            // 2 bytes ber sample

	dSP;                                       /* initialize stack pointer          */
	
	ENTER;                                     /* everything created after here     */
	SAVETMPS;                                  /* ...is a temporary variable.       */

	PUSHMARK(SP);                              /* remember the stack pointer        */
	XPUSHs(sv_2mortal(newSViv(MIX_CHANNEL_POST)));
	XPUSHs(sv_2mortal(newSViv(len)));
	XPUSHs(sv_2mortal(newSViv(*(int*)udata))); /* push something onto the stack     */
	int i;
	for(i = 0; i < len; i++)
		XPUSHs(sv_2mortal(newSViv(buf[i])));
	
	*(int*)udata = *(int*)udata + len * 2;
	PUTBACK;                                   /* make local stack pointer global   */

	if(pmcb != (SV*)NULL)
	{
        int count = call_sv(pmcb, G_ARRAY);    /* call the function                 */
		SPAGAIN;                               /* refresh stack pointer             */
		
		if(count > 0)
		{
			memset(buf, 0, len * 2); // clear the buffer
			
			for(i = len - 1; i > 0; i--)
			{
				buf[i] = POPi;
			}
		}

		PUTBACK;
	}

	FREETMPS;                                  /* free that return value            */
	LEAVE;                                     /* ...and the XPUSHed "mortal" args. */
	LEAVE_TLS_CONTEXT
}

void effect_done(int chan, void *udata)
{
	ENTER_TLS_CONTEXT

	dSP;                                       /* initialize stack pointer          */
	PUSHMARK(SP);                              /* remember the stack pointer        */

	if(fcb != (SV*)NULL)
	{
        call_sv(fcb, G_DISCARD|G_VOID);   /* call the function                 */
	}
	
	LEAVE_TLS_CONTEXT
}

#endif

void boot_SDL__Mixer__Effects_perl();

XS(boot_SDL__Mixer__Effects)
{
	GET_TLS_CONTEXT
	boot_SDL__Mixer__Effects_perl();
}

MODULE = SDL::Mixer::Effects 	PACKAGE = SDL::Mixer::Effects    PREFIX = mixeff_
PROTOTYPES: DISABLE

#ifdef HAVE_SDL_MIXER

int
mixeff_register(channel, func, done, arg)
	int channel
	SV *func
	SV *done
	int arg
	CODE:
		if (cb == (SV*)NULL)
			cb = newSVsv(func);
		else
			SvSetSV(cb, func);

		if (fcb == (SV*)NULL)
			fcb = newSVsv(done);
		else
			SvSetSV(fcb, done);

		void *arg2   = safemalloc(sizeof(int));
		*(int*) arg2 = arg;
		RETVAL = Mix_RegisterEffect(channel, &effect_func, &effect_done, arg2);
	OUTPUT:
		RETVAL

int
mixeff_unregister( channel, func )
	int channel
	SV *func
	CODE:
		RETVAL = Mix_UnregisterEffect(channel, &effect_func);
	OUTPUT:
		RETVAL

int
mixeff_unregister_all( channel )
	int channel
	CODE:
		RETVAL = Mix_UnregisterAllEffects(channel);
	OUTPUT:
		RETVAL

int
mixeff_set_panning( channel, left, right )
	int channel
	int left
	int right
	CODE:
		RETVAL = Mix_SetPanning(channel, left, right);
	OUTPUT:
		RETVAL

int
mixeff_set_position( channel, angle, distance )
	int channel
	Sint16 angle
	Uint8 distance
	CODE:
		RETVAL = Mix_SetPosition(channel, angle, distance);
	OUTPUT:
		RETVAL

int
mixeff_set_distance( channel, distance )
	int channel
	Uint8 distance
	CODE:
		RETVAL = Mix_SetDistance(channel, distance);
	OUTPUT:
		RETVAL

int
mixeff_set_reverse_stereo( channel, flip )
	int channel
	Uint8 flip
	CODE:
		RETVAL = Mix_SetReverseStereo(channel, flip);
	OUTPUT:
		RETVAL

void
mixeff_set_post_mix(func = NULL, arg = 0)
	SV *func
	int arg
	CODE:
		if(func != (SV *)NULL)
		{
			if (pmcb == (SV *)NULL)
				pmcb = newSVsv(func);
			else
				SvSetSV(pmcb, func);

			void *arg2   = safemalloc(sizeof(int));
			*(int*) arg2 = arg;
			Mix_SetPostMix(&effect_pm_func, arg2);
		}
		else
			Mix_SetPostMix(NULL, 0);

#endif

MODULE = SDL::Mixer::Effects_perl 	PACKAGE = SDL::Mixer::Effects    PREFIX = mixeff_
PROTOTYPES: DISABLE
