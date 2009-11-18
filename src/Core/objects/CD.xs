#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::CD 	PACKAGE = SDL::CD    PREFIX = cdr_

SDL_CD *
cdr_new ( CLASS, drive )
	char* CLASS
	int drive
	CODE:
		RETVAL = SDL_CDOpen(drive);
	OUTPUT:
		RETVAL


Uint32
cdr_status ( cd )
	SDL_CD *cd 
	CODE:
		RETVAL = SDL_CDStatus(cd);
	OUTPUT:
		RETVAL

int
cdr_play_tracks ( cd, start_track, ntracks, start_frame, nframes )
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
cdr_play ( cd, start, length )
	SDL_CD *cd
	int start
	int length
	CODE:
		RETVAL = SDL_CDPlay(cd,start,length);
	OUTPUT:
		RETVAL

int
cdr_pause ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = SDL_CDPause(cd);
	OUTPUT:
		RETVAL

int
cdr_resume ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = SDL_CDResume(cd);
	OUTPUT:
		RETVAL

int
cdr_stop ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = SDL_CDStop(cd);
	OUTPUT:
		RETVAL

int
cdr_eject ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = SDL_CDEject(cd);
	OUTPUT:
		RETVAL

int
cdr_id ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = cd->id;
	OUTPUT: 
		RETVAL

int
cdr_num_tracks ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = cd->numtracks;
	OUTPUT:
		RETVAL

int
cdr_cur_track ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = cd->cur_track;
	OUTPUT:
		RETVAL

int
cdr_cur_frame ( cd )
	SDL_CD *cd
	CODE:
		RETVAL = cd->cur_frame;
	OUTPUT:
		RETVAL

SDL_CDtrack *
cdr_track ( cd, number )
	SDL_CD *cd
	int number
	PREINIT:
		char* CLASS = "SDL::CDTrack";
	CODE:
		RETVAL = (SDL_CDtrack *)(cd->track + number);
	OUTPUT:
		RETVAL



void
cdr_DESTROY ( cd )
	SDL_CD *cd
	CODE:
		SDL_CDClose(cd);
	

