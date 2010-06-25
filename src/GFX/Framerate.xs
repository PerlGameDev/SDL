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

MODULE = SDL::GFX::Framerate 	PACKAGE = SDL::GFX::Framerate    PREFIX = gfx_frame_

=for documentation

The Following are XS bindings to the SDL_gfx Library

Described here:

See: L<http:/*www.ferzkopp.net/joomla/content/view/19/14/> */

=cut

#ifdef HAVE_SDL_GFX_FRAMERATE

void
gfx_frame_init(manager)
	FPSmanager * manager
	CODE:
		SDL_initFramerate(manager);

int
gfx_frame_set(manager, rate)
	FPSmanager * manager
	int rate
	CODE:
		RETVAL = SDL_setFramerate(manager, rate);
	OUTPUT:
		RETVAL

int
gfx_frame_get(manager)
	FPSmanager * manager
	CODE:
		RETVAL = SDL_getFramerate(manager);
	OUTPUT:
		RETVAL

void
gfx_frame_delay(manager)
	FPSmanager * manager
	CODE:
		SDL_framerateDelay(manager);

#endif
