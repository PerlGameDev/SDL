#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_thread.h>

MODULE = SDL::MultiThread 	PACKAGE = SDL::MultiThread    PREFIX = multi_

=for documentation

The Following are XS bindings to the MultiThread category in the SDL API v2.1.13

Describe on the SDL API site.

See: L<http:/*www.libsdl.org/cgi/docwiki.cgi/SDL_API> */

=cut

Uint32
multi_threadID()
	CODE:
		warn(" ... " );
