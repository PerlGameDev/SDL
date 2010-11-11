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

MODULE = SDLx::Validate 	PACKAGE = SDLx::Validate    PREFIX = val_

char *
val__color_format( color )
    SV *color
    CODE:
        RETVAL = _color_format( color );
        if(NULL == RETVAL)
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

SV *
val__color_number( color, alpha )
    SV* color
    SV* alpha
    CODE:
        RETVAL = _color_number( color, alpha );
    OUTPUT:
        RETVAL

AV *
val__color_arrayref( color, ... )
    AV *color
    CODE:
        RETVAL = items > 1
               ? _color_arrayref( color, ST(1) )
               : _color_arrayref( color, newSVuv(0) );
    OUTPUT:
        RETVAL

SV *
val_num_rgb( color )
    SV *color
    CODE:
        char *format = _color_format( color );
        if( 0 == strcmp("number", format) )
            RETVAL = _color_number(color, newSVuv(0));
        else if( 0 == strcmp("arrayref", format) )
        {
            AV *c  = _color_arrayref( (AV *)SvRV(color), newSVuv(0) );
	    unsigned int v = (( SvUV(AvARRAY(c)[0]) << 16 ) + ( SvUV(AvARRAY(c)[1]) << 8 ) + SvUV(AvARRAY(c)[2]));
            RETVAL = newSVuv(v);
        }
        else if( 0 == strcmp("SDLx::Color", format) )
        {
            SDL_Color *_color = (SDL_Color*) bag2obj( color );
	    unsigned int v = ( (_color->r) << 16 ) + ( (_color->g) << 8 ) + _color->b;
            RETVAL            = newSVuv( v );
        }
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

SV *
val_num_rgba( color )
    SV *color
    CODE:
        char *format = _color_format( color );
        if( 0 == strcmp("number", format) )
        {
            RETVAL = _color_number(color, newSVuv(1));
        }
        else if( 0 == strcmp("arrayref", format) )
        {
            AV *c          = _color_arrayref( (AV *)SvRV(color), newSVuv(1) );
            unsigned int v = (SvUV(AvARRAY(c)[0]) << 24) + (SvUV(AvARRAY(c)[1]) << 16) + (SvUV(AvARRAY(c)[2]) << 8) + SvUV(AvARRAY(c)[3] );
            RETVAL         = newSVuv(v);
        }
        else if( 0 == strcmp("SDLx::Color", format) )
        {
            SDL_Color *_color = (SDL_Color*)bag2obj( color );
            unsigned int v    = (((_color->r) << 24) + ((_color->g) << 16) + ((_color->b) << 8) + 0xFF) ;
            RETVAL            = newSVuv( v );
        }
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

AV *
val_list_rgb( color )
    SV *color
    CODE:
	RETVAL = __list_rgb( color );
    OUTPUT:
        RETVAL

AV *
val_list_rgba( color )
    SV *color
    CODE:
	RETVAL = __list_rgba( color );
    OUTPUT:
        RETVAL

SV *
val_rect( r )
    SV* r
    CODE:
	int new_ = 0;
        RETVAL = rect( r, &new_ );
    OUTPUT:
        RETVAL

SV *
val_surface( s )
    SV* s
    CODE:
        RETVAL = surface(s);
        if(NULL == RETVAL)
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

SV *
val_map_rgb( color, format)
    SV* color
    SDL_PixelFormat * format
    CODE:
	RETVAL = newSVuv( __map_rgb( color, format ) );
    OUTPUT:
	RETVAL

SV *
val_map_rgba( color, format)
    SV* color
    SDL_PixelFormat * format
    CODE:
	RETVAL = newSVuv( __map_rgba( color, format ) );
    OUTPUT:
	RETVAL
