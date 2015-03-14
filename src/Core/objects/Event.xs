#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

SV *new_data( SV *thing )
{
	if( SvROK(thing) ) 
		return newRV_inc( SvRV(thing) );
	else
		return SvREFCNT_inc(thing); 
}

MODULE = SDL::Event 	PACKAGE = SDL::Event    PREFIX = event_

=for documentation

SDL_Event -- General event structure

 typedef union{
  Uint8 type;
  SDL_ActiveEvent active;
  SDL_KeyboardEvent key;
  SDL_MouseMotionEvent motion;
  SDL_MouseButtonEvent button;
  SDL_JoyAxisEvent jaxis;
  SDL_JoyBallEvent jball;
  SDL_JoyHatEvent jhat;
  SDL_JoyButtonEvent jbutton;
  SDL_ResizeEvent resize;
  SDL_ExposeEvent expose;
  SDL_QuitEvent quit;
  SDL_UserEvent user;
  SDL_SysWMEvent syswm;
 } SDL_Event;


=cut

SDL_Event *
event_new (CLASS)
	char *CLASS
	CODE:
		RETVAL = (SDL_Event *)safemalloc( sizeof(SDL_Event) );
		/* set userdata to NULL for now  */
		(RETVAL->user).data1 = (void *)NULL;
		(RETVAL->user).data2 = (void *)NULL;
	OUTPUT:
		RETVAL

Uint8
event_type ( event, ... )
	SDL_Event *event
	CODE:
		if( items > 1 )
			event->type = SvUV( ST(1) );
		RETVAL = event->type;
	OUTPUT:
		RETVAL

SDL_ActiveEvent *
event_active ( event, ... )
	SDL_Event *event
	PREINIT:
		char *CLASS = "SDL::ActiveEvent";
	CODE:
		RETVAL = &(event->active);
	OUTPUT:
		RETVAL

Uint8
event_active_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_ActiveEvent *a;
	CODE:
		a = &(event->active);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL


Uint8
event_active_gain ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_ActiveEvent *a;
	CODE:
		a = &(event->active);
		if( items > 1 )
			a->gain = SvUV( ST(1) );
		RETVAL = a->gain;
	OUTPUT:
		RETVAL

Uint8
event_active_state ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_ActiveEvent *a;
	CODE:
		a = &(event->active);
		if( items > 1 )
			a->state = SvUV( ST(1) );
		RETVAL = a->state;
	OUTPUT:
		RETVAL


SDL_KeyboardEvent *
event_key ( event, ... )
	SDL_Event *event
	PREINIT:
		char *CLASS = "SDL::KeyboardEvent";
	CODE:
		RETVAL = &(event->key);
	OUTPUT:
		RETVAL

Uint8
event_key_type ( event, ... )
	SDL_Event *event
	PREINIT: 
		SDL_KeyboardEvent *a;
	CODE:
		a = &(event->key);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

Uint8
event_key_state ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_KeyboardEvent *a;
	CODE:
		a = &(event->key);
		if( items > 1 )
			a->state = SvUV( ST(1) );
		RETVAL = a->state;
	OUTPUT:
		RETVAL

SDL_keysym *
event_key_keysym ( event, ... )
	SDL_Event *event
	PREINIT:
		char* CLASS = "SDL::keysym";
	PREINIT:
		SDL_KeyboardEvent *a;
	CODE:
		a = &(event->key);
		if( items > 1 )
		{
			SDL_keysym *ksp;
			ksp       = (SDL_keysym *)SvPV( ST(1), PL_na);
			a->keysym = *ksp;
		}
		RETVAL = &(a->keysym);
	OUTPUT:
		RETVAL

Uint8
event_key_scancode ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_KeyboardEvent *a;
		SDL_keysym *b;
	CODE:
		a = &(event->key);
		b = &(a->keysym);
		if( items > 1 )
			b->scancode = SvUV( ST(1) );
		RETVAL = b->scancode;
	OUTPUT:
		RETVAL

Uint16
event_key_sym ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_KeyboardEvent *a;
		SDL_keysym *b;
	CODE:
		a = &(event->key);
		b = &(a->keysym);
		if( items > 1 )
			b->sym = SvUV( ST(1) );
		RETVAL = b->sym;
	OUTPUT:
		RETVAL

Uint16
event_key_mod ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_KeyboardEvent *a;
		SDL_keysym *b;
	CODE:
		a = &(event->key);
		b = &(a->keysym);
		if( items > 1 )
			b->mod = SvUV( ST(1) );
		RETVAL = b->mod;
	OUTPUT:
		RETVAL

Uint16
event_key_unicode ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_KeyboardEvent *a;
		SDL_keysym *b;
	CODE:
		a = &(event->key);
		b = &(a->keysym);
		if( items > 1 )
			b->unicode = SvUV( ST(1) );
		RETVAL = b->unicode;
	OUTPUT:
		RETVAL

SDL_MouseMotionEvent *
event_motion ( event, ... )
	SDL_Event *event
	PREINIT:
		char *CLASS = "SDL::MouseMotionEvent";
	CODE:
		RETVAL = &(event->motion);
	OUTPUT:
		RETVAL

Uint8
event_motion_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseMotionEvent *a;
	CODE:
		a = &(event->motion);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

Uint8
event_motion_state ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseMotionEvent *a;
	CODE:
		a = &(event->motion);
		if( items > 1 )
			a->state = SvUV( ST(1) );
		RETVAL = a->state;
	OUTPUT:
		RETVAL

Uint16
event_motion_x ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseMotionEvent *a;
	CODE:
		a = &(event->motion);
		if( items > 1 )
			a->x = SvUV( ST(1) );
		RETVAL = a->x;
	OUTPUT:
		RETVAL

Uint16
event_motion_y ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseMotionEvent *a;
	CODE:
		a = &(event->motion);
		if( items > 1 )
			a->y = SvUV( ST(1) );
		RETVAL = a->y;
	OUTPUT:
		RETVAL

Sint16
event_motion_xrel ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseMotionEvent *a;
	CODE:
		a = &(event->motion);
		if( items > 1 )
			a->xrel = SvIV( ST(1) );
		RETVAL = a->xrel;
	OUTPUT:
		RETVAL


Sint16
event_motion_yrel ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseMotionEvent *a;
	CODE:
		a = &(event->motion);
		if( items > 1 )
			a->yrel = SvIV( ST(1) );
		RETVAL = a->yrel;
	OUTPUT:
		RETVAL

SDL_MouseButtonEvent *
event_button ( event, ... )
	SDL_Event *event
	PREINIT:
		char *CLASS = "SDL::MouseButtonEvent";
	CODE:
		RETVAL = &(event->button);
	OUTPUT:
		RETVAL

Uint8
event_button_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseButtonEvent *a;
	CODE:
		a = &(event->button);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

Uint8
event_button_which ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseButtonEvent *a;
	CODE:
		a = &(event->button);
		if( items > 1 )
			a->which = SvUV( ST(1) );
		RETVAL = a->which;
	OUTPUT:
		RETVAL

Uint8
event_button_button ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseButtonEvent *a;
	CODE:
		a = &(event->button);
		if( items > 1 )
			a->button = SvUV( ST(1) );
		RETVAL = a->button;
	OUTPUT:
		RETVAL

Uint8
event_button_state ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseButtonEvent *a;
	CODE:
		a = &(event->button);
		if( items > 1 )
			a->state = SvUV( ST(1) );
		RETVAL = a->state;
	OUTPUT:
		RETVAL

Uint16
event_button_x ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseButtonEvent *a;
	CODE:
		a = &(event->button);
		if( items > 1 )
			a->x = SvUV( ST(1) );
		RETVAL = a->x;
	OUTPUT:
		RETVAL

Uint16
event_button_y ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_MouseButtonEvent *a;
	CODE:
		a = &(event->button);
		if( items > 1 )
			a->y = SvUV( ST(1) );
		RETVAL = a->y;
	OUTPUT:
		RETVAL

SDL_JoyAxisEvent *
event_jaxis ( event, ... )
	SDL_Event * event
	PREINIT:
		char *CLASS = "SDL::JoyAxisEvent";
	CODE:
		RETVAL = &(event->jaxis);
	OUTPUT:
		RETVAL

Uint8
event_jaxis_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyAxisEvent *a;
	CODE:
		a = &(event->jaxis);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

Uint8
event_jaxis_which ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyAxisEvent *a;
	CODE:
		a = &(event->jaxis);
		if( items > 1 )
			a->which = SvUV( ST(1) );
		RETVAL = a->which;
	OUTPUT:
		RETVAL

Uint8
event_jaxis_axis ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyAxisEvent *a;
	CODE:
		a = &(event->jaxis);

		if( items > 1 )
			a->axis = SvUV( ST(1) );

		RETVAL = a->axis;
	OUTPUT:
		RETVAL

Sint16
event_jaxis_value ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyAxisEvent *a;
	CODE:
		a = &(event->jaxis);
		if( items > 1 )
			a->value = SvUV( ST(1) );
		RETVAL = a->value;
	OUTPUT:
		RETVAL

SDL_JoyBallEvent *
event_jball ( event, ... )
	SDL_Event * event
	PREINIT:
		char *CLASS = "SDL::JoyBallEvent";
	CODE:
		RETVAL = &(event->jball);
	OUTPUT:
		RETVAL

Uint8
event_jball_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyBallEvent *a;
	CODE:
		a = &(event->jball);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = event->type;
	OUTPUT:
		RETVAL

Uint8
event_jball_which ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyBallEvent *a;
	CODE:
		a = &(event->jball);
		if( items > 1 )
			a->which = SvUV( ST(1) );
		RETVAL = a->which;
	OUTPUT:
		RETVAL

Uint8
event_jball_ball ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyBallEvent *a;
	CODE:
		a = &(event->jball);
		if( items > 1 )
			a->ball = SvUV( ST(1) );
		RETVAL = a->ball;
	OUTPUT:
		RETVAL

Sint16
event_jball_xrel ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyBallEvent *a;
	CODE:
		a = &(event->jball);
		if( items > 1 )
			a->xrel = SvIV( ST(1) );
		RETVAL = a->xrel;
	OUTPUT:
		RETVAL

Sint16
event_jball_yrel ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyBallEvent *a;
	CODE:
		a = &(event->jball);
		if( items > 1 )
			a->yrel = SvIV( ST(1) );
		RETVAL = a->yrel;
	OUTPUT:
		RETVAL

SDL_JoyHatEvent *
event_jhat ( event, ... )
	SDL_Event *event
	PREINIT:
		char *CLASS = "SDL::JoyHatEvent";
	CODE:
		RETVAL = NULL;
		if ( &event != NULL )
			RETVAL = &(event->jhat);
	OUTPUT:
		RETVAL

Uint8
event_jhat_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyHatEvent *a;
	CODE:
		a = &(event->jhat);
		if( items > 1 )
			a->which = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

Uint8
event_jhat_which ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyHatEvent *a;
	CODE:
		a = &(event->jhat);
		if( items > 1 )
			a->which = SvUV( ST(1) );
		RETVAL = a->which;
	OUTPUT:
		RETVAL

Uint8
event_jhat_hat ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyHatEvent *a;
	CODE:
		a = &(event->jhat);
		if( items > 1 )
			a->hat = SvUV( ST(1) );
		RETVAL = a->hat;
	OUTPUT:
		RETVAL

Uint8
event_jhat_value ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyHatEvent *a;
	CODE:
		a = &(event->jhat);
		if( items > 1 )
			a->value = SvUV( ST(1) );
		RETVAL = a->value;
	OUTPUT:
		RETVAL

SDL_JoyButtonEvent *
event_jbutton ( event, ... )
	SDL_Event *event
	PREINIT:
		char *CLASS = "SDL::JoyButtonEvent";
	CODE:
		RETVAL = NULL;
		if ( &event != NULL ) 
			RETVAL = &(event->jbutton);
	OUTPUT:
		RETVAL

Uint8
event_jbutton_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyButtonEvent *a;
	CODE:
		a = &(event->jbutton);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

Uint8
event_jbutton_which ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyButtonEvent *a;
	CODE:
		a = &(event->jbutton);
		if( items > 1 )
			a->which = SvUV( ST(1) );
		RETVAL = a->which;
	OUTPUT:
		RETVAL

Uint8
event_jbutton_button ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyButtonEvent *a;
	CODE:
		a = &(event->jbutton);
		if( items > 1 )
			a->button = SvUV( ST(1) );
		RETVAL = a->button;
	OUTPUT:
		RETVAL

Uint8
event_jbutton_state ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_JoyButtonEvent *a;
	CODE:
		a = &(event->jbutton);
		if( items > 1 )
			a->state = SvUV( ST(1) );
		RETVAL = a->state;
	OUTPUT:
		RETVAL

SDL_ResizeEvent *
event_resize ( event, ... )
	SDL_Event * event
	PREINIT:
		char *CLASS = "SDL::ResizeEvent";
	CODE:
		RETVAL = NULL;
		if ( &event != NULL ) 
			RETVAL = &(event->resize);
	OUTPUT:
		RETVAL

Uint8
event_resize_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_ResizeEvent *a;
	CODE:
		a = &(event->resize);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

int
event_resize_w ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_ResizeEvent * a;
	CODE:
		a = &(event->resize);
		if( items > 1 )
			a->w = SvUV( ST(1) );
		RETVAL = a->w;
	OUTPUT:
		RETVAL

int
event_resize_h ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_ResizeEvent *a; 
	CODE:
		a = &(event->resize); 
		if( items > 1 )
			a->h = SvUV( ST(1) );
		RETVAL = a->h;
	OUTPUT:
		RETVAL

SDL_ExposeEvent *
event_expose ( event, ... )
	SDL_Event * event
	PREINIT:
		char *CLASS = "SDL::ExposeEvent";
	CODE:
		RETVAL = &(event->expose);
	OUTPUT:
		RETVAL

Uint8
event_expose_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_ExposeEvent *a;
	CODE:
		a = &(event->expose);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

SDL_QuitEvent *
event_quit ( event, ... )
	SDL_Event * event
	PREINIT:
		char *CLASS = "SDL::QuitEvent";
	CODE:
		RETVAL = &(event->quit);
	OUTPUT:
		RETVAL

Uint8
event_quit_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_QuitEvent *a;
	CODE:
		a = &(event->quit);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

SDL_UserEvent *
event_user ( event, ... )
	SDL_Event * event
	PREINIT:
		char *CLASS = "SDL::UserEvent";
	CODE:
		RETVAL = &(event->user);
	OUTPUT:
		RETVAL

Uint8
event_user_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_UserEvent *a;
	CODE:
		a = &(event->user);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

int
event_user_code ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_UserEvent *a;
	CODE:
		a = &(event->user);
		if( items > 1 )
			a->code = SvUV( ST(1) );
		RETVAL = (int)a->code;
	OUTPUT:
		RETVAL

SV *
event_user_data1 ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_UserEvent *a;
	PPCODE:
		a = &(event->user);
		if( items > 1 )
			a->data1 = new_data( ST(1) ); 
		if( !a->data1 )
			XSRETURN_EMPTY;
		ST(0) = a->data1;
		XSRETURN(1);

SV *
event_user_data2 ( event, ... ) 
	SDL_Event *event
	PREINIT:
		SDL_UserEvent *a;
	PPCODE:
		a = &(event->user);
		if( items > 1 )
			a->data2 = new_data( ST(1) ); 
		if( !a->data2 )
			XSRETURN_EMPTY;
		ST(0) = a->data1;
		XSRETURN(1);

SDL_SysWMEvent *
event_syswm ( event, ... )
	SDL_Event *event
	PREINIT:
		char *CLASS = "SDL::SysWMEvent";
	CODE:
		RETVAL = &(event->syswm);
	OUTPUT:
		RETVAL

Uint8
event_syswm_type ( event, ... )
	SDL_Event *event
	PREINIT:
		SDL_SysWMEvent *a;
	CODE:
		a = &(event->syswm);
		if( items > 1 )
			a->type = SvUV( ST(1) );
		RETVAL = a->type;
	OUTPUT:
		RETVAL

SDL_SysWMmsg *
event_syswm_msg ( event, ... )
	SDL_Event *event
	PREINIT:
		char *CLASS = "SDL::SysWMmsg";
		SDL_SysWMEvent *a;
	CODE: 
		a = &(event->syswm);
		if( items > 1 )
		{
			SDL_SysWMmsg *sysm;
			sysm   = (SDL_SysWMmsg *)SvPV( ST(1), PL_na );
			a->msg = sysm;
		}
		RETVAL = a->msg;
	OUTPUT:
		RETVAL

void
event_DESTROY(bag)
	SV *bag
	PREINIT:
		void **pointers; 
		SDL_Event *self;
	CODE:
		if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			pointers = (void**)INT2PTR(void *, SvIV((SV *)SvRV( bag ))); 
			self     = (SDL_Event*)(pointers[0]);
			if (PERL_GET_CONTEXT == pointers[1]) {
				/*warn("Freed surface %p and pixels %p \n", surface, surface->pixels); */
				if(self->type == SDL_USEREVENT) {
					if( (self->user).data1 != NULL )
						SvREFCNT_dec( (self->user).data1);
					if( (self->user).data2 != NULL )
						SvREFCNT_dec( (self->user).data2);
				}
				safefree(self);
				safefree(pointers);
			}
		} else if (bag == 0) {
			XSRETURN(0);
		} else {
			XSRETURN_UNDEF;
		}
