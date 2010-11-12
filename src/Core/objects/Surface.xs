#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_newRV_noinc_GLOBAL
#define NEED_newSV_type_GLOBAL
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

void _free_surface(void *object)
{
	SDL_FreeSurface((SDL_Surface *)object);
}

MODULE = SDL::Surface 	PACKAGE = SDL::Surface    PREFIX = surface_

=for documentation

SDL_Surface -- Graphic surface structure 

  typedef struct SDL_Surface {
      Uint32 flags;                           /* Read-only */
      SDL_PixelFormat *format;                /* Read-only */
      int w, h;                               /* Read-only */
      Uint16 pitch;                           /* Read-only */
      void *pixels;                           /* Read-write */
      SDL_Rect clip_rect;                     /* Read-only */
      int refcount;                           /* Read-mostly */

    /* This structure also contains private fields not shown here */
  } SDL_Surface;

=cut

SDL_Surface *
surface_new (CLASS, flags, width, height, depth = 32, Rmask = 0xFF000000, Gmask = 0x00FF0000, Bmask = 0x0000FF00, Amask = 0x000000FF )
	char* CLASS
	Uint32 flags
	int width
	int height
	int depth
	Uint32 Rmask
	Uint32 Gmask
	Uint32 Bmask
	Uint32 Amask
	CODE:
		RETVAL = SDL_CreateRGBSurface ( flags, width, height,
				depth, Rmask, Gmask, Bmask, Amask );
	OUTPUT:
		RETVAL

SDL_Surface *
surface_new_from (CLASS, pixels, width, height, depth, pitch, Rmask = 0xFF000000 , Gmask =  0x00FF0000, Bmask = 0x0000FF00, Amask =  0x000000FF )
	char* CLASS
	int width
	int height
	int depth
	int pitch
	Uint32 Rmask
	Uint32 Gmask
	Uint32 Bmask
	Uint32 Amask
	SV* pixels
	CODE:
		int* pix = (int *) SvRV ( (SV*) SvRV( pixels ) );
		RETVAL = SDL_CreateRGBSurfaceFrom ( (void *)pix, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask );
		if( RETVAL == NULL)
		croak ("SDL_CreateRGBSurfaceFrom failed: %s", SDL_GetError());

	OUTPUT:	
		RETVAL


SV *
surface_format ( surface )
	SDL_Surface *surface
	PREINIT:
		char* CLASS = "SDL::PixelFormat";
	CODE:
		RETVAL = cpy2bag( surface->format, sizeof(SDL_PixelFormat *), sizeof(SDL_PixelFormat), "SDL::PixelFormat" );
	OUTPUT:
		RETVAL

Uint16
surface_pitch( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->pitch;
	OUTPUT:
		RETVAL

Uint32
surface_flags( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->flags;
	OUTPUT:
		RETVAL


Uint16
surface_w ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->w;
	OUTPUT:
		RETVAL

Uint16
surface_h ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->h;
	OUTPUT:
		RETVAL

int
surface_get_pixel(surface, offset)
	SDL_Surface *surface
	int offset
	CODE:
		switch(surface->format->BytesPerPixel)
		{
			case 1:  RETVAL = ((Uint8  *)surface->pixels)[offset];
			         break;
			case 2:  RETVAL = ((Uint16 *)surface->pixels)[offset];
			         break;
			case 3:  RETVAL = ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel]     <<  0)
			                + ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel + 1] <<  8)
			                + ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel + 2] << 16);
			         break;
			case 4:  RETVAL = ((Uint32 *)surface->pixels)[offset];
			         break;
			default: XSRETURN_UNDEF;
			         break;
		}
	OUTPUT:
		RETVAL


SV *
surface_get_pixels_ptr(surface)
	SDL_Surface *surface
	CODE:
	  if(!surface->pixels) croak("Incomplete surface");
	  SV * sv = newSV_type(SVt_PV);
	  SvPV_set(sv, surface->pixels);
	  SvPOK_on(sv);
	  SvREADONLY(sv);
	  SvLEN_set(sv, 0);
	  SvCUR_set(sv, surface->format->BytesPerPixel * surface->w * surface->h);
	  RETVAL = newRV_noinc(sv);
	OUTPUT:
	  RETVAL

void
surface_set_pixels(surface, offset, value)
	SDL_Surface *surface
	int offset
	unsigned int value
	CODE:
		switch(surface->format->BytesPerPixel)
		{
			case 1: ((Uint8  *)surface->pixels)[offset] = (Uint8)value;
			        break;
			case 2: ((Uint16 *)surface->pixels)[offset] = (Uint16)value;
			        break;
			case 3: ((Uint8  *)surface->pixels)[offset * surface->format->BytesPerPixel]     = (Uint8)( value        & 0xFF);
			        ((Uint8  *)surface->pixels)[offset * surface->format->BytesPerPixel + 1] = (Uint8)((value <<  8) & 0xFF);
			        ((Uint8  *)surface->pixels)[offset * surface->format->BytesPerPixel + 2] = (Uint8)((value << 16) & 0xFF);
			        break;
			case 4: ((Uint32 *)surface->pixels)[offset] = (Uint32)value;
			        break;
		}

void
surface_DESTROY(bag)
	SV* bag
	CODE:
		objDESTROY(bag, _free_surface);
