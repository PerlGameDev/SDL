#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::VideoInfo 	PACKAGE = SDL::VideoInfo    PREFIX = videoinfo_

=for documentation

SDL_VideoInfo -- Video target information

typedef struct{
    Uint32 hw_available:1;
    Uint32 wm_available:1;
    Uint32 blit_hw:1;
    Uint32 blit_hw_CC:1;
    Uint32 blit_hw_A:1;
    Uint32 blit_sw:1;
    Uint32 blit_sw_CC:1;
    Uint32 blit_sw_A:1;
    Uint32 blit_fill:1;
    Uint32 video_mem;
    SDL_PixelFormat *vfmt;
    int current_w;
    int current_h;
} SDL_VideoInfo;



=cut

Uint32
videoinfo_hw_available( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->hw_available;
	OUTPUT:
		RETVAL

Uint32
videoinfo_wm_available( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->wm_available;
	OUTPUT:
		RETVAL

Uint32
videoinfo_blit_hw( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->blit_hw;
	OUTPUT:
		RETVAL

Uint32
videoinfo_blit_hw_CC( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->blit_hw_CC;
	OUTPUT:
		RETVAL


Uint32
videoinfo_blit_hw_A( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->blit_hw_A;
	OUTPUT:
		RETVAL

Uint32
videoinfo_blit_sw( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->blit_sw;
	OUTPUT:
		RETVAL

Uint32
videoinfo_blit_sw_CC( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->blit_sw_CC;
	OUTPUT:
		RETVAL


Uint32
videoinfo_blit_sw_A( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->blit_sw_A;
	OUTPUT:
		RETVAL

Uint32
videoinfo_blit_fill( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->blit_fill;
	OUTPUT:
		RETVAL

Uint32
videoinfo_video_mem( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->video_mem;
	OUTPUT:
		RETVAL


SDL_PixelFormat *
videoinfo_vfmt( videoinfo )

	SDL_VideoInfo *videoinfo

	PREINIT:
	
		char* CLASS = "SDL::PixelFormat";	
	
	CODE:
		RETVAL = videoinfo->vfmt;
	OUTPUT:
		RETVAL

int
videoinfo_current_w( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->current_w;
	OUTPUT:
		RETVAL

int
videoinfo_current_h( videoinfo )

	SDL_VideoInfo *videoinfo
	
	CODE:
		RETVAL = videoinfo->current_h;
	OUTPUT:
		RETVAL



	

