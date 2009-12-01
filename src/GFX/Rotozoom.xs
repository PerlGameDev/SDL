#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#ifdef HAVE_SDL_GFX
#include <SDL_rotozoom.h>
#endif 

MODULE = SDL::GFX::Rotozoom 	PACKAGE = SDL::GFX::Rotozoom    PREFIX = gfx_roto_

=for documentation

The Following are XS bindings to the SDL_gfx Library

Described here:

See: L<http://www.ferzkopp.net/joomla/content/view/19/14/>

=cut

#ifdef HAVE_SDL_GFX

SDL_Surface *
gfx_roto_surface(src, angle, zoom, smooth)
	SDL_Surface * src
	double angle
	double zoom
	int smooth
	PREINIT:
		char *CLASS = "SDL::Surface";
	CODE:
		RETVAL = rotozoomSurface(src, angle, zoom, smooth);
	OUTPUT:
		RETVAL

SDL_Surface *
gfx_roto_surface_xy(src, angle, zoomx, zoomy, smooth)
	SDL_Surface * src
	double angle
	double zoomx
	double zoomy
	int smooth
	PREINIT:
		char *CLASS = "SDL::Surface";
	CODE:
		RETVAL = rotozoomSurfaceXY(src, angle, zoomx, zoomy, smooth);
	OUTPUT:
		RETVAL

void 
gfx_roto_surface_size(width, height, angle, zoom, dstwidth, dstheight)
	int width
	int height
	double angle
	double zoom
	int *dstwidth
	int *dstheight
	CODE:
		rotozoomSurfaceSize(width, height, angle, zoom, dstwidth, dstheight);

void 
gfx_roto_surface_size_xy(width, height, angle, zoomx, zoomy, dstwidth, dstheight)
	int width
	int height
	double angle
	double zoomx
	double zoomy
	int *dstwidth
	int *dstheight
	CODE:
		rotozoomSurfaceSizeXY(width, height, angle, zoomx, zoomy, dstwidth, dstheight);
	

SDL_Surface *
gfx_roto_zoom_surface(src, zoomx, zoomy, smooth)
	SDL_Surface * src
	double zoomx
	double zoomy
	int smooth
	PREINIT:
		char *CLASS = "SDL::Surface";
	CODE:
		RETVAL = zoomSurface(src, zoomx, zoomy, smooth);
	OUTPUT:
		RETVAL

void
gfx_roto_zoom_surface_size(width, height, zoomx, zoomy, dstwidth, dstheight)
	int width
	int height
	double zoomx
	double zoomy
	int *dstwidth
	int *dstheight
	CODE:
		zoomSurfaceSize(width, height, zoomx, zoomy, dstwidth, dstheight);

SDL_Surface *
gfx_roto_shrink_surface(src, factorx, factory)
	SDL_Surface * src
	int factorx
	int factory
	PREINIT:
		char *CLASS = "SDL::Surface";
	CODE:
		RETVAL = shrinkSurface(src, factorx, factory);
	OUTPUT:
		RETVAL

SDL_Surface *
gfx_roto_rotate_surface_90_degrees(pSurf, numClockwiseTurns)
	SDL_Surface* pSurf
	int numClockwiseTurns
	PREINIT:
		char *CLASS = "SDL::Surface";
	CODE:
		RETVAL = rotateSurface90Degrees(pSurf, numClockwiseTurns);
	OUTPUT:
		RETVAL

#endif
