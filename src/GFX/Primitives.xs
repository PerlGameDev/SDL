#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_gfxPrimitives.h>

MODULE = SDL::GFX::Primitives 	PACKAGE = SDL::GFX::Primitives    PREFIX = gfx_prim_

=for documentation

The Following are XS bindings to the SDL_gfx Library

Described here:

See: L<http://www.ferzkopp.net/joomla/content/view/19/14/>

=cut

int
gfx_prim_pixel_color(dst, x, y, color)
	SDL_Surface *dst
	Sint16 x
	Sint16 y
	Uint32 color
	CODE:
		RETVAL = pixelColor(dst, x, y, color);
	OUTPUT:
		RETVAL


