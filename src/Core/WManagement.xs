#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL/SDL_syswm.h>

MODULE = SDL::WManagement 	PACKAGE = SDL::WManagement    PREFIX = wmanage_

=for documentation

The Following are XS bindings to the Window Management category in the SDL API v2.1.13

Described on the SDL API site.


=cut


