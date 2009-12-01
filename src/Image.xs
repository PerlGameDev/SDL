#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_IMAGE
#include <SDL_image.h>
#endif 


MODULE = SDL::Image 	PACKAGE = SDL::Image    PREFIX = image_

#ifdef HAVE_SDL_IMAGE

SDL_version*
image_linked_version()
	PREINIT:
		char* CLASS = "SDL::Version";
	CODE:
		RETVAL = IMG_Linked_Version(); 
	OUTPUT:
		RETVAL

int
image_init(flags)
	int flags
	CODE:
		RETVAL = IMG_Init(flags);
	OUTPUT:
		RETVAL 

void
image_quit()
	CODE:
		IMG_Quit();
		

SDL_Surface *
image_load ( filename )
	char *filename
	CODE:
		char* CLASS = "SDL::Surface";
		RETVAL = IMG_Load(filename);
	OUTPUT:
		RETVAL

#endif
