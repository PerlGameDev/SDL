#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif


#ifdef HAVE_SMPEG
#include <smpeg/smpeg.h>
#endif



MODULE = SDL::SMPEG::Info	PACKAGE = SDL::SMPEG::Info
PROTOTYPES : DISABLE


#ifdef HAVE_SMPEG

SMPEG_Info *
NewSMPEGInfo()
	PREINIT:
		char* CLASS = "SDL::SMPEG::Info";
	CODE:	
		RETVAL = (SMPEG_Info *) safemalloc (sizeof(SMPEG_Info));
	OUTPUT:
		RETVAL

void
FreeSMPEGInfo ( info )
	SV *info
	CODE:	
		objDESTROY(info, safefree);

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


#endif



