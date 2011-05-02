#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::RWOps 	PACKAGE = SDL::RWOps    PREFIX = rwops_

=for documentation

SDL_RWops -- Direct memory read write.

=cut


SDL_RWops*
rwops_alloc (CLASS)
	char* CLASS
	CODE:
		RETVAL = SDL_AllocRW();
	OUTPUT:
	 	RETVAL


SDL_RWops*
rwops_new_file ( CLASS, file, mode )
	char* CLASS
	char* file
	char * mode
	CODE:
		RETVAL = SDL_RWFromFile(file,mode);
	OUTPUT:
		RETVAL

SDL_RWops*
rwops_new_FP ( CLASS, fp, autoclose )
	char* CLASS
	FILE* fp
	int autoclose
	CODE:
		RETVAL = SDL_RWFromFP(fp,autoclose);
	OUTPUT:
		RETVAL

SDL_RWops*
rwops_new_mem ( CLASS, mem, size )
	char* CLASS
	char* mem
	int size
	CODE:
		RETVAL = SDL_RWFromMem((void*)mem,size);
	OUTPUT:
		RETVAL

SDL_RWops *
rwops_new_const_mem (CLASS, mem, ... )
	char* CLASS
	SV* mem
	CODE:
		STRLEN len;
		unsigned char *text = SvPV(mem, len);
		if(items > 2 && SvIOK(ST(2)))
			len = SvIV(ST(2));
		RETVAL = SDL_RWFromConstMem((const void*)text, len);
	OUTPUT:
		RETVAL

int
rwops_seek ( rw, off, whence )
	SDL_RWops* rw
	int off
	int whence
	CODE:
		RETVAL = SDL_RWseek(rw,off,whence);
	OUTPUT:
		RETVAL

int
rwops_tell ( rw )
	SDL_RWops* rw
	CODE:
		RETVAL = SDL_RWtell(rw);
	OUTPUT:
		RETVAL

int
rwops_read ( rw, mem, size, n )
	SDL_RWops* rw
	char* mem
	int size
	int n
	CODE:
		RETVAL = SDL_RWread(rw,mem,size,n);
	OUTPUT:
		RETVAL

int
rwops_write ( rw, mem, size, n )
	SDL_RWops* rw
	char* mem
	int size
	int n
	CODE:
		RETVAL = SDL_RWwrite(rw,mem,size,n);
	OUTPUT:
		RETVAL

int
rwops_close ( rw )
	SDL_RWops* rw
	CODE:
		RETVAL = SDL_RWclose(rw);
	OUTPUT:
		RETVAL

void
rwops_free ( rw )
	SDL_RWops* rw
	CODE:
		SDL_FreeRW(rw);


