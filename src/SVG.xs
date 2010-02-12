#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#ifdef HAVE_SDL_SVG
#include <SDL_svg.h>
#endif


MODULE = SDL::SVG	PACKAGE = SDL::SVG
PROTOTYPES : DISABLE

#ifdef HAVE_SDL_SVG

SDL_svg_context *
SVG_Load ( filename )
	char* filename
	CODE:
		RETVAL = SVG_Load(filename);
	OUTPUT:
		RETVAL

SDL_svg_context *
SVG_LoadBuffer ( data, len )
	char* data
	int len
	CODE:
		RETVAL = SVG_LoadBuffer(data,len);
	OUTPUT:
		RETVAL

int
SVG_SetOffset ( source, xoff, yoff )
	SDL_svg_context* source
	double xoff
	double yoff
	CODE:
		RETVAL = SVG_SetOffset(source,xoff,yoff);
	OUTPUT:
		RETVAL

int
SVG_SetScale ( source, xscale, yscale )
	SDL_svg_context* source
	double xscale
	double yscale
	CODE:
		RETVAL = SVG_SetScale(source,xscale,yscale);
	OUTPUT:
		RETVAL

int
SVG_RenderToSurface ( source, x, y, dest )
	SDL_svg_context* source
	int x
	int y
	SDL_Surface* dest;
	CODE:
		RETVAL = SVG_RenderToSurface(source,x,y,dest);
	OUTPUT:
		RETVAL

void
SVG_Free ( source )
	SDL_svg_context* source
	CODE:
		SVG_Free(source);	

void
SVG_Set_Flags ( source, flags )
	SDL_svg_context* source
	Uint32 flags
	CODE:
		SVG_Set_Flags(source,flags);

float
SVG_Width ( source )
	SDL_svg_context* source
	CODE:
		RETVAL = SVG_Width(source);
	OUTPUT:
		RETVAL

float
SVG_HEIGHT ( source )
	SDL_svg_context* source
	CODE:
		RETVAL = SVG_Height(source);
	OUTPUT:
		RETVAL

void
SVG_SetClipping ( source, minx, miny, maxx, maxy )
	SDL_svg_context* source
	int minx
	int miny
	int maxx
	int maxy
	CODE:
		SVG_SetClipping(source,minx,miny,maxx,maxy);

int
SVG_Version ( )
	CODE:
		RETVAL = SVG_Version();
	OUTPUT:
		RETVAL


#endif




