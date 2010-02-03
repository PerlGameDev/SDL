#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_SDL_MIXER
#include <SDL_mixer.h>
#endif

#ifdef HAVE_SMPEG
#include <smpeg/smpeg.h>
#ifdef HAVE_SDL_MIXER
static int sdl_perl_use_smpeg_audio = 0;
#endif
#endif



MODULE = SDL::Mixer::Samples 	PACKAGE = SDL::Mixer::Samples    PREFIX = mixsam_

=for documentation

SDL_mixer bindings

See: http://www.libsdl.org/projects/SDL_mixer/docs/SDL_mixer.html

=cut

#ifdef HAVE_SDL_MIXER


#if SDL_MIXER_MAJOR_VERSION >	1 || SDL_MIXER_MINOR_VERSION > 2 || (  SDL_MIXER_MAJOR_VERSION == 1 && SDL_MIXER_MINOR_VERSION == 2 && SDL_MIXER_PATCHLEVEL >= 10 )

int 
mixsam_get_num_chunk_decoders ()
	CODE:
		RETVAL = Mix_GetNumChunkDecoders();
	OUTPUT:
		RETVAL

char* 
mixsam_get_chunk_decoder (idecoder)
	int idecoder
	CODE:
		RETVAL = (char *)Mix_GetChunkDecoder(idecoder);
	OUTPUT:
		RETVAL

#endif


Mix_Chunk *
mixsam_load_WAV ( filename )
	char *filename
	PREINIT:
		char * CLASS = "SDL::Mixer::MixChunk";
	CODE:
		Mix_Chunk * mixchunk;
		mixchunk = Mix_LoadWAV(filename);
		RETVAL = mixchunk;
	OUTPUT:
		RETVAL


Mix_Chunk *
mixsam_load_WAV_RW ( src, freesrc)
	SDL_RWops * src
	int freesrc
	PREINIT:
		char * CLASS = "SDL::Mixer::MixChunk";
	CODE:
		Mix_Chunk * mixchunk;
		mixchunk = Mix_LoadWAV_RW(src, freesrc);
		RETVAL = mixchunk;
	OUTPUT:
		RETVAL


Mix_Chunk *
mixsam_quick_load_WAV ( buf )
	Uint8 *buf
	PREINIT:
		char * CLASS = "SDL::Mixer::MixChunk";
	CODE:
		RETVAL = Mix_QuickLoad_WAV(buf);
	OUTPUT:
		RETVAL


Mix_Chunk *
mixsam_quick_load_RAW ( buf , len)
	Uint8 *buf
	int len
	PREINIT:
		char * CLASS = "SDL::Mixer::MixChunk";
	CODE:
		RETVAL = Mix_QuickLoad_RAW( buf, len );
	OUTPUT:
		RETVAL


int
mixsam_volume_chunk ( chunk, volume )
	Mix_Chunk *chunk
	int volume
	CODE:
		RETVAL = Mix_VolumeChunk(chunk,volume);
	OUTPUT:
		RETVAL


void
mixsam_free_chunk( chunk )
	Mix_Chunk *chunk
	CODE:
		Mix_FreeChunk(chunk);



#endif
