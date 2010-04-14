#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <SDL.h>
#ifdef HAVE_SDL_GFX_PRIMITIVES
#include <SDL_gfxPrimitives.h>
#endif
	SDL_version *linked_version = NULL; 


#ifndef SDL_GFXPRIMITIVES_MAJOR
#define SDL_GFXPRIMITIVES_MAJOR 0
#endif

#ifndef SDL_GFXPRIMITIVES_MINOR
#define SDL_GFXPRIMITIVES_MINOR 0
#endif

#ifndef SDL_GFXPRIMITIVES_MICRO
#define SDL_GFXPRIMITIVES_MICRO 0
#endif

#ifndef SDL_GFXPRIMITIVES_VERSION
#define SDL_GFXPRIMITIVES_VERSION(X)      \
{                                         \
	(X)->major = SDL_GFXPRIMITIVES_MAJOR; \
	(X)->minor = SDL_GFXPRIMITIVES_MINOR; \
	(X)->patch = SDL_GFXPRIMITIVES_MICRO; \
}
#endif

MODULE = SDL::GFX 	PACKAGE = SDL::GFX    PREFIX = gfx_

=for documentation

The Following are XS bindings to the SDL_gfx Library

Described here:

See: L<http://www.ferzkopp.net/joomla/content/view/19/14/>

=cut

const SDL_version *
gfx_linked_version()
	PREINIT:
		char* CLASS = "SDL::Version";
	CODE:
		if(linked_version == NULL)
		{
			linked_version = safemalloc(sizeof(SDL_version));
		}
		SDL_GFXPRIMITIVES_VERSION(linked_version);
		
		RETVAL = linked_version;
	OUTPUT:
		RETVAL


