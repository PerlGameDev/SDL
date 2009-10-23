#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

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


HV *
video_get_video_info()
	CODE:
		HV *hv;
		SDL_VideoInfo *info;
		info = (SDL_VideoInfo *) safemalloc ( sizeof(SDL_VideoInfo));
		memcpy(info,SDL_GetVideoInfo(),sizeof(SDL_VideoInfo));
		hv = newHV();
		hv_store(hv,"hw_available",strlen("hw_available"),
			newSViv(info->hw_available),0);
		hv_store(hv,"wm_available",strlen("wm_available"),
			newSViv(info->wm_available),0);
		hv_store(hv,"blit_hw",strlen("blit_hw"),
			newSViv(info->blit_hw),0);
		hv_store(hv,"blit_hw_CC",strlen("blit_hw_CC"),
			newSViv(info->blit_hw_CC),0);
		hv_store(hv,"blit_hw_A",strlen("blit_hw_A"),
			newSViv(info->blit_hw_A),0);
		hv_store(hv,"blit_sw",strlen("blit_sw"),
			newSViv(info->blit_sw),0);
		hv_store(hv,"blit_sw_CC",strlen("blit_sw_CC"),
			newSViv(info->blit_sw_CC),0);
		hv_store(hv,"blit_sw_A",strlen("blit_sw_A"),
			newSViv(info->blit_sw_A),0);
		hv_store(hv,"blit_fill",strlen("blit_fill"),
			newSViv(info->blit_fill),0);
		hv_store(hv,"video_mem",strlen("video_mem"),
			newSViv(info->video_mem),0);
		RETVAL = hv;
		OUTPUT:
		RETVAL
