#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "defines.h"

#include <SDL.h>

#ifdef HAVE_SDL_MIXER
#include <SDL_mixer.h>

char *cb  = NULL;
char *fcb = NULL;

void mix_func(void *udata, Uint8 *stream, int len)
{
	PERL_SET_CONTEXT(parent_perl);
	{
		dSP;                                       /* initialize stack pointer          */
		ENTER;                                     /* everything created after here     */
		SAVETMPS;                                  /* ...is a temporary variable.       */

		PUSHMARK(SP);                              /* remember the stack pointer        */
		XPUSHs(sv_2mortal(newSViv(*(int*)udata))); /* push something onto the stack     */
		XPUSHs(sv_2mortal(newSViv(len)));
		*(int*)udata = *(int*)udata + len;
		PUTBACK;                                   /* make local stack pointer global   */

		if(cb != NULL)
		{
			int count = call_pv(cb, G_ARRAY);      /* call the function                 */
			SPAGAIN;                               /* refresh stack pointer             */

			if(count == len + 1)
			{
				int i;
				for(i=0; i<len; i++)
					stream[i] = POPi;              /* pop the return value from stack   */
			}

			PUTBACK;
		}

		FREETMPS;                                  /* free that return value            */
		LEAVE;                                     /* ...and the XPUSHed "mortal" args. */
	}
}

void mix_finished(void)
{
	PERL_SET_CONTEXT(parent_perl);
	{
		dSP;                                       /* initialize stack pointer          */
		PUSHMARK(SP);                              /* remember the stack pointer        */

		if(fcb != NULL)
			call_pv(fcb, G_DISCARD|G_VOID);        /* call the function                 */
	}
}

#endif

MODULE = SDL::Mixer::Music 	PACKAGE = SDL::Mixer::Music    PREFIX = mixmus_

=for documentation

SDL_mixer bindings

See: http:/*www.libsdl.org/projects/SDL_mixer/docs/SDL_mixer.html */

=cut

#ifdef HAVE_SDL_MIXER

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
		warn("SDL_mixer >= 1.2.9 needed for SDL::Mixer::Music::getnum_music_decoders()");
		XSRETURN_UNDEF;
	OUTPUT:
		RETVAL

const char *
mixmus_get_music_decoder( index )
	int index
	CODE:
		warn("SDL_mixer >= 1.2.9 needed for SDL::Mixer::Music::get_music_decoder( index )");
		XSRETURN_UNDEF;
	OUTPUT:
		RETVAL

#endif

Mix_Music *
mixmus_load_MUS( filename )
	char *filename
	PREINIT:
		char * CLASS = "SDL::Mixer::MixMusic";
		Mix_Music *mixmusic;
	CODE:
		mixmusic = Mix_LoadMUS(filename);
		if (mixmusic == NULL)
			fprintf(stderr, "Could not load %s\n", filename);
		RETVAL = mixmusic;
	OUTPUT:
		RETVAL

#if VERSION_ATLEAST(SDL_MIXER_MAJOR_VERSION, SDL_MIXER_MINOR_VERSION, SDL_MIXER_PATCHLEVEL, 1, 2, 7)

Mix_Music *
mixmus_load_MUS_RW( rw )
	SDL_RWops *rw
	PREINIT:
		char * CLASS = "SDL::Mixer::MixMusic";
		Mix_Music *mixmusic;
	CODE:
		mixmusic = Mix_LoadMUS_RW(rw);
		if (mixmusic == NULL)
			fprintf(stderr, "Could not load SDL::RWOp object\n");
		RETVAL = mixmusic;
	OUTPUT:
		RETVAL

#else

Mix_Music *
mixmus_load_MUS_RW( rw )
	SDL_RWops *rw
	CODE:
		warn("SDL_mixer >= 1.2.7 needed for SDL::Mixer::Music::load_MUS_RW( rw )");
		XSRETURN_UNDEF;
	OUTPUT:
		RETVAL

#endif

void
mixmus_free_music( music )
	Mix_Music *music
	CODE:
		Mix_FreeMusic(music);

#ifdef USE_THREADS

void
mixmus_hook_music( func = NULL, arg = 0 )
	char *func
	int arg
	PREINIT:
		void *arg2;
	CODE:
		if(func != NULL)
		{
			parent_perl  = PERL_GET_CONTEXT;
			cb           = func;
			arg2         = safemalloc(sizeof(int));
			*(int *)arg2 = arg;
			Mix_HookMusic(&mix_func, arg2);
		}
		else
		{
			Mix_HookMusic(NULL, NULL);
			arg2       = Mix_GetMusicHookData();
			if(arg2 != NULL)
				safefree(arg2);
		}

void
mixmus_hook_music_finished( func = NULL )
	char *func
	CODE:
		if(func != NULL)
		{
			parent_perl  = PERL_GET_CONTEXT;
			fcb = func;
			Mix_HookMusicFinished(&mix_finished);
		}
		else
			Mix_HookMusicFinished(NULL);

#else

void
mixmus_hook_music( func = NULL, arg = 0 )
	char *func
	int arg
	CODE:
		warn("Perl need to be compiled with 'useithreads' for SDL::Mixer::Music::hook_music( func, arg )");

void
mixmus_hook_music_finished( func = NULL )
	char *func
	CODE:
		warn("Perl need to be compiled with 'useithreads' for SDL::Mixer::Music::hook_music_finished( func )");

#endif

int
mixmus_get_music_hook_data()
	CODE:
		RETVAL = *(int*)Mix_GetMusicHookData();
	OUTPUT:
		RETVAL

int
mixmus_play_music( music, loops )
	Mix_Music *music
	int loops
	CODE:
		RETVAL = Mix_PlayMusic(music,loops);
	OUTPUT:
		RETVAL

int
mixmus_fade_in_music( music, loops, ms )
	Mix_Music *music
	int loops
	int ms
	CODE:
		RETVAL = Mix_FadeInMusic(music,loops,ms);
	OUTPUT:
		RETVAL

int
mixmus_fade_in_music_pos( music, loops, ms, position )
	Mix_Music *music
	int loops
	int ms
	double position
	CODE:
		RETVAL = Mix_FadeInMusicPos(music,loops,ms,position);
	OUTPUT:
		RETVAL

int
mixmus_volume_music( volume = -1 )
	int volume
	CODE:
		RETVAL = Mix_VolumeMusic(volume);
	OUTPUT:
		RETVAL

int
mixmus_halt_music()
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

void
mixmus_DESTROY( music )
	Mix_Music *music
	CODE:
		Mix_FreeMusic(music);

#endif
