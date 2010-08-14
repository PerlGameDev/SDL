#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include "SDLx/Controller/Object.h"


AV* acceleration_cb( SDLx_Object * obj, float t )
{

	dSP;
	AV* array = newAV();
	int count;
	SV * eventref = newSV( sizeof(SDLx_State *) ); 	
	void * copyState = safemalloc( sizeof(SDLx_State) );
	memcpy( copyState, obj->current, sizeof(SDLx_State) );

	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	
		 void** pointers = malloc(2 * sizeof(void*));
		  pointers[0] = (void*)copyState;
		  pointers[1] = (void*)0;

	XPUSHs( sv_2mortal(newSVnv(t)));
	XPUSHs( sv_setref_pv( eventref, "SDLx::Controller::State", (void *)pointers) );

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

void evaluate(SDLx_Object* obj, SDLx_Derivative* out, SDLx_State* initial, float t)
{
	out->dx = initial->v_x;
	out->dy = initial->v_y;
	out->drotation = initial->ang_v;
	AV* accel = acceleration_cb(obj, t);
	out->dv_x = sv_nv(av_pop(accel));
	out->dv_y = sv_nv(av_pop(accel));
	out->dang_v = sv_nv(av_pop(accel));

}

void evaluate_dt(SDLx_Object* obj, SDLx_Derivative* out, SDLx_State* initial, float t, float dt, SDLx_Derivative* d)
{
	SDLx_State state;
	state.x = initial->x + d->dx*dt;
	state.y = initial->y + d->dy*dt;
	state.rotation = initial->rotation + d->drotation*dt;

	state.v_x = initial->v_x + d->dv_x*dt;
	state.v_y = initial->v_y + d->dv_y*dt;
	state.ang_v = initial->ang_v + d->dang_v*dt;

	out->dx = state.v_x;
	out->dy = state.v_y;
	out->drotation = state.ang_v;

	AV* accel = acceleration_cb(obj, t+dt);
	out->dv_x = sv_nv(av_pop(accel));
	out->dv_y = sv_nv(av_pop(accel));
	out->dang_v = sv_nv(av_pop(accel));
}

void integrate( SDLx_Object* object, float t, float dt) 
{
	SDLx_State* state = object->current;
	SDLx_Derivative* a = (SDLx_Derivative *)safemalloc( sizeof(SDLx_Derivative) );
	SDLx_Derivative* b = (SDLx_Derivative *)safemalloc( sizeof(SDLx_Derivative) );
	SDLx_Derivative* c = (SDLx_Derivative *)safemalloc( sizeof(SDLx_Derivative) );
	SDLx_Derivative* d = (SDLx_Derivative *)safemalloc( sizeof(SDLx_Derivative) );

	 evaluate(object, a, state, t);
	 evaluate_dt(object, b, state, t, dt*0.5f, a);
	 evaluate_dt(object, c, state, t, dt*0.5f, b);
	 evaluate_dt(object, d, state, t, dt, c);
	
	const float dxdt = 1.0f/6.0f * (a->dx + 2.0f*(b->dx + c->dx) + d->dx);
	const float dv_xdt = 1.0f/6.0f * (a->dv_x + 2.0f*(b->dv_x + c->dv_x) + d->dv_x);
	const float dydt = 1.0f/6.0f * (a->dy + 2.0f*(b->dy + c->dy) + d->dy);
	const float dv_ydt = 1.0f/6.0f * (a->dv_y + 2.0f*(b->dv_y + c->dv_y) + d->dv_y);
	const float drotationdt = 1.0f/6.0f * (a->drotation + 2.0f*(b->drotation + c->drotation) + d->drotation);
	const float dv_angdt = 1.0f/6.0f * (a->dang_v + 2.0f*(b->dang_v + c->dv_y) + d->dang_v);

	state->x = state->x + dxdt*dt;
	state->v_x = state->v_x + dv_xdt*dt;
	state->y = state->y + dydt*dt;
	state->v_y = state->v_y + dv_ydt*dt;
	state->rotation = state->rotation + drotationdt*dt;
	state->ang_v = state->ang_v + dv_angdt*dt;

	safefree(a);
	safefree(b);
	safefree(c);
	safefree(d);
}


MODULE = SDLx::Controller::Object    PACKAGE = SDLx::Controller::Object    PREFIX = objx_

SDLx_Object *
objx_new( CLASS, ... )
    char * CLASS
    CODE:
       RETVAL = (SDLx_Object * ) safemalloc( sizeof(SDLx_Object) );
       RETVAL->previous = (SDLx_State * ) safemalloc( sizeof(SDLx_State) ); 
       RETVAL->current  = (SDLx_State * ) safemalloc( sizeof(SDLx_State) );
	
	RETVAL->current->x = 0;
	RETVAL->current->y = 0;
	RETVAL->current->v_x = 0;
	RETVAL->current->v_y = 0;
	RETVAL->current->rotation = 0;
	RETVAL->current->ang_v = 0;

        if(items > 1)
            (RETVAL->current)->x = SvIV(ST(1));
        if(items > 2)
            (RETVAL->current)->y = SvIV(ST(2));
        if(items > 3)
            (RETVAL->current)->v_x = SvIV(ST(3));
        if(items > 4)
            (RETVAL->current)->v_y = SvIV(ST(4));
        if(items > 5)
            (RETVAL->current)->rotation = SvIV(ST(5));
        if(items > 6)
            (RETVAL->current)->ang_v = SvIV(ST(6));

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
objx_acceleration(obj, t)
	SDLx_Object* obj
	float t
	CODE:
	RETVAL = acceleration_cb(obj, t);
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
	 SDLx_State* out =  (SDLx_State *)safemalloc(sizeof(SDLx_State )) ;
	 interpolate( obj,out, alpha);
	 RETVAL = out;
	 OUTPUT:
	 RETVAL 

void
objx_update(obj, t, dt)
	SDLx_Object* obj
	float t
	float dt
	CODE:
	       copy_state( obj->previous, obj->current);
		integrate( obj, t, dt );
	

void
objx_DESTROY( obj )
	SDLx_Object *obj
	CODE: 
	safefree(obj->previous);
	safefree(obj->current);
	safefree(obj);
       

