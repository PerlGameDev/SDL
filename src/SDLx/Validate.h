#include "ppport.h"
#include <SDL.h>
#include "helper.h"

/* SV input should be a mortal SV */
SV *create_mortal_rect( SV *rect )
{
    SV *retval = NULL;

    if( !SvOK(rect) )
    {
        /* create a new zero sized rectangle */
        SDL_Rect* r = safemalloc( sizeof(SDL_Rect) );
        r->x        = 0;
        r->y        = 0;
        r->w        = 0;
        r->h        = 0;
        retval      = obj2bag( sizeof( SDL_Rect *), (void *)(r), "SDL::Rect" );
        sv_2mortal(retval) ;
    }
    else if( sv_derived_from(rect, "ARRAY") )
    {
        /* create a new rectangle from the array */
        SDL_Rect* r      = safemalloc( sizeof(SDL_Rect) );
        AV* recta        = (AV*)SvRV(rect);
        int len          = av_len(recta);
        int i;
        int ra[4];
        for(i = 0; i < 4; i++)
        { 
            SV* iv = i > len ? NULL : AvARRAY(recta)[i];
            ra[i]  = ( iv == NULL || !SvOK( iv ) || iv == &PL_sv_undef )
                   ? 0
                   : SvIV( iv );
        }

        r->x   = ra[0]; r->y = ra[1]; r->w = ra[2]; r->h= ra[3];
        retval = obj2bag( sizeof( SDL_Rect *), (void *)(r), "SDL::Rect" );
        sv_2mortal(retval) ;
    }
    else if( sv_isobject(rect) && sv_derived_from(rect, "SDL::Rect") )
    {
        /* we already had a good mortal rect . Just pass it along */
        retval = rect;
    }
    else
        croak("Rect must be number or arrayref or SDL::Rect or undef");

    return retval; 
}

void assert_surface( SV *surface )
{
    if( sv_isobject(surface) && sv_derived_from(surface, "SDL::Surface"))
        return;

    croak("Surface must be SDL::Surface or SDLx::Surface");
    /* does not return */
}

char *_color_format( SV *color )
{
    char *retval = NULL;
    if( !SvOK(color) || SvIOK(color) )
        retval = "number";
    else if( sv_derived_from(color, "ARRAY") )
        retval = "arrayref";
    else if( sv_isobject(color) && sv_derived_from(color, "SDL::Color") )
        retval = "SDL::Color";
    else
        croak("Color must be number or arrayref or SDL::Color");

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
            warn("Color was a negative number");
        retval = a == 1
               ? 0x000000FF
               : 0;
    }
    else
    {
        if( a == 1 && (c > 0xFFFFFFFF) )
        {
            warn("Color was number greater than maximum expected: 0xFFFFFFFF");
            retval = 0xFFFFFFFF; 
        }
        else if ( a != 1 && ( c > 0xFFFFFF) )
        {
            warn("Color was number greater than maximum expected: 0xFFFFFF");
            retval = 0xFFFFFF;
        }
    }

    return newSVuv(retval);
}

/* returns a new mortal AV* */
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
                warn("Number in color arrayref was greater than maximum expected: 0xFF");
                av_push(retval, newSVuv(0xFF));
            }
            else if( c < 0 )
            {
                warn("Number in color arrayref was negative");
                av_push(retval, newSVuv(0));
            }
            else
                av_push(retval, newSVuv(c));
        }
    }
    
    return retval;
}

/* returns a mortal AV* */
AV* __list_rgb( SV* color )
{
    char *format = _color_format(color);
    AV* RETVAL ;
    if ( 0 == strcmp("number", format) )
    {
        RETVAL              = (AV*)sv_2mortal( (SV *) newAV() );
        unsigned int _color = SvUV(sv_2mortal(_color_number(color, newSVuv(0))));
        av_push(RETVAL, newSVuv(_color >> 16 & 0xFF));
        av_push(RETVAL, newSVuv(_color >>  8 & 0xFF));
        av_push(RETVAL, newSVuv(_color       & 0xFF));
    }
    else if ( 0 == strcmp("arrayref", format) )
    {
        /* _color_arrayref returns a mortal AV* */
        RETVAL = _color_arrayref((AV *)SvRV(color), sv_2mortal(newSVuv(0)));
    }
    else if ( 0 == strcmp("SDL::Color", format) )
    {
        RETVAL            = (AV*)sv_2mortal((SV *) newAV() );
        SDL_Color *_color = (SDL_Color *)bag2obj(color);
        av_push(RETVAL, newSVuv(_color->r));
        av_push(RETVAL, newSVuv(_color->g));
        av_push(RETVAL, newSVuv(_color->b));
    }
    else
    {
        RETVAL = (AV*)sv_2mortal((SV *) newAV() );
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0));
    }
    
    return RETVAL;
}

AV* __list_rgba( SV* color )
{
    char *format = _color_format(color);
    AV* RETVAL ;
    if ( 0 == strcmp("number", format) )
    {
        RETVAL              = (AV*)sv_2mortal((SV *) newAV() );
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
    else if ( 0 == strcmp("SDL::Color", format) )
    {
        RETVAL            = (AV*)sv_2mortal((SV *) newAV() );
        SDL_Color *_color = (SDL_Color*)bag2obj(color);
        av_push(RETVAL, newSVuv(_color->r));
        av_push(RETVAL, newSVuv(_color->g));
        av_push(RETVAL, newSVuv(_color->b));
        av_push(RETVAL, newSVuv(0xFF));
    }
    else
    {
        RETVAL = (AV*)sv_2mortal((SV *) newAV() );
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0));
        av_push(RETVAL, newSVuv(0xFF));
    }

    return RETVAL;
}


unsigned int __map_rgb( SV* color, SDL_PixelFormat* format )
{
    Uint8 r, g, b;
    AV* a = __list_rgb( color );
    r     = SvUV(*av_fetch(a, 0, 0));
    g     = SvUV(*av_fetch(a, 1, 0));
    b     = SvUV(*av_fetch(a, 2, 0));

    return SDL_MapRGB( format, r, g, b ); 
}

unsigned int __map_rgba( SV* color, SDL_PixelFormat* format )
{
    int r, g, b, a;
    AV* ar = __list_rgba( color );
    r      = SvUV(*av_fetch(ar, 0, 0));
    g      = SvUV(*av_fetch(ar, 1, 0));
    b      = SvUV(*av_fetch(ar, 2, 0));
    a      = SvUV(*av_fetch(ar, 3, 0));

    return SDL_MapRGBA( format, r, g, b, a );
}
