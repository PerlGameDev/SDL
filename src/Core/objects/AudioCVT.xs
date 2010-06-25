#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_audio.h>

=for documentation

typedef struct{
  int needed;
  Uint16 src_format;
  Uint16 dest_format;
  double rate_incr;
  Uint8 *buf;
  int len;
  int len_cvt;
  int len_mult;
  double len_ratio;
  void (*filters[10])(struct SDL_AudioCVT *cvt, Uint16 format);
  int filter_index;
} SDL_AudioCVT;

=cut

MODULE = SDL::AudioCVT 	PACKAGE = SDL::AudioCVT    PREFIX = audiocvt_

SDL_AudioCVT* 
audiocvt_new(CLASS)
	char* CLASS
	CODE:
		RETVAL = safemalloc(sizeof(SDL_AudioCVT));
	OUTPUT:
		RETVAL

SDL_AudioCVT* 
audiocvt_build(CLASS, src_format, src_channels, src_rate, dst_format, dst_channels, dst_rate)
	char* CLASS
	Uint16 src_format
	Uint8 src_channels
	int src_rate
	Uint16 dst_format
	Uint8 dst_channels
	int dst_rate
	CODE:
		RETVAL = (SDL_AudioCVT *)safemalloc(sizeof(SDL_AudioCVT));
		if(SDL_BuildAudioCVT(RETVAL, src_format, src_channels, src_rate,
		                             dst_format, dst_channels, dst_rate))
		{ 
			safefree(RETVAL);
			RETVAL = NULL;
		}
	OUTPUT:
		RETVAL

int
audiocvt_needed(self, ...)
	SDL_AudioCVT* self
	CODE:
		if( items > 1 )
		{
			self->needed = SvIV( ST(1) );
		}
		RETVAL = self->needed;
	OUTPUT:
		RETVAL

Uint16
audiocvt_src_format(self, ...)
	SDL_AudioCVT* self
	CODE:
		if( items > 1 )
		{
			self->src_format = SvIV( ST(1) );
		}
		RETVAL = self->src_format;
	OUTPUT:
		RETVAL

Uint16
audiocvt_dest_format(self, ...)
	SDL_AudioCVT* self
	CODE:
		if( items > 1 )
		{
			self->dst_format = SvIV( ST(1) );
		}
		RETVAL = self->dst_format;
	OUTPUT:
		RETVAL


double
audiocvt_rate_incr(self, ...)
	SDL_AudioCVT* self
	CODE:
		if( items > 1 )
		{
			self->rate_incr = SvIV( ST(1) );
		}
		RETVAL = self->rate_incr;
	OUTPUT:
		RETVAL

int
audiocvt_len(self, ...)
	SDL_AudioCVT* self
	CODE:
		if( items > 1 )
		{
			self->len = SvIV( ST(1) );
		}
		RETVAL = self->len;
	OUTPUT:
		RETVAL

int
audiocvt_len_cvt(self, ...)
	SDL_AudioCVT* self
	CODE:
		if( items > 1 )
		{
			self->len_cvt = SvIV( ST(1) );
		}
		RETVAL = self->len_cvt;
	OUTPUT:
		RETVAL

int
audiocvt_len_mult(self, ...)
	SDL_AudioCVT* self
	CODE:
		if( items > 1 )
		{
			self->len_mult = SvIV( ST(1) );
		}
		RETVAL = self->len_mult;
	OUTPUT:
		RETVAL

int
audiocvt_len_ratio(self, ...)
	SDL_AudioCVT* self
	CODE:
		if( items > 1 )
		{
			self->len_ratio = SvIV( ST(1) );
		}
		RETVAL = self->len_ratio;
	OUTPUT:
		RETVAL

void
audiocvt_DESTROY(self)
	SDL_AudioCVT* self
	CODE:
		safefree(self);
