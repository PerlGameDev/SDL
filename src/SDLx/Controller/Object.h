// Defines Controller Object structs
//
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"


typedef struct SDLx_State
{
	// Position
	float x; 
	float y;
	// Velocity
	float v_x;
	float v_y;
	// Rotation
	float rotation;
	float ang_v; 
	// owned by an object or not?
	int owned;
	
} SDLx_State;

typedef struct Derivative
{
	float dx;
	float dy;
	float dv_x;
	float dv_y;
	float drotation;
	float dang_v;

} SDLx_Derivative;

typedef struct SDLx_Object
{

	// states to hold
	SDLx_State* previous;
	SDLx_State* current;

	// subs to callback 
	SV* acceleration;
	SV* evaluate;
	SV* interpolate;
	SV* integrate;

} SDLx_Object;

void copy_state( SDLx_State * a, SDLx_State * b )
{
    
	a->x        = b->x;
	a->y        = b->y;
	a->v_x      = b->v_x;
	a->v_y      = b->v_y;
	a->rotation = b->rotation;
        a->ang_v    = b->ang_v;
}


void interpolate( SDLx_Object* obj, SDLx_State* out, float alpha )
{
	 out->x = obj->current->x * alpha + obj->previous->x * (1 - alpha);
	 out->y = obj->current->y * alpha + obj->previous->y * (1 - alpha);
	 out->v_x = obj->current->v_x * alpha + obj->previous->v_x * (1 - alpha);
	 out->v_y = obj->current->v_y * alpha + obj->previous->v_y * (1 - alpha);
 	 out->rotation = obj->current->rotation * alpha + obj->previous->rotation * (1 - alpha);
	 out->ang_v = obj->current->ang_v * alpha + obj->previous->ang_v * (1 - alpha);

}


