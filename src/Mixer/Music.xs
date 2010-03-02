#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

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

PerlInterpreter * perl_for_cb = NULL;
static SV       * cb          = (SV*)NULL;

void mix_func(void *udata, Uint8 *stream, int len)
{
	PERL_SET_CONTEXT(perl_for_cb);
	dSP;
	ENTER;
	SAVETMPS;

	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(*(int*)udata)));
	XPUSHs(sv_2mortal(newSViv(len)));
	*(int*)udata = *(int*)udata + len;
	PUTBACK;

	if(cb != (SV*)NULL)
	{
        int count = perl_call_sv(cb, G_ARRAY);
		
		SPAGAIN;
		
		if(count == len + 1)
		{
			int i;
			for(i=0; i<len; i++)
				stream[i] = POPi;
		}
	}

	PUTBACK;

	FREETMPS;
	LEAVE;
}

#endif

MODULE = SDL::Mixer::Music 	PACKAGE = SDL::Mixer::Music    PREFIX = mixmus_

=for documentation

SDL_mixer bindings

See: http://www.libsdl.org/projects/SDL_mixer/docs/SDL_mixer.html

=cut

#ifdef HAVE_SDL_MIXER

void *
PerlMixMusicHook ()
	CODE:
		RETVAL = sdl_perl_music_callback;
	OUTPUT:
		RETVAL

#if (SDL_MIXER_MAJOR_VERSION >= 1) && (SDL_MIXER_MINOR_VERSION >= 2) && (SDL_MIXER_PATCHLEVEL >= 9)

int
mixmus_get_num_music_decoders( )
	CODE:
		RETVAL = Mix_GetNumMusicDecoders();
	OUTPUT:
		RETVAL

const char *
mixmus_get_music_decoder( index )
	int index
	CODE:
		RETVAL = Mix_GetMusicDecoder(index);
	OUTPUT:
		RETVAL

#else

int
mixmus_get_num_music_decoders( )
	CODE:
		warn("SDL_mixer >= 1.2.9 needed for getnum_music_decoders()");
		RETVAL = -1;
	OUTPUT:
		RETVAL

const char *
mixmus_get_music_decoder( index )
	int index
	CODE:
		warn("SDL_mixer >= 1.2.9 needed for get_music_decoder( index )");
		RETVAL = "";
	OUTPUT:
		RETVAL

#endif

void
mixmus_mix_audio ( dst, src, len, volume )
	Uint8 *dst
	Uint8 *src
	Uint32 len
	int volume
	CODE:
		SDL_MixAudio(dst,src,len,volume);



Mix_Music *
mixmus_load_MUS ( filename )
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
mixmus_free_music ( music )
	Mix_Music *music
	CODE:
		Mix_FreeMusic(music);

void
mixmus_hook_music ( func, arg )
	SV *func
	int arg
	CODE:
		perl_for_cb = PERL_GET_CONTEXT;
	
		if (cb == (SV*)NULL)
            cb = newSVsv(func);
        else
            SvSetSV(cb, func);

		void *arg2   = safemalloc(sizeof(int));
		*(int*) arg2 = arg;
		Mix_HookMusic(&mix_func, arg2);

void
mixmus_hook_music_finished( func )
	void *func
	CODE:
		mix_music_finished_cv = func;
		Mix_HookMusicFinished(sdl_perl_music_finished_callback);

int
mixmus_get_music_hook_data()
	CODE:
		RETVAL = *(int*)Mix_GetMusicHookData();
	OUTPUT:
		RETVAL

int
mixmus_play_music ( music, loops )
	Mix_Music *music
	int loops
	CODE:
		RETVAL = Mix_PlayMusic(music,loops);
	OUTPUT:
		RETVAL

int
mixmus_fade_in_music ( music, loops, ms )
	Mix_Music *music
	int loops
	int ms
	CODE:
		RETVAL = Mix_FadeInMusic(music,loops,ms);
	OUTPUT:
		RETVAL

int
mixmus_fade_in_music_pos ( music, loops, ms, position )
	Mix_Music *music
	int loops
	int ms
	double position
	CODE:
		RETVAL = Mix_FadeInMusicPos(music,loops,ms,position);
	OUTPUT:
		RETVAL

int
mixmus_volume_music ( volume )
	int volume
	CODE:
		RETVAL = Mix_VolumeMusic(volume);
	OUTPUT:
		RETVAL

int
mixmus_halt_music ()
	CODE:
		RETVAL = Mix_HaltMusic();
	OUTPUT:
		RETVAL

int
mixmus_fade_out_music ( ms )
	int ms
	CODE:
		RETVAL = Mix_FadeOutMusic(ms);
	OUTPUT:
		RETVAL

Mix_Fading
mixmus_fading_music()
	CODE:
		RETVAL = Mix_FadingMusic();
	OUTPUT:
		RETVAL

void
mixmus_pause_music ()
	CODE:
		Mix_PauseMusic();

void
mixmus_resume_music ()
	CODE:
		Mix_ResumeMusic();

void
mixmus_rewind_music ()
	CODE:
		Mix_RewindMusic();

int
mixmus_paused_music ()
	CODE:
		RETVAL = Mix_PausedMusic();
	OUTPUT:
		RETVAL

int
mixmus_playing_music()
	CODE:
		RETVAL = Mix_PlayingMusic();
	OUTPUT:
		RETVAL

int
mixmus_set_music_position( position )
	double position
	CODE:
		RETVAL = Mix_SetMusicPosition(position);
	OUTPUT:
		RETVAL

int
mixmus_get_music_type( music = NULL )
	Mix_Music * music
	CODE:
		RETVAL = Mix_GetMusicType( music );
	OUTPUT:
		RETVAL

int
mixmus_set_music_cmd( cmd = NULL )
	char *cmd
	CODE:
		RETVAL = Mix_SetMusicCMD( cmd );
	OUTPUT:
		RETVAL

#endif
