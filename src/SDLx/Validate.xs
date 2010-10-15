#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDLx/Validate.h>

MODULE = SDLx::Validate 	PACKAGE = SDLx::Validate    PREFIX = val_

SV* val__color_number( color, alpha )
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
