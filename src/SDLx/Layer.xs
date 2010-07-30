#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include "SDLx/Layer.h"

PerlInterpreter * perl = NULL;

MODULE = SDLx::Layer    PACKAGE = SDLx::Layer    PREFIX = layerx_

SDLx_Layer *
layerx_new( CLASS, surface, ... )
    char* CLASS
    SDL_Surface *surface
    CODE:
        RETVAL            = (SDLx_Layer *)safemalloc( sizeof(SDLx_Layer) );
        RETVAL->surface   = (SDL_Surface *)safemalloc( sizeof(SDL_Surface) );
        RETVAL->clip      = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->pos       = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->surface   = SDL_ConvertSurface(surface, surface->format, surface->flags);
        RETVAL->data      = (HV *)safemalloc( sizeof(HV) );
        (RETVAL->pos)->x  = 0;
        (RETVAL->pos)->y  = 0;
        (RETVAL->pos)->w  = (RETVAL->surface)->w;
        (RETVAL->pos)->h  = (RETVAL->surface)->h;
        (RETVAL->clip)->x = 0;
        (RETVAL->clip)->y = 0;
        (RETVAL->clip)->w = (RETVAL->surface)->w;
        (RETVAL->clip)->h = (RETVAL->surface)->h;
        
        if(SvROK(ST(items - 1)) && SVt_PVHV == SvTYPE(SvRV(ST(items - 1))))
        {
            RETVAL->data = (HV *)SvRV(ST(items - 1));
            items--;
        }
        else
            RETVAL->data = (HV *)NULL;

        if(items > 2)
            (RETVAL->pos)->x = SvIV(ST(2));
        if(items > 3)
            (RETVAL->pos)->y = SvIV(ST(3));
        if(items > 4)
            (RETVAL->clip)->x = SvIV(ST(4));
        if(items > 5)
            (RETVAL->clip)->y = SvIV(ST(5));
        if(items > 6)
            (RETVAL->clip)->w = SvIV(ST(6));
        if(items > 7)
            (RETVAL->clip)->h = SvIV(ST(7));
    OUTPUT:
        RETVAL

int
layerx_x( layer )
    SDLx_Layer *layer
    CODE:
        RETVAL = (layer->pos)->x;
    OUTPUT:
        RETVAL

int
layerx_y( layer )
    SDLx_Layer *layer
    CODE:
        RETVAL = (layer->pos)->y;
    OUTPUT:
        RETVAL

int
layerx_w( layer )
    SDLx_Layer *layer
    CODE:
        RETVAL = (layer->clip)->w;
    OUTPUT:
        RETVAL

int
layerx_h( layer )
    SDLx_Layer *layer
    CODE:
        RETVAL = (layer->clip)->h;
    OUTPUT:
        RETVAL

SV *
layerx_surface( layer )
    SDLx_Layer *layer
    PREINIT:
        char* CLASS = "SDL::Surface";
    CODE:
        SV   *rectref  = newSV( sizeof(SDL_Surface *) );
        void *copyRect = safemalloc( sizeof(SDL_Surface) );
        memcpy( copyRect, layer->surface, sizeof(SDL_Surface) );

        void** pointers = malloc(2 * sizeof(void*));
        pointers[0]     = (void*)copyRect;
        pointers[1]     = (void*)perl;

        RETVAL = newSVsv(sv_setref_pv(rectref, "SDL::Surface", (void *)pointers));
    OUTPUT:
        RETVAL

SV *
layerx_clip( layer )
    SDLx_Layer *layer
    PREINIT:
        char* CLASS = "SDL::Rect";
    CODE:
        SV   *rectref  = newSV( sizeof(SDL_Rect *) );
        void *copyRect = safemalloc( sizeof(SDL_Rect) );
        memcpy( copyRect, layer->clip, sizeof(SDL_Rect) );

        void** pointers = malloc(2 * sizeof(void*));
        pointers[0]     = (void*)copyRect;
        pointers[1]     = (void*)perl;

        RETVAL = newSVsv(sv_setref_pv(rectref, "SDL::Rect", (void *)pointers));
    OUTPUT:
        RETVAL

SV *
layerx_pos( layer )
    SDLx_Layer *layer
    PREINIT:
        char* CLASS = "SDL::Rect";
    CODE:
        SV   *rectref  = newSV( sizeof(SDL_Rect *) );
        void *copyRect = safemalloc( sizeof(SDL_Rect) );
        memcpy( copyRect, layer->pos, sizeof(SDL_Rect) );

        void** pointers = malloc(2 * sizeof(void*));
        pointers[0]     = (void*)copyRect;
        pointers[1]     = (void*)perl;

        RETVAL = newSVsv(sv_setref_pv(rectref, "SDL::Rect", (void *)pointers));
    OUTPUT:
        RETVAL

HV *
layerx_data( layer )
    SDLx_Layer *layer
    CODE:
        if((HV *)NULL == layer->data)
            XSRETURN_UNDEF;
        else
            RETVAL = layer->data;
    OUTPUT:
        RETVAL

void
layerx_DESTROY( layer )
    SDLx_Layer *layer
    CODE:
        /*safefree(layer->clip);
        layer->clip = NULL;
        safefree(layer->pos);
        layer->pos = NULL;*/
        safefree(layer);
        //layer = NULL;
