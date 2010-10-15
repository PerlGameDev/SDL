#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDLx::Validate 	PACKAGE = SDLx::Validate    PREFIX = val_

SV* val__color_number( color, alpha)
	SV* color
	SV* alpha
	CODE:
	
	   int c = SvIV(color);
	   int a = SvIV(alpha);

	   unsigned int retval = SvUV(color);
	   int new = 0;

	   if( !SvOK(color) || color < 0 )
	     {
		  if( color < 0 )
		  	warn ( " Color was a negative number ");	
		  if( a == 1 )
			{ retval = 0x000000FF;  }
		  else
			{ retval = 0;  }
	     } else {
		if( a == 1 && (c > 0xFFFFFFFF) ) {
		
		warn ( "Color was number greater than maximum expected: 0xFFFFFFFF"); 	
	  	       retval = 0xFFFFFFFF; 
		}
		else if ( a != 1 && ( c > 0xFFFFFF) )
		{
	
		warn ( "Color was number greater than maximum expected: 0xFFFFFF"); 	
	  	       retval = 0xFFFFFF; 		}
	
	
	     }

		RETVAL = newSVuv( retval );
	    
	    
	     

	OUTPUT:
	RETVAL

AV *
val__color_arrayref( color, ... )
    AV *color
    CODE:
        RETVAL = newAV();

        int length = (items > 1 && ST(1)) ? 4 : 3;
        int i      = 0;
        for(i = 0; i < length; i++)
        {
            SV *c = *av_fetch(color, i, 0);

            if( av_len(color) < i || !SvOK(*av_fetch(color, i, 0)) )
                av_push(RETVAL, newSVuv(i == 3 ? 0xFF : 0));
            else
            {
                int c = SvIV(*av_fetch(color, i, 0));
                if( c > 0xFF )
                {
                    warn("Number in color arrayref was greater than maximum expected: 0xFF");
                    av_push(RETVAL, newSVuv(0xFF));
                }
                else if( c < 0 )
                {
                    warn("Number in color arrayref was negative");
                    av_push(RETVAL, newSVuv(0));
                }
                else
                    av_push(RETVAL, newSVuv(c));
            }
        }
	sv_2mortal((SV*)RETVAL);
    OUTPUT:
        RETVAL
