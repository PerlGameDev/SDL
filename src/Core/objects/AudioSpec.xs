#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_audio.h>

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
audiospec_DESTROY(self)
	SDL_AudioSpec *self
	CODE:
		safefree( (char *)self );
