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


SDL_VideoInfo*
video_get_video_info()
	PREINIT:
		char* CLASS = "SDL::VideoInfo";
	CODE:
		RETVAL = SDL_GetVideoInfo;

	OUTPUT:
	RETVAL

char *
video_video_driver_name( maxlen )
	int maxlen
	CODE:
		char* buffer = safemalloc( sizeof(char) * maxlen); 
		char* str = SvPV( newSVpvn( buffer , maxlen), maxlen );

		RETVAL = SDL_VideoDriverName( str , maxlen);

		sv_2mortal(buffer); 		
		
	OUTPUT:
		RETVAL