#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include "SDLx/Controller/Object.h"


MODULE = SDLx::Controller::Object    PACKAGE = SDLx::Controller::Object    PREFIX = objx_

SDLx_Object *
objx_new( CLASS, ... )
    char * CLASS
    CODE:
       RETVAL = (SDLx_Object * ) safemalloc( sizeof(SDLx_Object) );
       RETVAL->previous = (SDLx_State * ) safemalloc( sizeof(SDLx_State) ); 
       RETVAL->current  = (SDLx_State * ) safemalloc( sizeof(SDLx_State) );
        if(items > 2)
            (RETVAL->current)->x = SvIV(ST(2));
        if(items > 3)
            (RETVAL->current)->y = SvIV(ST(3));
        if(items > 4)
            (RETVAL->current)->v_x = SvIV(ST(4));
        if(items > 5)
            (RETVAL->current)->v_y = SvIV(ST(5));
        if(items > 6)
            (RETVAL->current)->rotation = SvIV(ST(6));
        if(items > 7)
            (RETVAL->current)->ang_v = SvIV(ST(7));

       copy_state( RETVAL->previous, RETVAL->current);
    OUTPUT:
	RETVAL 


void
objx_DESTROY( obj )
	SDLx_Object *obj
	CODE: 
	safefree(obj->previous);
	safefree(obj->current);
	safefree(obj);
       

