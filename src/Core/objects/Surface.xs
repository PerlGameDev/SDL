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

SDL_PixelFormat *
surface_format ( surface )
	SDL_Surface *surface
	CODE:
		char* CLASS = "SDL::PixelFormat";
		RETVAL = surface->format;
	OUTPUT:
		RETVAL

void
surface_update_rects ( surface, ... )
	SDL_Surface *surface
	CODE:
		SDL_Rect *rects, *temp;
		int num_rects,i;
		if ( items < 2 ) return;
		num_rects = items - 1;
			
		rects = (SDL_Rect *)safemalloc(sizeof(SDL_Rect)*items);
		for(i=0;i<num_rects;i++) {
			temp = (SDL_Rect *)SvIV(ST(i+1));
			rects[i].x = temp->x;
			rects[i].y = temp->y;
			rects[i].w = temp->w;
			rects[i].h = temp->h;
		} 
		SDL_UpdateRects(surface,num_rects,rects);
		safefree(rects);

SDL_Surface *
surface_display ( surface )
	SDL_Surface *surface
	CODE:
		char* CLASS = "SDL::Surface";

		SDL_Surface *new_surface = SDL_DisplayFormat(surface);
		SDL_FreeSurface(surface);
		RETVAL = new_surface;	
	OUTPUT:
		RETVAL

SDL_Surface *
surface_display_alpha ( surface )
	SDL_Surface *surface
	CODE:
		char* CLASS = "SDL::Surface";
		SDL_Surface *new_surface = SDL_DisplayFormatAlpha(surface);
		SDL_FreeSurface(surface);
		RETVAL = new_surface;
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

IV
surface_get_pixels(surface)
	SDL_Surface *surface
	CODE:
	  if(!surface->pixels) croak("Incomplete surface");
	  RETVAL = PTR2IV(surface->pixels);
	OUTPUT:
	  RETVAL

void
surface_set_pixels(surface, pixels)
	SDL_Surface *surface

	SV *pixels

	PREINIT:
	  STRLEN len;
	  void *p;

	CODE:
	  p = SvPV(pixels, len);
	  if (len > surface->pitch*surface->h)
		len = surface->pitch*surface->h;
	  memcpy(surface->pixels, p, len);

void
surface_DESTROY(surface)
	SDL_Surface *surface
	CODE:
		Uint8* pixels = surface->pixels;
		Uint32 flags = surface->flags;
		SDL_FreeSurface(surface);
		if (flags & SDL_PREALLOC)
			Safefree(pixels);
