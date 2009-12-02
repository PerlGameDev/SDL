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

const SDL_version*
image_linked_version()
	PREINIT:
		char* CLASS = "SDL::Version";
	CODE:
		RETVAL = IMG_Linked_Version(); 
	OUTPUT:
		RETVAL

#if (SDL_IMAGE_MAJOR_VERSION >= 1) && (SDL_IMAGE_MINOR_VERSION >= 2) && (SDL_IMAGE_PATCHLEVEL >= 10)

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

#endif

SDL_Surface *
image_load ( filename )
	char *filename
	CODE:
		char* CLASS = "SDL::Surface";
		RETVAL = IMG_Load(filename);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_rw ( rw_file, src )
	SDL_RWops *rw_file
	int src
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = IMG_Load_RW(rw_file, src);
	OUTPUT:
		RETVAL  

SDL_Surface * 
image_loadtyped_rw(src, freesrc, type)
	SDL_RWops* src
	int freesrc
	char* type
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = IMG_LoadTyped_RW(src, freesrc, type);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadBMP_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadBMP_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadGIF_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadGIF_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadJPG_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadJPG_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadLBM_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadLBM_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadPCX_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadPCX_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadPNG_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadPNG_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadPNM_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadPNM_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadTGA_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadTGA_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadTIF_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadTIF_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadXCF_rw(src)
	SDL_RWops* src
	PREINIT:
 	 	 char *CLASS = "SDL::Surface"; 
 	CODE:
		RETVAL = IMG_LoadXCF_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadXPM_rw(src)
	SDL_RWops* src
	PREINIT:
 	 	 char *CLASS = "SDL::Surface"; 
 	CODE:
		RETVAL = IMG_LoadXPM_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_loadXV_rw(src)
	SDL_RWops* src
	PREINIT:
	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadXV_RW(src);
	OUTPUT:
		RETVAL




#endif
