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

AV *acceleration_cb( SDLx_Interface *obj, float t )
{
	SV *tmpsv;
	AV *array;
	int i;
	int count;
    SDLx_State *copyState;
	dSP;
	if( !(SvROK(obj->acceleration) && (tmpsv = obj->acceleration) ) )
		croak( "Interface doesn't not contain an acceleration callback" );

	array = newAV();
	copyState = (SDLx_State *)safemalloc( sizeof(SDLx_State) );
	copy_state( copyState, obj->current );
	copyState->owned = 0;
	ENTER;
	SAVETMPS;
	PUSHMARK(SP);
	XPUSHs( sv_2mortal(newSVnv(t)) );
	XPUSHs( sv_2mortal( obj2bag( sizeof(SDLx_State *), (void *)copyState, "SDLx::Controller::State" ) ) );
	PUTBACK;

	count = call_sv( obj->acceleration, G_ARRAY );

	SPAGAIN;
/*	warn( "state %p, state->x %f", copyState, ((SDLx_State *)copyState)->x ); */
	for( i = 0; i < count; i++ )
		av_push( array, newSVnv(POPn) );

/*	warn ("before obj->current->x %f", obj->current->x); */
	copy_state( obj->current, copyState );
/*	warn ("after obj->current->x %f", obj->current->x); */
	PUTBACK;
	FREETMPS;
	LEAVE;

	return array;
}

void evaluate(SDLx_Interface *obj, SDLx_Derivative *out, SDLx_State *initial, float t)
{
	AV *accel;
	SV *temp;
	out->dx        = initial->v_x;
	out->dy        = initial->v_y;
	out->drotation = initial->ang_v;
	accel          = acceleration_cb(obj, t);

	temp           = av_pop(accel);
	out->dv_x      = sv_nv(temp);
	SvREFCNT_dec(temp);

	temp           = av_pop(accel);
	out->dv_y      = sv_nv(temp);
	SvREFCNT_dec(temp);

	temp           = av_pop(accel);
	out->dang_v    = sv_nv(temp);
	SvREFCNT_dec(temp);

	SvREFCNT_dec((SV *)accel);
}

void evaluate_dt(SDLx_Interface *obj, SDLx_Derivative *out, SDLx_State *initial, float t, float dt, SDLx_Derivative *d)
{
	SDLx_State state;
	AV *accel;
	SV *temp;

	state.x        = initial->x        + d->dx        * dt;
	state.y        = initial->y        + d->dy        * dt;
	state.rotation = initial->rotation + d->drotation * dt;

	state.v_x      = initial->v_x      + d->dv_x      * dt;
	state.v_y      = initial->v_y      + d->dv_y      * dt;
	state.ang_v    = initial->ang_v    + d->dang_v    * dt;

	out->dx        = state.v_x;
	out->dy        = state.v_y;
	out->drotation = state.ang_v;

	accel          = acceleration_cb(obj, t+dt);

	temp           = av_pop(accel);
	out->dv_x      = sv_nv(temp);
	SvREFCNT_dec(temp);

	temp           = av_pop(accel);
	out->dv_y      = sv_nv(temp);
	SvREFCNT_dec(temp);

	temp           = av_pop(accel);
	out->dang_v    = sv_nv(temp);
	SvREFCNT_dec(temp);

	SvREFCNT_dec((SV *)accel);
}

void integrate( SDLx_Interface *object, float t, float dt)
{
	SDLx_State *state;
	SDLx_Derivative *a;
	SDLx_Derivative *b;
	SDLx_Derivative *c;
	SDLx_Derivative *d;

	state = object->current;
	a     = (SDLx_Derivative *)safemalloc( sizeof(SDLx_Derivative) );
	b     = (SDLx_Derivative *)safemalloc( sizeof(SDLx_Derivative) );
	c     = (SDLx_Derivative *)safemalloc( sizeof(SDLx_Derivative) );
	d     = (SDLx_Derivative *)safemalloc( sizeof(SDLx_Derivative) );

	 evaluate(object, a, state, t);
	 evaluate_dt(object, b, state, t, dt*0.5f, a);
	 evaluate_dt(object, c, state, t, dt*0.5f, b);
	 evaluate_dt(object, d, state, t, dt, c);

	{
		const float dxdt        = 1.0f/6.0f * (a->dx        + 2.0f * (b->dx        + c->dx)        + d->dx);
		const float dv_xdt      = 1.0f/6.0f * (a->dv_x      + 2.0f * (b->dv_x      + c->dv_x)      + d->dv_x);
		const float dydt        = 1.0f/6.0f * (a->dy        + 2.0f * (b->dy        + c->dy)        + d->dy);
		const float dv_ydt      = 1.0f/6.0f * (a->dv_y      + 2.0f * (b->dv_y      + c->dv_y)      + d->dv_y);
		const float drotationdt = 1.0f/6.0f * (a->drotation + 2.0f * (b->drotation + c->drotation) + d->drotation);
		const float dv_angdt    = 1.0f/6.0f * (a->dang_v    + 2.0f * (b->dang_v    + c->dang_v)    + d->dang_v);

		state->x        = state->x        + dxdt        * dt;
		state->v_x      = state->v_x      + dv_xdt      * dt;
		state->y        = state->y        + dydt        * dt;
		state->v_y      = state->v_y      + dv_ydt      * dt;
		state->rotation = state->rotation + drotationdt * dt;
		state->ang_v    = state->ang_v    + dv_angdt    * dt;
	}

	safefree(a);
	safefree(b);
	safefree(c);
	safefree(d);
}

MODULE = SDLx::Controller::Interface    PACKAGE = SDLx::Controller::Interface    PREFIX = objx_

SDLx_Interface *
objx_make( CLASS, ... )
	char *CLASS
	CODE:
		RETVAL               = (SDLx_Interface *)safemalloc( sizeof(SDLx_Interface) );
		RETVAL->previous     = (SDLx_State *)safemalloc( sizeof(SDLx_State) );
		RETVAL->current      = (SDLx_State *)safemalloc( sizeof(SDLx_State) );
		RETVAL->acceleration = newSViv(-1);

		RETVAL->current->x        = 0;
		RETVAL->current->y        = 0;
		RETVAL->current->v_x      = 0;
		RETVAL->current->v_y      = 0;
		RETVAL->current->rotation = 0;
		RETVAL->current->ang_v    = 0;
		RETVAL->current->owned    = 1;
		RETVAL->previous->owned   = 1;

		if(items > 1) (RETVAL->current)->x        = SvIV(ST(1));
		if(items > 2) (RETVAL->current)->y        = SvIV(ST(2));
		if(items > 3) (RETVAL->current)->v_x      = SvIV(ST(3));
		if(items > 4) (RETVAL->current)->v_y      = SvIV(ST(4));
		if(items > 5) (RETVAL->current)->rotation = SvIV(ST(5));
		if(items > 6) (RETVAL->current)->ang_v    = SvIV(ST(6));

		copy_state(RETVAL->previous, RETVAL->current);
	OUTPUT:
		RETVAL

void
objx_set_acceleration(obj, callback)
	SDLx_Interface *obj
	SV *callback
	PREINIT:
		SV *tmpsv;
	CODE:
		tmpsv = NULL;
		if( !(SvROK(callback) && (tmpsv = (SV*)SvRV(callback)) && SvTYPE(tmpsv) == SVt_PVCV ) )
			croak( "Acceleration callback needs to be a code ref, %p", callback );
		obj->acceleration = SvRV( newRV_inc(callback) );

AV *
objx_acceleration(obj, t)
	SDLx_Interface* obj
	float t
	CODE:
		RETVAL = acceleration_cb(obj, t);
		sv_2mortal((SV*)RETVAL);
	OUTPUT:
		RETVAL

SDLx_State *
objx_interpolate(obj, alpha)
	SDLx_Interface *obj
	float alpha
	PREINIT:
		SDLx_State *out;
		char *CLASS = "SDLx::Controller::State";
	CODE:
		out = (SDLx_State *)safemalloc(sizeof(SDLx_State ));
		interpolate( obj,out, alpha);
		out->owned = 0; /* condition free */
		RETVAL     = out;
	OUTPUT:
		RETVAL

SDLx_State *
objx_current ( obj, ... )
	SDLx_Interface *obj
	PREINIT:
		char * CLASS = "SDLx::Controller::State";
	CODE:
		RETVAL = obj->current;
	OUTPUT:
		RETVAL

SDLx_State *
objx_previous ( obj, ... )
	SDLx_Interface *obj
	PREINIT:
		char *CLASS = "SDLx::Controller::State";
	CODE:
		RETVAL = obj->previous;
	OUTPUT:
		RETVAL

void
objx_update(obj, t, dt)
	SDLx_Interface *obj
	float t
	float dt
	CODE:
		copy_state( obj->previous, obj->current);
		integrate( obj, t, dt );

void
objx_DESTROY( obj )
	SDLx_Interface *obj
	CODE:
		SvREFCNT_dec(obj->acceleration);
		safefree(obj->previous);
		safefree(obj->current);
		safefree(obj);
