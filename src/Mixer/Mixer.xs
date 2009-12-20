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


#ifdef HAVE_SDL_MIXER
#include <SDL_mixer.h>
void (*mix_music_finished_cv)();
#endif

#ifdef HAVE_SMPEG
#include <smpeg/smpeg.h>
#ifdef HAVE_SDL_MIXER
static int sdl_perl_use_smpeg_audio = 0;
#endif
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


#ifdef HAVE_SDL_MIXER

void
sdl_perl_music_callback ( void ) 
{
	SV *cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)Mix_GetMusicHookData();

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	PUTBACK;
	
	call_sv(cmd,G_VOID|G_DISCARD);

	PUTBACK;
	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT
}

void
sdl_perl_music_finished_callback ( void )
{
	SV *cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)mix_music_finished_cv;
	if ( cmd == NULL ) return;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	PUTBACK;
	
	call_sv(cmd,G_VOID|G_DISCARD);
	
	PUTBACK;
	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT
}

#endif




MODULE = SDL::Mixer 	PACKAGE = SDL::Mixer    PREFIX = mixer_

=for documentation

SDL_mixer bindings

See: http://www.libsdl.org/projects/SDL_mixer/docs/SDL_mixer.html

=cut

#ifdef HAVE_SDL_MIXER

#if (SDL_MIXER_MAJOR_VERSION >= 1) && (SDL_MIXER_MINOR_VERSION >= 2) && (SDL_MIXER_PATCHLEVEL >= 10)

int
mixer_init(flags)
	int flags
	CODE:
		RETVAL = Mix_Init(flags);
	OUTPUT:
		RETVAL

#endif


void*
PerlMixMusicHook ()
	CODE:
		RETVAL = sdl_perl_music_callback;
	OUTPUT:
		RETVAL

void
mixer_mix_audio ( dst, src, len, volume )
	Uint8 *dst
	Uint8 *src
	Uint32 len
	int volume
	CODE:
		SDL_MixAudio(dst,src,len,volume);

int
mixer_open_audio ( frequency, format, channels, chunksize )
	int frequency
	Uint16 format
	int channels
	int chunksize	
	CODE:
		RETVAL = Mix_OpenAudio(frequency, format, channels, chunksize);
	OUTPUT:
		RETVAL

int
mixer_allocate_channels ( number )
	int number
	CODE:
		RETVAL = Mix_AllocateChannels(number);
	OUTPUT:
		RETVAL

AV *
mixer_query_spec ()
	CODE:
		int freq, channels, status;
		Uint16 format;
		status = Mix_QuerySpec(&freq,&format,&channels);
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		av_push(RETVAL,newSViv(status));
		av_push(RETVAL,newSViv(freq));
		av_push(RETVAL,newSViv(format));
		av_push(RETVAL,newSViv(channels));
	OUTPUT:
		RETVAL

Mix_Chunk *
mixer_load_WAV ( filename )
	char *filename
	PREINIT:
		char * CLASS = "SDL::Mixer::MixChunk";
	CODE:
		Mix_Chunk * mixchunk;
		mixchunk = Mix_LoadWAV(filename);
		if (mixchunk == NULL) {
		  fprintf(stderr, "Could not load %s\n", filename);
		}
		RETVAL = mixchunk;
	OUTPUT:
		RETVAL

Mix_Music *
mixer_load_MUS ( filename )
	char *filename
	PREINIT:
		char * CLASS = "SDL::Mixer::MixMusic";
	CODE:
		Mix_Music * mixmusic;
		mixmusic = Mix_LoadMUS(filename);
		if (mixmusic == NULL) {
		  fprintf(stderr, "Could not load %s\n", filename);
		}
		RETVAL = mixmusic;
	OUTPUT:
		RETVAL

Mix_Chunk *
mixer_quick_load_WAV ( buf )
	Uint8 *buf
	PREINIT:
		char * CLASS = "SDL::Mixer::MixChunk";
	CODE:
		RETVAL = Mix_QuickLoad_WAV(buf);
	OUTPUT:
		RETVAL

void
mixer_free_chunk( chunk )
	Mix_Chunk *chunk
	CODE:
		Mix_FreeChunk(chunk);

void
mixer_free_music ( music )
	Mix_Music *music
	CODE:
		Mix_FreeMusic(music);

void
mixer_set_post_mix ( func, arg )
	void *func
	void *arg
	CODE:
		Mix_SetPostMix(func,arg);

void
mixer_hook_music ( func, arg )
	void *func
	void *arg
	CODE:
		Mix_HookMusic(func,arg);

void
mixer_hook_music_finished ( func )
	void *func
	CODE:
		mix_music_finished_cv = func;
		Mix_HookMusicFinished(sdl_perl_music_finished_callback);

void *
mixer_get_music_hook_data ()
	CODE:
		RETVAL = Mix_GetMusicHookData();
	OUTPUT:
		RETVAL

int
mixer_reserve_channels ( number )
	int number
	CODE:
		RETVAL = Mix_ReserveChannels ( number );
	OUTPUT:
		RETVAL

int
mixer_group_channel ( which, tag )
	int which
	int tag
	CODE:
		RETVAL = Mix_GroupChannel(which,tag);
	OUTPUT:
		RETVAL

int
mixer_group_channels ( from, to, tag )
	int from
	int to
	int tag
	CODE:
		RETVAL = Mix_GroupChannels(from,to,tag);
	OUTPUT:
		RETVAL

int
mixer_group_available ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupAvailable(tag);
	OUTPUT:
		RETVAL

int
mixer_group_count ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupCount(tag);
	OUTPUT:
		RETVAL

int
mixer_group_oldest ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupOldest(tag);
	OUTPUT:
		RETVAL

int
mixer_group_newer ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupNewer(tag);
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
mixer_play_music ( music, loops )
	Mix_Music *music
	int loops
	CODE:
		RETVAL = Mix_PlayMusic(music,loops);
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

int
mixer_fade_in_music ( music, loops, ms )
	Mix_Music *music
	int loops
	int ms
	CODE:
		RETVAL = Mix_FadeInMusic(music,loops,ms);
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
mixer_volume_chunk ( chunk, volume )
	Mix_Chunk *chunk
	int volume
	CODE:
		RETVAL = Mix_VolumeChunk(chunk,volume);
	OUTPUT:
		RETVAL

int
mixer_volume_music ( volume )
	int volume
	CODE:
		RETVAL = Mix_VolumeMusic(volume);
	OUTPUT:
		RETVAL

int
mixer_halt_channel ( channel )
	int channel
	CODE:
		RETVAL = Mix_HaltChannel(channel);
	OUTPUT:
		RETVAL

int
mixer_halt_group ( tag )
	int tag
	CODE:
		RETVAL = Mix_HaltGroup(tag);
	OUTPUT:
		RETVAL

int
mixer_halt_music ()
	CODE:
		RETVAL = Mix_HaltMusic();
	OUTPUT:
		RETVAL

int
mixer_expire_channel ( channel, ticks )
	int channel
	int ticks
	CODE:
		RETVAL = Mix_ExpireChannel ( channel,ticks);
	OUTPUT:
		RETVAL

int
mixer_fade_out_channel ( which, ms )
	int which
	int ms
	CODE:
		RETVAL = Mix_FadeOutChannel(which,ms);
	OUTPUT:
		RETVAL

int
mixer_fade_out_group ( which, ms )
	int which
	int ms
	CODE:
		RETVAL = Mix_FadeOutGroup(which,ms);
	OUTPUT:
		RETVAL

int
mixer_fade_out_music ( ms )
	int ms
	CODE:
		RETVAL = Mix_FadeOutMusic(ms);
	OUTPUT:
		RETVAL

Mix_Fading
mixer_fading_music()
	CODE:
		RETVAL = Mix_FadingMusic();
	OUTPUT:
		RETVAL

Mix_Fading
mixer_fading_channel( which )
	int which
	CODE:
		RETVAL = Mix_FadingChannel(which);
	OUTPUT:
		RETVAL

void
mixer_pause ( channel )
	int channel
	CODE:
		Mix_Pause(channel);

void
mixer_resume ( channel )
	int channel
	CODE:
		Mix_Resume(channel);

int
mixer_paused ( channel )
	int channel
	CODE:
		RETVAL = Mix_Paused(channel);
	OUTPUT:
		RETVAL

void
mixer_pause_music ()
	CODE:
		Mix_PauseMusic();

void
mixer_resume_music ()
	CODE:
		Mix_ResumeMusic();

void
mixer_rewind_music ()
	CODE:
		Mix_RewindMusic();

int
mixer_paused_music ()
	CODE:
		RETVAL = Mix_PausedMusic();
	OUTPUT:
		RETVAL

int
mixer_playing( channel )
	int channel	
	CODE:
		RETVAL = Mix_Playing(channel);
	OUTPUT:
		RETVAL

int
mixer_playing_music()
	CODE:
		RETVAL = Mix_PlayingMusic();
	OUTPUT:
		RETVAL

int
mixer_set_panning ( channel, left, right )
	int channel
	int left
	int right
	CODE:
		RETVAL = Mix_SetPanning(channel, left, right);
	OUTPUT:
		RETVAL

void
mixer_close_audio ()
	CODE:
		Mix_CloseAudio();

#endif
