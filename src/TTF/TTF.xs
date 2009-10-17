#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include <SDL_ttf.h>

MODULE = SDL	PACKAGE = SDL
PROTOTYPES : DISABLE


=for comment

These are here right now to keep them around with using the code.

int
TTFGetFontStyle ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_GetFontStyle(font);
	OUTPUT:
		RETVAL

void
TTFSetFontStyle ( font, style )
	TTF_Font *font
	int style
	CODE:
		TTF_SetFontStyle(font,style);
	
int
TTFFontHeight ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontHeight(font);
	OUTPUT:
		RETVAL

int
TTFFontAscent ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontAscent(font);
	OUTPUT:
		RETVAL

int
TTFFontDescent ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontDescent(font);
	OUTPUT:
		RETVAL

int
TTFFontLineSkip ( font )
	TTF_Font *font
	CODE:
		RETVAL = TTF_FontLineSkip(font);
	OUTPUT:
		RETVAL

AV*
TTFGlyphMetrics ( font, ch )
	TTF_Font *font
	Uint16 ch
	CODE:
		int minx, miny, maxx, maxy, advance;
		RETVAL = newAV();
		TTF_GlyphMetrics(font, ch, &minx, &miny, &maxx, &maxy, &advance);
		av_push(RETVAL,newSViv(minx));
		av_push(RETVAL,newSViv(miny));
		av_push(RETVAL,newSViv(maxx));
		av_push(RETVAL,newSViv(maxy));
		av_push(RETVAL,newSViv(advance));
	OUTPUT:
		RETVAL


AV*
TTFSizeUTF8 ( font, text )
	TTF_Font *font
	char *text
	CODE:
		int w,h;
		RETVAL = newAV();
		if(TTF_SizeUTF8(font,text,&w,&h))
		{
			av_push(RETVAL,newSViv(w));
			av_push(RETVAL,newSViv(h));
			sv_2mortal((SV*)RETVAL);

		}
		else
		{
			printf("TTF error at TTFSizeUTF8 with : %s \n", TTF_GetError());
			Perl_croak (aTHX_ "TTF error \n");
		}
		
	OUTPUT:
		RETVAL

AV*
TTFSizeUNICODE ( font, text )
	TTF_Font *font
	const Uint16 *text
	CODE:
		int w,h;
		RETVAL = newAV();
		if(TTF_SizeUNICODE(font,text,&w,&h))
		{
			av_push(RETVAL,newSViv(w));
			av_push(RETVAL,newSViv(h));
			sv_2mortal((SV*)RETVAL);

		}
		else
		{
			printf("TTF error at TTFSizeUNICODE : %s \n", TTF_GetError()); 
			Perl_croak (aTHX_ "TTF error \n");
		}

	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderTextSolid ( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderText_Solid(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUTF8Solid ( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderUTF8_Solid(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUNICODESolid ( font, text, fg )
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderUNICODE_Solid(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderGlyphSolid ( font, ch, fg )
	TTF_Font *font
	Uint16 ch
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderGlyph_Solid(font,ch,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderTextShaded ( font, text, fg, bg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	SDL_Color *bg
	CODE:
		RETVAL = TTF_RenderText_Shaded(font,text,*fg,*bg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUTF8Shaded( font, text, fg, bg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	SDL_Color *bg
	CODE:
		RETVAL = TTF_RenderUTF8_Shaded(font,text,*fg,*bg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUNICODEShaded( font, text, fg, bg )
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	SDL_Color *bg
	CODE:
		RETVAL = TTF_RenderUNICODE_Shaded(font,text,*fg,*bg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderGlyphShaded ( font, ch, fg, bg )
	TTF_Font *font
	Uint16 ch
	SDL_Color *fg
	SDL_Color *bg
	CODE:
		RETVAL = TTF_RenderGlyph_Shaded(font,ch,*fg,*bg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderTextBlended( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderText_Blended(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUTF8Blended( font, text, fg )
	TTF_Font *font
	char *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderUTF8_Blended(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderUNICODEBlended( font, text, fg )
	TTF_Font *font
	const Uint16 *text
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderUNICODE_Blended(font,text,*fg);
	OUTPUT:
		RETVAL

SDL_Surface*
TTFRenderGlyphBlended( font, ch, fg )
	TTF_Font *font
	Uint16 ch
	SDL_Color *fg
	CODE:
		RETVAL = TTF_RenderGlyph_Blended(font,ch,*fg);
	OUTPUT:
		RETVAL

void
TTFCloseFont ( font )
	TTF_Font *font
	CODE:
		TTF_CloseFont(font);
		font=NULL; //to be safe http://sdl.beuc.net/sdl.wiki/SDL_ttf_copy_Functions_Management_TTF_CloseFont

SDL_Surface*
TTFPutString ( font, mode, surface, x, y, fg, bg, text )
	TTF_Font *font
	int mode
	SDL_Surface *surface
	int x
	int y
	SDL_Color *fg
	SDL_Color *bg
	char *text
	CODE:
		SDL_Surface *img;
		SDL_Rect dest;
		int w,h;
		dest.x = x;
		dest.y = y;
		RETVAL = NULL;
		switch (mode) {
			case TEXT_SOLID:
				img = TTF_RenderText_Solid(font,text,*fg);
				TTF_SizeText(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case TEXT_SHADED:
				img = TTF_RenderText_Shaded(font,text,*fg,*bg);
				TTF_SizeText(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case TEXT_BLENDED:
				img = TTF_RenderText_Blended(font,text,*fg);
				TTF_SizeText(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UTF8_SOLID:
				img = TTF_RenderUTF8_Solid(font,text,*fg);
				TTF_SizeUTF8(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UTF8_SHADED:
				img = TTF_RenderUTF8_Shaded(font,text,*fg,*bg);
				TTF_SizeUTF8(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UTF8_BLENDED:
				img = TTF_RenderUTF8_Blended(font,text,*fg);
				TTF_SizeUTF8(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UNICODE_SOLID:
				img = TTF_RenderUNICODE_Solid(font,(Uint16*)text,*fg);
				TTF_SizeUNICODE(font,(Uint16*)text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UNICODE_SHADED:
				img = TTF_RenderUNICODE_Shaded(font,(Uint16*)text,*fg,*bg);
				TTF_SizeUNICODE(font,(Uint16*)text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			case UNICODE_BLENDED:
				img = TTF_RenderUNICODE_Blended(font,(Uint16*)text,*fg);
				TTF_SizeUNICODE(font,(Uint16*)text,&w,&h);
				dest.w = w;
				dest.h = h;
				break;
			default:
				img = TTF_RenderText_Shaded(font,text,*fg,*bg);
				TTF_SizeText(font,text,&w,&h);
				dest.w = w;
				dest.h = h;
		}
		if ( img && img->format && img->format->palette ) {
			SDL_Color *c = &img->format->palette->colors[0];
			Uint32 key = SDL_MapRGB( img->format, c->r, c->g, c->b );
			SDL_SetColorKey(img,SDL_SRCCOLORKEY,key );
			if (0 > SDL_BlitSurface(img,NULL,surface,&dest)) {
				SDL_FreeSurface(img);
				RETVAL = NULL;	
			} else {
				RETVAL = img;
			}
		}
	OUTPUT:
		RETVAL

=cut
