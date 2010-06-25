#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <SDL.h>

#ifdef HAVE_SDL_PANGO
#include <SDL_Pango.h>

SDLPango_Matrix _MATRIX_DEFAULT
    = {0, 255, 0, 0,
       0, 255, 0, 0,
       0, 255, 0, 0,
       0, 255, 0, 0,};

SDLPango_Matrix *MATRIX_DEFAULT = &_MATRIX_DEFAULT;

#endif

MODULE = SDL::Pango	PACKAGE = SDL::Pango	PREFIX = pango_

=for documentation

See L<http:/*sdlpango.sourceforge.net/> */

=cut

#ifdef HAVE_SDL_PANGO

int
pango_init()
	CODE:
		RETVAL = SDLPango_Init();
	OUTPUT:
		RETVAL

int
pango_was_init()
	CODE:
		RETVAL = SDLPango_WasInit();
	OUTPUT:
		RETVAL

void
pango_draw(context, surface, x, y)
	SDLPango_Context *context
	SDL_Surface *surface
	int x
	int y
	CODE:
		SDLPango_Draw(context, surface, x, y);

int
pango_get_layout_width(context)
	SDLPango_Context *context
	CODE:
		RETVAL = SDLPango_GetLayoutWidth(context);
	OUTPUT:
		RETVAL

int
pango_get_layout_height(context)
	SDLPango_Context *context
	CODE:
		RETVAL = SDLPango_GetLayoutHeight(context);
	OUTPUT:
		RETVAL

void
pango_set_default_color(context, ...)
	SDLPango_Context *context
	/*const SDLPango_Matrix *color_matrix */
	CODE:
		if(items == 3) /* context, foreground, background */
		{
			Uint32 fg = SvIV(ST(1));
			Uint32 bg = SvIV(ST(2));
			MATRIX_DEFAULT->m[0][1] = (fg >> 24) & 0xFF; /* fg red */
			MATRIX_DEFAULT->m[1][1] = (fg >> 16) & 0xFF; /* fg green */
			MATRIX_DEFAULT->m[2][1] = (fg >>  8) & 0xFF; /* fg blue */
			MATRIX_DEFAULT->m[3][1] =  fg        & 0xFF; /* fg alpha */
			MATRIX_DEFAULT->m[0][0] = (bg >> 24) & 0xFF; /* bg red */
			MATRIX_DEFAULT->m[1][0] = (bg >> 16) & 0xFF; /* bg green */
			MATRIX_DEFAULT->m[2][0] = (bg >>  8) & 0xFF; /* bg blue */
			MATRIX_DEFAULT->m[3][0] =  bg        & 0xFF; /* bg alpha */
			SDLPango_SetDefaultColor(context, MATRIX_DEFAULT);
		}
		else if(items == 9) /* context, fr, fg, fb, fa, br, bg, bb, ba */
		{
			MATRIX_DEFAULT->m[0][1] = SvIV(ST(1)); /* fg red */
			MATRIX_DEFAULT->m[1][1] = SvIV(ST(2)); /* fg green */
			MATRIX_DEFAULT->m[2][1] = SvIV(ST(3)); /* fg blue */
			MATRIX_DEFAULT->m[3][1] = SvIV(ST(4)); /* fg alpha */
			MATRIX_DEFAULT->m[0][0] = SvIV(ST(5)); /* bg red */
			MATRIX_DEFAULT->m[1][0] = SvIV(ST(6)); /* bg green */
			MATRIX_DEFAULT->m[2][0] = SvIV(ST(7)); /* bg blue */
			MATRIX_DEFAULT->m[3][0] = SvIV(ST(8)); /* bg alpha */
			SDLPango_SetDefaultColor(context, MATRIX_DEFAULT);
		}
		else
			croak("Usage: SDL::Pango::set_default_color(context, fg, bg) or (context, r, g, b, a, r, g, b, a)");

void
pango_set_markup(context, markup, length)
	SDLPango_Context *context
	const char *markup
	int length
	CODE:
		SDLPango_SetMarkup(context, markup, length);

void
pango_set_minimum_size(context, width, height)
	SDLPango_Context *context
	int width
	int height
	CODE:
		SDLPango_SetMinimumSize(context, width, height);

void
pango_set_surface_create_args(context, flags, depth, Rmask, Gmask, Bmask, Amask)
	SDLPango_Context *context
	Uint32 flags
    int depth
    Uint32 Rmask
	Uint32 Gmask
	Uint32 Bmask
	Uint32 Amask
	CODE:
		SDLPango_SetSurfaceCreateArgs(context, flags, depth, Rmask, Gmask, Bmask, Amask);

SDL_Surface *
pango_create_surface_draw(context)
	SDLPango_Context *context
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = SDLPango_CreateSurfaceDraw(context);
	OUTPUT:
		RETVAL

void
pango_set_dpi(context, dpi_x, dpi_y)
	SDLPango_Context *context
	double dpi_x
	double dpi_y
	CODE:
		SDLPango_SetDpi(context, dpi_x, dpi_y);

void
pango_set_text(context, markup, length, alignment = SDLPANGO_ALIGN_LEFT)
	SDLPango_Context *context
	const char *markup
	int length
	SDLPango_Alignment alignment
	CODE:
		SDLPango_SetText_GivenAlignment(context, markup, length, alignment);

void
pango_set_language(context, language_tag)
	SDLPango_Context *context
	const char *language_tag
	CODE:
		SDLPango_SetLanguage(context, language_tag);

void
pango_set_base_direction(context, direction)
	SDLPango_Context *context
	int direction
	CODE:
		SDLPango_SetBaseDirection(context, direction);

#endif
