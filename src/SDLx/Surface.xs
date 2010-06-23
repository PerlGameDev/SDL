#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>


SV * get_pixel32 (SDL_Surface *surface, int x, int y)
{
	
	if( x==0 && y ==0)
	{
		
	}
	//Convert the pixels to 32 bit 
	Uint32 *pixels = (Uint32 *)surface->pixels; 
	//Get the requested pixel 
	
	Uint32* u_ptr =  &(pixels[( y * surface->w ) + x ]); 


	SV* sv = newSV_type(SVt_PV);
        SvPV_set(sv, (char*)u_ptr);
        SvLEN_set(sv, 0);              /* So Perl won't free it. */
        SvCUR_set(sv, sizeof(Uint32));
        SvPOK_on(sv);

	return sv; //make a modifiable reference using u_ptr's place as the memory :)

}


SV * construct_p_matrix ( SDL_Surface *surface )
{
    AV * matrix = newAV();
     int i, j;
     for(  i =0 ; i < surface->w; i++)
      {
	AV * matrix_row = newAV();
	 for( j =0 ; j < surface->h; j++)
		{
			av_push(matrix_row, get_pixel32(surface, i,j) );
		}
	  av_push(matrix, newRV_noinc((SV*) matrix_row) );
	}

	return newRV_noinc(matrix);
}




MODULE = SDLx::Surface 	PACKAGE = SDLx::Surface    PREFIX = surfacex_


SV *
surfacex_pixel_array ( surface )
	SDL_Surface *surface
	CODE:
		if (surface->format->BytesPerPixel != 4) { croak( " only 32 bbp is implemented so far"); } 
		RETVAL = construct_p_matrix (surface);
		
	OUTPUT:
		RETVAL
