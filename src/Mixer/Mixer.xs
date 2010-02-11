#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_MIXER
#include <SDL_mixer.h>
#endif

#ifdef HAVE_SMPEG
#include <smpeg/smpeg.h>
#ifdef HAVE_SDL_MIXER
static int sdl_perl_use_smpeg_audio = 0;
#endif
#endif

MODULE = SDL::Mixer 	PACKAGE = SDL::Mixer    PREFIX = mixer_

=for documentation

SDL_mixer bindings

See: http://www.libsdl.org/projects/SDL_mixer/docs/SDL_mixer.html

=cut

#ifdef HAVE_SDL_MIXER

#if (SDL_MIXER_MAJOR_VERSION >= 1) && (SDL_MIXER_MINOR_VERSION >= 2) && (SDL_MIXER_PATCHLEVEL >= 10)

int
mixer_init(flags)
	int flags
	CODE:
		RETVAL = Mix_Init(flags);
	OUTPUT:
		RETVAL


void
mixer_quit()
	CODE:
		Mix_Quit();

#endif

const SDL_version *
mixer_linked_version ()
	PREINIT:
		char* CLASS = "SDL::Version";
	CODE:
		RETVAL = Mix_Linked_Version();
	OUTPUT:
		RETVAL


int
mixer_open_audio ( frequency, format, channels, chunksize )
	int frequency
	Uint16 format
	int channels
	int chunksize	
	CODE:
		RETVAL = Mix_OpenAudio(frequency, format, channels, chunksize);
	OUTPUT:
		RETVAL

void
mixer_close_audio ()
	CODE:
		Mix_CloseAudio();



AV *
mixer_query_spec ()
	CODE:
		int freq, channels, status;
		Uint16 format;
		status = Mix_QuerySpec(&freq,&format,&channels);
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		av_push(RETVAL,newSViv(status));
		av_push(RETVAL,newSViv(freq));
		av_push(RETVAL,newSViv(format));
		av_push(RETVAL,newSViv(channels));
	OUTPUT:
		RETVAL

#endif
