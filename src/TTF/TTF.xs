#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <SDL.h>

#ifdef HAVE_SDL_TTF
#include <SDL_ttf.h>

static char *utf8_to_UTF8(char *s)
{
	return s;
}

static Uint16 *utf16be_to_UNICODE(SV *sv)
{
	STRLEN len;
	char *text      = SvPV(sv, len);
	len            /= 2;
	Uint16 *unicode = safemalloc((len + 2) * sizeof(Uint16));
	int i;

	unicode[0] = UNICODE_BOM_NATIVE;
	for( i = 0; i <= len; i++ )
	{
		unicode[i + 1] = (((const unsigned char *)text)[i * 2] << 2) | ((const unsigned char *)text)[i * 2 + 1];
	}
	unicode[i] = 0;

	return unicode;
}

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
ttf_init()
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
		RETVAL = safemalloc(sizeof(TTF_Font *));
		RETVAL = TTF_OpenFont(file, ptsize);
	OUTPUT:
		RETVAL

TTF_Font *
ttf_open_font_index(file, ptsize, index)
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
ttf_open_font_RW(src, freesrc, ptsize)
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
ttf_open_font_index_RW(src, freesrc, ptsize, index)
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
ttf_get_font_style(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_GetFontStyle(font);
	OUTPUT:
		RETVAL

void
ttf_set_font_style(font, style)
	TTF_Font *font
	int style
	CODE:
		TTF_SetFontStyle(font, style);

int
ttf_font_height(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontHeight(font);
	OUTPUT:
		RETVAL

int
ttf_font_ascent(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontAscent(font);
	OUTPUT:
		RETVAL

int
ttf_font_descent(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontDescent(font);
	OUTPUT:
		RETVAL

int
ttf_font_line_skip(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontLineSkip(font);
	OUTPUT:
		RETVAL

long
ttf_font_faces(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontFaces(font);
	OUTPUT:
		RETVAL

int
ttf_font_face_is_fixed_width(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontFaceIsFixedWidth(font);
	OUTPUT:
		RETVAL

char *
ttf_font_face_family_name(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontFaceFamilyName(font);
	OUTPUT:
		RETVAL

char *
ttf_font_face_style_name(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontFaceStyleName(font);
	OUTPUT:
		RETVAL

AV *
ttf_glyph_metrics(font, ch)
	TTF_Font *font
	char ch
	CODE:
		int minx, maxx, miny, maxy, advance;
		if(TTF_GlyphMetrics(font, ch, &minx, &maxx, &miny, &maxy, &advance) == 0)
		{
			RETVAL = newAV();
			sv_2mortal((SV*)RETVAL);
			av_push(RETVAL,newSViv(minx));
			av_push(RETVAL,newSViv(maxx));
			av_push(RETVAL,newSViv(miny));
			av_push(RETVAL,newSViv(maxy));
			av_push(RETVAL,newSViv(advance));
		}
		else
			XSRETURN_UNDEF;
	OUTPUT:
		RETVAL

AV *
ttf_size_text(font, text)
	TTF_Font *font
	const char *text
	CODE:
		int w, h;
		if(0 == TTF_SizeText(font, text, &w, &h))
		{
			RETVAL = newAV();
			sv_2mortal((SV*)RETVAL);
			av_push(RETVAL,newSViv(w));
			av_push(RETVAL,newSViv(h));
		}
		else
			XSRETURN_UNDEF;
	OUTPUT:
		RETVAL

AV *
ttf_size_utf8(font, text)
	TTF_Font *font
	const char *text
	CODE:
		int w, h;
		if(0 == TTF_SizeUTF8(font, text, &w, &h))
		{
			RETVAL = newAV();
			sv_2mortal((SV*)RETVAL);
			av_push(RETVAL,newSViv(w));
			av_push(RETVAL,newSViv(h));
		}
		else
			XSRETURN_UNDEF;
	OUTPUT:
		RETVAL

AV *
ttf_size_unicode(font, text)
	TTF_Font *font
	SV *text
	CODE:
		int w, h;
		if(0 == TTF_SizeUNICODE(font, utf16be_to_UNICODE(text), &w, &h))
		{
			RETVAL = newAV();
			sv_2mortal((SV*)RETVAL);
			av_push(RETVAL,newSViv(w));
			av_push(RETVAL,newSViv(h));
		}
		else
			XSRETURN_UNDEF;
	OUTPUT:
		RETVAL

SDL_Surface *
ttf_render_text_solid(font, text, fg)
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
ttf_render_utf8_solid(font, text, fg)
	TTF_Font *font
	char *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		//STRLEN len;
		//utf8_to_bytes(text, &len);
		RETVAL = TTF_RenderUTF8_Solid(font, utf8_to_UTF8(text), *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
ttf_render_unicode_solid(font, text, fg)
	TTF_Font *font
	SV *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUNICODE_Solid(font, utf16be_to_UNICODE(text), *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
ttf_render_glyph_solid(font, ch, fg)
	TTF_Font *font
	char ch
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderGlyph_Solid(font, ch, *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
ttf_render_text_shaded(font, text, fg, bg)
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
ttf_render_utf8_shaded(font, text, fg, bg)
	TTF_Font *font
	char *text
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUTF8_Shaded(font, text, *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
ttf_render_unicode_shaded(font, text, fg, bg)
	TTF_Font *font
	SV *text
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUNICODE_Shaded(font, utf16be_to_UNICODE(text), *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
ttf_render_glyph_shaded(font, ch, fg, bg)
	TTF_Font *font
	char ch
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderGlyph_Shaded(font, ch, *fg, *bg);
	OUTPUT:
		RETVAL

SDL_Surface *
ttf_render_text_blended(font, text, fg)
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
ttf_render_utf8_blended(font, text, fg)
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
ttf_render_unicode_blended(font, text, fg)
	TTF_Font *font
	SV *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUNICODE_Blended(font, utf16be_to_UNICODE(text), *fg);
	OUTPUT:
		RETVAL

SDL_Surface *
ttf_render_glyph_blended(font, ch, fg)
	TTF_Font *font
	char ch
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderGlyph_Blended(font, ch, *fg);
	OUTPUT:
		RETVAL

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
