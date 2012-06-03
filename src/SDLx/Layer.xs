#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include "SDLx/LayerManager.h"

MODULE = SDLx::Layer    PACKAGE = SDLx::Layer    PREFIX = layerx_


SDLx_Layer *
layerx_new( CLASS, surface, ... )
    char* CLASS
    SDL_Surface *surface
    CODE:
        RETVAL               = (SDLx_Layer *)safemalloc( sizeof(SDLx_Layer) );
        RETVAL->index        = -1;
        RETVAL->surface      = (SDL_Surface *)safemalloc( sizeof(SDL_Surface) );
        RETVAL->clip         = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->pos          = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->touched      = 1;
        RETVAL->attached     = 0;
        RETVAL->attached_pos = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->attached_rel = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->surface      = SDL_ConvertSurface(surface, surface->format, surface->flags);
        (RETVAL->pos)->x     = 0;
        (RETVAL->pos)->y     = 0;
        (RETVAL->pos)->w     = (RETVAL->surface)->w;
        (RETVAL->pos)->h     = (RETVAL->surface)->h;
        (RETVAL->clip)->x    = 0;
        (RETVAL->clip)->y    = 0;
        (RETVAL->clip)->w    = (RETVAL->surface)->w;
        (RETVAL->clip)->h    = (RETVAL->surface)->h;
        
        if(SvROK(ST(items - 1)) && SVt_PVHV == SvTYPE(SvRV(ST(items - 1))))
        {
            RETVAL->data = (HV *)SvRV(ST(items - 1));
            /*if(SvREFCNT(RETVAL->data) < 2) */
                SvREFCNT_inc(RETVAL->data);
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
layerx_index( layer )
    SDLx_Layer *layer
    CODE:
        RETVAL = layer->index;
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
layerx_surface( layer, ... )
    SDLx_Layer *layer
    CODE:
        if(items > 1)
        {
            SDL_Surface *surface  = (SDL_Surface *)bag2obj(ST(1));
            layer->surface        = SDL_ConvertSurface(surface, surface->format, surface->flags);
            layer->touched        = 1;
            layer->manager->saved = 0;
            layer->pos->w         = layer->surface->w;
            layer->pos->h         = layer->surface->h;
            layer->clip->w        = layer->surface->w;
            layer->clip->h        = layer->surface->h;
        }
    
        RETVAL = _sv_ref( layer->surface, sizeof(SDL_Surface *), sizeof(SDL_Surface), "SDL::Surface" );
    OUTPUT:
        RETVAL

SV *
layerx_clip( layer )
    SDLx_Layer *layer
    CODE:
        RETVAL = _sv_ref( layer->clip, sizeof(SDL_Rect *), sizeof(SDL_Rect), "SDL::Rect" );
    OUTPUT:
        RETVAL

SV *
layerx_pos( layer, ... )
    SDLx_Layer *layer
    CODE:
        if(items == 3)
        {
            layer->attached = 2;
            layer->pos->x   = SvIV(ST(1));
            layer->pos->y   = SvIV(ST(2));
        }
        RETVAL = _sv_ref( layer->pos, sizeof(SDL_Rect *), sizeof(SDL_Rect), "SDL::Rect" );
    OUTPUT:
        RETVAL

HV *
layerx_data( layer, ... )
    SDLx_Layer *layer
    CODE:
        if(items > 1)
        {
            layer->data = (HV *)SvRV(ST(1));
            SvREFCNT_inc(layer->data);
        }

        if((HV *)NULL == layer->data)
            XSRETURN_UNDEF;
        else
            RETVAL = layer->data;
    OUTPUT:
        RETVAL

AV *
layerx_ahead( layer )
    SDLx_Layer *layer
    CODE:
        RETVAL = layers_ahead( layer );
    OUTPUT:
        RETVAL

AV *
layerx_behind( layer )
    SDLx_Layer *layer
    CODE:
        RETVAL = layers_behind( layer );
    OUTPUT:
        RETVAL

void
layerx_attach( layer, x = -1, y = -1 )
    SDLx_Layer *layer
    int x
    int y
    CODE:
        if(-1 == x || -1 == y)
            SDL_GetMouseState(&x, &y);
        
        layer->attached        = 1;
        layer->attached_pos->x = layer->pos->x;
        layer->attached_pos->y = layer->pos->x;
        layer->attached_rel->x = layer->pos->x - x;
        layer->attached_rel->y = layer->pos->y - y;
        layer->manager->saved = 0;

AV *
layerx_detach_xy( layer, x = -1, y = -1 )
    SDLx_Layer *layer
    int x
    int y
    CODE:
        layer->attached = 0;
        layer->pos->x   = x;
        layer->pos->y   = y;
        layer->manager->saved = 0;
        
        RETVAL = newAV();
        av_store(RETVAL, 0, newSViv(layer->attached_pos->x));
        av_store(RETVAL, 1, newSViv(layer->attached_pos->y));
    OUTPUT:
        RETVAL

SV *
layerx_foreground( bag )
    SV *bag
    CODE:
        SDLx_Layer        *layer   = (SDLx_Layer *)bag2obj(bag);
        SDLx_LayerManager *manager = layer->manager;
        int index                  = layer->index; /* we cant trust its value */
        int i;
        layer->manager->saved = 0;
        
        for(i = 0; i <= av_len(manager->layers); i++)
        {
            if(*av_fetch(manager->layers, i, 0) == bag) /* what bag do we have? => finding the right layer index */
            {
                index = i;
                break;
            }
        }

        for(i = index; i < av_len(manager->layers); i++)
        {
            AvARRAY(manager->layers)[i] = AvARRAY(manager->layers)[i + 1];
            ((SDLx_Layer *)bag2obj(AvARRAY(manager->layers)[i]))->index = i;
        }
        AvARRAY(manager->layers)[i] = bag;
        ((SDLx_Layer *)bag2obj(AvARRAY(manager->layers)[i]))->index = i;
        SvREFCNT_inc( bag );
        RETVAL                      = newSVsv(bag);
        SvREFCNT_inc(RETVAL);
    OUTPUT:
        RETVAL

void
layerx_DESTROY( layer )
    SDLx_Layer *layer
CODE:
        /*if((HV *)NULL != layer->data) // Attempt to free unreferenced scalar */
            /*SvREFCNT_dec(layer->data); */
        safefree(layer);
