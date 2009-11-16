#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Audio     PACKAGE = SDL::Audio    PREFIX = audio_

int
audio_open_audio ( desired, obtained )
	SDL_AudioSpec *desired
	SDL_AudioSpec *obtained
	CODE:
		RETVAL = SDL_OpenAudio(desired, obtained);
	OUTPUT:
		RETVAL

void
audio_pause_audio ( pause_on )
	int pause_on
	CODE:
		SDL_PauseAudio(pause_on);

Uint32
audio_get_audio_status ()
	CODE:
		RETVAL = SDL_GetAudioStatus ();
	OUTPUT:
		RETVAL

void
audio_lock_audio ()
	CODE:
		SDL_LockAudio();

void
audio_unlock_audio ()
	CODE:
		SDL_UnlockAudio();

void
audio_close_audio ()
	CODE:
		SDL_CloseAudio();

