//
// SDL.xs
//
// Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
//
// ------------------------------------------------------------------------------
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
// ------------------------------------------------------------------------------
//
// Please feel free to send questions, suggestions or improvements to:
//
//	David J. Goehrig
//	dgoehrig@cpan.org
//

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

#ifdef HAVE_GL
#include <gl.h>
#endif

#ifdef HAVE_GLU
#include <glu.h>
#endif

#ifdef HAVE_SDL_SOUND
#include <SDL_sound.h>
#endif


//#ifdef HAVE_SDL_MIXER
//#include <SDL_mixer.h>
//void (*mix_music_finished_cv)();
//#endif

#ifdef HAVE_SMPEG
#include <smpeg/smpeg.h>
//#ifdef HAVE_SDL_MIXER
//static int sdl_perl_use_smpeg_audio = 0;
//#endif
#endif

#ifdef HAVE_SDL_SVG
#include <SDL_svg.h>
#endif

#ifdef HAVE_SDL_TTF
#include <SDL_ttf.h>
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

void
windows_force_driver ()
{
   const SDL_version *version =  SDL_Linked_Version();
	if(version->patch == 14)
	{
		putenv("SDL_VIDEODRIVER=directx");
	}
	else
	{
		putenv("SDL_VIDEODRIVER=windib");
	}
}

Uint32 
sdl_perl_timer_callback ( Uint32 interval, void* param )
{
	Uint32 retval;
	int back;
	SV* cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)param;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(interval)));
	PUTBACK;

	if (0 != (back = call_sv(cmd,G_SCALAR))) {
		SPAGAIN;
		if (back != 1 ) Perl_croak (aTHX_ "Timer Callback failed!");
		retval = POPi;	
	} else {
		Perl_croak(aTHX_ "Timer Callback failed!");
	}

	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT
	
	return retval;
}

void
sdl_perl_audio_callback ( void* data, Uint8 *stream, int len )
{
	SV *cmd;
	ENTER_TLS_CONTEXT
	dSP;

	cmd = (SV*)data;

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs(sv_2mortal(newSViv(PTR2IV(stream))));
	XPUSHs(sv_2mortal(newSViv(len)));
	PUTBACK;

	call_sv(cmd,G_VOID|G_DISCARD);
	
	PUTBACK;
	FREETMPS;
	LEAVE;

	LEAVE_TLS_CONTEXT	
}

#define INIT_NS_APPLICATION
#define QUIT_NS_APPLICATION


void
sdl_perl_atexit (void)
{
	QUIT_NS_APPLICATION	
	SDL_Quit();
}

void boot_SDL();
void boot_SDL__OpenGL();

XS(boot_SDL_perl)
{
	GET_TLS_CONTEXT
	boot_SDL();
}

MODULE = SDL_perl	PACKAGE = SDL
PROTOTYPES : DISABLE


# workaround as:
#  extern DECLSPEC void SDLCALL SDL_SetError(const char *fmt, ...);
void
set_error_real (fmt, ...)
	char *fmt
	CODE:
		SDL_SetError(fmt, items);

char *
get_error ()
	CODE:
		RETVAL = SDL_GetError();
	OUTPUT:
		RETVAL

void
clear_error ()
	CODE:
		SDL_ClearError();

int
init ( flags )
	Uint32 flags
	CODE:
		INIT_NS_APPLICATION
#if defined WINDOWS || WIN32
		windows_force_driver();
#endif
		RETVAL = SDL_Init(flags);
#ifdef HAVE_TLS_CONTEXT
		Perl_call_atexit(PERL_GET_CONTEXT, (void*)sdl_perl_atexit,0);
#else
		atexit(sdl_perl_atexit);
#endif
	OUTPUT:
		RETVAL

int
init_sub_system ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_InitSubSystem(flags);
	OUTPUT:
		RETVAL

void
quit_sub_system ( flags )
	Uint32 flags
	CODE:
		SDL_QuitSubSystem(flags);

void
quit ()
	CODE:
		QUIT_NS_APPLICATION
		SDL_Quit();

int
was_init ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_WasInit(flags);
	OUTPUT:
		RETVAL

SDL_version *
version ()
	PREINIT:
		char * CLASS = "SDL::Version";
		SDL_version *version;
	CODE:
	 	version = (SDL_version *) safemalloc (sizeof(SDL_version));
		SDL_VERSION(version);
		RETVAL = version;
	OUTPUT:
		RETVAL

SDL_version *
linked_version ()
	PREINIT:
		char * CLASS = "SDL::Version";
	CODE:
		RETVAL = (SDL_version *) SDL_Linked_Version();
	OUTPUT:
		RETVAL

int
putenv (variable)
	char *variable
	CODE:
		RETVAL = SDL_putenv(variable);
	OUTPUT:
		RETVAL

char*
getenv (name)
	char *name
	CODE:
		RETVAL = SDL_getenv(name);
	OUTPUT:
		RETVAL

void
delay ( ms )
	int ms
	CODE:
		SDL_Delay(ms);

Uint32
get_ticks ()
	CODE:
		RETVAL = SDL_GetTicks();
	OUTPUT:
		RETVAL

int
set_timer ( interval, callback )
	Uint32 interval
	SDL_TimerCallback callback
	CODE:
		RETVAL = SDL_SetTimer(interval,callback);
	OUTPUT:
		RETVAL

SDL_TimerID
AddTimer ( interval, callback, param )
	Uint32 interval
	SDL_NewTimerCallback callback
	void *param
	CODE:
		RETVAL = SDL_AddTimer(interval,callback,param);
	OUTPUT:
		RETVAL

SDL_NewTimerCallback
PerlTimerCallback ()
	CODE:
		RETVAL = sdl_perl_timer_callback;
	OUTPUT:
		RETVAL  

SDL_TimerID
NewTimer ( interval, cmd )
	Uint32 interval
	void *cmd
	CODE:
		RETVAL = SDL_AddTimer(interval,sdl_perl_timer_callback,cmd);
	OUTPUT:
		RETVAL

Uint32
RemoveTimer ( id )
	SDL_TimerID id
	CODE:
		RETVAL = SDL_RemoveTimer(id);
	OUTPUT:
		RETVAL

char*
AudioDriverName ()
	CODE:
		char name[32];
		RETVAL = SDL_AudioDriverName(name,32);
	OUTPUT:
		RETVAL

#ifdef HAVE_SMPEG

SMPEG_Info *
NewSMPEGInfo()
	CODE:	
		RETVAL = (SMPEG_Info *) safemalloc (sizeof(SMPEG_Info));
	OUTPUT:
		RETVAL

void
FreeSMPEGInfo ( info )
	SMPEG_Info *info
	CODE:	
		safefree(info);

int
SMPEGInfoHasAudio ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->has_audio;
	OUTPUT:
		RETVAL

int
SMPEGInfoHasVideo ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->has_video;
	OUTPUT:
		RETVAL

int
SMPEGInfoWidth ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->width;
	OUTPUT:
		RETVAL

int
SMPEGInfoHeight ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->height;
	OUTPUT:
		RETVAL

int
SMPEGInfoCurrentFrame ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->current_frame;
	OUTPUT:
		RETVAL

double
SMPEGInfoCurrentFPS ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->current_fps;
	OUTPUT:
		RETVAL

int
SMPEGInfoCurrentAudioFrame ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->audio_current_frame;
	OUTPUT:
		RETVAL

int
SMPEGInfoCurrentOffset ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->current_offset;
	OUTPUT:
		RETVAL

int
SMPEGInfoTotalSize ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->total_size;
	OUTPUT:
		RETVAL

double
SMPEGInfoCurrentTime ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->current_time;
	OUTPUT:
		RETVAL

double
SMPEGInfoTotalTime ( info )
	SMPEG_Info* info
	CODE:
		RETVAL = info->total_time;
	OUTPUT:
		RETVAL

char *
SMPEGError ( mpeg )
	SMPEG* mpeg
	CODE:	
		RETVAL = SMPEG_error(mpeg);
	OUTPUT:
		RETVAL

SMPEG*
NewSMPEG ( filename, info, use_audio )
	char* filename
	SMPEG_Info* info
	int use_audio
	CODE:	
//#ifdef HAVE_SDL_MIXER
//		RETVAL = SMPEG_new(filename,info,0);
//#else
		RETVAL = SMPEG_new(filename,info,use_audio);
//#endif
	OUTPUT:
		RETVAL

void
FreeSMPEG ( mpeg )
	SMPEG* mpeg
	CODE:
		SMPEG_delete(mpeg);

void
SMPEGEnableAudio ( mpeg , flag )
	SMPEG* mpeg
	int flag
	CODE:	
		SMPEG_enableaudio(mpeg,flag);
//#ifdef HAVE_SDL_MIXER
//		sdl_perl_use_smpeg_audio = flag;
//#endif

void
SMPEGEnableVideo ( mpeg , flag )
	SMPEG* mpeg
	int flag
	CODE:	
		SMPEG_enablevideo(mpeg,flag);

void
SMPEGSetVolume ( mpeg , volume )
	SMPEG* mpeg
	int volume
	CODE:	
		SMPEG_setvolume(mpeg,volume);

void
SMPEGSetDisplay ( mpeg, dest, surfLock )
	SMPEG* mpeg
	SDL_Surface* dest
	SDL_mutex*  surfLock
	CODE:
		SMPEG_setdisplay(mpeg,dest,surfLock,NULL);

void
SMPEGScaleXY ( mpeg, w, h)
	SMPEG* mpeg
	int w
	int h
	CODE:
		SMPEG_scaleXY(mpeg,w,h);

void
SMPEGScale ( mpeg, scale )
	SMPEG* mpeg
	int scale
	CODE:
		SMPEG_scale(mpeg,scale);

void
SMPEGPlay ( mpeg )
	SMPEG* mpeg
	CODE:
                SDL_AudioSpec audiofmt;
                Uint16 format;
                int freq, channels;
//#ifdef HAVE_SDL_MIXER
//		if  (sdl_perl_use_smpeg_audio ) {
//       			SMPEG_enableaudio(mpeg, 0);
//			Mix_QuerySpec(&freq, &format, &channels);
//			audiofmt.format = format;
//			audiofmt.freq = freq;
//			audiofmt.channels = channels;
//			SMPEG_actualSpec(mpeg, &audiofmt);
//			Mix_HookMusic(SMPEG_playAudioSDL, mpeg);
//			SMPEG_enableaudio(mpeg, 1);
//		}
//#endif
	        SMPEG_play(mpeg);

SMPEGstatus
SMPEGStatus ( mpeg )
	SMPEG* mpeg
	CODE:
		RETVAL = SMPEG_status(mpeg);
	OUTPUT:
		RETVAL

void
SMPEGPause ( mpeg )
	SMPEG* mpeg
	CODE:
		SMPEG_pause(mpeg);

void
SMPEGLoop ( mpeg, repeat )
	SMPEG* mpeg
	int repeat
	CODE:
		SMPEG_loop(mpeg,repeat);

void
SMPEGStop ( mpeg )
	SMPEG* mpeg
	CODE:
		SMPEG_stop(mpeg);
//#ifdef HAVE_SDL_MIXER
//        	Mix_HookMusic(NULL, NULL);
//#endif

void
SMPEGRewind ( mpeg )
	SMPEG* mpeg
	CODE:
		SMPEG_rewind(mpeg);

void
SMPEGSeek ( mpeg, bytes )
	SMPEG* mpeg
	int bytes
	CODE:
		SMPEG_seek(mpeg,bytes);

void
SMPEGSkip ( mpeg, seconds )
	SMPEG* mpeg
	float seconds
	CODE:
		SMPEG_skip(mpeg,seconds);

void
SMPEGSetDisplayRegion ( mpeg, rect )
	SMPEG* mpeg
	SDL_Rect* rect
	CODE:
		SMPEG_setdisplayregion(mpeg,rect->x,rect->y,rect->w,rect->h);

void
SMPEGRenderFrame ( mpeg, frame )
	SMPEG* mpeg
	int frame
	CODE:
		SMPEG_renderFrame(mpeg,frame);

SMPEG_Info *
SMPEGGetInfo ( mpeg )
	SMPEG* mpeg
	CODE:
		RETVAL = (SMPEG_Info *) safemalloc (sizeof(SMPEG_Info));
		SMPEG_getinfo(mpeg,RETVAL);
	OUTPUT:
		RETVAL

#endif



#ifdef HAVE_SDL_SVG

SDL_svg_context *
SVG_Load ( filename )
	char* filename
	CODE:
		RETVAL = SVG_Load(filename);
	OUTPUT:
		RETVAL

SDL_svg_context *
SVG_LoadBuffer ( data, len )
	char* data
	int len
	CODE:
		RETVAL = SVG_LoadBuffer(data,len);
	OUTPUT:
		RETVAL

int
SVG_SetOffset ( source, xoff, yoff )
	SDL_svg_context* source
	double xoff
	double yoff
	CODE:
		RETVAL = SVG_SetOffset(source,xoff,yoff);
	OUTPUT:
		RETVAL

int
SVG_SetScale ( source, xscale, yscale )
	SDL_svg_context* source
	double xscale
	double yscale
	CODE:
		RETVAL = SVG_SetScale(source,xscale,yscale);
	OUTPUT:
		RETVAL

int
SVG_RenderToSurface ( source, x, y, dest )
	SDL_svg_context* source
	int x
	int y
	SDL_Surface* dest;
	CODE:
		RETVAL = SVG_RenderToSurface(source,x,y,dest);
	OUTPUT:
		RETVAL

void
SVG_Free ( source )
	SDL_svg_context* source
	CODE:
		SVG_Free(source);	

void
SVG_Set_Flags ( source, flags )
	SDL_svg_context* source
	Uint32 flags
	CODE:
		SVG_Set_Flags(source,flags);

float
SVG_Width ( source )
	SDL_svg_context* source
	CODE:
		RETVAL = SVG_Width(source);
	OUTPUT:
		RETVAL

float
SVG_HEIGHT ( source )
	SDL_svg_context* source
	CODE:
		RETVAL = SVG_Height(source);
	OUTPUT:
		RETVAL

void
SVG_SetClipping ( source, minx, miny, maxx, maxy )
	SDL_svg_context* source
	int minx
	int miny
	int maxx
	int maxy
	CODE:
		SVG_SetClipping(source,minx,miny,maxx,maxy);

int
SVG_Version ( )
	CODE:
		RETVAL = SVG_Version();
	OUTPUT:
		RETVAL


#endif

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

#ifdef HAVE_SDL_TTF

int
TTF_Init ()
	CODE:
		RETVAL = TTF_Init();
	OUTPUT:
		RETVAL

void
TTF_Quit ()
	CODE:
		TTF_Quit();

TTF_Font*
TTF_OpenFont ( file, ptsize )
	char *file
	int ptsize
	CODE:
		char* CLASS = "SDL::TTF_Font";
		RETVAL = TTF_OpenFont(file,ptsize);
	OUTPUT:
		RETVAL

AV*
TTF_SizeText ( font, text )
	TTF_Font *font
	char *text
	CODE:
		int w,h;
		RETVAL = (AV*)sv_2mortal((SV*)newAV());
		if(TTF_SizeText(font,text,&w,&h))
		{
			printf("TTF error at TTFSizeText: %s \n", TTF_GetError());
			Perl_croak (aTHX_ "TTF error \n");
		}
		else
		{
			av_push(RETVAL,newSViv(w));
			av_push(RETVAL,newSViv(h));
		}
	OUTPUT:
		RETVAL

SDL_Surface*
TTF_RenderText_Blended ( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		char* CLASS = "SDL::Surface";
		RETVAL = TTF_RenderText_Blended(font,text,*fg);
	OUTPUT:
		RETVAL

#endif

MODULE = SDL		PACKAGE = SDL
PROTOTYPES : DISABLE


