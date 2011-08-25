#include "ppport.h"
#include <SDL.h>
#include "helper.h"

SV *rect( SV *rect, int* new_rect_made)
{
    SV *retval = NULL;
    /*we hand this over to perl to handle */

    if( !SvOK(rect) )
    {
        SDL_Rect* r = safemalloc( sizeof(SDL_Rect) );
        (*new_rect_made) = 1;
        r->x        = 0;
        r->y        = 0;
        r->w        = 0;
        r->h        = 0;
        retval      = obj2bag( sizeof( SDL_Rect *), (void *)(r), "SDL::Rect" );
    }
    else if( sv_derived_from(rect, "ARRAY") )
    {
        SDL_Rect* r = safemalloc( sizeof(SDL_Rect) );
        (*new_rect_made) = 1;
        int ra[4];
        int i            = 0;
        AV* recta        = (AV*)SvRV(rect);
        int len          = av_len(recta);
        for(i = 0; i < 4; i++)
        { 
            SV* iv = i > len ? NULL : AvARRAY(recta)[i];
            if( iv == NULL || !SvOK( iv ) || iv == &PL_sv_undef )
                ra[i] = 0;
            else
                ra[i] = SvIV( iv );
        }

        r->x   = ra[0]; r->y = ra[1]; r->w = ra[2]; r->h= ra[3];
        retval = obj2bag( sizeof( SDL_Rect *), (void *)(r), "SDL::Rect" );
    }
    else if( sv_isobject(rect) && sv_derived_from(rect, "SDL::Rect") )
    {
        (*new_rect_made) = 0;
        retval = rect;
        SvREFCNT_inc(rect);
    }
    else
        croak("Rect must be number or arrayref or SDL::Rect or undef");

    //SvREFCNT_inc(rect);
    return retval;
}

SV *surface( SV *surface )
{
    if( sv_isobject(surface) && sv_derived_from(surface, "SDL::Surface"))
    {
        SvREFCNT_inc(surface);
        return surface;
    }
    croak("Surface must be SDL::Surface or SDLx::Surface");
    return NULL;
}

char *_color_format( SV *color )
{
    char *retval = NULL;
    if( !SvOK(color) || SvIOK(color) )
        retval = "number";
    else if( sv_derived_from(color, "ARRAY") )
        retval = "arrayref";
    else if( sv_isobject(color) && sv_derived_from(color, "SDL::Color") )
        retval = "SDLx::Color";
    else
        croak("Color must be number or arrayref or SDLx::Color");

    return retval;
}

SV *_color_number( SV *color, SV *alpha )
{
    int          c      = SvIV(color);
    int          a      = SvIV(alpha);
    unsigned int retval = SvUV(color);

    if( !SvOK(color) || color < 0 )
    {
        if( color < 0 )
        croak("Color was a negative number");
        retval = a == 1 ? 0x000000FF : 0;
    }
    else
    {
        if( a == 1 && (c > 0xFFFFFFFF) )
        {
            croak("Color was number greater than maximum expected: 0xFFFFFFFF");
            retval = 0xFFFFFFFF; 
        }
        else if ( a != 1 && ( c > 0xFFFFFF) )
        {
            croak("Color was number greater than maximum expected: 0xFFFFFF");
            retval = 0xFFFFFF;
        }
    }

    return newSVuv(retval);
}

AV *_color_arrayref( AV *color, SV *alpha )
{
    AV *retval = (AV*)sv_2mortal((SV*)newAV());
    int length = SvTRUE(alpha) ? 4 : 3;
    int i      = 0;
    for(i = 0; i < length; i++)
    {
        if( av_len(color) < i || !SvOK(AvARRAY(color)[i]) )
            av_push(retval, newSVuv(i == 3 ? 0xFF : 0));
        else
        {
            int c = SvIV(AvARRAY(color)[i]);
            if( c > 0xFF )
            {
                croak("Number in color arrayref was greater than maximum expected: 0xFF");
                av_push(retval, newSVuv(0xFF));
            }
            else if( c < 0 )
            {
                croak("Number in color arrayref was negative");
                av_push(retval, newSVuv(0));
            }
            else
                av_push(retval, newSVuv(c));
        }
    }
    
    return retval;
}


AV* __list_rgb( SV* color )
{
    char *format = _color_format(color);
    AV* RETVAL   = newAV();
    if ( 0 == strcmp("number", format) )
    {
        RETVAL = (AV*)sv_2mortal((SV *)RETVAL);
        unsigned int _color = SvUV(sv_2mortal(_color_number(color, newSVuv(0))));
        av_push(RETVAL, newSVuv(_color >> 16 & 0xFF));
        av_push(RETVAL, newSVuv(_color >>  8 & 0xFF));
        av_push(RETVAL, newSVuv(_color       & 0xFF));
    }
    else if ( 0 == strcmp("arrayref", format) )
    {
        RETVAL = _color_arrayref((AV *)SvRV(color), sv_2mortal(newSVuv(0)));
    }
    else if ( 0 == strcmp("SDLx::Color", format) )
    {
        RETVAL = (AV*)sv_2mortal((SV *)RETVAL);
        SDL_Color *_color = (SDL_Color *)bag2obj(color);
        av_push(RETVAL, newSVuv(_color->r));
        av_push(RETVAL, newSVuv(_color->g));
        av_push(RETVAL, newSVuv(_color->b));
    }
    else
    {
        RETVAL = (AV*)sv_2mortal((SV *)RETVAL);
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0));
    }
    
    return RETVAL;
}


AV* __list_rgba( SV* color )
{
    char *format = _color_format(color);
    AV* RETVAL   = newAV();
    if ( 0 == strcmp("number", format) )
    {
        RETVAL = (AV*)sv_2mortal((SV *)RETVAL);
        unsigned int _color = SvUV(sv_2mortal(_color_number(color, sv_2mortal(newSVuv(1)))));
        av_push(RETVAL, newSVuv(_color >> 24 & 0xFF));
        av_push(RETVAL, newSVuv(_color >> 16 & 0xFF));
        av_push(RETVAL, newSVuv(_color >>  8 & 0xFF));
        av_push(RETVAL, newSVuv(_color       & 0xFF));
    }
    else if ( 0 == strcmp("arrayref", format) )
    {
        RETVAL = _color_arrayref((AV *)SvRV(color), sv_2mortal(newSVuv(1)));
    }
    else if ( 0 == strcmp("SDLx::Color", format) )
    {
        RETVAL = (AV*)sv_2mortal((SV *)RETVAL);
        SDL_Color *_color = (SDL_Color*)bag2obj(color);
        av_push(RETVAL, newSVuv(_color->r));
        av_push(RETVAL, newSVuv(_color->g));
        av_push(RETVAL, newSVuv(_color->b));
        av_push(RETVAL, newSVuv(0xFF));
    }
    else
    {
        RETVAL = (AV*)sv_2mortal((SV *)RETVAL);
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0xFF));
    }

    return RETVAL;
}


unsigned int __map_rgb( SV* color, SDL_PixelFormat* format )
{
	Uint8 r,g,b;
	AV* a = __list_rgb( color );
	r = SvUV(*av_fetch(a, 0, 0));
	g = SvUV(*av_fetch(a, 1, 0));
	b = SvUV(*av_fetch(a, 2, 0));

	return SDL_MapRGB( format, r, g, b ); 

}

unsigned int __map_rgba( SV* color, SDL_PixelFormat* format )
{
	int r,g,b,a;
	AV* ar = __list_rgba( color );
	r = SvUV(*av_fetch(ar, 0, 0));
	g = SvUV(*av_fetch(ar, 1, 0));
	b = SvUV(*av_fetch(ar, 2, 0));
	a = SvUV(*av_fetch(ar, 3, 0));

	return SDL_MapRGBA( format, r, g, b, a );
}
