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
        RETVAL = (SDLx_LayerManager *)safemalloc( sizeof(SDLx_LayerManager) );
        RETVAL->sv_layers = newAV();
    OUTPUT:
        RETVAL

void 
lmx_add( manager, bag )
    SDLx_LayerManager *manager
    SV* bag 
    CODE:
        if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) )
        {
            void **pointers   = (void**)(SvIV((SV*)SvRV( bag ))); 
            SDLx_Layer *layer = (SDLx_Layer *)(pointers[0]);
            layer->index      = av_len( manager->sv_layers );
            layer->manager    = manager;
            av_push( manager->sv_layers, bag);
            SvREFCNT_inc(bag);
        }

AV *
lmx_layers( manager )
    SDLx_LayerManager *manager
    CODE:
        XSRETURN_UNDEF;
    OUTPUT:
        RETVAL


SV *
lmx_layer( manager, index )
    SDLx_LayerManager *manager
    int index
    PREINIT:
        char* CLASS = "SDLx::Layer";
    CODE:
        if(index >= 0 && index < av_len( manager->sv_layers ) + 1)
        {
             RETVAL = *av_fetch( manager->sv_layers, index, 0 ) ;
        }
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

int
lmx_length( manager )
    SDLx_LayerManager *manager
    CODE:
        RETVAL = av_len( manager->sv_layers ) + 1;
    OUTPUT:
        RETVAL

void
lmx_blit( manager, dest )
    SDLx_LayerManager *manager
    SDL_Surface       *dest
    CODE:
        int index  = 0;
        int length = av_len( manager->sv_layers ) + 1;
        int attached_layers = 0;
        while(index < length)
        {
            SDLx_Layer *layer = bag_to_layer(*av_fetch(manager->sv_layers, index, 0));
            
            if(layer->attached == 0)
                SDL_BlitSurface(layer->surface, layer->clip, dest, layer->pos);
            else
                attached_layers = 1;
            
            index++;
        }
        
        if(attached_layers)
        {
            int x, y;
            SDL_GetMouseState(&x, &y);
            index  = 0;
            while(index < length)
            {
                SDLx_Layer *layer = bag_to_layer(*av_fetch(manager->sv_layers, index, 0));
                
                if(layer->attached == 1)
                {
                    layer->pos->x = x + layer->attached_rel->x;
                    layer->pos->y = y + layer->attached_rel->y;
                    SDL_BlitSurface(layer->surface, layer->clip, dest, layer->pos);
                }
                
                index++;
            }
        }

SV *
lmx_by_position( manager, x, y )
    SDLx_LayerManager* manager
    int x
    int y
    CODE:
        int i;
        int match = -1;
        for( i = av_len( manager->sv_layers ); i >= 0 && match < 0; i-- )
        {
            SDLx_Layer  *layer = bag_to_layer(*av_fetch(manager->sv_layers, i, 0));
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
                    match = i;
            }
        }

        if(match >= 0)
        {
            RETVAL = *av_fetch(manager->sv_layers, match, 0);
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
        int matches_count = 0;
        SDLx_Layer *layer = bag_to_layer(*av_fetch(manager->sv_layers, index, 0));
        AV *matches       = layers_ahead( layer, &matches_count);

        RETVAL = matches;
    OUTPUT:
        RETVAL

AV *
lmx_behind( manager, index )
    SDLx_LayerManager *manager
    int               index
    CODE:
        int matches_count = 0;
        SDLx_Layer *layer = bag_to_layer(*av_fetch(manager->sv_layers, index, 0));
        AV *matches       = layers_behind( layer, &matches_count);

        /*
        my @more_matches = ();
        while ( scalar(@matches) && ( @more_matches = $self->get_layers_ahead_layer( $matches[$#matches] ) ) )
        {
            push @matches, @more_matches;
        }*/

        RETVAL = matches;
    OUTPUT:
        RETVAL

void
lmx_attach( manager, ... )
    SDLx_LayerManager *manager
    CODE:
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
            SDLx_Layer *layer      = bag_to_layer(ST(i));
            printf("%d %d\n", i, layer->index);
            layer->attached        = 1;
            layer->attached_pos->x = layer->pos->x;
            layer->attached_pos->y = layer->pos->x;
            layer->attached_rel->x = layer->pos->x - x;
            layer->attached_rel->y = layer->pos->y - y;
        }

void
lmx_DESTROY( manager )
    SDLx_LayerManager *manager
    CODE:
        safefree(manager);
