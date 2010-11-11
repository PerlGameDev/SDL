#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#include <SDL.h>

#ifdef HAVE_SDL_TTF
#include <SDL_ttf.h>

#ifndef SDL_TTF_MAJOR_VERSION
#define SDL_TTF_MAJOR_VERSION	0
#endif

#ifndef SDL_TTF_MINOR_VERSION
#define SDL_TTF_MINOR_VERSION	0
#endif

#ifndef SDL_TTF_PATCHLEVEL
#define SDL_TTF_PATCHLEVEL	0
#endif

#define SDL_TTF_VERSION(X)						\
{									\
	(X)->major = SDL_TTF_MAJOR_VERSION;				\
	(X)->minor = SDL_TTF_MINOR_VERSION;				\
	(X)->patch = SDL_TTF_PATCHLEVEL;				\
}

static Uint16 *UTF8_to_UNICODE(Uint16 *unicode, const char *utf8, int len)
{
	int i, j;
	Uint16 ch;

	for ( i=0, j=0; i < len; ++i, ++j ) {
		ch = ((const unsigned char *)utf8)[i];
		if ( ch >= 0xF0 ) {
			ch  =  (Uint16)(utf8[i]&0x07) << 18;
			ch |=  (Uint16)(utf8[++i]&0x3F) << 12;
			ch |=  (Uint16)(utf8[++i]&0x3F) << 6;
			ch |=  (Uint16)(utf8[++i]&0x3F);
		} else
		if ( ch >= 0xE0 ) {
			ch  =  (Uint16)(utf8[i]&0x0F) << 12;
			ch |=  (Uint16)(utf8[++i]&0x3F) << 6;
			ch |=  (Uint16)(utf8[++i]&0x3F);
		} else
		if ( ch >= 0xC0 ) {
			ch  =  (Uint16)(utf8[i]&0x1F) << 6;
			ch |=  (Uint16)(utf8[++i]&0x3F);
		}
		unicode[j] = ch;
	}
	unicode[j] = 0;
	
	return unicode;
}

static Uint16 *utf16_to_UNICODE(SV *sv)
{
	STRLEN len;
	char *text      = SvPV(sv, len);
	len            /= 2;                                      /* 1-Byte chars to 2-Byte Uint16 */
	Uint16 *unicode = safemalloc((len + 2) * sizeof(Uint16)); /* length = BOM + characters + NULL */
	int i;

	/* UTF-16 Big Endian with BOM */
	if((Uint8)text[0] == 0xFE && (Uint8)text[1] == 0xFF)
	{
		for( i = 0; i < len; i++ )
		{
			unicode[i] = ((Uint8)text[i * 2] << 8) | (Uint8)text[i * 2 + 1];
		}
		unicode[i] = 0;
	}
	
	else
	/* UTF-16 Little Endian with BOM */
	if((Uint8)text[0] == 0xFF && (Uint8)text[1] == 0xFE)
	{
		for( i = 0; i < len; i++ )
		{
			unicode[i] = ((Uint8)text[i * 2 + 1] << 8) | (Uint8)text[i * 2];
		}
		unicode[i] = 0;
	}
	
	else /* everything without BOM is treated as UTF-16 Big Endian */
	{
		unicode[0] = 0xFEFF; /* we have to pass it as UTF-16 Big Endian */
		for( i = 0; i <= len; i++ )
		{
			unicode[i + 1] = (text[i * 2] << 8) | text[i * 2 + 1];
		}
		unicode[i] = 0;
	}

	return unicode;
}

#endif

MODULE = SDL::TTF	PACKAGE = SDL::TTF	PREFIX = ttf_

#ifdef HAVE_SDL_TTF

const SDL_version *
ttf_linked_version()
	PREINIT:
		char* CLASS = "SDL::Version";
		SDL_version *version;
	CODE:
		version = (SDL_version *) safemalloc ( sizeof(SDL_version) );
		SDL_version* version_dont_free = (SDL_version *)TTF_Linked_Version();

		version->major = version_dont_free->major;
		version->minor = version_dont_free->minor;
		version->patch = version_dont_free->patch;
		RETVAL = version;
	OUTPUT:
		RETVAL

const SDL_version *
ttf_compile_time_version()
	PREINIT:
		char* CLASS = "SDL::Version";
	CODE:
		SDL_version *compile_time_version = safemalloc(sizeof(SDL_version));
		SDL_TTF_VERSION(compile_time_version);
		RETVAL = compile_time_version;
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
		char* CLASS = "SDL::TTF::Font";
	CODE:
		RETVAL = TTF_OpenFont(file, ptsize);
	OUTPUT:
		RETVAL

TTF_Font *
ttf_open_font_index(file, ptsize, index)
	char *file
	int ptsize
	long index
	PREINIT:
		char* CLASS = "SDL::TTF::Font";
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
		char* CLASS = "SDL::TTF::Font";
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
		char* CLASS = "SDL::TTF::Font";
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
	SV *ch
	CODE:
		int minx, maxx, miny, maxy, advance;
		
		if(TTF_GlyphMetrics(font, *(utf16_to_UNICODE(ch)+1), &minx, &maxx, &miny, &maxy, &advance) == 0)
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
		if(0 == TTF_SizeUNICODE(font, utf16_to_UNICODE(text), &w, &h))
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
	SV *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		/* this is buggy, see: http://bugzilla.libsdl.org/show_bug.cgi?id=970 */
		/*RETVAL = TTF_RenderUTF8_Solid(font, text, *fg); */
		
		STRLEN len;
		unsigned char*utf8_text = SvPV(text, len);
		Uint16 *unicode         = safemalloc((sv_len_utf8(text) + 2) * sizeof(Uint16));
		*unicode                = 0xFEFF;
		UTF8_to_UNICODE(unicode+1, utf8_text, len);

		RETVAL = TTF_RenderUNICODE_Solid(font, unicode, *fg);
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
		RETVAL = TTF_RenderUNICODE_Solid(font, utf16_to_UNICODE(text), *fg);
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
	SV *text
	SDL_Color *fg
	SDL_Color *bg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUTF8_Shaded(font, SvPV(text, PL_na), *fg, *bg);
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
		RETVAL = TTF_RenderUNICODE_Shaded(font, utf16_to_UNICODE(text), *fg, *bg);
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
	SV *text
	SDL_Color *fg
	PREINIT:
		char* CLASS = "SDL::Surface";
	CODE:
		RETVAL = TTF_RenderUTF8_Blended(font, SvPV(text, PL_na), *fg);
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
		RETVAL = TTF_RenderUNICODE_Blended(font, utf16_to_UNICODE(text), *fg);
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

#if SDL_TTF_MAJOR_VERSION >= 2 && SDL_TTF_MINOR_VERSION >= 0 && SDL_TTF_PATCHLEVEL >= 10

int
ttf_get_font_outline(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_GetFontOutline(font);
	OUTPUT:
		RETVAL

void
ttf_set_font_outline(font, outline)
	TTF_Font *font
	int outline
	CODE:
		TTF_SetFontOutline(font, outline);

int
ttf_get_font_hinting(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_GetFontHinting(font);
	OUTPUT:
		RETVAL

void
ttf_set_font_hinting(font, hinting)
	TTF_Font *font
	int hinting
	CODE:
		TTF_SetFontHinting(font, hinting);

int
ttf_get_font_kerning(font)
	TTF_Font *font
	CODE:
		RETVAL = TTF_GetFontKerning(font);
	OUTPUT:
		RETVAL

void
ttf_set_font_kerning(font, allowed)
	TTF_Font *font
	int allowed
	CODE:
		TTF_SetFontKerning(font, allowed);

int
ttf_glyph_is_provided(font, ch);
	TTF_Font *font
	SV *ch
	CODE:
		RETVAL = TTF_GlyphIsProvided(font, *(utf16_to_UNICODE(ch)+1));
	OUTPUT:
		RETVAL

#endif

#endif
