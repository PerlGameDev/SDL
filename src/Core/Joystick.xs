#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Joystick 	PACKAGE = SDL::Joystick    PREFIX = joystick_

SDL_Joystick *
joystick_new (CLASS, index ) 
	char* CLASS
	int index
	CODE:
		RETVAL = SDL_JoystickOpen(index);
	OUTPUT:
		RETVAL


int
joystick_num_joysticks ()
	CODE:
		RETVAL = SDL_NumJoysticks();
	OUTPUT:
		RETVAL

char *
joystick_name ( index )
	int index
	CODE:
		RETVAL = (char*)SDL_JoystickName(index);
	OUTPUT:
		RETVAL

int
joystick_opened ( index )
	int index
	CODE:
		RETVAL = SDL_JoystickOpened(index);
	OUTPUT:
		RETVAL

int
joystick_index ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickIndex(joystick);
	OUTPUT:
		RETVAL

int
joystick_num_axes ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickNumAxes(joystick);
	OUTPUT:
		RETVAL

int
joystick_num_balls ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickNumBalls(joystick);
	OUTPUT:
		RETVAL

int
joystick_num_hats ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickNumHats(joystick);
	OUTPUT:
		RETVAL

int
joystick_num_buttons ( joystick )
	SDL_Joystick *joystick
	CODE:
		RETVAL = SDL_JoystickNumButtons(joystick);
	OUTPUT:
		RETVAL

void
joystick_update ()
	CODE:
		SDL_JoystickUpdate();

Sint16
joystick_get_axis ( joystick, axis )
	SDL_Joystick *joystick
	int axis
	CODE:
		RETVAL = SDL_JoystickGetAxis(joystick,axis);
	OUTPUT:
		RETVAL

Uint8
joystick_get_hat ( joystick, hat )
	SDL_Joystick *joystick
	int hat 
	CODE:
		RETVAL = SDL_JoystickGetHat(joystick,hat);
	OUTPUT:
		RETVAL

Uint8
joystick_get_button ( joystick, button)
	SDL_Joystick *joystick
	int button 
	CODE:
		RETVAL = SDL_JoystickGetButton(joystick,button);
	OUTPUT:
		RETVAL

AV *
joystick_get_ball ( joystick, ball )
	SDL_Joystick *joystick
	int ball 
	CODE:
		int success,dx,dy;
		success = SDL_JoystickGetBall(joystick,ball,&dx,&dy);
		RETVAL = newAV();
		RETVAL = sv_2mortal((SV*)RETVAL);
		av_push(RETVAL,newSViv(success));
		av_push(RETVAL,newSViv(dx));
		av_push(RETVAL,newSViv(dy));
	OUTPUT:
		RETVAL	

void
joystick_DESTROY ( joystick )
	SDL_Joystick *joystick
	CODE:
		SDL_JoystickClose(joystick);

