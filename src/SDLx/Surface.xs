#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>


SV * get_pixel32 (SDL_Surface *surface, int x, int y)
{
	
	/*Convert the pixels to 32 bit  */
	Uint32 *pixels = (Uint32 *)surface->pixels; 
	/*Get the requested pixel  */
	
	void* s =  pixels + _calc_offset(surface, x, y); 

	/*printf( " Pixel = %d, Ptr = %p \n", *((int*) s), s ); */

	SV* sv = newSV_type(SVt_PV);
	SvPV_set(sv, s);
	SvPOK_on(sv);
	SvLEN_set(sv, 0);
	SvCUR_set(sv, surface->format->BytesPerPixel);
	return newRV_noinc(sv); /*make a modifiable reference using u_ptr's place as the memory :) */

}


SV * construct_p_matrix ( SDL_Surface *surface )
{
    /*return  get_pixel32( surface, 0, 0); */
    AV * matrix = newAV();
     int i, j;
     i = 0;
     for(  i =0 ; i < surface->w; i++)
      {
	AV * matrix_row = newAV();
	 for( j =0 ; j < surface->h; j++)
		{
			av_push(matrix_row, get_pixel32(surface, i,j) );
		}
	  av_push(matrix, newRV_noinc((SV *)matrix_row) );
	
	}

	return newRV_noinc((SV *)matrix);
}


int _calc_offset ( SDL_Surface* surface, int x, int y )
{	
	int offset;
	offset  = (surface->pitch * y)/surface->format->BytesPerPixel;
	offset += x;
	return offset;
}


unsigned int _get_pixel(SDL_Surface * surface, int offset)
{

	unsigned int value;
		switch(surface->format->BytesPerPixel)
		{
			case 1:  value = ((Uint8  *)surface->pixels)[offset];
			         break;
			case 2:  value = ((Uint16 *)surface->pixels)[offset];
			         break;
			case 3:  value = ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel]     <<  0)
			                + ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel + 1] <<  8)
			                + ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel + 2] << 16);
			         break;
			case 4:  value = ((Uint32 *)surface->pixels)[offset];
			         break;

		}
	return value;
}


MODULE = SDLx::Surface 	PACKAGE = SDLx::Surface    PREFIX = surfacex_


SV *
surfacex_pixel_array ( surface )
	SDL_Surface *surface
	CODE:
		switch(surface->format->BytesPerPixel)
		{
			case 1:  croak("Not implemented yet for 8bpp surfaces\n");
			         break;
			case 2:  croak("Not implemented yet for 16bpp surfaces\n");
			         break;
			case 3:  croak("Not implemented yet for 24bpp surfaces\n");
			         break;
			case 4: 
				RETVAL = construct_p_matrix (surface);
			         break;

		}
		
		
	OUTPUT:
		RETVAL

unsigned int
surfacex_get_pixel_xs ( surface, x, y )
	SDL_Surface *surface
	int x
	int y
	CODE:
		if( x < 0 || y < 0 || x > surface->w || y > surface->h)
		{
		    croak(" Invalid location for pixel (%d, %d) on surface dims (%d, %d)", x,y,surface->w, surface->h);
		}

		int offset;
		offset =  _calc_offset( surface, x, y);
		RETVAL = _get_pixel( surface, offset );
	
	OUTPUT:
		RETVAL


void
surfacex_set_pixel_xs ( surface, x, y, value )
	SDL_Surface *surface
	int x
	int y
	unsigned int value
	CODE:
		if( x < 0 || y < 0 || x > surface->w || y > surface->h)
		{
		    croak(" Invalid location for pixel (%d, %d) on surface dims (%d, %d)", x,y,surface->w, surface->h);
		}
		int offset;
		offset =  _calc_offset( surface, x, y);
		if(SDL_MUSTLOCK(surface)) 
		  if ( SDL_LockSurface(surface) < 0)
		    croak( "Locking surface in set_pixels failed: %s", SDL_GetError() );
		switch(surface->format->BytesPerPixel)
			{
				case 1: ((Uint8  *)surface->pixels)[offset] = (Uint8)value;
					break;
				case 2: ((Uint16 *)surface->pixels)[offset] = (Uint16)value;
					break;
				case 3: ((Uint8  *)surface->pixels)[offset * surface->format->BytesPerPixel]     = (Uint8)( value        & 0xFF);
					((Uint8  *)surface->pixels)[offset * surface->format->BytesPerPixel + 1] = (Uint8)((value <<  8) & 0xFF);
					((Uint8  *)surface->pixels)[offset * surface->format->BytesPerPixel + 2] = (Uint8)((value << 16) & 0xFF);
					break;
				case 4: ((Uint32 *)surface->pixels)[offset] = (Uint32)value;
					break;
			}	
		if(SDL_MUSTLOCK(surface))
		SDL_UnlockSurface(surface);

	
