#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_GFX_BLITFUNC
#include <SDL_gfxBlitFunc.h>
#endif

MODULE = SDL::GFX::BlitFunc 	PACKAGE = SDL::GFX::BlitFunc    PREFIX = gfx_blit_

=for documentation

The Following are XS bindings to the SDL_gfx Library

Described here:

See: L<http:/*www.ferzkopp.net/joomla/content/view/19/14/> */

=cut

#ifdef HAVE_SDL_GFX_BLITFUNC

#endif
