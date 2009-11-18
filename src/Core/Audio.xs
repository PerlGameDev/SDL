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
		SDL_AudioSpec *temp = safemalloc(sizeof(SDL_AudioSpec));
		Uint8 *buf;
		Uint32 len;
		SV * asref = newSV( sizeof(SDL_AudioSpec *) );

		memcpy( temp, spec, sizeof(SDL_AudioSpec) );
		temp = SDL_LoadWAV(filename,temp,&buf,&len);
		if ( temp == NULL ) 
		{
		  croak("Error in SDL_LoadWAV: %s", SDL_GetError()); 
		}
		else
		{	
		RETVAL = newAV();
		RETVAL = sv_2mortal((SV*)RETVAL );
		av_push(RETVAL, sv_setref_pv( asref, "SDL::AudioSpec", (void *)temp));
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

