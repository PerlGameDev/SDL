#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include "SDLx/LayerManager.h"

PerlInterpreter * perl = NULL;

SV *_sv_ref( void *object, int p_size, int s_size, char *package )
{
    SV   *ref  = newSV( p_size );
    void *copy = safemalloc( s_size );
    memcpy( copy, object, s_size );

    void** pointers = malloc(2 * sizeof(void*));
    pointers[0]     = (void*)copy;
    pointers[1]     = (void*)perl;

    return newSVsv(sv_setref_pv(ref, package, (void *)pointers));
}

MODULE = SDLx::Layer    PACKAGE = SDLx::Layer    PREFIX = layerx_


SDLx_Layer *
layerx_new( CLASS, surface, ... )
    char* CLASS
    SDL_Surface *surface
    CODE:
        RETVAL            = (SDLx_Layer *)safemalloc( sizeof(SDLx_Layer) );
        //RETVAL->manager   = (SDLx_LayerManager *)safemalloc( sizeof(SDLx_LayerManager) );
        RETVAL->index     = -1;
        RETVAL->surface   = (SDL_Surface *)safemalloc( sizeof(SDL_Surface) );
        RETVAL->clip      = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->pos       = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->attached     = 0;
        RETVAL->attached_pos = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->attached_rel = (SDL_Rect *)safemalloc( sizeof(SDL_Rect) );
        RETVAL->surface   = SDL_ConvertSurface(surface, surface->format, surface->flags);
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
            //if(SvREFCNT(RETVAL->data) < 2)
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
            SDL_Surface *surface = bag_to_surface(ST(1));
            layer->surface       = SDL_ConvertSurface(surface, surface->format, surface->flags);
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
layerx_pos( layer )
    SDLx_Layer *layer
    CODE:
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
        int count   = 0;
        AV *matches = layers_ahead( layer, &count);

        RETVAL = matches;
    OUTPUT:
        RETVAL

AV *
layerx_behind( layer )
    SDLx_Layer *layer
    CODE:
        int count   = 0;
        AV *matches = layers_behind( layer, &count);

        RETVAL = matches;
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

AV *
layerx_detach_xy( layer, x = -1, y = -1 )
    SDLx_Layer *layer
    int x
    int y
    CODE:
        layer->attached = 0;
        layer->pos->x   = x;
        layer->pos->y   = y;
        
        RETVAL = newAV();
        av_store(RETVAL, 0, newSViv(layer->attached_pos->x));
        av_store(RETVAL, 1, newSViv(layer->attached_pos->y));
    OUTPUT:
        RETVAL

void
layerx_foreground( bag )
    SV *bag
    CODE:
        SDLx_Layer *layer = bag_to_layer(bag);
        int i;
        
        //for(i=0; i < av_len(layer->manager->sv_layers); i++)
        //    printf("%d ", bag_to_layer(*av_fetch(layer->manager->sv_layers, i, 0))->index);
        //printf("\n");
        
        i = layer->index;        
        /*if(i < av_len(layer->manager->sv_layers) - 1)
        {//if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) )
            while(i < av_len(layer->manager->sv_layers) - 1)
            {
                printf("%d <- %d\n", i, i + 1);
                //void **pointers   = (void**)(SvIV((SV*)SvRV( bag ))); 
                //SDLx_Layer *layer = (SDLx_Layer *)(pointers[0]);
                //SV *fetched = *av_fetch( layer->manager->sv_layers, i + 1, 0 );
                //SvREFCNT_inc(fetched);
                //av_store( layer->manager->sv_layers, i, fetched );
             
                //av_splice( layer->manager->sv_layers, layer->index, 1 );
                
                //layer->index      = av_len( layer->manager->sv_layers );
                //SvREFCNT_inc(bag);
                
                // TODO removing old layer
                i++;
            }
            
            av_store( layer->manager->sv_layers, av_len(layer->manager->sv_layers), bag );
        }*/
        
        //av_clean(layer->manager->sv_layers, 0, av_len(layer->manager->sv_layers));
        
        //for(i=0; i < av_len(layer->manager->sv_layers); i++)
        //    printf("%d ", bag_to_layer(*av_fetch(layer->manager->sv_layers, i, 0))->index);
        //printf("\n");

void
layerx_DESTROY( layer )
    SDLx_Layer *layer
CODE:
        //if((HV *)NULL != layer->data) // Attempt to free unreferenced scalar
            //SvREFCNT_dec(layer->data);
        safefree(layer);
