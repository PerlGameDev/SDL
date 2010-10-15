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

		RETVAL = newSViv( retval );
	    
	    
	     

	OUTPUT:
	RETVAL

