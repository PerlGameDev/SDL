/* */
/* SDL.xs */
/* */
/* Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org> */
/* */
/* ------------------------------------------------------------------------------ */
/* */
/* This library is free software; you can redistribute it and/or */
/* modify it under the terms of the GNU Lesser General Public */
/* License as published by the Free Software Foundation; either */
/* version 2.1 of the License, or (at your option) any later version. */
/*  */
/* This library is distributed in the hope that it will be useful, */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU */
/* Lesser General Public License for more details. */
/*  */
/* You should have received a copy of the GNU Lesser General Public */
/* License along with this library; if not, write to the Free Software */
/* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA */
/* */
/* ------------------------------------------------------------------------------ */
/* */
/* Please feel free to send questions, suggestions or improvements to: */
/* */
/*	David J. Goehrig */
/*	dgoehrig@cpan.org */
/* */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_GL
#include <gl.h>
#endif

#ifdef HAVE_GLU
#include <glu.h>
#endif


#ifdef USE_THREADS
#define HAVE_TLS_CONTEXT
#endif

/* For windows  */
#ifndef SDL_PERL_DEFINES_H
#define SDL_PERL_DEFINES_H

#ifdef HAVE_TLS_CONTEXT
PerlInterpreter *parent_perl = NULL;
extern PerlInterpreter *parent_perl;
#define GET_TLS_CONTEXT parent_perl =  PERL_GET_CONTEXT;
#define ENTER_TLS_CONTEXT \
        PerlInterpreter *current_perl = PERL_GET_CONTEXT; \
	        PERL_SET_CONTEXT(parent_perl); { \
			                PerlInterpreter *my_perl = parent_perl;
#define LEAVE_TLS_CONTEXT \
					        } PERL_SET_CONTEXT(current_perl);
#else
#define GET_TLS_CONTEXT         /* TLS context not enabled */
#define ENTER_TLS_CONTEXT       /* TLS context not enabled */
#define LEAVE_TLS_CONTEXT       /* TLS context not enabled */
#endif

#endif


#ifndef NOSIGCATCH
#include <execinfo.h>
#include <signal.h>
#include <stdlib.h>

void handler(int sig) {
  void *array[10];
  size_t size;

   //get void*'s for all entries on the stack
     size = backtrace(array, 10);
  
    // print out all the frames to stderr
         fprintf(stderr, "Error: signal %d:\n", sig);
           backtrace_symbols_fd(array, size, 2);
      exit(1);
}
#endif

void
windows_force_driver()
{
	char *test = SDL_getenv("SDL_VIDEODRIVER");
	if(!test || 0 != strcmp("dummy", test))
	{
#if SDL_MAJOR_VERSION >= 1 && SDL_MINOR_VERSION >= 2 &&  SDL_PATCHLEVEL >= 14
		putenv("SDL_VIDEODRIVER=directx");
#else
		putenv("SDL_VIDEODRIVER=windib");
#endif
	}
}


#define INIT_NS_APPLICATION
#define QUIT_NS_APPLICATION


void
sdl_perl_atexit (void)
{
	QUIT_NS_APPLICATION	
	SDL_Quit();
}

void boot_SDL();
void boot_SDL__OpenGL();

XS(boot_SDL_perl)
{

#ifndef NOSIGCATCH 
	signal(SIGSEGV, handler);
#endif
	PL_perl_destruct_level = 2;
	GET_TLS_CONTEXT
	boot_SDL();
}

MODULE = SDL_perl	PACKAGE = SDL
PROTOTYPES : DISABLE


# workaround as:
#  extern DECLSPEC void SDLCALL SDL_SetError(const char *fmt, ...);
void
set_error_real (fmt, ...)
	char *fmt
	CODE:
		SDL_SetError(fmt, items);

char *
get_error ()
	CODE:
		RETVAL = SDL_GetError();
	OUTPUT:
		RETVAL

void
clear_error ()
	CODE:
		SDL_ClearError();

int
init ( flags )
	Uint32 flags
	CODE:
		INIT_NS_APPLICATION
#if defined WINDOWS || defined WIN32
		windows_force_driver();
#endif
		RETVAL = SDL_Init(flags);
#ifndef WINDOWS 
#ifndef WIN32
#ifdef HAVE_TLS_CONTEXT 

		Perl_call_atexit(PERL_GET_CONTEXT, (void*)sdl_perl_atexit,0);
#else
		atexit(sdl_perl_atexit);
#endif
#endif
#endif
	OUTPUT:
		RETVAL

int
init_sub_system ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_InitSubSystem(flags);
	OUTPUT:
		RETVAL

void
quit_sub_system ( flags )
	Uint32 flags
	CODE:
		SDL_QuitSubSystem(flags);

void
quit ()
	CODE:
		QUIT_NS_APPLICATION
		SDL_Quit();

int
was_init ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_WasInit(flags);
	OUTPUT:
		RETVAL

SDL_version *
version ()
	PREINIT:
		char * CLASS = "SDL::Version";
		SDL_version *version;
	CODE:
	 	version = (SDL_version *) safemalloc (sizeof(SDL_version));
		SDL_VERSION(version);
		RETVAL = version;
	OUTPUT:
		RETVAL

SDL_version *
linked_version ()
	PREINIT:
		char * CLASS = "SDL::Version";
		SDL_version *version;
	CODE:
		version = (SDL_version *) safemalloc ( sizeof(SDL_version) );
		SDL_version* version_dont_free = (SDL_version *) SDL_Linked_Version();

		version->major = version_dont_free->major;
		version->minor = version_dont_free->minor;
		version->patch = version_dont_free->patch;
		RETVAL = version;
	OUTPUT:
		RETVAL

char*
getenv (name)
	char *name
	CODE:
		RETVAL = SDL_getenv(name);
	OUTPUT:
		RETVAL

void
delay ( ms )
	int ms
	CODE:
		SDL_Delay(ms);

Uint32
get_ticks ()
	CODE:
		RETVAL = SDL_GetTicks();
	OUTPUT:
		RETVAL



MODULE = SDL		PACKAGE = SDL
PROTOTYPES : DISABLE


