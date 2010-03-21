#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_version.h>

MODULE = SDL::Version 	PACKAGE = SDL::Version    PREFIX = version_

=for documentation

SDL_Version -- Version structure

  typedef struct SDL_version {
          Uint8 major;
          Uint8 minor;
          Uint8 patch;
  } SDL_version;

=cut

SDL_version *
version_new( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc( sizeof( SDL_version) );
	OUTPUT:
		RETVAL
		

Uint8
version_major ( version, ... )
	SDL_version *version
	CODE:
		RETVAL = version->major;
	OUTPUT:
		RETVAL

Uint8
version_minor ( version, ... )
	SDL_version *version
	CODE:
		RETVAL = version->minor;
	OUTPUT:
		RETVAL

Uint8
version_patch ( version, ... )
	SDL_version *version
	CODE:
		RETVAL = version->patch;
	OUTPUT:
		RETVAL

void
version_DESTROY(bag)
	SV *bag
	CODE:
		if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			   void** pointers = (void**)(SvIV((SV*)SvRV( bag ))); 
			   SDL_version * version = (SDL_version*)(pointers[0]);
			   if (PERL_GET_CONTEXT == pointers[1]) {
			       pointers[0] = NULL;
			       safefree( pointers );

			       safefree(version);
			   }
		       } else if (bag == 0) {
			   XSRETURN(0);
		       } else {
			   XSRETURN_UNDEF;
		       }

