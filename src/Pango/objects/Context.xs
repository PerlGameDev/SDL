#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <SDL.h>

#ifdef HAVE_SDL_PANGO
#include <SDL_Pango.h>
#endif

MODULE = SDL::Pango::Context	PACKAGE = SDL::Pango::Context	PREFIX = context_

=for documentation

See L<http://sdlpango.sourceforge.net/>

=cut

#ifdef HAVE_SDL_PANGO

SDLPango_Context *
context_new(CLASS, ...)
	char* CLASS
	CODE:
		if(items > 1)
			RETVAL = SDLPango_CreateContext_GivenFontDesc((char *)SvPV(ST(1), PL_na));
		else
			RETVAL = SDLPango_CreateContext();
	OUTPUT:
		RETVAL

void
context_DESTROY(context)
	SDLPango_Context *context
	CODE:
		SDLPango_FreeContext(context);

#endif
