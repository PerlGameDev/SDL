#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>


static Uint16* av_to_uint16 (AV* av)
{
	int len = av_len(av);
	if( len != -1)
	{
	int i;
	Uint16* table = (Uint16 *)safemalloc(sizeof(Uint16)*(len));
	for ( i = 0; i < len+1 ; i++ ){ 
		SV ** temp = av_fetch(av,i,0);
	      if( temp != NULL)
		{
			table[i] =  (Uint16 *) SvIV(  *temp   );
		}
		else { table[i] =0; }

	}
	return table;
	}
	return NULL;
}



MODULE = SDL::Video 	PACKAGE = SDL::Video    PREFIX = video_

=for documentation

The Following are XS bindings to the Video category in the SDL API v2.1.13

Describe on the SDL API site.

See: L<http://www.libsdl.org/cgi/docwiki.cgi/SDL_API#head-813f033ec44914f267f32195aba7d9aff8c410c0>

=cut

SDL_Surface *
video_get_video_surface()
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = SDL_GetVideoSurface();
	OUTPUT:
		RETVAL


SDL_VideoInfo*
video_get_video_info()
	PREINIT:
		char* CLASS = "SDL::VideoInfo";
	CODE:
		RETVAL = (SDL_VideoInfo *) SDL_GetVideoInfo();

	OUTPUT:
		RETVAL

SV *
video_video_driver_name( )
	
	CODE:
		char buffer[1024];
		if ( SDL_VideoDriverName(buffer, 1024) != NULL ) 
		{ 
			RETVAL =  newSVpv(buffer, 0);
		} 
		else 
			 XSRETURN_UNDEF;  	
	OUTPUT:
		RETVAL

AV*
list_modes ( format, flags )
	Uint32 flags
	SDL_PixelFormat *format

	CODE:
		SDL_Rect **mode;
		RETVAL = newAV();
		mode = SDL_ListModes(format,flags);
		if (mode == (SDL_Rect**)-1 ) {
			av_push(RETVAL,newSVpv("all",0));
		} else if (! mode ) {
			av_push(RETVAL,newSVpv("none",0));
		} else {
			for (;*mode;mode++) {
				av_push(RETVAL,newSViv(PTR2IV(*mode)));
			}
		}
	OUTPUT:
		RETVAL


int
video_video_mode_ok ( width, height, bpp, flags )
	int width
	int height
	int bpp
	Uint32 flags
	CODE:
		RETVAL = SDL_VideoModeOK(width,height,bpp,flags);
	OUTPUT:
		RETVAL


SDL_Surface *
video_set_video_mode ( width, height, bpp, flags )
	int width
	int height
	int bpp
	Uint32 flags
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = SDL_SetVideoMode(width,height,bpp,flags);
	OUTPUT:
		RETVAL


void
video_update_rect ( surface, x, y, w ,h )
	SDL_Surface *surface
	int x
	int y
	int w
	int h
	CODE:
		SDL_UpdateRect(surface,x,y,w,h);

void
video_update_rects ( surface, ... )
	SDL_Surface *surface
	CODE:
		SDL_Rect *rects;
		int num_rects,i;
		if ( items < 2 ) return;
		num_rects = items - 1;
		rects = (SDL_Rect *)safemalloc(sizeof(SDL_Rect)*items);
		for(i=0;i<num_rects;i++) {
			rects[i] = *(SDL_Rect *)SvIV((SV*)SvRV( ST(i + 1) ));
		}
		SDL_UpdateRects(surface,num_rects,rects);
		safefree(rects);


int
video_flip ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_Flip(surface);
	OUTPUT:
		RETVAL

int
video_set_colors ( surface, start, ... )
	SDL_Surface *surface
	int start
	CODE:
		SDL_Color *colors,*temp;
		int i, length;
		if ( items < 3 ) { RETVAL = 0;}
		else
		{
		length = items - 2;
		colors = (SDL_Color *)safemalloc(sizeof(SDL_Color)*(length+1));
		for ( i = 0; i < length ; i++ ) {
			temp = (SDL_Color *)SvIV(ST(i+2));
			colors[i].r = temp->r;
			colors[i].g = temp->g;
			colors[i].b = temp->b;
		}
		RETVAL = SDL_SetColors(surface, colors, start, length );
	  	safefree(colors);
		}	

	OUTPUT:	
		RETVAL

int
video_set_palette ( surface, flags, start, ... )
	SDL_Surface *surface
	int flags
	int start

	CODE:
		SDL_Color *colors,*temp;
		int i, length;
		if ( items < 4 ) { 
		RETVAL = 0;
			}
		else
		{		
		length = items - 3;
		colors = (SDL_Color *)safemalloc(sizeof(SDL_Color)*(length+1));
		for ( i = 0; i < length ; i++ ){ 
			temp = (SDL_Color *)SvIV(ST(i+3));
			colors[i].r = temp->r;
			colors[i].g = temp->g;
			colors[i].b = temp->b;
		}
		RETVAL = SDL_SetPalette(surface, flags, colors, start, length );
	  	safefree(colors);
		}
	OUTPUT:	
		RETVAL

int
video_set_gamma(r, g, b)
	float r;
	float g;
	float b;
	CODE:
		RETVAL = SDL_SetGamma(r,g,b);
	OUTPUT:	
		RETVAL

	
int
video_set_gamma_ramp( rt, gt, bt )
	AV* rt;
	AV* gt;
	AV* bt;
	CODE:
		Uint16 *redtable, *greentable, *bluetable;
		redtable = av_to_uint16(rt);
		greentable = av_to_uint16(gt);
		bluetable = av_to_uint16(bt);
		RETVAL =  SDL_SetGammaRamp(redtable, greentable, bluetable);
		if( redtable != NULL) { safefree(redtable); }
		if( greentable != NULL) { safefree(greentable); }
		if( bluetable != NULL) { safefree(bluetable); }	
	OUTPUT:
		RETVAL 



Uint32
video_map_RGB ( pixel_format, r, g, b )
	SDL_PixelFormat *pixel_format
	Uint8 r
	Uint8 g
	Uint8 b
	CODE:
		RETVAL = SDL_MapRGB(pixel_format,r,g,b);
	OUTPUT:
		RETVAL

Uint32
video_map_RGBA ( pixel_format, r, g, b, a )
	SDL_PixelFormat *pixel_format
	Uint8 r
	Uint8 g
	Uint8 b	
	Uint8 a
	CODE:
		RETVAL = SDL_MapRGB(pixel_format,r,g,b);
	OUTPUT:
		RETVAL

int
video_lock_surface ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_LockSurface(surface);
	OUTPUT:
		RETVAL

void
video_unlock_surface ( surface )
	SDL_Surface *surface
	CODE:
		SDL_UnlockSurface(surface);


SDL_Surface *
video_convert_surface( src, fmt, flags)
	SDL_Surface* src
	SDL_PixelFormat* fmt
	Uint32	flags
	PREINIT:
		char *CLASS = "SDL::Surface";
	CODE:
		RETVAL = SDL_ConvertSurface(src, fmt, flags);
	OUTPUT:
		RETVAL
