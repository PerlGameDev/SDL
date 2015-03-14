#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_newSV_type_GLOBAL
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include "SDLx/Validate.h"

#ifdef HAVE_SDL_GFX_PRIMITIVES
#include <SDL_gfxPrimitives.h>
#endif

SV * get_pixel32 (SDL_Surface *surface, int x, int y)
{
    /* Convert the pixels to 32 bit  */
    Uint32 *pixels = (Uint32 *)surface->pixels; 
    /* Get the requested pixel  */

    void* s =  pixels + _calc_offset(surface, x, y); 

    /* printf( " Pixel = %d, Ptr = %p \n", *((int*) s), s ); */

    SV* sv = newSV_type(SVt_PV);
    SvPV_set(sv, s);
    SvPOK_on(sv);
    SvLEN_set(sv, 0);
    SvCUR_set(sv, surface->format->BytesPerPixel);
    return newRV_noinc(sv); /* make a modifiable reference using u_ptr's place as the memory :) */
}

SV * construct_p_matrix ( SDL_Surface *surface )
{
    /* return  get_pixel32( surface, 0, 0); */
    AV * matrix = newAV();
    int i, j;
    i = 0;
    for( i =0 ; i < surface->w; i++ )
    {
        AV * matrix_row = newAV();
        for( j =0 ; j < surface->h; j++ )
            av_push( matrix_row, get_pixel32(surface, i,j) );

        av_push( matrix, newRV_noinc((SV *)matrix_row) );
    }

    return newRV_noinc((SV *)matrix);
}

int _calc_offset ( SDL_Surface* surface, int x, int y )
{
    int offset;
    offset  = (surface->pitch * y) / surface->format->BytesPerPixel;
    offset += x;
    return offset;
}

unsigned int _get_pixel(SDL_Surface * surface, int offset)
{
    unsigned int value;
    switch(surface->format->BytesPerPixel)
    {
        case 1: value = ((Uint8  *)surface->pixels)[offset];
                break;
        case 2: value = ((Uint16 *)surface->pixels)[offset];
                break;
        case 3: value = ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel]     <<  0)
                      + ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel + 1] <<  8)
                      + ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel + 2] << 16);
                break;
        case 4: value = ((Uint32 *)surface->pixels)[offset];
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
            case 1: croak("Not implemented yet for 8bpp surfaces\n");
                    break;
            case 2: croak("Not implemented yet for 16bpp surfaces\n");
                    break;
            case 3: croak("Not implemented yet for 24bpp surfaces\n");
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
        _int_range( &x, 0, surface->w );
        _int_range( &y, 0, surface->h );
        int offset;
        offset = _calc_offset( surface, x, y);
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
        _int_range( &x, 0, surface->w );
        _int_range( &y, 0, surface->h );
        int offset;
        offset = _calc_offset( surface, x, y);
        if(SDL_MUSTLOCK(surface) && SDL_LockSurface(surface) < 0)
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

        if( SvOK(rt) )
            r_rect = *(SDL_Rect*)bag2obj( create_mortal_rect( rt ) );
        else
        {
            r_rect.x = 0; r_rect.y = 0; r_rect.w = surface->w; r_rect.h = surface->h;
        }
        SDL_FillRect(surface, &r_rect, m_color);

#ifdef HAVE_SDL_GFX_PRIMITIVES

SV *
surfacex_draw_polygon ( surface, vectors, color, ... )
    SV* surface
    AV* vectors
    Uint32 color
    CODE:
        SDL_Surface * _surface = (SDL_Surface *)bag2obj(surface);
        AV* vx                 = newAV();
        AV* vy                 = newAV();
        AV* vertex;
        while(av_len(vectors) >= 0)
        {
            vertex = (AV*)SvRV(av_shift(vectors));
            av_push(vx, av_shift(vertex));
            av_push(vy, av_shift(vertex));
        }
        
        int n          = av_len(vx) + 1;
        Sint16 * _vx   = av_to_sint16(vx);
        Sint16 * _vy   = av_to_sint16(vy);
        if ( items > 3 && SvTRUE( ST(3) ) )
            aapolygonColor( _surface, _vx, _vy, n, color );
        else
            polygonColor( _surface, _vx, _vy, n, color );
        _svinta_free( _vx, av_len(vx) );
        _svinta_free( _vy, av_len(vy) );
        RETVAL = SvREFCNT_inc(surface); // why SvREFCNT_inc?
    OUTPUT:
        RETVAL

#endif

void
surfacex_blit( src, dest, ... )
    SV *src
    SV *dest
    CODE:
        assert_surface(src);
        assert_surface(dest);
        /* just return the pointer stored in the bag */
        SDL_Surface *_src  = (SDL_Surface *)bag2obj(src);
        SDL_Surface *_dest = (SDL_Surface *)bag2obj(dest);

        SDL_Rect _src_rect;
        SDL_Rect _dest_rect;

        if( items > 2 && SvOK(ST(2)) )
            _src_rect = *(SDL_Rect *)bag2obj( create_mortal_rect( ST(2) ) );
        else
        {
            _src_rect.x = 0;
            _src_rect.y = 0;
            _src_rect.w = _src->w;
            _src_rect.h = _src->h;
        }
        
        if( items > 3 && SvOK(ST(3)) )
            _dest_rect = *(SDL_Rect *)bag2obj( create_mortal_rect( ST(3) ) );
        else
        {
            _dest_rect.x = 0;
            _dest_rect.y = 0;
            _dest_rect.w = _dest->w;
            _dest_rect.h = _dest->h;
        }
        
        SDL_BlitSurface( _src, &_src_rect, _dest, &_dest_rect );
