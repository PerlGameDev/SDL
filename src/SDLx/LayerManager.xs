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

int _get_pixel( SDL_Surface *surface, int x, int y )
{
    int value  = 0;
    int offset = x + surface->w * y;
    switch(surface->format->BytesPerPixel)
    {
        case 1:  value = ((Uint8  *)surface->pixels)[offset];
                 break;
        case 2:  value = ((Uint16 *)surface->pixels)[offset];
                 break;
        case 3:  value = ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel]     <<  0)
                       + ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel + 1] <<  8)
                       + ((Uint32)((Uint8 *)surface->pixels)[offset * surface->format->BytesPerPixel + 2] << 16);
                 break;
        case 4:  value = ((Uint32 *)surface->pixels)[offset];
                 break;
    }

    return value;
}

MODULE = SDLx::LayerManager    PACKAGE = SDLx::LayerManager    PREFIX = lmx_

SDLx_LayerManager *
lmx_new( CLASS, ... )
    char* CLASS
    CODE:
        RETVAL           = (SDLx_LayerManager *)safemalloc( sizeof(SDLx_LayerManager) );
        RETVAL->layers   = newAV();
        RETVAL->saveshot = (SDL_Surface *)safemalloc( sizeof(SDL_Surface) );
        RETVAL->saved    = 0;
    OUTPUT:
        RETVAL

void 
lmx_add( manager, bag )
    SDLx_LayerManager *manager
    SV* bag 
    CODE:
        if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) )
        {
            SDLx_Layer *layer = (SDLx_Layer *)bag2obj(bag);
            layer->index      = av_len( manager->layers ) + 1;
            layer->manager    = manager;
            layer->touched    = 1;
            av_push( manager->layers, bag);
            SvREFCNT_inc(bag);
        }

AV *
lmx_layers( manager )
    SDLx_LayerManager *manager
    CODE:
        RETVAL = manager->layers;
    OUTPUT:
        RETVAL


SV *
lmx_layer( manager, index )
    SDLx_LayerManager *manager
    int index
    PREINIT:
        char* CLASS = "SDLx::Layer";
    CODE:
        if(index >= 0 && index < av_len( manager->layers ) + 1)
        {
             RETVAL = *av_fetch( manager->layers, index, 0 ) ;
             SvREFCNT_inc(RETVAL);
        }
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

int
lmx_length( manager )
    SDLx_LayerManager *manager
    CODE:
        RETVAL = av_len( manager->layers ) + 1;
    OUTPUT:
        RETVAL

AV *
lmx_blit( manager, dest )
    SDLx_LayerManager *manager
    SDL_Surface       *dest
    CODE:
        manager->dest       = dest;
        RETVAL              = newAV();
        int index           = 0;
        int length          = av_len( manager->layers ) + 1;
        int attached_layers = 0;
        int did_something   = 0;
        
        while(index < length)
        {
            SDLx_Layer *layer = (SDLx_Layer *)bag2obj(*av_fetch(manager->layers, index, 0));
            
            if(layer->attached == 0)
            {
                if(layer->touched || manager->saved == 0)
                {
                    SDL_Rect *rect = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
                    rect->x        = layer->pos->x;
                    rect->y        = layer->pos->y;
                    rect->w        = layer->clip->w;
                    rect->h        = layer->clip->h;
                    layer->touched = 0;
                    av_push(RETVAL, _sv_ref( rect, sizeof(SDL_Rect *), sizeof(SDL_Rect), "SDL::Rect" ));
                    SDL_BlitSurface(layer->surface, layer->clip, dest, layer->pos);
                    did_something  = 1;
                }
            }
            else
                attached_layers = 1;
            
            index++;
        }
        
        if(manager->saved == 0)
        {
            manager->saveshot = SDL_ConvertSurface(dest, dest->format, dest->flags);
            manager->saved    = 1;
        }
        
        if((manager->saved && did_something) || attached_layers)
        {
            SDL_BlitSurface(manager->saveshot, NULL, dest, NULL);
        }
        
        if(attached_layers)
        {
            int x, y;
            SDL_GetMouseState(&x, &y);
            index = 0;
            while(index < length)
            {
                SDLx_Layer *layer = (SDLx_Layer *)bag2obj(*av_fetch(manager->layers, index, 0));
                
                if(layer->attached == 1)
                {
                    SDL_Rect *rect = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
                    
                    rect->x        =  layer->pos->x < x + layer->attached_rel->x ? layer->pos->x : x + layer->attached_rel->x;
                    rect->y        =  layer->pos->y < y + layer->attached_rel->y ? layer->pos->y : y + layer->attached_rel->y;
                    rect->w        = (layer->pos->x > x + layer->attached_rel->x ? layer->pos->x : x + layer->attached_rel->x) + layer->clip->w;
                    rect->h        = (layer->pos->y > y + layer->attached_rel->y ? layer->pos->y : y + layer->attached_rel->y) + layer->clip->h;
                    av_push(RETVAL, _sv_ref( rect, sizeof(SDL_Rect *), sizeof(SDL_Rect), "SDL::Rect" ));
                    layer->pos->x  = x + layer->attached_rel->x;
                    layer->pos->y  = y + layer->attached_rel->y;
                    SDL_BlitSurface(layer->surface, layer->clip, dest, layer->pos);
                }
                else if(layer->attached == 2)
                {
                    SDL_BlitSurface(layer->surface, layer->clip, dest, layer->pos);
                }
                
                index++;
            }
        }
    OUTPUT:
        RETVAL

SV *
lmx_by_position( manager, x, y )
    SDLx_LayerManager* manager
    int x
    int y
    CODE:
        int i;
        SV *match = NULL;
        for( i = av_len( manager->layers ); i >= 0 && match == NULL; i-- )
        {
            SV          *bag   = *av_fetch(manager->layers, i, 0);
            SDLx_Layer  *layer = (SDLx_Layer *)bag2obj(bag);
            SDL_Rect    *clip  = layer->clip;
            SDL_Rect    *pos   = layer->pos;
            SDL_Surface *surf  = layer->surface;
            if (   pos->x <= x && x <= pos->x + clip->w
                && pos->y <= y && y <= pos->y + clip->h)
            {
                Uint8 r, g, b, a;
                Uint32 pixel = _get_pixel(surf, x - pos->x, y - pos->y);
                SDL_GetRGBA( pixel, surf->format, &r, &g, &b, &a );

                if(a > 0)
                    match = bag;
            }
        }

        if(match != NULL)
        {
            RETVAL = match;
            SvREFCNT_inc(RETVAL);
        }
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

AV *
lmx_ahead( manager, index )
    SDLx_LayerManager *manager
    int               index
    CODE:
        SDLx_Layer *layer = (SDLx_Layer *)bag2obj(*av_fetch(manager->layers, index, 0));
        RETVAL            = layers_ahead( layer );
    OUTPUT:
        RETVAL

AV *
lmx_behind( manager, index )
    SDLx_LayerManager *manager
    int               index
    CODE:
        SDLx_Layer *layer = (SDLx_Layer *)bag2obj(*av_fetch(manager->layers, index, 0));
        RETVAL            = layers_behind( layer );
    OUTPUT:
        RETVAL

void
lmx_attach( manager, ... )
    SDLx_LayerManager *manager
    CODE:
        manager->saved = 0;
        int x = -1;
        int y = -1;
        
        if(SvIOK(ST(items - 1)))
        {
            y = SvIV(ST(items - 1));
            items--;
        }
        
        if(SvIOK(ST(items - 1)))
        {
            x = SvIV(ST(items - 1));
            items--;
        }
        
        if(-1 == x || -1 == y)
            SDL_GetMouseState(&x, &y);

        int i;
        for( i = 1; i < items; i++ )
        {
            SDLx_Layer *layer      = (SDLx_Layer *)bag2obj(ST(i));
            layer->attached        = 1;
            layer->attached_pos->x = layer->pos->x;
            layer->attached_pos->y = layer->pos->y;
            layer->attached_rel->x = layer->pos->x - x;
            layer->attached_rel->y = layer->pos->y - y;
        }

AV *
lmx_detach_xy( manager, x = -1, y = -1 )
    SDLx_LayerManager *manager
    int x
    int y
    CODE:
        RETVAL = newAV();
        int index  = 0;
        int length = av_len( manager->layers ) + 1;
        int lower_x;
        int lower_y;
        int offset_x = 0;
        int offset_y = 0;
        while(index < length)
        {
            SDLx_Layer *layer = (SDLx_Layer *)bag2obj(*av_fetch(manager->layers, index, 0));
            
            if(layer->attached == 1)
            {
                if(av_len(RETVAL) == -1)
                {
                    lower_x  = layer->attached_pos->x;
                    lower_y  = layer->attached_pos->y;
                    offset_x = layer->attached_pos->x - x;
                    offset_y = layer->attached_pos->y - y;
                    av_push(RETVAL, newSViv(layer->attached_pos->x));
                    av_push(RETVAL, newSViv(layer->attached_pos->y));
                }
                
                layer->attached = 0;
                layer->touched  = 1;
                layer->pos->x   = layer->attached_pos->x - offset_x;
                layer->pos->y   = layer->attached_pos->y - offset_y;
            }
            
            index++;
        }
        manager->saved = 0;
    OUTPUT:
        RETVAL

void
lmx_detach_back( manager )
    SDLx_LayerManager *manager
    CODE:
        int index  = 0;
        int length = av_len( manager->layers ) + 1;
        while(index < length)
        {
            SDLx_Layer *layer = (SDLx_Layer *)bag2obj(*av_fetch(manager->layers, index, 0));
            
            if(layer->attached == 1)
            {
                layer->attached = 0;
                layer->touched  = 1;
                layer->pos->x   = layer->attached_pos->x;
                layer->pos->y   = layer->attached_pos->y;
            }
            
            index++;
        }
        manager->saved = 0;

AV *
lmx_foreground( manager, ... )
    SDLx_LayerManager *manager
    CODE:
        RETVAL = newAV();
        int x;
        for(x = 1; x < items; x++)
        {
            SDLx_Layer        *layer   = (SDLx_Layer *)bag2obj(ST(x));
            SDLx_LayerManager *manager = layer->manager;
            int index                  = layer->index; // we cant trust its value
            int i;
            
            SV *fetched;
            for(i = 0; i <= av_len(manager->layers); i++)
            {
                fetched = *av_fetch(manager->layers, i, 0);
                if(fetched == ST(x)) // what bag do we have? => finding the right layer index
                {
                    index = i;
                    break;
                }
            }

            for(i = index; i < av_len(manager->layers); i++)
            {
                AvARRAY(manager->layers)[i] = AvARRAY(manager->layers)[i + 1];
            }
            
            AvARRAY(manager->layers)[i] = fetched;
            manager->saved = 0;
        }
    OUTPUT:
        RETVAL

void
lmx_DESTROY( manager )
    SDLx_LayerManager *manager
    CODE:
        safefree(manager);
