#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include "SDLx/Controller/Object.h"


AV* acceleration_cb( SDLx_Object * obj )
{

	dSP;
	AV* array = newAV();
	int count;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);

	XPUSHs( sv_2mortal(newSVnv(obj->current->x)));
	XPUSHs( sv_2mortal(newSVnv(obj->current->y)));
	XPUSHs( sv_2mortal(newSVnv(obj->current->v_x)));
	XPUSHs( sv_2mortal(newSVnv(obj->current->v_y)));
	XPUSHs( sv_2mortal(newSVnv(obj->current->rotation)));
	XPUSHs( sv_2mortal(newSVnv(obj->current->ang_v)));

	PUTBACK;

	count = call_sv(obj->acceleration, G_ARRAY);

	SPAGAIN;
	int i;
	for( i =0; i < count ; i++)
	 av_push( array, newSVnv(POPn));

	FREETMPS;
	LEAVE;

	return array;
}


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
objx_set_acceleration(obj, callback)
	SDLx_Object* obj
	SV* callback
	CODE:
	obj->acceleration = callback;	
		

AV*
objx_acceleration(obj)
	SDLx_Object* obj
	CODE:
	RETVAL = acceleration_cb(obj);
	sv_2mortal((SV*)RETVAL);
	OUTPUT:
	RETVAL
	

SDLx_State *
objx_interpolate(obj, alpha)
	SDLx_Object* obj
	float alpha
	PREINIT:
	    char * CLASS = "SDLx::Controller::State";
	CODE:
	 RETVAL = (SDLx_State *)safemalloc(sizeof(SDLx_State ));
	 RETVAL->x = obj->current->x * alpha + obj->previous->x * (1 - alpha);
	 RETVAL->y = obj->current->y * alpha + obj->previous->y * (1 - alpha);
	 RETVAL->v_x = obj->current->v_x * alpha + obj->previous->v_x * (1 - alpha);
	 RETVAL->v_y = obj->current->v_y * alpha + obj->previous->v_y * (1 - alpha);
 	 RETVAL->rotation = obj->current->rotation * alpha + obj->previous->rotation * (1 - alpha);
	 RETVAL->ang_v = obj->current->ang_v * alpha + obj->previous->ang_v * (1 - alpha);
	 OUTPUT:
	 RETVAL 




void
objx_DESTROY( obj )
	SDLx_Object *obj
	CODE: 
	safefree(obj->previous);
	safefree(obj->current);
	safefree(obj);
       

