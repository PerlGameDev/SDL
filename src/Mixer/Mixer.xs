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


void
mixer_quit()
	CODE:
		Mix_Quit();

#endif

const SDL_version *
mixer_linked_version ()
	PREINIT:
		char* CLASS = "SDL::Version";
	CODE:
		RETVAL = Mix_Linked_Version();
	OUTPUT:
		RETVAL


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

void
mixer_close_audio ()
	CODE:
		Mix_CloseAudio();



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
mixer_play_music ( music, loops )
	Mix_Music *music
	int loops
	CODE:
		RETVAL = Mix_PlayMusic(music,loops);
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
mixer_volume_music ( volume )
	int volume
	CODE:
		RETVAL = Mix_VolumeMusic(volume);
	OUTPUT:
		RETVAL



int
mixer_halt_music ()
	CODE:
		RETVAL = Mix_HaltMusic();
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

#endif
