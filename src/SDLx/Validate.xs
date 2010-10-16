#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

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
            RETVAL = newSVuv(( SvUV(AvARRAY(c)[0]) << 16 ) + ( SvUV(AvARRAY(c)[1]) << 8 ) + SvUV(AvARRAY(c)[2]));
        }
        else if( 0 == strcmp("SDLx::Color", format) )
        {
            SDL_Color *_color = bag_to_color( color );
            RETVAL            = newSVuv(( (_color->r) << 16 ) + ( (_color->g) << 8 ) + _color->b);
        }
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

SV* 
val_rect( r )
    SV* r
    CODE:
	RETVAL = rect( r );
    OUTPUT:
	RETVAL
