#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif


#ifdef HAVE_SDL_TTF
#include <SDL_ttf.h>
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



#include <SDL.h>
#include <SDL_audio.h>

static SV * callbacksv;

void
sdl_perl_audio_callback ( void* data, Uint8 *stream, int len )
{
	SV *cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)data;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(PTR2IV(data))));
	XPUSHs(sv_2mortal(newSViv(PTR2IV(stream))));
	XPUSHs(sv_2mortal(newSViv(len)));
	PUTBACK;

	call_sv(callbacksv,G_VOID|G_DISCARD);
	
	PUTBACK;
	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT	
}

MODULE = SDL::AudioSpec 	PACKAGE = SDL::AudioSpec    PREFIX = audiospec_

=for documentation

SDL_AudioSpec -- Audio specification

  /* The calculated values in this structure are calculated by SDL_OpenAudio() */
  typedef struct SDL_AudioSpec {
          int freq;               /* DSP frequency -- samples per second */
          Uint16 format;          /* Audio data format */
          Uint8  channels;        /* Number of channels: 1 mono, 2 stereo */
          Uint8  silence;         /* Audio buffer silence value (calculated) */
          Uint16 samples;         /* Audio buffer size in samples (power of 2) */
          Uint16 padding;         /* Necessary for some compile environments */
          Uint32 size;            /* Audio buffer size in bytes (calculated) */
          /* This function is called when the audio device needs more data.
             'stream' is a pointer to the audio data buffer
             'len' is the length of that buffer in bytes.
             Once the callback returns, the buffer will no longer be valid.
             Stereo samples are stored in a LRLRLR ordering.
          */
          void (SDLCALL *callback)(void *userdata, Uint8 *stream, int len);
          void  *userdata;
  } SDL_AudioSpec;

=cut

SDL_AudioSpec *
audiospec_new (CLASS)
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_AudioSpec));
	OUTPUT:
		RETVAL

int
audiospec_freq ( audiospec, ... )
	SDL_AudioSpec *audiospec
	CODE:
		if (items > 1 ) audiospec->freq = SvIV(ST(1)); 
		RETVAL = audiospec->freq;
	OUTPUT:
		RETVAL

Uint16
audiospec_format ( audiospec, ... )
	SDL_AudioSpec *audiospec
	CODE:
		if (items > 1 ) audiospec->format = SvIV(ST(1)); 
		RETVAL = audiospec->format;
	OUTPUT:
		RETVAL

Uint8
audiospec_channels ( audiospec, ... )
	SDL_AudioSpec *audiospec
	CODE:
		if (items > 1 ) audiospec->channels = SvIV(ST(1)); 
		RETVAL = audiospec->channels;
	OUTPUT:
		RETVAL

Uint16
audiospec_samples ( audiospec, ... )
	SDL_AudioSpec *audiospec
	CODE:
		if (items > 1 ) audiospec->samples = SvIV(ST(1)); 
		RETVAL = audiospec->samples;
	OUTPUT:
		RETVAL
		
void
audiospec_callback( audiospec, cb )
	SDL_AudioSpec *audiospec
	SV* cb
	CODE:
		callbacksv = cb;
		audiospec->callback = sdl_perl_audio_callback;
		

void
audiospec_DESTROY(self)
	SDL_AudioSpec *self
	CODE:
		safefree( (char *)self );
