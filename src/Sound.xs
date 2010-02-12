#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#ifdef HAVE_SDL_SOUND
#include <SDL_sound.h>
#endif


MODULE = SDL::Sound	PACKAGE = SDL::Sound
PROTOTYPES : DISABLE

#ifdef HAVE_SDL_SOUND

Uint16
SoundAudioInfoFormat ( audioinfo )
	Sound_AudioInfo* audioinfo
	CODE:
		RETVAL = audioinfo->format;
	OUTPUT:
		RETVAL

Uint8
SoundAudioInfoChannels ( audioinfo )
	Sound_AudioInfo* audioinfo
	CODE:
		RETVAL = audioinfo->channels;
	OUTPUT:
		RETVAL

Uint32
SoundAudioInforate ( audioinfo )
	Sound_AudioInfo* audioinfo
	CODE:
		RETVAL = audioinfo->rate;
	OUTPUT:
		RETVAL

AV*
SoundDecoderInfoExtensions ( decoderinfo )
	Sound_DecoderInfo* decoderinfo
	CODE:
		const char **ext;
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		for ( ext = decoderinfo->extensions; *ext != NULL; ext++ ){
			av_push(RETVAL,newSVpv(*ext,0));
		}
	OUTPUT:
		RETVAL

const char*
SoundDecoderInfoDescription ( decoderinfo )
	Sound_DecoderInfo* decoderinfo
	CODE:
		RETVAL = decoderinfo->description;
	OUTPUT:
		RETVAL

const char*
SoundDecoderInfoAuthor ( decoderinfo )
	Sound_DecoderInfo* decoderinfo
	CODE:
		RETVAL = decoderinfo->author;
	OUTPUT:
		RETVAL

const char*
SoundDecoderInfoUrl ( decoderinfo )
	Sound_DecoderInfo* decoderinfo
	CODE:
		RETVAL = decoderinfo->url;
	OUTPUT:
		RETVAL

const Sound_DecoderInfo*
SoundSampleDecoder ( sample ) 
	Sound_Sample* sample
	CODE:
		RETVAL = sample->decoder;
	OUTPUT:
		RETVAL

Sound_AudioInfo* 
SoundSampleDesired ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = &sample->desired;
	OUTPUT:
		RETVAL

Sound_AudioInfo*
SoundSampleAcutal ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = &sample->actual;
	OUTPUT:
		RETVAL

char*
SoundSampleBuffer ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = sample->buffer;
	OUTPUT:
		RETVAL

Uint32
SoundSampleBufferSize ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = sample->buffer_size;
	OUTPUT:
		RETVAL

Uint32
SoundSampleFlags ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = (Uint32)sample->flags;
	OUTPUT:
		RETVAL

int
Sound_Init ( )
	CODE:
		RETVAL = Sound_Init();
	OUTPUT:
		RETVAL

int
Sound_Quit ( )
	CODE:
		RETVAL = Sound_Quit();
	OUTPUT:
		RETVAL

AV*
Sound_AvailableDecoders ( )
	CODE:
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		const Sound_DecoderInfo** sdi;
		sdi = Sound_AvailableDecoders();
		if (sdi != NULL)  {
			for (;*sdi != NULL; ++sdi) {
				av_push(RETVAL,newSViv(PTR2IV(*sdi)));
			}
		}
	OUTPUT:
		RETVAL

const char*
Sound_GetError ( )
	CODE:
		RETVAL = Sound_GetError();
	OUTPUT:
		RETVAL

void
Sound_ClearError ( )
	CODE:
		Sound_ClearError();

Sound_Sample*
Sound_NewSample ( rw, ext, desired, buffsize )
	SDL_RWops* rw
	const char* ext
	Sound_AudioInfo* desired
	Uint32 buffsize
	CODE:
		RETVAL = Sound_NewSample(rw,ext,desired,buffsize);
	OUTPUT:
		RETVAL

Sound_Sample*
Sound_NewSampleFromMem ( data, size, ext, desired, buffsize )
	const Uint8 *data
	Uint32 size
	const char* ext
	Sound_AudioInfo* desired
	Uint32 buffsize
	CODE:
		RETVAL = Sound_NewSampleFromMem(data,size,ext,desired,buffsize);
	OUTPUT:
		RETVAL

Sound_Sample*
Sound_NewSampleFromFile ( fname, desired, buffsize )
	const char* fname
	Sound_AudioInfo* desired
	Uint32 buffsize
	CODE:
		RETVAL = Sound_NewSampleFromFile(fname,desired,buffsize);
	OUTPUT:
		RETVAL

void
Sound_FreeSample ( sample )
	Sound_Sample* sample
	CODE:
		Sound_FreeSample(sample);

Sint32
Sound_GetDuration ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = Sound_GetDuration(sample);
	OUTPUT:
		RETVAL

int
Sound_SetBufferSize ( sample, size )
	Sound_Sample* sample
	Uint32 size
	CODE:
		RETVAL = Sound_SetBufferSize(sample,size);
	OUTPUT:
		RETVAL

Uint32
Sound_Decode ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = Sound_Decode(sample);
	OUTPUT:
		RETVAL

Uint32
Sound_DecodeAll ( sample ) 
	Sound_Sample* sample
	CODE:
		RETVAL = Sound_DecodeAll(sample);
	OUTPUT:
		RETVAL

int
Sound_Rewind ( sample )
	Sound_Sample* sample
	CODE:
		RETVAL = Sound_Rewind(sample);
	OUTPUT:
		RETVAL

int
Sound_Seek ( sample, ms )
	Sound_Sample* sample
	Uint32 ms
	CODE:
		RETVAL = Sound_Seek(sample,ms);
	OUTPUT:
		RETVAL

#endif




