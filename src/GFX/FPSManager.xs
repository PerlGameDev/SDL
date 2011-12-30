#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_GFX_FRAMERATE
#include <SDL_framerate.h>
#endif

MODULE = SDL::GFX::FPSManager 	PACKAGE = SDL::GFX::FPSManager    PREFIX = gfx_fps_

=for documentation

The Following are XS bindings to the SDL_gfx Library

typedef struct {
    Uint32 framecount;
    float rateticks;
    Uint32 lastticks;
    Uint32 rate;
    } FPSmanager;

Described here:

See: L<http:/*www.ferzkopp.net/joomla/content/view/19/14/> */

=cut

#ifdef HAVE_SDL_GFX_FRAMERATE

FPSmanager *
gfx_fps_new (CLASS, framecount, rateticks, lastticks, rate)
	char *CLASS
	Uint32 framecount
    float rateticks
    Uint32 lastticks
    Uint32 rate
	CODE:
		RETVAL = (FPSmanager *) safemalloc(sizeof(FPSmanager));
		RETVAL->framecount = framecount;
		RETVAL->rateticks  = rateticks;
		RETVAL->lastticks  = lastticks;
		RETVAL->rate       = rate;
	OUTPUT:
		RETVAL

Uint32
gfx_fps_framecount ( fps, ... )
	FPSmanager *fps
	CODE:
		if (items > 1 ) fps->framecount = SvIV(ST(1)); 
		RETVAL = fps->framecount;
	OUTPUT:
		RETVAL

float
gfx_fps_rateticks ( fps, ... )
	FPSmanager *fps
	CODE:
		if (items > 1 ) fps->rateticks = SvNV(ST(1)); 
		RETVAL = fps->rateticks;
	OUTPUT:
		RETVAL

Uint32
gfx_fps_lastticks ( fps, ... )
	FPSmanager *fps
	CODE:
		if (items > 1 ) fps->lastticks = SvIV(ST(1)); 
		RETVAL = fps->lastticks;
	OUTPUT:
		RETVAL

Uint32
gfx_fps_rate ( fps, ... )
	FPSmanager *fps
	CODE:
		if (items > 1 ) fps->rate = SvIV(ST(1)); 
		RETVAL = fps->rate;
	OUTPUT:
		RETVAL

void
gfx_fps_DESTROY(bag)
	SV *bag
	CODE:
		if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			   void** pointers = (void**)INT2PTR(void *, SvIV((SV *)SvRV( bag ))); 
			   FPSmanager * fps = (FPSmanager*)(pointers[0]);
			   if (PERL_GET_CONTEXT == pointers[1]) {
			       pointers[0] = NULL;
			       safefree(fps);
			   }
		       } else if (bag == 0) {
			   XSRETURN(0);
		       } else {
			   XSRETURN_UNDEF;
		       }

#endif
