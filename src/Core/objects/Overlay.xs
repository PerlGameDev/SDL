#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>

MODULE = SDL::Overlay 	PACKAGE = SDL::Overlay    PREFIX = overlay_

=for documentation

SDL_Overlay -- YUV video overlay

typedef struct{
  Uint32 format;
  int w, h;
  int planes;
  Uint16 *pitches;
  Uint8 **pixels;
  Uint32 hw_overlay:1;
} SDL_Overlay;
}

=cut

