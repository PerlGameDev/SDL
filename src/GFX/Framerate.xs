#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_framerate.h>

MODULE = SDL::GFX::Framerate 	PACKAGE = SDL::GFX::Framerate    PREFIX = gfx_frame_

=for documentation

The Following are XS bindings to the SDL_gfx Library

Described here:

See: L<http://www.ferzkopp.net/joomla/content/view/19/14/>

=cut

#ifdef HAVE_SDL_GFX

#endif