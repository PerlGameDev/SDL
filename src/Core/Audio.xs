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

AV *
audio_load_wav ( filename, spec )
	char *filename
	SDL_AudioSpec *spec
	CODE:
		SDL_AudioSpec *temp;
		Uint8 *buf;
		Uint32 len;

		temp = SDL_LoadWAV(filename,spec,&buf,&len);
		if ( ! temp ) 
		{
		  warn("Error in SDL_LoadWAV"); 
		  RETVAL = newAV(); 	
		  RETVAL = sv_2mortal((SV*)RETVAL ); 
		}
		else
		{	
		RETVAL = newAV();
		RETVAL = sv_2mortal((SV*)RETVAL );
		av_push(RETVAL,newSViv(PTR2IV(temp)));
		av_push(RETVAL,newSViv(PTR2IV(buf)));
		av_push(RETVAL,newSViv(len));
		}
	OUTPUT:
		RETVAL

void
audio_free_wav ( audio_buf )
	Uint8 *audio_buf
	CODE:
		SDL_FreeWAV(audio_buf);


void
audio_close_audio ()
	CODE:
		SDL_CloseAudio();

