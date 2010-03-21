#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Overlay 	PACKAGE = SDL::Overlay    PREFIX = overlay_

=for documentation

SDL_Overlay -- YUV video overlay

typedef struct{
  Uint32 format;
  int w, h;
  int planes;
  Uint16 *pitches;
  Uint8 **pixels;
  Uint32 hw_overlay:1;
} SDL_Overlay;


=cut

SDL_Overlay *
overlay_new(CLASS, width, height, format, display)
	char* CLASS
	int width
	int height
	Uint32 format
	SDL_Surface *display;
	CODE:
		RETVAL = SDL_CreateYUVOverlay(width, height, format, display);
	OUTPUT:
		RETVAL

int
overlay_w( overlay )
	SDL_Overlay* overlay
	CODE:
		RETVAL = overlay->w;
	OUTPUT:
		RETVAL

int
overlay_h( overlay )
	SDL_Overlay* overlay
	CODE:
		RETVAL = overlay->h;
	OUTPUT:
		RETVAL

int
overlay_planes( overlay )
	SDL_Overlay* overlay
	CODE:
		RETVAL = overlay->planes;
	OUTPUT:
		RETVAL

Uint32 
overlay_hwoverlay( overlay )
	SDL_Overlay* overlay
	CODE:
		RETVAL = overlay->hw_overlay;		
	OUTPUT:
		RETVAL

Uint32
overlay_format( overlay )
	SDL_Overlay* overlay
	CODE:
		RETVAL = overlay->format;		
	OUTPUT:
		RETVAL


void
overlay_DESTROY(bag)
	SV *bag
	CODE:
		if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			   void** pointers = (void**)(SvIV((SV*)SvRV( bag ))); 
			   SDL_Overlay * overlay = (SDL_Overlay*)(pointers[0]);
			   if (PERL_GET_CONTEXT == pointers[1]) {
			       pointers[0] = NULL;
			       safefree( pointers );

			       SDL_FreeYUVOverlay(overlay);
			   }
		       } else if (bag == 0) {
			   XSRETURN(0);
		       } else {
			   XSRETURN_UNDEF;
		       }


