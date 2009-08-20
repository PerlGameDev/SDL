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

#ifdef HAVE_SDL_IMAGE
#include <SDL_image.h>
#endif 

#ifdef HAVE_SDL_MIXER
#include <SDL_mixer.h>
void (*mix_music_finished_cv)();
#endif

#ifdef HAVE_SDL_SOUND
#include <SDL_sound.h>
#endif

#ifdef HAVE_SDL_NET
#include <SDL_net.h>
#endif

#ifdef HAVE_SDL_TTF
#include <SDL_ttf.h>
#define TEXT_SOLID	1
#define TEXT_SHADED	2
#define TEXT_BLENDED	4
#define UTF8_SOLID	8
#define UTF8_SHADED	16	
#define UTF8_BLENDED	32
#define UNICODE_SOLID	64
#define UNICODE_SHADED	128
#define UNICODE_BLENDED	256
#endif

#ifdef HAVE_SMPEG
#include <smpeg/smpeg.h>
#ifdef HAVE_SDL_MIXER
static int sdl_perl_use_smpeg_audio = 0;
#endif
#endif

#ifdef HAVE_SDL_GFX
#include <SDL_rotozoom.h>
#include <SDL_gfxPrimitives.h>
#include <SDL_framerate.h>
#include <SDL_imageFilter.h>
#endif

#ifdef HAVE_SDL_SVG
#include <SDL_svg.h>
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

char *
GetError ()
	CODE:
		RETVAL = SDL_GetError();
	OUTPUT:
		RETVAL

int
Init ( flags )
	Uint32 flags
	CODE:
		INIT_NS_APPLICATION
		RETVAL = SDL_Init(flags);
#ifdef HAVE_TLS_CONTEXT
		Perl_call_atexit(PERL_GET_CONTEXT, (void*)sdl_perl_atexit,0);
#else
		atexit(sdl_perl_atexit);
#endif
	OUTPUT:
		RETVAL

int
InitSubSystem ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_InitSubSystem(flags);
	OUTPUT:
		RETVAL

void
QuitSubSystem ( flags )
	Uint32 flags
	CODE:
		SDL_QuitSubSystem(flags);

void
Quit ()
	CODE:
		QUIT_NS_APPLICATION
		SDL_Quit();

int
WasInit ( flags )
	Uint32 flags
	CODE:
		RETVAL = SDL_WasInit(flags);
	OUTPUT:
		RETVAL

void
Delay ( ms )
	int ms
	CODE:
		SDL_Delay(ms);

Uint32
GetTicks ()
	CODE:
		RETVAL = SDL_GetTicks();
	OUTPUT:
		RETVAL

int
SetTimer ( interval, callback )
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

SDL_RWops*
RWFromFile ( file, mode )
	char* file
	char * mode
	CODE:
		RETVAL = SDL_RWFromFile(file,mode);
	OUTPUT:
		RETVAL

SDL_RWops*
RWFromFP ( fp, autoclose )
	FILE* fp
	int autoclose
	CODE:
		RETVAL = SDL_RWFromFP(fp,autoclose);
	OUTPUT:
		RETVAL

SDL_RWops*
RWFromMem ( mem, size )
	char* mem
	int size
	CODE:
		RETVAL = SDL_RWFromMem((void*)mem,size);
	OUTPUT:
		RETVAL

SDL_RWops*
RWFromConstMem ( mem, size )
	const char* mem
	int size
	CODE:
		RETVAL = SDL_RWFromConstMem((const void*)mem,size);
	OUTPUT:
		RETVAL

SDL_RWops*
AllocRW ()
	CODE:
		RETVAL = SDL_AllocRW();
	OUTPUT:
		RETVAL

void
FreeRW ( rw )
	SDL_RWops* rw
	CODE:
		SDL_FreeRW(rw);

int
RWseek ( rw, off, whence )
	SDL_RWops* rw
	int off
	int whence
	CODE:
		RETVAL = SDL_RWseek(rw,off,whence);
	OUTPUT:
		RETVAL

int
RWtell ( rw )
	SDL_RWops* rw
	CODE:
		RETVAL = SDL_RWtell(rw);
	OUTPUT:
		RETVAL

int
RWread ( rw, mem, size, n )
	SDL_RWops* rw
	char* mem
	int size
	int n
	CODE:
		RETVAL = SDL_RWread(rw,mem,size,n);
	OUTPUT:
		RETVAL

int
RWwrite ( rw, mem, size, n )
	SDL_RWops* rw
	char* mem
	int size
	int n
	CODE:
		RETVAL = SDL_RWwrite(rw,mem,size,n);
	OUTPUT:
		RETVAL

int
RWclose ( rw )
	SDL_RWops* rw
	CODE:
		RETVAL = SDL_RWclose(rw);
	OUTPUT:
		RETVAL

int
CDNumDrives ()
	CODE:
		RETVAL = SDL_CDNumDrives();
	OUTPUT:
		RETVAL

char *
CDName ( drive )
	int drive
	CODE:
		RETVAL = strdup(SDL_CDName(drive));
	OUTPUT:
		RETVAL

SDL_CD *
CDOpen ( drive )
	int drive
	CODE:
		RETVAL = SDL_CDOpen(drive);
	OUTPUT:
		RETVAL

Uint8
CDTrackId ( track )
	SDL_CDtrack *track
	CODE:
		RETVAL = track->id;
	OUTPUT:
		RETVAL

Uint8
CDTrackType ( track )
	SDL_CDtrack *track
	CODE:
		RETVAL = track->type;
	OUTPUT:
		RETVAL

Uint16
CDTrackLength ( track )
	SDL_CDtrack *track
	CODE:
		RETVAL = track->length;
	OUTPUT:
		RETVAL

Uint32
CDTrackOffset ( track )
	SDL_CDtrack *track
	CODE:
		RETVAL = track->offset;
	OUTPUT: 
		RETVAL

Uint32
CDStatus ( cd )
	SDL_CD *cd 
	CODE:
		RETVAL = SDL_CDStatus(cd);
	OUTPUT:
		RETVAL

int
CDPlayTracks ( cd, start_track, ntracks, start_frame, nframes )
	SDL_CD *cd
	int start_track
	int ntracks
	int start_frame
	int nframes
	CODE:
		RETVAL = SDL_CDPlayTracks(cd,start_track,start_frame,ntracks,nframes);
	OUTPUT:
		RETVAL

int
CDPlay ( cd, start, length )
	SDL_CD *cd
	int start
	int length
	CODE:
		RETVAL = SDL_CDPlay(cd,start,length);
	OUTPUT:
		RETVAL

int
CDPause ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = SDL_CDPause(cd);
	OUTPUT:
		RETVAL

int
CDResume ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = SDL_CDResume(cd);
	OUTPUT:
		RETVAL

int
CDStop ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = SDL_CDStop(cd);
	OUTPUT:
		RETVAL

int
CDEject ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = SDL_CDEject(cd);
	OUTPUT:
		RETVAL

void
CDClose ( cd )
	SDL_CD *cd
	CODE:
		SDL_CDClose(cd);
	
int
CDId ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = cd->id;
	OUTPUT: 
		RETVAL

int
CDNumTracks ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = cd->numtracks;
	OUTPUT:
		RETVAL

int
CDCurTrack ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = cd->cur_track;
	OUTPUT:
		RETVAL

int
CDCurFrame ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = cd->cur_frame;
	OUTPUT:
		RETVAL

SDL_CDtrack *
CDTrack ( cd, number )
	SDL_CD *cd
	int number
	CODE:
		RETVAL = (SDL_CDtrack *)(cd->track + number);
	OUTPUT:
		RETVAL

void
PumpEvents ()
	CODE:
		SDL_PumpEvents();

int
PushEvent( e )
	SDL_Event *e
	CODE:
		RETVAL = SDL_PushEvent( e );
	OUTPUT:
		RETVAL

SDL_Event *
NewEvent ()
	CODE:	
		RETVAL = (SDL_Event *) safemalloc (sizeof(SDL_Event));
	OUTPUT:
		RETVAL

void
FreeEvent ( e )
	SDL_Event *e
	CODE:
		safefree(e);

int
PollEvent ( e )
	SDL_Event *e
	CODE:
		RETVAL = SDL_PollEvent(e);
	OUTPUT:
		RETVAL

int
WaitEvent ( e )
	SDL_Event *e
	CODE:
		RETVAL = SDL_WaitEvent(e);
	OUTPUT:
		RETVAL

Uint8
EventState ( type, state )
	Uint8 type
	int state
	CODE:
		RETVAL = SDL_EventState(type,state);
	OUTPUT:
		RETVAL 

Uint8
EventType ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->type;
	OUTPUT:
		RETVAL

Uint8
SetEventType ( e, type )
	SDL_Event *e
	Uint8 type
	CODE:
		RETVAL = e->type;
		e->type = type;
	OUTPUT:
		RETVAL

Uint8
ActiveEventGain ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->active.gain;
	OUTPUT:	
		RETVAL

Uint8
ActiveEventState ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->active.state;
	OUTPUT:
		RETVAL

Uint8
KeyEventState( e )
	SDL_Event *e
	CODE:
		RETVAL = e->key.state;
	OUTPUT:
		RETVAL

int
KeyEventSym ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->key.keysym.sym;
	OUTPUT:
		RETVAL

int 
KeyEventMod ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->key.keysym.mod;
	OUTPUT:
		RETVAL

Uint16
KeyEventUnicode ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->key.keysym.unicode;
	OUTPUT:
		RETVAL

Uint8
KeyEventScanCode ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->key.keysym.scancode;
	OUTPUT:
		RETVAL

Uint8
MouseMotionState ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->motion.state;
	OUTPUT:	
		RETVAL

Uint16
MouseMotionX ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->motion.x;
	OUTPUT:
		RETVAL

Uint16
MouseMotionY ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->motion.y;
	OUTPUT:
		RETVAL

Sint16
MouseMotionXrel( e )
	SDL_Event *e
	CODE:
		RETVAL = e->motion.xrel;
	OUTPUT:
		RETVAL

Sint16
MouseMotionYrel ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->motion.yrel;
	OUTPUT:
		RETVAL

Uint8
MouseButtonState ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->button.state;
	OUTPUT:
		RETVAL

Uint8
MouseButton ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->button.button;
	OUTPUT:
		RETVAL

Uint16
MouseButtonX ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->button.x;
	OUTPUT:
		RETVAL

Uint16
MouseButtonY ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->button.y;
	OUTPUT:
		RETVAL

SDL_SysWMmsg *
SysWMEventMsg ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->syswm.msg;
	OUTPUT:
		RETVAL

int
EnableUnicode ( enable )
	int enable
	CODE:
		RETVAL = SDL_EnableUNICODE(enable);
	OUTPUT:
		RETVAL

void
EnableKeyRepeat ( delay, interval )
	int delay
	int interval
	CODE:
		SDL_EnableKeyRepeat(delay,interval);

Uint32
GetModState ()
	CODE:
		RETVAL = SDL_GetModState();
	OUTPUT:
		RETVAL

void
SetModState ( state )
	Uint32 state
	CODE:
		SDL_SetModState(state);

char *
GetKeyName ( sym )
	int sym
	CODE:
		RETVAL = SDL_GetKeyName(sym);
	OUTPUT:
		RETVAL

SDL_Surface *
CreateRGBSurface (flags, width, height, depth, Rmask, Gmask, Bmask, Amask )
	Uint32 flags
	int width
	int height
	int depth
	Uint32 Rmask
	Uint32 Gmask
	Uint32 Bmask
	Uint32 Amask
	CODE:
		RETVAL = SDL_CreateRGBSurface ( flags, width, height,
				depth, Rmask, Gmask, Bmask, Amask );
	OUTPUT:	
		RETVAL


SDL_Surface *
CreateRGBSurfaceFrom (pixels, width, height, depth, pitch, Rmask, Gmask, Bmask, Amask )
	char *pixels
	int width
	int height
	int depth
	int pitch
	Uint32 Rmask
	Uint32 Gmask
	Uint32 Bmask
	Uint32 Amask
	CODE:
		Uint8* pixeldata;
		Uint32 len = pitch * height;
		New(0,pixeldata,len,Uint8);
		Copy(pixels,pixeldata,len,Uint8);
		RETVAL = SDL_CreateRGBSurfaceFrom ( pixeldata, width, height,
				depth, pitch, Rmask, Gmask, Bmask, Amask );
	OUTPUT:	
		RETVAL

#ifdef HAVE_SDL_IMAGE

SDL_Surface *
IMGLoad ( fname )
	char *fname
	CODE:
		RETVAL = IMG_Load(fname);
	OUTPUT:
		RETVAL

#endif

SDL_Surface*
SurfaceCopy ( surface )
	SDL_Surface *surface
	CODE:
		Uint8* pixels;
		Uint32 size = surface->pitch * surface->h;
		New(0,pixels,size,Uint8);
		Copy(surface->pixels,pixels,size,Uint8);
		RETVAL = SDL_CreateRGBSurfaceFrom(pixels,surface->w,surface->h,
			surface->format->BitsPerPixel, surface->pitch,
			surface->format->Rmask, surface->format->Gmask,
			surface->format->Bmask, surface->format->Amask);
	OUTPUT:
		RETVAL

void
FreeSurface ( surface )
	SDL_Surface *surface
	CODE:
		if (surface) {
			Uint8* pixels = surface->pixels;
			Uint32 flags = surface->flags;
			SDL_FreeSurface(surface);
			if (flags & SDL_PREALLOC)
				Safefree(pixels);
		}
	
Uint32
SurfaceFlags ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->flags;
	OUTPUT:
		RETVAL

SDL_Palette *
SurfacePalette ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->palette;
	OUTPUT:
		RETVAL

Uint8
SurfaceBitsPerPixel ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->BitsPerPixel;
	OUTPUT:
		RETVAL

Uint8
SurfaceBytesPerPixel ( surface )
	SDL_Surface *surface
	CODE:	
		RETVAL = surface->format->BytesPerPixel;
	OUTPUT:
		RETVAL

Uint8
SurfaceRshift ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->Rshift;
	OUTPUT:
		RETVAL

Uint8
SurfaceGshift ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->Gshift;
	OUTPUT:
		RETVAL

Uint8
SurfaceBshift ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->Bshift;
	OUTPUT:
		RETVAL

Uint8
SurfaceAshift ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->Ashift;
	OUTPUT:
		RETVAL

Uint32
SurfaceRmask( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->Rmask;
	OUTPUT:
		RETVAL

Uint32
SurfaceGmask ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->Gmask;
	OUTPUT:
		RETVAL

Uint32
SurfaceBmask ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->Bmask;
	OUTPUT:
		RETVAL

Uint32
SurfaceAmask ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->Amask;
	OUTPUT:
		RETVAL

Uint32
SurfaceColorKey ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->colorkey;
	OUTPUT:
		RETVAL

Uint32
SurfaceAlpha( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = surface->format->alpha;
	OUTPUT:
		RETVAL

int
SurfaceW ( surface )
	SDL_Surface *surface
	CODE:	
		RETVAL = surface->w;
	OUTPUT:
		RETVAL

int
SurfaceH ( surface )
	SDL_Surface *surface
	CODE:	
		RETVAL = surface->h;
	OUTPUT:
		RETVAL

Uint16
SurfacePitch ( surface )
	SDL_Surface *surface
	CODE:	
		RETVAL = surface->pitch;
	OUTPUT:
		RETVAL

SV*
SurfacePixels ( surface )
	SDL_Surface *surface
	CODE:	
		RETVAL = newSVpvn(surface->pixels,surface->pitch*surface->h);
	OUTPUT:
		RETVAL

SDL_Color*
SurfacePixel ( surface, x, y, ... )
	SDL_Surface *surface
	Sint32 x
	Sint32 y
	CODE:
		SDL_Color* color;
		int pix,index;
		Uint8 r,g,b,a;
		int bpp = surface->format->BytesPerPixel;
		Uint8* p = (Uint8*)surface->pixels + bpp*x + surface->pitch*y;
		if ( items < 3 || items > 4 ) 
			Perl_croak(aTHX_ "usage: SDL::SurfacePixel(surface,x,y,[color])");
		if ( items == 4) {
			color = (SDL_Color*)SvIV(ST(3));
			pix = SDL_MapRGB(surface->format,color->r,color->g,color->b);
			switch(bpp) {
				case 1:
					*(Uint8*)p = pix;
					break;
				case 2:
					*(Uint16*)p = pix;
					break;
				case 3:
					if (SDL_BYTEORDER == SDL_BIG_ENDIAN) {
						p[0] = (pix >> 16) & 0xff;
						p[1] = (pix >> 8) & 0xff;
						p[2] = pix & 0xff;
					} else {
						p[0] = pix & 0xff;
						p[1] = (pix >> 8) & 0xff;
						p[2] = (pix >> 16) & 0xff;
					}
					break;
				case 4:
					*(Uint32*)p = pix;
					break;
			}
		}
		RETVAL = (SDL_Color *) safemalloc(sizeof(SDL_Color));
		switch(bpp) {
			case 1:
				index = *(Uint8*)p;
				memcpy(RETVAL,&surface->format->palette[index],sizeof(SDL_Color));
				break;
			case 2:
				pix = *(Uint16*)p;
				SDL_GetRGB(pix,surface->format,&r,&g,&b);
				RETVAL->r = r;
				RETVAL->g = g;
				RETVAL->b = b;
				break;
			case 3:
			case 4:
				pix = *(Uint32*)p;
				SDL_GetRGB(pix,surface->format,&r,&g,&b);
				RETVAL->r = r;
				RETVAL->g = g;
				RETVAL->b = b;
				break;
		}
	OUTPUT:
		RETVAL

int
MUSTLOCK ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_MUSTLOCK(surface);
	OUTPUT:
		RETVAL		

int
SurfaceLock ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_LockSurface(surface);
	OUTPUT:
		RETVAL

void
SurfaceUnlock ( surface )
	SDL_Surface *surface
	CODE:
		SDL_UnlockSurface(surface);

SDL_Surface *
GetVideoSurface ()
	CODE:
		RETVAL = SDL_GetVideoSurface();
	OUTPUT:
		RETVAL


HV *
VideoInfo ()
	CODE:
		HV *hv;
		SDL_VideoInfo *info;
		info = (SDL_VideoInfo *) safemalloc ( sizeof(SDL_VideoInfo));
		memcpy(info,SDL_GetVideoInfo(),sizeof(SDL_VideoInfo));
		hv = newHV();
		hv_store(hv,"hw_available",strlen("hw_available"),
			newSViv(info->hw_available),0);
		hv_store(hv,"wm_available",strlen("wm_available"),
			newSViv(info->wm_available),0);
		hv_store(hv,"blit_hw",strlen("blit_hw"),
			newSViv(info->blit_hw),0);
		hv_store(hv,"blit_hw_CC",strlen("blit_hw_CC"),
			newSViv(info->blit_hw_CC),0);
		hv_store(hv,"blit_hw_A",strlen("blit_hw_A"),
			newSViv(info->blit_hw_A),0);
		hv_store(hv,"blit_sw",strlen("blit_sw"),
			newSViv(info->blit_sw),0);
		hv_store(hv,"blit_sw_CC",strlen("blit_sw_CC"),
			newSViv(info->blit_sw_CC),0);
		hv_store(hv,"blit_sw_A",strlen("blit_sw_A"),
			newSViv(info->blit_sw_A),0);
		hv_store(hv,"blit_fill",strlen("blit_fill"),
			newSViv(info->blit_fill),0);
		hv_store(hv,"video_mem",strlen("video_mem"),
			newSViv(info->video_mem),0);
		RETVAL = hv;
	OUTPUT:
		RETVAL

SDL_Rect *
NewRect ( x, y, w, h )
	Sint16 x
	Sint16 y
	Uint16 w
	Uint16 h
	CODE:
		RETVAL = (SDL_Rect *) safemalloc (sizeof(SDL_Rect));
		RETVAL->x = x;
		RETVAL->y = y;
		RETVAL->w = w;
		RETVAL->h = h;
	OUTPUT:
		RETVAL

void
FreeRect ( rect )
	SDL_Rect *rect
	CODE:
		safefree(rect);

Sint16
RectX ( rect, ... )
	SDL_Rect *rect
	CODE:
		if (items > 1 ) rect->x = SvIV(ST(1)); 
		RETVAL = rect->x;
	OUTPUT:
		RETVAL

Sint16
RectY ( rect, ... )
	SDL_Rect *rect
	CODE:
		if (items > 1 ) rect->y = SvIV(ST(1)); 
		RETVAL = rect->y;
	OUTPUT:
		RETVAL

Uint16
RectW ( rect, ... )
	SDL_Rect *rect
	CODE:
		if (items > 1 ) rect->w = SvIV(ST(1)); 
		RETVAL = rect->w;
	OUTPUT:
		RETVAL

Uint16
RectH ( rect, ... )
	SDL_Rect *rect
	CODE:
		if (items > 1 ) rect->h = SvIV(ST(1)); 
		RETVAL = rect->h;
	OUTPUT:
		RETVAL

AV*
ListModes ( format, flags )
	Uint32 flags
	SDL_PixelFormat *format
	CODE:
		SDL_Rect **mode;
		RETVAL = newAV();
		mode = SDL_ListModes(format,flags);
		if (mode == (SDL_Rect**)-1 ) {
			av_push(RETVAL,newSVpv("all",0));
		} else if (! mode ) {
			av_push(RETVAL,newSVpv("none",0));
		} else {
			for (;*mode;mode++) {
				av_push(RETVAL,newSViv(PTR2IV(*mode)));
			}
		}
	OUTPUT:
		RETVAL


SDL_Color *
NewColor ( r, g, b )
	Uint8 r
	Uint8 g
	Uint8 b
	CODE:
		RETVAL = (SDL_Color *) safemalloc(sizeof(SDL_Color));
		RETVAL->r = r;
		RETVAL->g = g;
		RETVAL->b = b;
	OUTPUT:
		RETVAL

Uint8
ColorR ( color, ... )
	SDL_Color *color
	CODE:
		if (items > 1 ) color->r = SvIV(ST(1)); 
		RETVAL = color->r;
	OUTPUT:
		RETVAL

Uint8
ColorG ( color, ... )
	SDL_Color *color
	CODE:
		if (items > 1 ) color->g = SvIV(ST(1)); 
		RETVAL = color->g;
	OUTPUT:
		RETVAL

Uint8
ColorB ( color, ... )
	SDL_Color *color
	CODE:
		if (items > 1 ) color->b = SvIV(ST(1)); 
		RETVAL = color->b;
	OUTPUT:
		RETVAL

void
FreeColor ( color )
	SDL_Color *color
	CODE:
		return; safefree(color);

SDL_Palette *
NewPalette ( number )
	int number
	CODE:
		RETVAL = (SDL_Palette *)safemalloc(sizeof(SDL_Palette));
		RETVAL->colors = (SDL_Color *)safemalloc(number * 
						sizeof(SDL_Color));
		RETVAL->ncolors = number;
	OUTPUT:
		RETVAL

int
PaletteNColors ( palette, ... )
	SDL_Palette *palette
	CODE:
		if ( items > 1 ) palette->ncolors = SvIV(ST(1));
		RETVAL = palette->ncolors;
	OUTPUT:
		RETVAL

SDL_Color *
PaletteColors ( palette, index, ... )
	SDL_Palette *palette
	int index
	CODE:
		if ( items > 2 ) {
			palette->colors[index].r = SvUV(ST(2)); 
			palette->colors[index].g = SvUV(ST(3)); 
			palette->colors[index].b = SvUV(ST(4)); 
		}
		RETVAL = (SDL_Color *)(palette->colors + index);
	OUTPUT:
		RETVAL

int
VideoModeOK ( width, height, bpp, flags )
	int width
	int height
	int bpp
	Uint32 flags
	CODE:
		RETVAL = SDL_VideoModeOK(width,height,bpp,flags);
	OUTPUT:
		RETVAL

SDL_Surface *
SetVideoMode ( width, height, bpp, flags )
	int width
	int height
	int bpp
	Uint32 flags
	CODE:
		RETVAL = SDL_SetVideoMode(width,height,bpp,flags);
	OUTPUT:
		RETVAL

void
UpdateRect ( surface, x, y, w ,h )
	SDL_Surface *surface
	int x
	int y
	int w
	int h
	CODE:
		SDL_UpdateRect(surface,x,y,w,h);

void
UpdateRects ( surface, ... )
	SDL_Surface *surface
	CODE:
		SDL_Rect *rects, *temp;
		int num_rects,i;
		if ( items < 2 ) return;
		num_rects = items - 1;	
		rects = (SDL_Rect *)safemalloc(sizeof(SDL_Rect)*items);
		for(i=0;i<num_rects;i++) {
			temp = (SDL_Rect *)SvIV(ST(i+1));
			rects[i].x = temp->x;
			rects[i].y = temp->y;
			rects[i].w = temp->w;
			rects[i].h = temp->h;
		} 
		SDL_UpdateRects(surface,num_rects,rects);
		safefree(rects);

int
Flip ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_Flip(surface);
	OUTPUT:
		RETVAL

int
SetColors ( surface, start, ... )
	SDL_Surface *surface
	int start
	CODE:
		SDL_Color *colors,*temp;
		int i, length;
		if ( items < 3 ) { RETVAL = 0;	goto all_done; }
		length = items - 2;
		colors = (SDL_Color *)safemalloc(sizeof(SDL_Color)*(length+1));
		for ( i = 0; i < length ; i++ ) {
			temp = (SDL_Color *)SvIV(ST(i+2));
			colors[i].r = temp->r;
			colors[i].g = temp->g;
			colors[i].b = temp->b;
		}
		RETVAL = SDL_SetColors(surface, colors, start, length );
		safefree(colors);
all_done:
	OUTPUT:	
		RETVAL

Uint32
MapRGB ( surface, r, g, b )
	SDL_Surface *surface
	Uint8 r
	Uint8 g
	Uint8 b
	CODE:
		RETVAL = SDL_MapRGB(surface->format,r,g,b);
	OUTPUT:
		RETVAL

Uint32
MapRGBA ( surface, r, g, b, a )
	SDL_Surface *surface
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = SDL_MapRGBA(surface->format,r,g,b,a);
	OUTPUT:
		RETVAL

AV *
GetRGB ( surface, pixel )
	SDL_Surface *surface
	Uint32 pixel
	CODE:
		Uint8 r,g,b;
		SDL_GetRGB(pixel,surface->format,&r,&g,&b);
		RETVAL = newAV();
		av_push(RETVAL,newSViv(r));
		av_push(RETVAL,newSViv(g));
		av_push(RETVAL,newSViv(b));
	OUTPUT:
		RETVAL

AV *
GetRGBA ( surface, pixel )
	SDL_Surface *surface
	Uint32 pixel
	CODE:
		Uint8 r,g,b,a;
		SDL_GetRGBA(pixel,surface->format,&r,&g,&b,&a);
		RETVAL = newAV();
		av_push(RETVAL,newSViv(r));
		av_push(RETVAL,newSViv(g));
		av_push(RETVAL,newSViv(b));
		av_push(RETVAL,newSViv(a));
	OUTPUT:
		RETVAL

int
SaveBMP ( surface, filename )
	SDL_Surface *surface
	char *filename
	CODE:
		RETVAL = SDL_SaveBMP(surface,filename);
	OUTPUT:
		RETVAL	

int
SetColorKey ( surface, flag, key )
	SDL_Surface *surface
	Uint32 flag
	SDL_Color *key
	CODE:
		Uint32 pixel = SDL_MapRGB(surface->format,key->r,key->g,key->b);
		RETVAL = SDL_SetColorKey(surface,flag,pixel);
	OUTPUT:
		RETVAL

int
SetAlpha ( surface, flag, alpha )
	SDL_Surface *surface
	Uint32 flag
	Uint8 alpha
	CODE:
		RETVAL = SDL_SetAlpha(surface,flag,alpha);
	OUTPUT:
		RETVAL

SDL_Surface *
DisplayFormat ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_DisplayFormat(surface);
	OUTPUT:
		RETVAL

SDL_Surface*
DisplayFormatAlpha ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_DisplayFormatAlpha(surface);
	OUTPUT:
		RETVAL

SDL_Surface*
ConvertRGB ( surface )
	SDL_Surface * surface
	CODE:
		SDL_PixelFormat fmt;
		fmt.palette = NULL;
		fmt.BitsPerPixel = 24;
		fmt.BytesPerPixel = 3;
		fmt.Rmask = 0x000000ff;
		fmt.Gmask = 0x0000ff00;
		fmt.Bmask = 0x00ff0000;
		fmt.Amask = 0x00000000;
		fmt.Rloss = 0;
		fmt.Gloss = 0;
		fmt.Bloss = 0;
		fmt.Aloss = 0;
		fmt.Rshift = 0;
		fmt.Gshift = 8;
		fmt.Bshift = 16;
		fmt.Ashift = 24;
		fmt.colorkey = 0;
		fmt.alpha = 0;
		RETVAL = SDL_ConvertSurface(surface,&fmt,surface->flags);
	OUTPUT:
		RETVAL

SDL_Surface* 
ConvertRGBA ( surface )
	SDL_Surface * surface
	CODE:
		SDL_PixelFormat fmt;
		fmt.palette = NULL;
		fmt.BitsPerPixel = 32;
		fmt.BytesPerPixel = 4;
		fmt.Rmask = 0x000000ff;
		fmt.Gmask = 0x0000ff00;
		fmt.Bmask = 0x00ff0000;
		fmt.Amask = 0xff000000;
		fmt.Rloss = 0;
		fmt.Gloss = 0;
		fmt.Bloss = 0;
		fmt.Aloss = 0;
		fmt.Rshift = 0;
		fmt.Gshift = 8;
		fmt.Bshift = 16;
		fmt.Ashift = 24;
		fmt.colorkey = 0;
		fmt.alpha = 0;
		RETVAL = SDL_ConvertSurface(surface,&fmt,surface->flags);
	OUTPUT:
		RETVAL

int
BlitSurface ( src, src_rect, dest, dest_rect )
	SDL_Surface *src
	SDL_Rect *src_rect
	SDL_Surface *dest
	SDL_Rect *dest_rect
	CODE:
		RETVAL = SDL_BlitSurface(src,src_rect,dest,dest_rect);
	OUTPUT:
		RETVAL

int
FillRect ( dest, dest_rect, color )
	SDL_Surface *dest
	SDL_Rect *dest_rect
	SDL_Color *color
	CODE:
		Uint32 pixel = SDL_MapRGB(dest->format,color->r,color->g,color->b);
		RETVAL = SDL_FillRect(dest,dest_rect,pixel);
	OUTPUT:
		RETVAL

Uint8
GetAppState ()
	CODE:
		RETVAL = SDL_GetAppState();
	OUTPUT:
		RETVAL


void
WMSetCaption ( title, icon )
	char *title
	char *icon
	CODE:
		SDL_WM_SetCaption(title,icon);

AV *
WMGetCaption ()
	CODE:
		char *title,*icon;
		SDL_WM_GetCaption(&title,&icon);
		RETVAL = newAV();
		av_push(RETVAL,newSVpv(title,0));
		av_push(RETVAL,newSVpv(icon,0));
	OUTPUT:
		RETVAL

void
WMSetIcon ( icon )
	SDL_Surface *icon
	CODE:
		SDL_WM_SetIcon(icon,NULL);

void
WarpMouse ( x, y )
	Uint16 x
	Uint16 y
	CODE:
		SDL_WarpMouse(x,y);

AV*
GetMouseState ()
	CODE:
		Uint8 mask;
		int x;
		int y;
		mask = SDL_GetMouseState(&x,&y);
		RETVAL = newAV();
		av_push(RETVAL,newSViv(mask));
		av_push(RETVAL,newSViv(x));
		av_push(RETVAL,newSViv(y));
	OUTPUT:
		RETVAL	

AV*
GetRelativeMouseState ()
	CODE:
		Uint8 mask;
		int x;
		int y;
		mask = SDL_GetRelativeMouseState(&x,&y);
		RETVAL = newAV();
		av_push(RETVAL,newSViv(mask));
		av_push(RETVAL,newSViv(x));
		av_push(RETVAL,newSViv(y));
	OUTPUT:
		RETVAL	

SDL_Cursor *
NewCursor ( data, mask, x ,y )
	SDL_Surface *data
	SDL_Surface *mask
	int x
	int y
	CODE:
		RETVAL = SDL_CreateCursor((Uint8*)data->pixels,
				(Uint8*)mask->pixels,data->w,data->h,x,y);
	OUTPUT:
		RETVAL

void
FreeCursor ( cursor )
	SDL_Cursor *cursor
	CODE:
		SDL_FreeCursor(cursor);

void
SetCursor ( cursor )
	SDL_Cursor *cursor
	CODE:
		SDL_SetCursor(cursor);

SDL_Cursor *
GetCursor ()
	CODE:
		RETVAL = SDL_GetCursor();
	OUTPUT:
		RETVAL

int
ShowCursor ( toggle )
	int toggle
	CODE:
		RETVAL = SDL_ShowCursor(toggle);
	OUTPUT: 
		RETVAL

SDL_AudioSpec *
NewAudioSpec ( freq, format, channels, samples )
	int freq
	Uint16 format
	Uint8 channels
	Uint16 samples
	CODE:
		RETVAL = (SDL_AudioSpec *)safemalloc(sizeof(SDL_AudioSpec));
		RETVAL->freq = freq;
		RETVAL->format = format;
		RETVAL->channels = channels;
		RETVAL->samples = samples;
	OUTPUT:
		RETVAL

void
FreeAudioSpec ( spec )
	SDL_AudioSpec *spec
	CODE:
		safefree(spec);

SDL_AudioCVT *
NewAudioCVT ( src_format, src_channels, src_rate, dst_format, dst_channels, dst_rate)
	Uint16 src_format
	Uint8 src_channels
	int src_rate
	Uint16 dst_format
	Uint8 dst_channels
	int dst_rate
	CODE:
		RETVAL = (SDL_AudioCVT *)safemalloc(sizeof(SDL_AudioCVT));
		if (SDL_BuildAudioCVT(RETVAL,src_format, src_channels, src_rate,
			dst_format, dst_channels, dst_rate)) { 
			safefree(RETVAL); RETVAL = NULL; }
	OUTPUT:
		RETVAL

void
FreeAudioCVT ( cvt )
	SDL_AudioCVT *cvt
	CODE:
		safefree(cvt);

int
ConvertAudioData ( cvt, data, len )
	SDL_AudioCVT *cvt
	Uint8 *data
	int len
	CODE:
		cvt->len = len;
		cvt->buf = (Uint8*) safemalloc(cvt->len*cvt->len_mult);
		memcpy(cvt->buf,data,cvt->len);
		RETVAL = SDL_ConvertAudio(cvt);
	OUTPUT:
		RETVAL			

int
OpenAudio ( spec, callback )
	SDL_AudioSpec *spec
	SV* callback
	CODE:
		spec->userdata = (void*)callback;
		spec->callback = sdl_perl_audio_callback;
		RETVAL = SDL_OpenAudio(spec,NULL);
	OUTPUT:
		RETVAL

Uint32
GetAudioStatus ()
	CODE:
		RETVAL = SDL_GetAudioStatus ();
	OUTPUT:
		RETVAL

void
PauseAudio ( p_on )
	int p_on
	CODE:
		SDL_PauseAudio(p_on);
	
void
LockAudio ()
	CODE:
		SDL_LockAudio();

void
UnlockAudio ()
	CODE:
		SDL_UnlockAudio();

void
CloseAudio ()
	CODE:
		SDL_CloseAudio();

void
FreeWAV ( buf )
	Uint8 *buf
	CODE:
		SDL_FreeWAV(buf);

AV *
LoadWAV ( filename, spec )
	char *filename
	SDL_AudioSpec *spec
	CODE:
		SDL_AudioSpec *temp;
		Uint8 *buf;
		Uint32 len;

		RETVAL = newAV();
		temp = SDL_LoadWAV(filename,spec,&buf,&len);
		if ( ! temp ) goto error;
		av_push(RETVAL,newSViv(PTR2IV(temp)));
		av_push(RETVAL,newSViv(PTR2IV(buf)));
		av_push(RETVAL,newSViv(len));
error:
	OUTPUT:
		RETVAL
	
#ifdef HAVE_SDL_MIXER

void
MixAudio ( dst, src, len, volume )
	Uint8 *dst
	Uint8 *src
	Uint32 len
	int volume
	CODE:
		SDL_MixAudio(dst,src,len,volume);

int
MixOpenAudio ( frequency, format, channels, chunksize )
	int frequency
	Uint16 format
	int channels
	int chunksize	
	CODE:
		RETVAL = Mix_OpenAudio(frequency, format, channels, chunksize);
	OUTPUT:
		RETVAL

int
MixAllocateChannels ( number )
	int number
	CODE:
		RETVAL = Mix_AllocateChannels(number);
	OUTPUT:
		RETVAL

AV *
MixQuerySpec ()
	CODE:
		int freq, channels, status;
		Uint16 format;
		status = Mix_QuerySpec(&freq,&format,&channels);
		RETVAL = newAV();
		av_push(RETVAL,newSViv(status));
		av_push(RETVAL,newSViv(freq));
		av_push(RETVAL,newSViv(format));
		av_push(RETVAL,newSViv(channels));
	OUTPUT:
		RETVAL

Mix_Chunk *
MixLoadWAV ( filename )
	char *filename
	CODE:
		RETVAL = Mix_LoadWAV(filename);
	OUTPUT:
		RETVAL

Mix_Music *
MixLoadMusic ( filename )
	char *filename
	CODE:
		RETVAL = Mix_LoadMUS(filename);
	OUTPUT:
		RETVAL

Mix_Chunk *
MixQuickLoadWAV ( buf )
	Uint8 *buf
	CODE:
		RETVAL = Mix_QuickLoad_WAV(buf);
	OUTPUT:
		RETVAL

void
MixFreeChunk( chunk )
	Mix_Chunk *chunk
	CODE:
		Mix_FreeChunk(chunk);

void
MixFreeMusic ( music )
	Mix_Music *music
	CODE:
		Mix_FreeMusic(music);

void
MixSetPostMixCallback ( func, arg )
	void *func
	void *arg
	CODE:
		Mix_SetPostMix(func,arg);

void*
PerlMixMusicHook ()
	CODE:
		RETVAL = sdl_perl_music_callback;
	OUTPUT:
		RETVAL

void
MixSetMusicHook ( func, arg )
	void *func
	void *arg
	CODE:
		Mix_HookMusic(func,arg);

void
MixSetMusicFinishedHook ( func )
	void *func
	CODE:
		mix_music_finished_cv = func;
		Mix_HookMusicFinished(sdl_perl_music_finished_callback);

void *
MixGetMusicHookData ()
	CODE:
		RETVAL = Mix_GetMusicHookData();
	OUTPUT:
		RETVAL

int
MixReverseChannels ( number )
	int number
	CODE:
		RETVAL = Mix_ReserveChannels ( number );
	OUTPUT:
		RETVAL

int
MixGroupChannel ( which, tag )
	int which
	int tag
	CODE:
		RETVAL = Mix_GroupChannel(which,tag);
	OUTPUT:
		RETVAL

int
MixGroupChannels ( from, to, tag )
	int from
	int to
	int tag
	CODE:
		RETVAL = Mix_GroupChannels(from,to,tag);
	OUTPUT:
		RETVAL

int
MixGroupAvailable ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupAvailable(tag);
	OUTPUT:
		RETVAL

int
MixGroupCount ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupCount(tag);
	OUTPUT:
		RETVAL

int
MixGroupOldest ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupOldest(tag);
	OUTPUT:
		RETVAL

int
MixGroupNewer ( tag )
	int tag
	CODE:
		RETVAL = Mix_GroupNewer(tag);
	OUTPUT:
		RETVAL

int
MixPlayChannel ( channel, chunk, loops )
	int channel
	Mix_Chunk *chunk
	int loops
	CODE:
		RETVAL = Mix_PlayChannel(channel,chunk,loops);
	OUTPUT:
		RETVAL

int
MixPlayChannelTimed ( channel, chunk, loops, ticks )
	int channel
	Mix_Chunk *chunk
	int loops
	int ticks
	CODE:
		RETVAL = Mix_PlayChannelTimed(channel,chunk,loops,ticks);
	OUTPUT:
		RETVAL

int
MixPlayMusic ( music, loops )
	Mix_Music *music
	int loops
	CODE:
		RETVAL = Mix_PlayMusic(music,loops);
	OUTPUT:
		RETVAL

int
MixFadeInChannel ( channel, chunk, loops, ms )
	int channel
	Mix_Chunk *chunk
	int loops
	int ms
	CODE:
		RETVAL = Mix_FadeInChannel(channel,chunk,loops,ms);
	OUTPUT:
		RETVAL

int
MixFadeInChannelTimed ( channel, chunk, loops, ms, ticks )
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
MixFadeInMusic ( music, loops, ms )
	Mix_Music *music
	int loops
	int ms
	CODE:
		RETVAL = Mix_FadeInMusic(music,loops,ms);
	OUTPUT:
		RETVAL

int
MixVolume ( channel, volume )
	int channel
	int volume
	CODE:	
		RETVAL = Mix_Volume(channel,volume);
	OUTPUT:
		RETVAL

int
MixVolumeChunk ( chunk, volume )
	Mix_Chunk *chunk
	int volume
	CODE:
		RETVAL = Mix_VolumeChunk(chunk,volume);
	OUTPUT:
		RETVAL

int
MixVolumeMusic ( volume )
	int volume
	CODE:
		RETVAL = Mix_VolumeMusic(volume);
	OUTPUT:
		RETVAL

int
MixHaltChannel ( channel )
	int channel
	CODE:
		RETVAL = Mix_HaltChannel(channel);
	OUTPUT:
		RETVAL

int
MixHaltGroup ( tag )
	int tag
	CODE:
		RETVAL = Mix_HaltGroup(tag);
	OUTPUT:
		RETVAL

int
MixHaltMusic ()
	CODE:
		RETVAL = Mix_HaltMusic();
	OUTPUT:
		RETVAL

int
MixExpireChannel ( channel, ticks )
	int channel
	int ticks
	CODE:
		RETVAL = Mix_ExpireChannel ( channel,ticks);
	OUTPUT:
		RETVAL

int
MixFadeOutChannel ( which, ms )
	int which
	int ms
	CODE:
		RETVAL = Mix_FadeOutChannel(which,ms);
	OUTPUT:
		RETVAL

int
MixFadeOutGroup ( which, ms )
	int which
	int ms
	CODE:
		RETVAL = Mix_FadeOutGroup(which,ms);
	OUTPUT:
		RETVAL

int
MixFadeOutMusic ( ms )
	int ms
	CODE:
		RETVAL = Mix_FadeOutMusic(ms);
	OUTPUT:
		RETVAL

Mix_Fading
MixFadingMusic()
	CODE:
		RETVAL = Mix_FadingMusic();
	OUTPUT:
		RETVAL

Mix_Fading
MixFadingChannel( which )
	int which
	CODE:
		RETVAL = Mix_FadingChannel(which);
	OUTPUT:
		RETVAL

void
MixPause ( channel )
	int channel
	CODE:
		Mix_Pause(channel);

void
MixResume ( channel )
	int channel
	CODE:
		Mix_Resume(channel);

int
MixPaused ( channel )
	int channel
	CODE:
		RETVAL = Mix_Paused(channel);
	OUTPUT:
		RETVAL

void
MixPauseMusic ()
	CODE:
		Mix_PauseMusic();

void
MixResumeMusic ()
	CODE:
		Mix_ResumeMusic();

void
MixRewindMusic ()
	CODE:
		Mix_RewindMusic();

int
MixPausedMusic ()
	CODE:
		RETVAL = Mix_PausedMusic();
	OUTPUT:
		RETVAL

int
MixPlaying( channel )
	int channel	
	CODE:
		RETVAL = Mix_Playing(channel);
	OUTPUT:
		RETVAL

int
MixPlayingMusic()
	CODE:
		RETVAL = Mix_PlayingMusic();
	OUTPUT:
		RETVAL


void
MixCloseAudio ()
	CODE:
		Mix_CloseAudio();

#endif

int
GLLoadLibrary ( path )
	char *path
	CODE:
		RETVAL = SDL_GL_LoadLibrary(path);
	OUTPUT:
		RETVAL

void*
GLGetProcAddress ( proc )
	char *proc
	CODE:
		RETVAL = SDL_GL_GetProcAddress(proc);
	OUTPUT:
		RETVAL

int
GLSetAttribute ( attr,  value )
	int        attr
	int        value
	CODE:
		RETVAL = SDL_GL_SetAttribute(attr, value);
	OUTPUT:
	        RETVAL

AV *
GLGetAttribute ( attr )
	int        attr
	CODE:
		int value;
		RETVAL = newAV();
		av_push(RETVAL,newSViv(SDL_GL_GetAttribute(attr, &value)));
		av_push(RETVAL,newSViv(value));
	OUTPUT:
	        RETVAL

void
GLSwapBuffers ()
	CODE:
		SDL_GL_SwapBuffers ();


int
BigEndian ()
	CODE:
		RETVAL = (SDL_BYTEORDER == SDL_BIG_ENDIAN);
	OUTPUT:
		RETVAL

int
NumJoysticks ()
	CODE:
		RETVAL = SDL_NumJoysticks();
	OUTPUT:
		RETVAL

char *
JoystickName ( index )
	int index
	CODE:
		RETVAL = (char*)SDL_JoystickName(index);
	OUTPUT:
		RETVAL

SDL_Joystick *
JoystickOpen ( index ) 
	int index
	CODE:
		RETVAL = SDL_JoystickOpen(index);
	OUTPUT:
		RETVAL

int
JoystickOpened ( index )
	int index
	CODE:
		RETVAL = SDL_JoystickOpened(index);
	OUTPUT:
		RETVAL

int
JoystickIndex ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickIndex(joystick);
	OUTPUT:
		RETVAL

int
JoystickNumAxes ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickNumAxes(joystick);
	OUTPUT:
		RETVAL

int
JoystickNumBalls ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickNumBalls(joystick);
	OUTPUT:
		RETVAL

int
JoystickNumHats ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickNumHats(joystick);
	OUTPUT:
		RETVAL

int
JoystickNumButtons ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickNumButtons(joystick);
	OUTPUT:
		RETVAL

void
JoystickUpdate ()
	CODE:
		SDL_JoystickUpdate();

Sint16
JoystickGetAxis ( joystick, axis )
	SDL_Joystick *joystick
	int axis
	CODE:
		RETVAL = SDL_JoystickGetAxis(joystick,axis);
	OUTPUT:
		RETVAL

Uint8
JoystickGetHat ( joystick, hat )
	SDL_Joystick *joystick
	int hat 
	CODE:
		RETVAL = SDL_JoystickGetHat(joystick,hat);
	OUTPUT:
		RETVAL

Uint8
JoystickGetButton ( joystick, button)
	SDL_Joystick *joystick
	int button 
	CODE:
		RETVAL = SDL_JoystickGetButton(joystick,button);
	OUTPUT:
		RETVAL

AV *
JoystickGetBall ( joystick, ball )
	SDL_Joystick *joystick
	int ball 
	CODE:
		int success,dx,dy;
		success = SDL_JoystickGetBall(joystick,ball,&dx,&dy);
		RETVAL = newAV();
		av_push(RETVAL,newSViv(success));
		av_push(RETVAL,newSViv(dx));
		av_push(RETVAL,newSViv(dy));
	OUTPUT:
		RETVAL	

void
JoystickClose ( joystick )
	SDL_Joystick *joystick
	CODE:
		SDL_JoystickClose(joystick);

Sint16
JoyAxisEventWhich ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->jaxis.which;
	OUTPUT:
		RETVAL

Uint8
JoyAxisEventAxis ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jaxis.axis;
        OUTPUT:
                RETVAL

Sint16
JoyAxisEventValue ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jaxis.value;
        OUTPUT:
                RETVAL

Uint8
JoyButtonEventWhich ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jbutton.which;
        OUTPUT:
                RETVAL

Uint8
JoyButtonEventButton ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jbutton.button;
        OUTPUT:
                RETVAL

Uint8
JoyButtonEventState ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jbutton.state;
        OUTPUT:
                RETVAL
	
Uint8
JoyHatEventWhich ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jhat.which;
        OUTPUT:
                RETVAL

Uint8
JoyHatEventHat ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jhat.hat;
        OUTPUT:
                RETVAL

Uint8
JoyHatEventValue ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jhat.value;
        OUTPUT:
                RETVAL

Uint8
JoyBallEventWhich ( e )
        SDL_Event *e
        CODE: 
                RETVAL = e->jball.which;
        OUTPUT:
                RETVAL

Uint8
JoyBallEventBall ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jball.ball;
        OUTPUT:
                RETVAL

Sint16
JoyBallEventXrel ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jball.xrel;
        OUTPUT:
                RETVAL

Sint16
JoyBallEventYrel ( e )
        SDL_Event *e
        CODE:
                RETVAL = e->jball.yrel;
        OUTPUT:
                RETVAL

void
SetClipRect ( surface, rect )
	SDL_Surface *surface
	SDL_Rect *rect
	CODE:
		SDL_SetClipRect(surface,rect);
	
SDL_Rect*
GetClipRect ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = (SDL_Rect*) safemalloc(sizeof(SDL_Rect));
		SDL_GetClipRect(surface,RETVAL);
	OUTPUT:
		RETVAL


#ifdef HAVE_SDL_NET

int
NetInit ()
	CODE:
		RETVAL = SDLNet_Init();
	OUTPUT:
		RETVAL

void
NetQuit ()
	CODE:
		SDLNet_Quit();

IPaddress*
NetNewIPaddress ( host, port )
	Uint32 host
	Uint16 port
	CODE:
		RETVAL = (IPaddress*) safemalloc(sizeof(IPaddress));
		RETVAL->host = host;
		RETVAL->port = port;
	OUTPUT:
		RETVAL

Uint32
NetIPaddressHost ( ip )
	IPaddress *ip
	CODE:
		RETVAL = ip->host;
	OUTPUT:
		RETVAL

Uint16
NetIPaddressPort ( ip )
	IPaddress *ip
	CODE:
		RETVAL = ip->port;
	OUTPUT:
		RETVAL

void
NetFreeIPaddress ( ip )
	IPaddress *ip
	CODE:
		safefree(ip);

const char*
NetResolveIP ( address )
	IPaddress *address
	CODE:
		RETVAL = SDLNet_ResolveIP(address);
	OUTPUT:
		RETVAL

int
NetResolveHost ( address, host, port )
	IPaddress *address
	const char *host
	Uint16 port
	CODE:
		RETVAL = SDLNet_ResolveHost(address,host,port);
	OUTPUT:
		RETVAL
	
TCPsocket
NetTCPOpen ( ip )
	IPaddress *ip
	CODE:
		RETVAL = SDLNet_TCP_Open(ip);
	OUTPUT:
		RETVAL

TCPsocket
NetTCPAccept ( server )
	TCPsocket server
	CODE:
		RETVAL = SDLNet_TCP_Accept(server);
	OUTPUT:
		RETVAL

IPaddress*
NetTCPGetPeerAddress ( sock )
	TCPsocket sock
	CODE:
		RETVAL = SDLNet_TCP_GetPeerAddress(sock);
	OUTPUT:
		RETVAL

int
NetTCPSend ( sock, data, len  )
	TCPsocket sock
	void *data
	int len
	CODE:
		RETVAL = SDLNet_TCP_Send(sock,data,len);
	OUTPUT:
		RETVAL

AV*
NetTCPRecv ( sock, maxlen )
	TCPsocket sock
	int maxlen
	CODE:
		int status;
		void *buffer;
		buffer = safemalloc(maxlen);
		RETVAL = newAV();
		status = SDLNet_TCP_Recv(sock,buffer,maxlen);
		av_push(RETVAL,newSViv(status));
		av_push(RETVAL,newSVpvn((char*)buffer,maxlen));
	OUTPUT:
		RETVAL	
	
void
NetTCPClose ( sock )
	TCPsocket sock
	CODE:
		SDLNet_TCP_Close(sock);

UDPpacket*
NetAllocPacket ( size )
	int size
	CODE:
		RETVAL = SDLNet_AllocPacket(size);
	OUTPUT:
		RETVAL

UDPpacket**
NetAllocPacketV ( howmany, size )
	int howmany
	int size
	CODE:
		RETVAL = SDLNet_AllocPacketV(howmany,size);
	OUTPUT:
		RETVAL

int
NetResizePacket ( packet, newsize )
	UDPpacket *packet
	int newsize
	CODE:
		RETVAL = SDLNet_ResizePacket(packet,newsize);
	OUTPUT:
		RETVAL

void
NetFreePacket ( packet )
	UDPpacket *packet
	CODE:
		SDLNet_FreePacket(packet);

void
NetFreePacketV ( packet )
	UDPpacket **packet
	CODE:
		SDLNet_FreePacketV(packet);

UDPsocket
NetUDPOpen ( port )
	Uint16 port
	CODE:
		RETVAL = SDLNet_UDP_Open(port);
	OUTPUT:
		RETVAL

int
NetUDPBind ( sock, channel, address )
	UDPsocket sock
	int channel
	IPaddress *address
	CODE:
		RETVAL = SDLNet_UDP_Bind(sock,channel,address);
	OUTPUT:
		RETVAL

void
NetUDPUnbind ( sock, channel )
	UDPsocket sock
	int channel
	CODE:
		SDLNet_UDP_Unbind(sock,channel);

IPaddress*
NetUDPGetPeerAddress ( sock, channel )
	UDPsocket sock
	int channel
	CODE:
		RETVAL = SDLNet_UDP_GetPeerAddress(sock,channel);
	OUTPUT:
		RETVAL

int
NetUDPSendV ( sock, packets, npackets )
	UDPsocket sock
	UDPpacket **packets
	int npackets
	CODE:
		RETVAL = SDLNet_UDP_SendV(sock,packets,npackets);
	OUTPUT:
		RETVAL

int
NetUDPSend ( sock, channel, packet )
	UDPsocket sock
	int channel
	UDPpacket *packet 
	CODE:
		RETVAL = SDLNet_UDP_Send(sock,channel,packet);
	OUTPUT:
		RETVAL

int
NetUDPRecvV ( sock, packets )
	UDPsocket sock
	UDPpacket **packets
	CODE:
		RETVAL = SDLNet_UDP_RecvV(sock,packets);
	OUTPUT:
		RETVAL

int
NetUDPRecv ( sock, packet )
	UDPsocket sock
	UDPpacket *packet
	CODE:
		RETVAL = SDLNet_UDP_Recv(sock,packet);
	OUTPUT:
		RETVAL

void
NetUDPClose ( sock )
	UDPsocket sock
	CODE:
		SDLNet_UDP_Close(sock);

SDLNet_SocketSet
NetAllocSocketSet ( maxsockets )
	int maxsockets
	CODE:
		RETVAL = SDLNet_AllocSocketSet(maxsockets);
	OUTPUT:
		RETVAL

int
NetTCP_AddSocket ( set, sock )
	SDLNet_SocketSet set
	TCPsocket sock
	CODE:
		RETVAL = SDLNet_TCP_AddSocket(set,sock);
	OUTPUT:
		RETVAL

int
NetUDP_AddSocket ( set, sock )
	SDLNet_SocketSet set
	UDPsocket sock
	CODE:
		RETVAL = SDLNet_UDP_AddSocket(set,sock);
	OUTPUT:
		RETVAL

int
NetTCP_DelSocket ( set, sock )
	SDLNet_SocketSet set
	TCPsocket sock
	CODE:
		RETVAL = SDLNet_TCP_DelSocket(set,sock);
	OUTPUT:
		RETVAL

int
NetUDP_DelSocket ( set, sock )
	SDLNet_SocketSet set
	UDPsocket sock
	CODE:
		RETVAL = SDLNet_UDP_DelSocket(set,sock);
	OUTPUT:
		RETVAL

int
NetCheckSockets ( set, timeout )
	SDLNet_SocketSet set
	Uint32 timeout
	CODE:
		RETVAL = SDLNet_CheckSockets(set,timeout);
	OUTPUT:
		RETVAL

int
NetSocketReady ( sock )
	SDLNet_GenericSocket sock
	CODE:
		RETVAL = SDLNet_SocketReady(sock);
	OUTPUT:
		RETVAL

void
NetFreeSocketSet ( set )
	SDLNet_SocketSet set
	CODE:
		SDLNet_FreeSocketSet(set);

void
NetWrite16 ( value, area )
	Uint16 value
	void *area
	CODE:
		SDLNet_Write16(value,area);

void
NetWrite32 ( value, area )
	Uint32 value
	void *area
	CODE:
		SDLNet_Write32(value,area);
	
Uint16
NetRead16 ( area )
	void *area
	CODE:
		RETVAL = SDLNet_Read16(area);
	OUTPUT:
		RETVAL

Uint32
NetRead32 ( area )
	void *area
	CODE:
		RETVAL = SDLNet_Read32(area);
	OUTPUT:
		RETVAL

#endif 

#ifdef HAVE_SDL_TTF

int
TTFInit ()
	CODE:
		RETVAL = TTF_Init();
	OUTPUT:
		RETVAL

void
TTFQuit ()
	CODE:
		TTF_Quit();

TTF_Font*
TTFOpenFont ( file, ptsize )
	char *file
	int ptsize
	CODE:
		RETVAL = TTF_OpenFont(file,ptsize);
	OUTPUT:
		RETVAL

int
TTFGetFontStyle ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_GetFontStyle(font);
	OUTPUT:
		RETVAL

void
TTFSetFontStyle ( font, style )
	TTF_Font *font
	int style
	CODE:
		TTF_SetFontStyle(font,style);
	
int
TTFFontHeight ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontHeight(font);
	OUTPUT:
		RETVAL

int
TTFFontAscent ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontAscent(font);
	OUTPUT:
		RETVAL

int
TTFFontDescent ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontDescent(font);
	OUTPUT:
		RETVAL

int
TTFFontLineSkip ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontLineSkip(font);
	OUTPUT:
		RETVAL

AV*
TTFGlyphMetrics ( font, ch )
	TTF_Font *font
	Uint16 ch
	CODE:
		int minx, miny, maxx, maxy, advance;
		RETVAL = newAV();
		TTF_GlyphMetrics(font, ch, &minx, &miny, &maxx, &maxy, &advance);
		av_push(RETVAL,newSViv(minx));
		av_push(RETVAL,newSViv(miny));
		av_push(RETVAL,newSViv(maxx));
		av_push(RETVAL,newSViv(maxy));
		av_push(RETVAL,newSViv(advance));
	OUTPUT:
		RETVAL

AV*
TTFSizeText ( font, text )
	TTF_Font *font
	char *text
	CODE:
		int w,h;
		RETVAL = newAV();
		TTF_SizeText(font,text,&w,&h);
		av_push(RETVAL,newSViv(w));
		av_push(RETVAL,newSViv(h));
	OUTPUT:
		RETVAL

AV*
TTFSizeUTF8 ( font, text )
	TTF_Font *font
	char *text
	CODE:
		int w,h;
		RETVAL = newAV();
		TTF_SizeUTF8(font,text,&w,&h);
		av_push(RETVAL,newSViv(w));
		av_push(RETVAL,newSViv(h));
	OUTPUT:
		RETVAL

AV*
TTFSizeUNICODE ( font, text )
	TTF_Font *font
	const Uint16 *text
	CODE:
		int w,h;
		RETVAL = newAV();
		TTF_SizeUNICODE(font,text,&w,&h);
		av_push(RETVAL,newSViv(w));
		av_push(RETVAL,newSViv(h));
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderTextSolid ( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderText_Solid(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUTF8Solid ( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderUTF8_Solid(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUNICODESolid ( font, text, fg )
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderUNICODE_Solid(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderGlyphSolid ( font, ch, fg )
	TTF_Font *font
	Uint16 ch
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderGlyph_Solid(font,ch,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderTextShaded ( font, text, fg, bg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	SDL_Color *bg
	CODE:
		RETVAL = TTF_RenderText_Shaded(font,text,*fg,*bg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUTF8Shaded( font, text, fg, bg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	SDL_Color *bg
	CODE:
		RETVAL = TTF_RenderUTF8_Shaded(font,text,*fg,*bg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUNICODEShaded( font, text, fg, bg )
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	SDL_Color *bg
	CODE:
		RETVAL = TTF_RenderUNICODE_Shaded(font,text,*fg,*bg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderGlyphShaded ( font, ch, fg, bg )
	TTF_Font *font
	Uint16 ch
	SDL_Color *fg
	SDL_Color *bg
	CODE:
		RETVAL = TTF_RenderGlyph_Shaded(font,ch,*fg,*bg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderTextBlended( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderText_Blended(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUTF8Blended( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderUTF8_Blended(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUNICODEBlended( font, text, fg )
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderUNICODE_Blended(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderGlyphBlended( font, ch, fg )
	TTF_Font *font
	Uint16 ch
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderGlyph_Blended(font,ch,*fg);
	OUTPUT:
		RETVAL

void
TTFCloseFont ( font )
	TTF_Font *font
	CODE:
		TTF_CloseFont(font);
		font=NULL; //to be safe http://sdl.beuc.net/sdl.wiki/SDL_ttf_copy_Functions_Management_TTF_CloseFont

SDL_Surface*
TTFPutString ( font, mode, surface, x, y, fg, bg, text )
	TTF_Font *font
	int mode
	SDL_Surface *surface
	int x
	int y
	SDL_Color *fg
	SDL_Color *bg
	char *text
	CODE:
		SDL_Surface *img;
		SDL_Rect dest;
		int w,h;
		dest.x = x;
		dest.y = y;
		RETVAL = NULL;
		switch (mode) {
			case TEXT_SOLID:
				img = TTF_RenderText_Solid(font,text,*fg);
				TTF_SizeText(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case TEXT_SHADED:
				img = TTF_RenderText_Shaded(font,text,*fg,*bg);
				TTF_SizeText(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case TEXT_BLENDED:
				img = TTF_RenderText_Blended(font,text,*fg);
				TTF_SizeText(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UTF8_SOLID:
				img = TTF_RenderUTF8_Solid(font,text,*fg);
				TTF_SizeUTF8(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UTF8_SHADED:
				img = TTF_RenderUTF8_Shaded(font,text,*fg,*bg);
				TTF_SizeUTF8(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UTF8_BLENDED:
				img = TTF_RenderUTF8_Blended(font,text,*fg);
				TTF_SizeUTF8(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UNICODE_SOLID:
				img = TTF_RenderUNICODE_Solid(font,(Uint16*)text,*fg);
				TTF_SizeUNICODE(font,(Uint16*)text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UNICODE_SHADED:
				img = TTF_RenderUNICODE_Shaded(font,(Uint16*)text,*fg,*bg);
				TTF_SizeUNICODE(font,(Uint16*)text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UNICODE_BLENDED:
				img = TTF_RenderUNICODE_Blended(font,(Uint16*)text,*fg);
				TTF_SizeUNICODE(font,(Uint16*)text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			default:
				img = TTF_RenderText_Shaded(font,text,*fg,*bg);
				TTF_SizeText(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
		}
		if ( img && img->format && img->format->palette ) {
			SDL_Color *c = &img->format->palette->colors[0];
			Uint32 key = SDL_MapRGB( img->format, c->r, c->g, c->b );
			SDL_SetColorKey(img,SDL_SRCCOLORKEY,key );
			if (0 > SDL_BlitSurface(img,NULL,surface,&dest)) {
				SDL_FreeSurface(img);
				RETVAL = NULL;	
			} else {
				RETVAL = img;
			}
		}
	OUTPUT:
		RETVAL

#endif

SDL_Overlay*
CreateYUVOverlay ( width, height, format, display )
	int width
	int height
	Uint32 format
	SDL_Surface *display
	CODE:
		RETVAL = SDL_CreateYUVOverlay ( width, height, format, display );
	OUTPUT:
		RETVAL

int
LockYUVOverlay ( overlay )
	SDL_Overlay *overlay
	CODE:
		RETVAL = SDL_LockYUVOverlay(overlay);
	OUTPUT:
		RETVAL

void
UnlockYUVOverlay ( overlay )
        SDL_Overlay *overlay
        CODE:
                SDL_UnlockYUVOverlay(overlay);

int
DisplayYUVOverlay ( overlay, dstrect )
	SDL_Overlay *overlay
	SDL_Rect *dstrect
	CODE:
		RETVAL = SDL_DisplayYUVOverlay ( overlay, dstrect );
	OUTPUT:
		RETVAL

void
FreeYUVOverlay ( overlay )
        SDL_Overlay *overlay
        CODE:
                SDL_FreeYUVOverlay ( overlay );

Uint32
OverlayFormat ( overlay, ... )
	SDL_Overlay *overlay
	CODE:
		if ( items > 1 ) 
			overlay->format = SvIV(ST(1));
		RETVAL = overlay->format;
	OUTPUT:
		RETVAL

int 
OverlayW ( overlay, ... )
	SDL_Overlay *overlay
	CODE:
		if ( items > 1 ) 
			overlay->w = SvIV(ST(1));
		RETVAL = overlay->w;
	OUTPUT:
		RETVAL

int
OverlayH ( overlay, ... )
	SDL_Overlay *overlay
	CODE:
		if ( items > 1 )
			overlay->h = SvIV(ST(1));
		RETVAL = overlay->h;
	OUTPUT:
		RETVAL 

int
OverlayPlanes ( overlay, ... )
        SDL_Overlay *overlay
        CODE:
                if ( items > 1 )
                        overlay->planes = SvIV(ST(1));
                RETVAL = overlay->planes;
        OUTPUT:
                RETVAL

Uint32
OverlayHW ( overlay )
	SDL_Overlay *overlay
	CODE:
		RETVAL = overlay->hw_overlay;
	OUTPUT:
		RETVAL

Uint16*
OverlayPitches ( overlay )
	SDL_Overlay *overlay
	CODE:
		RETVAL = overlay->pitches;
	OUTPUT:
		RETVAL

Uint8**
OverlayPixels ( overlay )
	SDL_Overlay *overlay
	CODE:
		RETVAL = overlay->pixels;
	OUTPUT:
		RETVAL

int
WMToggleFullScreen ( surface )
	SDL_Surface *surface
	CODE:
		RETVAL = SDL_WM_ToggleFullScreen(surface);
	OUTPUT:
		RETVAL

Uint32
WMGrabInput ( mode )
	Uint32 mode
	CODE:
		RETVAL = SDL_WM_GrabInput(mode);
	OUTPUT:
		RETVAL

int
WMIconifyWindow ()
	CODE:
		RETVAL = SDL_WM_IconifyWindow();
	OUTPUT:
		RETVAL

int
ResizeEventW ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->resize.w;
	OUTPUT:
		RETVAL

int
ResizeEventH ( e )
	SDL_Event *e
	CODE:
		RETVAL = e->resize.h;
	OUTPUT:
		RETVAL

char*
AudioDriverName ()
	CODE:
		char name[32];
		RETVAL = SDL_AudioDriverName(name,32);
	OUTPUT:
		RETVAL

Uint32
GetKeyState ( k )
	SDLKey k
	CODE:
		if (k >= SDLK_LAST) Perl_croak (aTHX_ "Key out of range");	
		RETVAL = SDL_GetKeyState(NULL)[k];
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
#ifdef HAVE_SDL_MIXER
		RETVAL = SMPEG_new(filename,info,0);
#else
		RETVAL = SMPEG_new(filename,info,use_audio);
#endif
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
#ifdef HAVE_SDL_MIXER
		sdl_perl_use_smpeg_audio = flag;
#endif

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
#ifdef HAVE_SDL_MIXER
		if  (sdl_perl_use_smpeg_audio ) {
       			SMPEG_enableaudio(mpeg, 0);
			Mix_QuerySpec(&freq, &format, &channels);
			audiofmt.format = format;
			audiofmt.freq = freq;
			audiofmt.channels = channels;
			SMPEG_actualSpec(mpeg, &audiofmt);
			Mix_HookMusic(SMPEG_playAudioSDL, mpeg);
			SMPEG_enableaudio(mpeg, 1);
		}
#endif
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
#ifdef HAVE_SDL_MIXER
        	Mix_HookMusic(NULL, NULL);
#endif

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

#ifdef HAVE_SDL_GFX

SDL_Surface *
GFXRotoZoom ( src, angle, zoom, smooth)
	SDL_Surface * src
	double angle
	double zoom
	int smooth
	CODE:
		RETVAL = rotozoomSurface( src, angle, zoom, smooth);
	OUTPUT:
		RETVAL

SDL_Surface *
GFXZoom ( src, zoomx, zoomy, smooth)
	SDL_Surface *src
	double zoomx
	double zoomy
	int smooth
	CODE:
		RETVAL = zoomSurface( src, zoomx, zoomy, smooth);
	OUTPUT:
		RETVAL

int
GFXPixelColor ( dst, x, y, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Uint32 color
	CODE:
		RETVAL = pixelColor( dst, x, y, color);
	OUTPUT:
		RETVAL

int
GFXPixelRGBA ( dst, x, y, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = pixelRGBA( dst, x, y, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXHlineColor ( dst, x1, x2, y, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 x2
	Sint16 y
	Uint32 color
	CODE:
		RETVAL = hlineColor( dst, x1, x2, y, color );
	OUTPUT:
		RETVAL

int
GFXHlineRGBA ( dst, x1, x2, y, r, g, b, a )
	SDL_Surface* dst
	Sint16 x1
	Sint16 x2
	Sint16 y
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = hlineRGBA( dst, x1, x2, y, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXVlineColor ( dst, x, y1, y2, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y1
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = vlineColor( dst, x, y1, y2, color );
	OUTPUT:
		RETVAL

int
GFXVlineRGBA ( dst, x, y1, y2, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y1
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = vlineRGBA( dst, x, y1, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXRectangleColor ( dst, x1, y1, x2, y2, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = rectangleColor( dst, x1, y1, x2, y2, color );
	OUTPUT:
		RETVAL

int
GFXRectangleRGBA ( dst, x1, y1, x2, y2, r, g, b, a )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = rectangleRGBA( dst, x1, y1, x2, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXBoxColor ( dst, x1, y1, x2, y2, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = boxColor( dst, x1, y1, x2, y2, color );
	OUTPUT:
		RETVAL

int
GFXBoxRGBA ( dst, x1, y1, x2, y2, r, g, b, a )
	SDL_Surface* dst;
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = boxRGBA( dst, x1, y1, x2, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXLineColor ( dst, x1, y1, x2, y2, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = lineColor( dst, x1, y1, x2, y2, color );
	OUTPUT:
		RETVAL

int
GFXLineRGBA ( dst, x1, y1, x2, y2, r, g, b, a )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = lineRGBA( dst, x1, y1, x2, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXAalineColor ( dst, x1, y1, x2, y2, color )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint32 color
	CODE:
		RETVAL = aalineColor( dst, x1, y1, x2, y2, color );
	OUTPUT:
		RETVAL

int
GFXAalineRGBA ( dst, x1, y1, x2, y2, r, g, b, a )
	SDL_Surface* dst
	Sint16 x1
	Sint16 y1
	Sint16 x2
	Sint16 y2
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = aalineRGBA( dst, x1, y1, x2, y2, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXCircleColor ( dst, x, y, r, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 r
	Uint32 color
	CODE:
		RETVAL = circleColor( dst, x, y, r, color );
	OUTPUT:
		RETVAL

int
GFXCircleRGBA ( dst, x, y, rad, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = circleRGBA( dst, x, y, rad, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXAacircleColor ( dst, x, y, r, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 r
	Uint32 color
	CODE:
		RETVAL = aacircleColor( dst, x, y, r, color );
	OUTPUT:
		RETVAL

int
GFXAacircleRGBA ( dst, x, y, rad, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = aacircleRGBA( dst, x, y, rad, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXFilledCircleColor ( dst, x, y, r, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 r
	Uint32 color
	CODE:
		RETVAL = filledCircleColor( dst, x, y, r, color );
	OUTPUT:
		RETVAL

int
GFXFilledCircleRGBA ( dst, x, y, rad, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = filledCircleRGBA( dst, x, y, rad, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXEllipseColor ( dst, x, y, rx, ry, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rx
	Sint16 ry
	Uint32 color
	CODE:
		RETVAL = ellipseColor( dst, x, y, rx, ry, color );
	OUTPUT:
		RETVAL

int
GFXEllipseRGBA ( dst, x, y, rx, ry, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 	rx
	Sint16 ry
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = ellipseRGBA( dst, x, y, rx, ry, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXAaellipseColor ( dst, xc, yc, rx, ry, color )
	SDL_Surface* dst
	Sint16 xc
	Sint16 yc
	Sint16 rx
	Sint16 ry
	Uint32 color
	CODE:
		RETVAL = aaellipseColor( dst, xc, yc, rx, ry, color );
	OUTPUT:
		RETVAL

int
GFXAaellipseRGBA ( dst, x, y, rx, ry, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rx
	Sint16 ry
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = aaellipseRGBA( dst, x, y, rx, ry, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXFilledEllipseColor ( dst, x, y, rx, ry, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rx
	Sint16 ry
	Uint32 color
	CODE:
		RETVAL = filledEllipseColor( dst, x, y, rx, ry, color );
	OUTPUT:
		RETVAL

int
GFXFilledEllipseRGBA ( dst, x, y, rx, ry, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rx
	Sint16 ry
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = filledEllipseRGBA( dst, x, y, rx, ry, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXFilledPieColor ( dst, x, y, rad, start, end, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Sint16 start
	Sint16 end
	Uint32 color
	CODE:
		RETVAL = filledPieColor( dst, x, y, rad, start, end, color );
	OUTPUT:
		RETVAL

int
GFXFilledPieRGBA ( dst, x, y, rad, start, end, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	Sint16 rad
	Sint16 start
	Sint16 end
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = filledPieRGBA( dst, x, y, rad, start, end, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXPolygonColor ( dst, vx, vy, n, color )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint32 color;
	CODE:
		RETVAL = polygonColor( dst, vx, vy, n, color );
	OUTPUT:
		RETVAL

int
GFXPolygonRGBA ( dst, vx, vy, n, r, g, b, a )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = polygonRGBA( dst, vx, vy, n, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXAapolygonColor ( dst, vx, vy, n, color )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint32 color
	CODE:
		RETVAL = aapolygonColor( dst, vx, vy, n, color );
	OUTPUT:
		RETVAL

int
GFXAapolygonRGBA ( dst, vx, vy, n, r, g, b, a )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = aapolygonRGBA( dst, vx, vy, n, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXFilledPolygonColor ( dst, vx, vy, n, color )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	int color
	CODE:
		RETVAL = filledPolygonColor( dst, vx, vy, n, color );
	OUTPUT:
		RETVAL

int
GFXFilledPolygonRGBA ( dst, vx, vy, n, r, g, b, a )
	SDL_Surface* dst
	Sint16* vx
	Sint16* vy
	int n
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = filledPolygonRGBA( dst, vx, vy, n, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXCharacterColor ( dst, x, y, c, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	char c
	Uint32 color
	CODE:
		RETVAL = characterColor( dst, x, y, c, color );
	OUTPUT:
		RETVAL

int
GFXCharacterRGBA ( dst, x, y, c, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	char c
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = characterRGBA( dst, x, y, c, r, g, b, a );
	OUTPUT:
		RETVAL

int
GFXStringColor ( dst, x, y, c, color )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	char* c
	Uint32 color
	CODE:
		RETVAL = stringColor( dst, x, y, c, color );
	OUTPUT:
		RETVAL

int
GFXStringRGBA ( dst, x, y, c, r, g, b, a )
	SDL_Surface* dst
	Sint16 x
	Sint16 y
	char* c
	Uint8 r
	Uint8 g
	Uint8 b
	Uint8 a
	CODE:
		RETVAL = stringRGBA( dst, x, y, c, r, g, b, a );
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
		RETVAL = newAV();
		const Sound_DecoderInfo** sdi;
		sdi = Sound_AvailableDecoders();
		if (sdi != NULL)  {
			for (;*sdi != NULL; ++sdi) {
				av_push(RETVAL,sv_2mortal(newSViv(PTR2IV(*sdi))));
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

MODULE = SDL		PACKAGE = SDL
PROTOTYPES : DISABLE


