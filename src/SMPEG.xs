#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif


#ifdef HAVE_SMPEG
#include <smpeg/smpeg.h>
#endif



MODULE = SDL::SMPEG	PACKAGE = SDL::SMPEG
PROTOTYPES : DISABLE


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
/*#ifdef HAVE_SDL_MIXER */
/*		RETVAL = SMPEG_new(filename,info,0); */
/*#else */
		RETVAL = SMPEG_new(filename,info,use_audio);
/*#endif */
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
/*#ifdef HAVE_SDL_MIXER */
/*		sdl_perl_use_smpeg_audio = flag; */
/*#endif */

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
/*#ifdef HAVE_SDL_MIXER */
/*		if  (sdl_perl_use_smpeg_audio ) { */
/*       			SMPEG_enableaudio(mpeg, 0); */
/*			Mix_QuerySpec(&freq, &format, &channels); */
/*			audiofmt.format = format; */
/*			audiofmt.freq = freq; */
/*			audiofmt.channels = channels; */
/*			SMPEG_actualSpec(mpeg, &audiofmt); */
/*			Mix_HookMusic(SMPEG_playAudioSDL, mpeg); */
/*			SMPEG_enableaudio(mpeg, 1); */
/*		} */
/*#endif */
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
/*#ifdef HAVE_SDL_MIXER */
/*        	Mix_HookMusic(NULL, NULL); */
/*#endif */

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



