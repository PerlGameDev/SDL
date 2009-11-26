#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

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
			RETVAL = sv_2mortal( (SV *)RETVAL );
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

void
audio_close ()
	CODE:
		SDL_CloseAudio();

