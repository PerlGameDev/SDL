#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::PixelFormat 	PACKAGE = SDL::PixelFormat    PREFIX = pixelformat_

=for documentation

SDL_PixelFormat -- Stores surface format information

  typedef struct SDL_PixelFormat {
    SDL_Palette *palette;
    Uint8  BitsPerPixel;
    Uint8  BytesPerPixel;
    Uint8  Rloss, Gloss, Bloss, Aloss;
    Uint8  Rshift, Gshift, Bshift, Ashift;
    Uint32 Rmask, Gmask, Bmask, Amask;
    Uint32 colorkey;
    Uint8  alpha;
  } SDL_PixelFormat;

=cut

SV *
pixelformat_palette( pixelformat )
	SDL_PixelFormat *pixelformat
	PREINIT:
		char* CLASS = "SDL::Palette";
	CODE:
		if(pixelformat->palette)
			RETVAL = cpy2bag( pixelformat->palette, sizeof(SDL_Palette *), sizeof(SDL_Palette), "SDL::Palette" );
		else
			XSRETURN_UNDEF;
	OUTPUT:
		RETVAL


Uint8
pixelformat_BitsPerPixel( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->BitsPerPixel;
	OUTPUT:
		RETVAL

Uint8
pixelformat_BytesPerPixel( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->BytesPerPixel;
	OUTPUT:
		RETVAL

Uint8
pixelformat_Rloss( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Rloss;
	OUTPUT:
		RETVAL

Uint8
pixelformat_Bloss( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Bloss;
	OUTPUT:
		RETVAL

Uint8
pixelformat_Gloss( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Gloss;
	OUTPUT:
		RETVAL

Uint8
pixelformat_Aloss( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Aloss;
	OUTPUT:
		RETVAL

Uint8
pixelformat_Rshift( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Rshift;
	OUTPUT:
		RETVAL

Uint8
pixelformat_Bshift( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Bshift;
	OUTPUT:
		RETVAL

Uint8
pixelformat_Gshift( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Gshift;
	OUTPUT:
		RETVAL

Uint8
pixelformat_Ashift( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Ashift;
	OUTPUT:
		RETVAL

Uint32
pixelformat_Rmask( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Rmask;
	OUTPUT:
		RETVAL

Uint32
pixelformat_Bmask( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Bmask;
	OUTPUT:
		RETVAL

Uint32
pixelformat_Gmask( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Gmask;
	OUTPUT:
		RETVAL

Uint32
pixelformat_Amask( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->Amask;
	OUTPUT:
		RETVAL

Uint32
pixelformat_colorkey( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->colorkey;
	OUTPUT:
		RETVAL

Uint8
pixelformat_alpha( pixelformat )
	SDL_PixelFormat *pixelformat
	CODE:
		RETVAL = pixelformat->alpha;
	OUTPUT:
		RETVAL

void
pixelformat_DESTROY ( bag )
	SV *bag
	CODE:
		objDESTROY(bag, safefree);
