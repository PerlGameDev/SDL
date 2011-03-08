#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "defines.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include "SDLx/Controller/Interface.h"


MODULE = SDLx::Controller::State    PACKAGE = SDLx::Controller::State    PREFIX = state_

SDLx_State *
state_new( CLASS, ... )
    char * CLASS
    CODE:
       RETVAL = (SDLx_State * ) safemalloc( sizeof(SDLx_State) );
        if(items > 2)
            RETVAL->x = SvIV(ST(2));
        if(items > 3)
            RETVAL->y = SvIV(ST(3));
        if(items > 4)
            RETVAL->v_x = SvIV(ST(4));
        if(items > 5)
            RETVAL->v_y = SvIV(ST(5));
        if(items > 6)
            RETVAL->rotation = SvIV(ST(6));
        if(items > 7)
            RETVAL->ang_v = SvIV(ST(7));
    OUTPUT:
	RETVAL 

float
state_x(state, ...)
	SDLx_State * state
	CODE:
		if (items > 1 ) state->x = SvNV(ST(1)); 
		RETVAL = state->x;
	OUTPUT:
		RETVAL

float
state_y(state, ...)
	SDLx_State * state
	CODE:
		if (items > 1 ) state->y = SvNV(ST(1)); 
		RETVAL = state->y;
	OUTPUT:
		RETVAL

float
state_v_x(state, ...)
	SDLx_State * state
	CODE:
		if (items > 1 ) state->v_x = SvNV(ST(1));	
		RETVAL = state->v_x;
	OUTPUT:
		RETVAL

float
state_v_y(state, ...)
	SDLx_State * state
	CODE:
		if (items > 1 ) state->v_y = SvNV(ST(1));
		RETVAL = state->v_y;
	OUTPUT:
		RETVAL

float
state_rotation(state, ...)
	SDLx_State * state
	CODE:
		if (items > 1 ) state->rotation = SvNV((ST(1)));
		RETVAL = state->rotation;
	OUTPUT:
		RETVAL

float
state_ang_v(state, ...)
	SDLx_State * state
	CODE:
		if (items > 1 ) state->ang_v = SvNV((ST(1)));
		RETVAL = state->ang_v;
	OUTPUT:
		RETVAL

void
state_DESTROY( bag )
	SV *bag
	CODE:
		SDLx_State *obj = (SDLx_State *)bag2obj(bag);
		if (obj->owned == 0)
			objDESTROY(bag, safefree);


