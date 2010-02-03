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


MODULE = SDL::Mixer::Channels 	PACKAGE = SDL::Mixer::Channels    PREFIX = mixchan_

=for documentation

SDL_mixer bindings

See: http://www.libsdl.org/projects/SDL_mixer/docs/SDL_mixer.html

=cut

#ifdef HAVE_SDL_MIXER

int
mixer_allocate_channels ( number )
	int number
	CODE:
		RETVAL = Mix_AllocateChannels(number);
	OUTPUT:
		RETVAL


int
mixer_volume ( channel, volume )
	int channel
	int volume
	CODE:	
		RETVAL = Mix_Volume(channel,volume);
	OUTPUT:
		RETVAL

int
mixer_play_channel ( channel, chunk, loops )
	int channel
	Mix_Chunk *chunk
	int loops
	CODE:
		RETVAL = Mix_PlayChannel(channel,chunk,loops);
	OUTPUT:
		RETVAL

int
mixer_play_channel_timed ( channel, chunk, loops, ticks )
	int channel
	Mix_Chunk *chunk
	int loops
	int ticks
	CODE:
		RETVAL = Mix_PlayChannelTimed(channel,chunk,loops,ticks);
	OUTPUT:
		RETVAL


int
mixer_fade_in_channel ( channel, chunk, loops, ms )
	int channel
	Mix_Chunk *chunk
	int loops
	int ms
	CODE:
		RETVAL = Mix_FadeInChannel(channel,chunk,loops,ms);
	OUTPUT:
		RETVAL

int
mixer_fade_in_channel_timed ( channel, chunk, loops, ms, ticks )
	int channel
	Mix_Chunk *chunk
	int loops
	int ticks
	int ms
	CODE:
		RETVAL = Mix_FadeInChannelTimed(channel,chunk,loops,ms,ticks);
	OUTPUT:
		RETVAL

#endif

