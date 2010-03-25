#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#ifdef USE_THREADS
#define HAVE_TLS_CONTEXT
#endif

PerlInterpreter * perl_my = NULL;

PerlInterpreter * perl_for_audio_cb = NULL;

#include <SDL.h>
#include <SDL_audio.h>


void
audio_callback ( void* data, Uint8 *stream, int len )
{

	PERL_SET_CONTEXT(perl_for_audio_cb); 
	
	dSP;

        char* string = (char*)stream;

	SV* sv = newSVpv("a",1);
        SvCUR_set(sv,len * sizeof(Uint8));
	SvLEN_set(sv,len * sizeof(Uint8));
        void* old = SvPVX(sv);
        SvPV_set(sv,string);

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
 
	XPUSHs(sv_2mortal(newSViv(sizeof(Uint8))));
	XPUSHs(sv_2mortal(newSViv(len)));
	XPUSHs(sv_2mortal(newRV_inc(sv)));
 
	PUTBACK;
 	call_pv(data,G_VOID|G_DISCARD);

        SvPV_set(sv,old);
        SvCUR_set(sv,1);
	SvLEN_set(sv,1);
        sv_2mortal(sv);

	FREETMPS;
	LEAVE;
	

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
	char* cb
	CODE:
		// the audio callback will happen in a different thread.
                // so we're going to leave a cloned interpreter available
                // but still remain in the current one.
		if (perl_for_audio_cb == NULL) {
		  perl_my = PERL_GET_CONTEXT;
		  perl_for_audio_cb = perl_clone(perl_my, CLONEf_KEEP_PTR_TABLE);
                  PERL_SET_CONTEXT(perl_my);
                }
		audiospec->userdata = cb;
		audiospec->callback = audio_callback;

void
audiospec_DESTROY(self)
	SDL_AudioSpec *self
	CODE:
		safefree( (char *)self );
