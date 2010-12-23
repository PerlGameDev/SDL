#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include "SDLx/Validate.h"

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
		if( x < 0  )
           x = 0;
        else if ( x > surface->w)
           x = surface->w;

        if ( y < 0 )
           y = 0;
        else if ( y > surface->h)
           y = surface->h;	

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
		if( x < 0  )
           x = 0;
        else if ( x > surface->w)
           x = surface->w;

        if ( y < 0 )
           y = 0;
        else if ( y > surface->h)
           y = surface->h;	

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


void
surfacex_draw_rect ( surface, rt, color )
	SDL_Surface *surface
	SV* rt
	SV* color
	CODE:
	
	Uint32 m_color = __map_rgba( color, surface->format );
	SDL_Rect r_rect;
	r_rect.x = 0; r_rect.y = 0; r_rect.w = surface->w; r_rect.h = surface->h;

	if( SvOK(rt) )
	{
		int newly_created_rect = 0;
		SV* foo = rect( rt, &newly_created_rect );
		SDL_Rect* v_rect = (SDL_Rect*)bag2obj(foo);
		r_rect.x = v_rect->x;
		r_rect.y = v_rect->y;
		r_rect.w = v_rect->w;
		r_rect.h = v_rect->h;
		SDL_FillRect(surface, &r_rect, m_color);
		SvREFCNT_dec(foo);
		//if( newly_created_rect == 1 ) {  safefree( v_rect); } 
	}
	else
    	SDL_FillRect(surface, &r_rect, m_color);

void
surfacex_blit( src, dest, ... )
    SV *src
    SV *dest
    CODE:
        src  = surface(src);
        dest = surface(dest);
        SDL_Surface *_src  = (SDL_Surface *)bag2obj(src);
        SDL_Surface *_dest = (SDL_Surface *)bag2obj(dest);

        SDL_Rect _src_rect;
        SDL_Rect _dest_rect;
        int newly_created_rect = 0;
       	SV* s_rect_sv, *d_rect_sv; 
		int mall_sr = 0; int mall_dr = 0;
        if( items > 2 && SvOK(ST(2)) )
        { 
			s_rect_sv =  rect(ST(2), &newly_created_rect);
			_src_rect = *(SDL_Rect *)bag2obj( s_rect_sv );
			mall_sr = 1;
		}
        else
        {
            _src_rect.x = 0;
            _src_rect.y = 0;
            _src_rect.w = _src->w;
            _src_rect.h = _src->h;
        }
        
        if( items > 3 && SvOK(ST(3)) )
		{
			d_rect_sv = rect(ST(3), &newly_created_rect);
            _dest_rect = *(SDL_Rect *)bag2obj( d_rect_sv );
			mall_dr = 1;
		}
        else
        {
            _dest_rect.x = 0;
            _dest_rect.y = 0;
            _dest_rect.w = _dest->w;
            _dest_rect.h = _dest->h;
        }
        
        SDL_BlitSurface( _src, &_src_rect, _dest, &_dest_rect );
		if ( mall_sr == 1 )
			SvREFCNT_dec( s_rect_sv);
		if ( mall_dr == 1 )
			SvREFCNT_dec( d_rect_sv );

   
