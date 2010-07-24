#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include "SDLx/Timer.h"

MODULE = SDLx::Controller::Timer 	PACKAGE = SDLx::Controller::Timer    PREFIX = timerx_




