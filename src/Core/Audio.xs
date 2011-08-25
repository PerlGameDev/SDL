#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Audio     PACKAGE = SDL::Audio    PREFIX = audio_

int
audio_open ( desired, obtained )
	SDL_AudioSpec *desired
	SDL_AudioSpec *obtained
	CODE:
		RETVAL = SDL_OpenAudio(desired, obtained);
	OUTPUT:
		RETVAL

void
audio_pause ( pause_on )
	int pause_on
	CODE:
		SDL_PauseAudio(pause_on);

Uint32
audio_get_status ()
	CODE:
		RETVAL = SDL_GetAudioStatus ();
	OUTPUT:
		RETVAL

void
audio_lock ()
	CODE:
		SDL_LockAudio();

void
audio_unlock ()
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

		memcpy( temp, spec, sizeof(SDL_AudioSpec) );
		temp = SDL_LoadWAV(filename,temp,&buf,&len);
		if ( temp == NULL ) 
		{
			croak("Error in SDL_LoadWAV: %s", SDL_GetError()); 
		}
		else
		{
			RETVAL = (AV*)sv_2mortal((SV*)newAV());
			av_push(RETVAL, obj2bag( sizeof(SDL_AudioSpec *), (void *)temp, "SDL::AudioSpec" ));
			av_push(RETVAL, newSViv(PTR2IV(buf)));
			av_push(RETVAL, newSViv(len));
		}
	OUTPUT:
		RETVAL

void
audio_free_wav ( audio_buf )
	Uint8 *audio_buf
	CODE:
		SDL_FreeWAV(audio_buf);

int
audio_convert( cvt, data, len )
	SDL_AudioCVT *cvt
	Uint8 *data
	int len
	CODE:
		cvt->buf = (Uint8 *)safemalloc(len * cvt->len_mult);
		cvt->len = len;
		memcpy(cvt->buf, data, cvt->len);
		RETVAL = SDL_ConvertAudio(cvt);
		
		
	OUTPUT:
		RETVAL

SV *
audio_audio_driver_name ( ... )
	CODE:
		char buffer[1024];
		if ( SDL_AudioDriverName(buffer, 1024) != NULL ) 
		{ 
			RETVAL =  newSVpv(buffer, 0);
		} 
		else 
			 XSRETURN_UNDEF;  	
	OUTPUT:
		RETVAL


void
audio_close ()
	CODE:
		SDL_CloseAudio();

