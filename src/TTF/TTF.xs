#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <SDL.h>

#ifdef HAVE_SDL_TTF
#include <SDL_ttf.h>
#endif

MODULE = SDL::TTF	PACKAGE = SDL::TTF	PREFIX = ttf_

#ifdef HAVE_SDL_TTF

const SDL_version *
ttf_linked_version()
	PREINIT:
		char* CLASS = "SDL::Version";
	CODE:
		RETVAL = TTF_Linked_Version();
	OUTPUT:
		RETVAL

void
ttf_byte_swapped_unicode(swapped)
	int swapped
	CODE:
		TTF_ByteSwappedUNICODE(swapped);

int
ttt_Init()
	CODE:
		RETVAL = TTF_Init();
	OUTPUT:
		RETVAL

TTF_Font *
ttf_open_font(file, ptsize)
	const char *file
	int ptsize
	PREINIT:
		char* CLASS = "SDL::TTF_Font";
	CODE:
		RETVAL = TTF_OpenFont(file, ptsize);
	OUTPUT:
		RETVAL

TTF_Font *
TTF_OpenFontIndex(file, ptsize, index)
	char *file
	int ptsize
	long index
	PREINIT:
		char* CLASS = "SDL::TTF_Font";
	CODE:
		RETVAL = TTF_OpenFontIndex(file, ptsize, index);
	OUTPUT:
		RETVAL

TTF_Font *
TTF_OpenFontRW(src, freesrc, ptsize)
	SDL_RWops *src
	int freesrc
	int ptsize
	PREINIT:
		char* CLASS = "SDL::TTF_Font";
	CODE:
		RETVAL = TTF_OpenFontRW(src, freesrc, ptsize);
	OUTPUT:
		RETVAL

TTF_Font *
TTF_OpenFontIndexRW(src, freesrc, ptsize, index)
	SDL_RWops *src
	int freesrc
	int ptsize
	long index
	PREINIT:
		char* CLASS = "SDL::TTF_Font";
	CODE:
		RETVAL = TTF_OpenFontIndexRW(src, freesrc, ptsize, index);
	OUTPUT:
		RETVAL

int
TTF_GetFontStyle(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_GetFontStyle(font);
	OUTPUT:
		RETVAL

void
TTF_SetFontStyle(font, style)
	TTF_Font *font
	int style
	CODE:
		TTF_SetFontStyle(font, style);

int
TTF_FontHeight(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontHeight(font);
	OUTPUT:
		RETVAL

int
TTF_FontAscent(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontAscent(font);
	OUTPUT:
		RETVAL

int
TTF_FontDescent(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontDescent(font);
	OUTPUT:
		RETVAL

int
TTF_FontLineSkip(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontLineSkip(font);
	OUTPUT:
		RETVAL

long
TTF_FontFaces(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontFaces(font);
	OUTPUT:
		RETVAL

int
TTF_FontFaceIsFixedWidth(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontFaceIsFixedWidth(font);
	OUTPUT:
		RETVAL

char *
TTF_FontFaceFamilyName(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontFaceFamilyName(font);
	OUTPUT:
		RETVAL

char *
TTF_FontFaceStyleName(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontFaceStyleName(font);
	OUTPUT:
		RETVAL

int
TTF_GlyphMetrics(font, ch, minx, maxx, miny, maxy, advance)
	TTF_Font *font
	Uint16 ch
	int *minx
	int *maxx
	int *miny
	int *maxy
	int *advance
	CODE:
		RETVAL = TTF_GlyphMetrics(font, ch, minx, maxx, miny, maxy, advance);
	OUTPUT:
		RETVAL

int
TTF_SizeText(font, text, w, h)
	TTF_Font *font
	const char *text
	int *w
	int *h
	CODE:
		RETVAL = TTF_SizeText(font, text, w, h);
	OUTPUT:
		RETVAL

int
TTF_SizeUTF8(font, text, w, h)
	TTF_Font *font
	const char *text
	int *w
	int *h
	CODE:
		RETVAL = TTF_SizeUTF8(font, text, w, h);
	OUTPUT:
		RETVAL

int
TTF_SizeUNICODE(font, text, w, h)
	TTF_Font *font
	const Uint16 *text
	int *w
	int *h
	CODE:
		RETVAL = TTF_SizeUNICODE(font, text, w, h);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderText_Solid(font, text, fg)
	TTF_Font *font
	const char *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderText_Solid(font, text, *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderUTF8_Solid(font, text, fg)
	TTF_Font *font
	const char *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUTF8_Solid(font, text, *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderUNICODE_Solid(font, text, fg)
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUNICODE_Solid(font, text, *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderGlyph_Solid(font, ch, fg)
	TTF_Font *font
	Uint16 ch
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderGlyph_Solid(font, ch, *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderText(font, text, fg, bg)
	TTF_Font *font
	const char *text
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderText(font, text, *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderText_Shaded(font, text, fg, bg)
	TTF_Font *font
	const char *text
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderText_Shaded(font, text, *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderUTF8(font, text, fg, bg)
	TTF_Font *font
	const char *text
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUTF8(font, text, *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderUTF8_Shaded(font, text, fg, bg)
	TTF_Font *font
	const char *text
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUTF8_Shaded(font, text, *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderUNICODE(font, text, fg, bg)
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUNICODE(font, text, *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderUNICODE_Shaded(font, text, fg, bg)
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUNICODE_Shaded(font, text, *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderGlyph_Shaded(font, ch, fg, bg)
	TTF_Font *font
	Uint16 ch
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderGlyph_Shaded(font, ch, *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderText_Blended(font, text, fg)
	TTF_Font *font
	const char *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderText_Blended(font, text, *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderUTF8_Blended(font, text, fg)
	TTF_Font *font
	const char *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUTF8_Blended(font, text, *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderUNICODE_Blended(font, text, fg)
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUNICODE_Blended(font, text, *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
TTF_RenderGlyph_Blended(font, ch, fg)
	TTF_Font *font
	Uint16 ch
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderGlyph_Blended(font, ch, *fg);
	OUTPUT:
		RETVAL

void
ttf_close_font(font)
	TTF_Font *font
	CODE:
		TTF_CloseFont(font);

void
ttf_quit()
	CODE:
		TTF_Quit();

int
ttf_was_init()
	CODE:
		RETVAL = TTF_WasInit();
	OUTPUT:
		RETVAL

#endif
