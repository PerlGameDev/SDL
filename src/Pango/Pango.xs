#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <SDL.h>

#ifdef HAVE_SDL_PANGO
#include <SDL_Pango.h>
#endif

MODULE = SDL::Pango	PACKAGE = SDL::Pango	PREFIX = pango_

=for documentation

See L<http://sdlpango.sourceforge.net/>

=cut

#ifdef HAVE_SDL_PANGO

int
pango_init()
	CODE:
		RETVAL = SDLPango_Init();
	OUTPUT:
		RETVAL

int
pango_was_init()
	CODE:
		RETVAL = SDLPango_WasInit();
	OUTPUT:
		RETVAL

#endif
