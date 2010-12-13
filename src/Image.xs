#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_IMAGE
#include <SDL_image.h>
#endif 

void test( char** xpm)
{

int x, y;
int w, h, ncolors, cpp;
char *line;
char ***xpmlines = NULL;


xpmlines = &xpm;

line = *(*xpmlines)++;

if(sscanf(line, "%d %d %d %d", &w, &h, &ncolors, &cpp) != 4
	   || w <= 0 || h <= 0 || ncolors <= 0 || cpp <= 0) {
		warn( "Invalid format description %s \n  %d %d %d %d", line, w, h, ncolors, cpp);
	}


}




MODULE = SDL::Image 	PACKAGE = SDL::Image    PREFIX = image_

#ifdef HAVE_SDL_IMAGE

const SDL_version*
image_linked_version()
	PREINIT:
		char* CLASS = "SDL::Version";
		SDL_version *version;
	CODE:
		version = (SDL_version *) safemalloc ( sizeof(SDL_version) );
		SDL_version* version_dont_free = (SDL_version *)IMG_Linked_Version();

		version->major = version_dont_free->major;
		version->minor = version_dont_free->minor;
		version->patch = version_dont_free->patch;
		RETVAL = version;
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
image_load_typed_rw(src, freesrc, type)
	SDL_RWops* src
	int freesrc
	char* type
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = IMG_LoadTyped_RW(src, freesrc, type);
	OUTPUT:
		RETVAL

#if (SDL_IMAGE_MAJOR_VERSION >= 1) && (SDL_IMAGE_MINOR_VERSION >= 2) && (SDL_IMAGE_PATCHLEVEL >= 10)

SDL_Surface *
image_load_ICO_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadICO_RW(src);
	OUTPUT:
		RETVAL


SDL_Surface *
image_load_CUR_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadCUR_RW(src);
	OUTPUT:
		RETVAL

#endif

SDL_Surface *
image_load_BMP_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadBMP_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_GIF_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadGIF_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_JPG_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadJPG_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_LBM_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadLBM_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_PCX_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadPCX_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_PNG_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadPNG_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_PNM_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadPNM_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_TGA_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadTGA_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_TIF_rw(src)
	SDL_RWops* src
 	PREINIT:
 	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadTIF_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_XCF_rw(src)
	SDL_RWops* src
	PREINIT:
 	 	 char *CLASS = "SDL::Surface"; 
 	CODE:
		RETVAL = IMG_LoadXCF_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_XPM_rw(src)
	SDL_RWops* src
	PREINIT:
 	 	 char *CLASS = "SDL::Surface"; 
 	CODE:
		RETVAL = IMG_LoadXPM_RW(src);
	OUTPUT:
		RETVAL

SDL_Surface *
image_load_XV_rw(src)
	SDL_RWops* src
	PREINIT:
	 	 char *CLASS = "SDL::Surface";
 	CODE:
		RETVAL = IMG_LoadXV_RW(src);
	OUTPUT:
		RETVAL


int image_is_BMP(src)
	SDL_RWops* src;
	CODE:
		RETVAL=IMG_isBMP(src);
	OUTPUT:
		RETVAL

#if (SDL_IMAGE_MAJOR_VERSION >= 1) && (SDL_IMAGE_MINOR_VERSION >= 2) && (SDL_IMAGE_PATCHLEVEL >= 10)

int image_is_CUR(src)
	SDL_RWops* src;
	CODE:
		RETVAL=IMG_isCUR(src);
	OUTPUT:
		RETVAL


int image_is_ICO(src)
	SDL_RWops* src;
	CODE:
		RETVAL=IMG_isICO(src);
	OUTPUT:
		RETVAL

#endif

int 
image_is_GIF(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isGIF(src);
	OUTPUT:
		RETVAL

int 
image_is_JPG(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isJPG(src);
	OUTPUT:
		RETVAL

int 
image_is_LBM(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isLBM(src);
	OUTPUT:
		RETVAL

int 
image_is_PCX(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isPCX(src);
	OUTPUT:
		RETVAL

int 
image_is_PNG(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isPNG(src);
	OUTPUT:
		RETVAL

int 
image_is_PNM(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isPNM(src);
	OUTPUT:
		RETVAL

int 
image_is_TIF(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isTIF(src);
	OUTPUT:
		RETVAL

int 
image_is_XCF(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isXCF(src);
	OUTPUT:
		RETVAL

int 
image_is_XPM(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isXPM(src);
	OUTPUT:
		RETVAL

int 
image_is_XV(src)
	 SDL_RWops * src;
	CODE:
		RETVAL=IMG_isXV(src);
	OUTPUT:
		RETVAL



SDL_Surface *
image_read_XPM_from_array(array, w)
	int w
	AV* array 
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		/*make columns first */
		int x, len;
		SV ** elem;
		len = av_len(array) + 1;
		char** src_x = safemalloc( len * sizeof(char*));
		char* temp;
		for(x=0; x < len ; x++)
		{
			 elem =  av_fetch(array, x, 0) ;
			 temp = SvPV_nolen(*elem);
			src_x[x] = safemalloc(w * sizeof(char) );
			memcpy( src_x[x], temp, w * sizeof(char) );
			/*warn("put in %s", src_x[x]); */
		}
	  		/*test(src_x);  */
		RETVAL = IMG_ReadXPMFromArray( src_x) ;
		for(x=0; x < len; x++)
		  safefree(src_x[x]);
		safefree(src_x);
	
	OUTPUT:
		RETVAL





#endif
