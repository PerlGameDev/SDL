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
} SDLx_State;

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


