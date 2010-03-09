#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <SDL.h>

#ifdef HAVE_SDL_MIXER
#include <SDL_mixer.h>

PerlInterpreter *perl    = NULL;
PerlInterpreter *perl_cb = NULL;
int registered_effects   = 0;

char* effect_func_cb = NULL;

void effect_func(int chan, void *stream, int len, void *udata)
{
	PERL_SET_CONTEXT(perl_cb);
	Sint16 *buf = (Sint16 *)stream;

	len /= 2;            // 2 bytes ber sample
	
	dSP;                                       /* initialize stack pointer          */
	
	ENTER;                                     /* everything created after here     */
	SAVETMPS;                                  /* ...is a temporary variable.       */

	PUSHMARK(SP);                              /* remember the stack pointer        */
	XPUSHs(sv_2mortal(newSViv(chan)));
	XPUSHs(sv_2mortal(newSViv(len)));
	XPUSHs(sv_2mortal(newSVsv(udata))); /* push something onto the stack     */
	int i;
	for(i = 0; i < len; i++)
		XPUSHs(sv_2mortal(newSViv(buf[i])));
	
	PUTBACK;                                   /* make local stack pointer global   */

	//if(cb != (SV*)NULL)
	{
        int count = call_pv(effect_func_cb, G_ARRAY); /* call the function                 */
		SPAGAIN;                               /* refresh stack pointer             */
		
		if(count == len + 1)
			*(SV *)udata = *sv_2mortal(newSVsv(POPs));
		
		if(count)
		{
			memset(buf, 0, len * 2); // clear the buffer
			
			for(i = len - 1; i >= 0; i--)
			{
				buf[i] = POPi;
			}
		}

		PUTBACK;
	}

	FREETMPS;                                  /* free that return value            */
	LEAVE;                                     /* ...and the XPUSHed "mortal" args. */
}

void effect_pm_func(void *udata, Uint8 *stream, int len)
{
	effect_func(-2, (void *)stream, len, udata);
}

void effect_done(int chan, void *udata)
{
	PERL_SET_CONTEXT(perl_cb);

	dSP;                                       /* initialize stack pointer          */
	PUSHMARK(SP);                              /* remember the stack pointer        */

	//if(fcb != (SV*)NULL)
	{
        call_pv("main::effect_done", G_DISCARD|G_VOID);   /* call the function                 */
	}
}

#endif

MODULE = SDL::Mixer::Effects 	PACKAGE = SDL::Mixer::Effects    PREFIX = mixeff_

#ifdef HAVE_SDL_MIXER

int
mixeff_register(channel, func, done, arg)
	int channel
	char *func
	SV *done
	SV *arg
	CODE:
		if(perl_cb == NULL)
		{
			perl    = PERL_GET_CONTEXT;
			perl_cb = perl_clone(perl, CLONEf_KEEP_PTR_TABLE);
			PERL_SET_CONTEXT(perl);
		}

		effect_func_cb = func;
		
		if(0 != Mix_RegisterEffect(channel, &effect_func, &effect_done, arg))
			RETVAL = ++registered_effects;
		else
			RETVAL = 0;
		
	OUTPUT:
		RETVAL

int
mixeff_unregister( channel, func )
	int channel
	SV *func
	CODE:
		if(perl_cb == NULL)
		{
			perl    = PERL_GET_CONTEXT;
			perl_cb = perl_clone(perl, CLONEf_KEEP_PTR_TABLE);
			PERL_SET_CONTEXT(perl);
		}
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
mixeff_set_post_mix(func = NULL, arg = NULL)
	SV *func
	SV *arg
	CODE:
		if(perl_cb == NULL)
		{
			perl    = PERL_GET_CONTEXT;
			perl_cb = perl_clone(perl, CLONEf_KEEP_PTR_TABLE);
			PERL_SET_CONTEXT(perl);
		}

		if(func != (SV *)NULL)
		{
			Mix_SetPostMix(&effect_pm_func, arg);
		}
		else
			Mix_SetPostMix(NULL, NULL);

#endif
