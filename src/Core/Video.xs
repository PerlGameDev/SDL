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
		for ( i = 0; i < len+1 ; i++ )
		{ 
			SV ** temp = av_fetch(av,i,0);
			if( temp != NULL )
			{
				table[i] = (Uint16) SvIV( *temp );
			}
			else
			{
				table[i] = 0;
			}
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
video_list_modes ( format, flags )
	Uint32 flags
	SDL_PixelFormat *format

	CODE:
		SDL_Rect **mode;
		RETVAL = newAV();
		sv_2mortal((SV*)RETVAL);
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
		SDL_Rect* rects;
		int num_rects,i;
		if ( items < 2 ) return;
		num_rects = items - 1;
		rects = (SDL_Rect *)safemalloc(sizeof(SDL_Rect)*items);
		for(i=0;i<num_rects;i++) {
                        void** pointers = (void**)(SvIV((SV*)SvRV( ST(i+1) ))); 
			rects[i] = *(SDL_Rect *)(pointers[0]);
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
                        void** pointers = (void**)(SvIV(ST(i+2))); 
			temp = (SDL_Color *)pointers[0];
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
		SDL_Color *colors;
                SDL_Color *temp;
		int i,length;

		if ( items < 4 ) { 
                  RETVAL = 0;

                } else {
		  length = items - 3;		
                  colors = (SDL_Color *)safemalloc(sizeof(SDL_Color)*(length+1));
                  for ( i = 0; i < length; i++ ){ 

                     void** pointers = (void**)(SvIV(ST(i+3))); 
                     temp = (SDL_Color *)pointers[0];
                     colors[i].r = temp->r;
                     colors[i].g = temp->g;
                     colors[i].b = temp->b;
		  }

		  RETVAL = SDL_SetPalette(surface, flags, colors, start, length);
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
video_get_gamma_ramp( redtable, greentable, bluetable )
	AV* redtable;
	AV* greentable;
	AV* bluetable;
	CODE:
		Uint16 red_ramp[256];
		Uint16 green_ramp[256];
		Uint16 blue_ramp[256];
		int i;
		RETVAL = SDL_GetGammaRamp(red_ramp, green_ramp, blue_ramp);
		for ( i=0; i<256; ++i ) {
			av_push(redtable,newSViv(red_ramp[i]));
			av_push(greentable,newSViv(green_ramp[i]));
			av_push(bluetable,newSViv(blue_ramp[i]));
		}
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
		RETVAL = SDL_MapRGB(pixel_format, r,g,b);
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
		RETVAL = SDL_MapRGBA(pixel_format, r,g,b,a );
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


SDL_Surface *
video_display_format ( surface )
	SDL_Surface *surface
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = SDL_DisplayFormat(surface);
	OUTPUT:
		RETVAL

SDL_Surface *
video_display_format_alpha ( surface )
	SDL_Surface *surface
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = SDL_DisplayFormatAlpha(surface);
	OUTPUT:
		RETVAL


int
video_set_color_key ( surface, flag, key )
	SDL_Surface *surface
	Uint32 flag
	SDL_Color *key
	CODE:
		Uint32 pixel = SDL_MapRGB(surface->format,key->r,key->g,key->b);
		RETVAL = SDL_SetColorKey(surface,flag,pixel);
	OUTPUT:
		RETVAL

int
video_set_alpha ( surface, flag, alpha )
	SDL_Surface *surface
	Uint32 flag
	Uint8 alpha
	CODE:
		RETVAL = SDL_SetAlpha(surface,flag,alpha);
	OUTPUT:
		RETVAL

AV *
video_get_RGB ( pixel_format, pixel )
	SDL_PixelFormat *pixel_format
	Uint32 pixel
	CODE:
		Uint8 r,g,b;
		SDL_GetRGB(pixel,pixel_format,&r,&g,&b);
		RETVAL = newAV();
		sv_2mortal((SV*)RETVAL);
		av_push(RETVAL,newSViv(r));
		av_push(RETVAL,newSViv(g));
		av_push(RETVAL,newSViv(b));
	OUTPUT:
		RETVAL

AV *
video_get_RGBA ( pixel_format, pixel )
	SDL_PixelFormat *pixel_format
	Uint32 pixel
	CODE:
		Uint8 r,g,b,a;
		SDL_GetRGBA(pixel,pixel_format,&r,&g,&b,&a);
		RETVAL = newAV();
		sv_2mortal((SV*)RETVAL);
		av_push(RETVAL,newSViv(r));
		av_push(RETVAL,newSViv(g));
		av_push(RETVAL,newSViv(b));
		av_push(RETVAL,newSViv(a));
	OUTPUT:
		RETVAL

SDL_Surface*
video_load_BMP ( filename )
	char *filename
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = SDL_LoadBMP(filename);
	OUTPUT:
		RETVAL

int
save_BMP ( surface, filename )
	SDL_Surface *surface
	char *filename
	CODE:
		RETVAL = SDL_SaveBMP(surface,filename);
	OUTPUT:
		RETVAL

int
fill_rect ( dest, dest_rect, pixel )
	SDL_Surface *dest
	SDL_Rect *dest_rect
	Uint32 pixel
	CODE:
		RETVAL = SDL_FillRect(dest,dest_rect,pixel);
	OUTPUT:
		RETVAL

int
blit_surface ( src, src_rect, dest, dest_rect )
	SDL_Surface *src
	SDL_Surface *dest
	SDL_Rect *src_rect
	SDL_Rect *dest_rect
	CODE:
		RETVAL = SDL_BlitSurface(src,src_rect,dest,dest_rect);
	OUTPUT:
		RETVAL

void
set_clip_rect ( surface, rect )
	SDL_Surface *surface
	SDL_Rect *rect
	CODE:
		SDL_SetClipRect(surface,rect);

void
get_clip_rect ( surface, rect )
	SDL_Surface *surface
	SDL_Rect *rect;
	CODE:
		SDL_GetClipRect(surface, rect);



int
video_lock_YUV_overlay ( overlay )
	SDL_Overlay *overlay
	CODE:
		RETVAL = SDL_LockYUVOverlay(overlay);
	OUTPUT:
		RETVAL

void
video_unlock_YUV_overlay ( overlay )
        SDL_Overlay *overlay
        CODE:
                SDL_UnlockYUVOverlay(overlay);

int
video_display_YUV_overlay ( overlay, dstrect )
	SDL_Overlay *overlay
	SDL_Rect *dstrect
	CODE:
		RETVAL = SDL_DisplayYUVOverlay ( overlay, dstrect );
	OUTPUT:
		RETVAL


int
video_GL_load_library ( path )
	char *path
	CODE:
		RETVAL = SDL_GL_LoadLibrary(path);
	OUTPUT:
		RETVAL

void*
video_GL_get_proc_address ( proc )
	char *proc
	CODE:
		RETVAL = SDL_GL_GetProcAddress(proc);
	OUTPUT:
		RETVAL

int
video_GL_set_attribute ( attr,  value )
	int        attr
	int        value
	CODE:
		RETVAL = SDL_GL_SetAttribute(attr, value);
	OUTPUT:
	        RETVAL

AV *
video_GL_get_attribute ( attr )
	int        attr
	CODE:
		int value;
		RETVAL = newAV();
		sv_2mortal((SV*)RETVAL);
		av_push(RETVAL,newSViv(SDL_GL_GetAttribute(attr, &value)));
		av_push(RETVAL,newSViv(value));
	OUTPUT:
	        RETVAL

void
video_GL_swap_buffers ()
	CODE:
		SDL_GL_SwapBuffers ();

void
video_wm_set_caption ( title, icon )
	char *title
	char *icon
	CODE:
		SDL_WM_SetCaption(title,icon);

AV *
video_wm_get_caption ()
	CODE:
		char *title,*icon;
		SDL_WM_GetCaption(&title,&icon);
		RETVAL = newAV();
		sv_2mortal((SV*)RETVAL);
		av_push(RETVAL,newSVpv(title,0));
		av_push(RETVAL,newSVpv(icon,0));
	OUTPUT:
		RETVAL

void
video_wm_set_icon ( icon )
	SDL_Surface *icon
	CODE:
		SDL_WM_SetIcon(icon,NULL);

Uint32
video_wm_grab_input ( mode )
	Uint32 mode
	CODE:
		RETVAL = SDL_WM_GrabInput(mode);
	OUTPUT:
		RETVAL

int
video_wm_iconify_window ()
	CODE:
		RETVAL = SDL_WM_IconifyWindow();
	OUTPUT:
		RETVAL

int
video_wm_toggle_fullscreen ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_WM_ToggleFullScreen(surface);
	OUTPUT:
		RETVAL

int
video_MUSTLOCK ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_MUSTLOCK(surface);
	OUTPUT:
		RETVAL		
