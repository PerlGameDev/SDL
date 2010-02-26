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

PerlInterpreter * perl_for_cb = NULL;
static SV * cb                = (SV*)NULL;

void callback(int channel)
{
	if(NULL == perl_for_cb)
		return;
	
	PERL_SET_CONTEXT(perl_for_cb);

	dSP;
	ENTER;
	SAVETMPS;

	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(channel)));
	PUTBACK;

	if(cb != (SV*)NULL)
		call_sv(cb, G_VOID);

	FREETMPS;
	LEAVE;
}

MODULE = SDL::Mixer::Channels 	PACKAGE = SDL::Mixer::Channels    PREFIX = mixchan_

=for documentation

SDL_mixer bindings

See: http://www.libsdl.org/projects/SDL_mixer/docs/SDL_mixer.html

=cut

#ifdef HAVE_SDL_MIXER

int
mixchan_allocate_channels ( number )
	int number
	CODE:
		RETVAL = Mix_AllocateChannels(number);
	OUTPUT:
		RETVAL


int
mixchan_volume ( channel, volume )
	int channel
	int volume
	CODE:	
		RETVAL = Mix_Volume(channel,volume);
	OUTPUT:
		RETVAL

int
mixchan_play_channel ( channel, chunk, loops )
	int channel
	Mix_Chunk *chunk
	int loops
	CODE:
		RETVAL = Mix_PlayChannel(channel,chunk,loops);
	OUTPUT:
		RETVAL

int
mixchan_play_channel_timed ( channel, chunk, loops, ticks )
	int channel
	Mix_Chunk *chunk
	int loops
	int ticks
	CODE:
		RETVAL = Mix_PlayChannelTimed(channel,chunk,loops,ticks);
	OUTPUT:
		RETVAL


int
mixchan_fade_in_channel ( channel, chunk, loops, ms )
	int channel
	Mix_Chunk *chunk
	int loops
	int ms
	CODE:
		RETVAL = Mix_FadeInChannel(channel,chunk,loops,ms);
	OUTPUT:
		RETVAL

int
mixchan_fade_in_channel_timed ( channel, chunk, loops, ms, ticks )
	int channel
	Mix_Chunk *chunk
	int loops
	int ticks
	int ms
	CODE:
		RETVAL = Mix_FadeInChannelTimed(channel,chunk,loops,ms,ticks);
	OUTPUT:
		RETVAL

void
mixchan_pause ( channel )
	int channel
	CODE:
		Mix_Pause(channel);

void
mixchan_resume ( channel )
	int channel
	CODE:
		Mix_Resume(channel);

int
mixchan_halt_channel ( channel )
	int channel
	CODE:
		RETVAL = Mix_HaltChannel(channel);
	OUTPUT:
		RETVAL

int
mixchan_expire_channel ( channel, ticks )
	int channel
	int ticks
	CODE:
		RETVAL = Mix_ExpireChannel ( channel,ticks);
	OUTPUT:
		RETVAL

int
mixchan_fade_out_channel ( which, ms )
	int which
	int ms
	CODE:
		RETVAL = Mix_FadeOutChannel(which,ms);
	OUTPUT:
		RETVAL

void
mixchan_channel_finished( fn )
	SV* fn
	CODE:
		perl_for_cb = PERL_GET_CONTEXT;
	
		if (cb == (SV*)NULL)
            cb = newSVsv(fn);
        else
            SvSetSV(cb, fn);
			
		Mix_ChannelFinished(&callback);

int
mixchan_playing( channel )
	int channel	
	CODE:
		RETVAL = Mix_Playing(channel);
	OUTPUT:
		RETVAL

int
mixchan_paused ( channel )
	int channel
	CODE:
		RETVAL = Mix_Paused(channel);
	OUTPUT:
		RETVAL

Mix_Fading
mixchan_fading_channel( which )
	int which
	CODE:
		RETVAL = Mix_FadingChannel(which);
	OUTPUT:
		RETVAL


Mix_Chunk *
mixchan_get_chunk(chan)
	int chan
	PREINIT:
		char* CLASS = "SDL::Mixer::MixChunk";
	CODE:
		RETVAL = Mix_GetChunk(chan);
	OUTPUT:
		RETVAL

#endif

