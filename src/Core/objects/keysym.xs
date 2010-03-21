#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::keysym 	PACKAGE = SDL::keysym    PREFIX = keysym_

=for documentation

SDL_keysym -- keysym structure

 typedef struct{
  Uint8 scancode;
  SDLKey sym;
  SDLMod mod;
  Uint16 unicode;
 } SDL_keysym;


=cut

SDL_keysym *
keysym_new ( CLASS )
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_keysym));
	OUTPUT:
		RETVAL

Uint8
keysym_scancode ( keysym, ... )
	SDL_keysym *keysym
	CODE: 
		if( items > 1 )
		{
			keysym->scancode = SvIV( ST(1) );
		}

		RETVAL = keysym->scancode;
	OUTPUT:
		RETVAL

SDLKey *
keysym_sym ( keysym, ... )
	SDL_keysym *keysym
	PREINIT:
		char* CLASS = "SDL::Key";
	CODE: 
		if( items > 1 )
		{
			SDLKey *kp  = (SDLKey * )SvPV( ST(1), PL_na) ;
			keysym->sym = *kp;
		}

		RETVAL = &(keysym->sym);
	OUTPUT:
		RETVAL

SDLMod *
keysym_mod ( keysym, ... )
	SDL_keysym *keysym
	PREINIT:
		char* CLASS = "SDL::Mod";
	CODE: 
		if( items > 1 )
		{
			SDLMod *mp  = (SDLMod * )SvPV( ST(1), PL_na) ;
			keysym->mod = *mp;
		}

		RETVAL = &(keysym->mod);
	OUTPUT:
		RETVAL

Uint16
keysym_unicode ( keysym, ... )
	SDL_keysym *keysym
	CODE: 
		if( items > 1 )
		{
			keysym->unicode = SvIV( ST(1) );
		}

		RETVAL = keysym->unicode;
	OUTPUT:
		RETVAL

void
keysym_DESTROY(bag)
	SV *bag
	CODE:
		if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			   void** pointers = (void**)(SvIV((SV*)SvRV( bag ))); 
			   SDL_keysym * keysym = (SDL_keysym*)(pointers[0]);
			   if (PERL_GET_CONTEXT == pointers[1]) {
			       pointers[0] = NULL;
			       safefree( pointers );

			       safefree(keysym);
			   }
		       } else if (bag == 0) {
			   XSRETURN(0);
		       } else {
			   XSRETURN_UNDEF;
		       }



