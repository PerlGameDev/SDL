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
context_new(CLASS)
	char* CLASS
	CODE:
		RETVAL = SDLPango_CreateContext();
	OUTPUT:
		RETVAL

void
context_DESTROY(bag)
	SV *bag
	CODE:
		if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			   void** pointers = (void**)(SvIV((SV*)SvRV( bag ))); 
			   SDLPango_Context * context = (SDLPango_Context*)(pointers[0]);
			   if (PERL_GET_CONTEXT == pointers[1]) {
			       pointers[0] = NULL;
			       safefree( pointers );

			       SDLPango_FreeContext(context);
			   }
		       } else if (bag == 0) {
			   XSRETURN(0);
		       } else {
			   XSRETURN_UNDEF;
		       }

#endif
