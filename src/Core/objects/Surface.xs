#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

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
surface_new (CLASS, flags, width, height, depth, Rmask, Gmask, Bmask, Amask )
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
surface_new_from (CLASS, pixels, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask )
	char* CLASS
	int width
	int height
	int depth
	int pitch
	Uint32 Rmask
	Uint32 Gmask
	Uint32 Bmask
	Uint32 Amask
	IV pixels
	CODE:
		//warn ("USING THIS WILL CAUSE YOUR CODE TO SEGFAULT ON EXIT! \n READ: http://sdlperl.ath.cx/projects/SDLPerl/ticket/53");
		void *p = INT2PTR(void*, pixels);
		int size_p = sizeof( (*p));  //gets freed by old surface
	        unsigned int *newpixels = safemalloc( size_p ); //gets freed by new Surface
		memcpy(newpixels, p, size_p);
		//warn("p is %p, newpixels is %p \n", p, newpixels);
		
		RETVAL = SDL_CreateRGBSurfaceFrom ( newpixels, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask );
		if( RETVAL == NULL)
		croak ("SDL_CreateRGBSurfaceFrom failed: %s", SDL_GetError());

	OUTPUT:	
		RETVAL


SDL_PixelFormat *
surface_format ( surface )
	SDL_Surface *surface
	PREINIT:
		char* CLASS = "SDL::PixelFormat";
	CODE:
		RETVAL = surface->format;
	OUTPUT:
		RETVAL

Uint16
surface_pitch( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->pitch;
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
	  RETVAL =((unsigned int*)surface->pixels)[offset];
	OUTPUT:
	  RETVAL


IV
surface_get_pixels_ptr(surface)
	SDL_Surface *surface
	CODE:
	  if(!surface->pixels) croak("Incomplete surface");
	  RETVAL = PTR2IV(surface->pixels);
	OUTPUT:
	  RETVAL

void
surface_set_pixels(surface, index, value)
	SDL_Surface *surface
	int index
	unsigned int value
	CODE:
	((unsigned int*)surface->pixels)[index] = value;

void
surface_DESTROY(surface)
	SDL_Surface *surface
	CODE:
		//warn("Freed surface %p and pixels %p \n", surface, surface->pixels);
		SDL_FreeSurface(surface);
		
