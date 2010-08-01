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

int _calc_offset( SDL_Surface* surface, int x, int y )
{
    int offset;
    offset  = (surface->pitch * y)/surface->format->BytesPerPixel;
    offset += x;
    return offset;
}


int _get_pixel( SDL_Surface * surface, int offset )
{
    int value = 0;
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
        RETVAL->length = 0;
    OUTPUT:
        RETVAL

void *
lmx_add( manager, layer )
    SDLx_LayerManager *manager
    SDLx_Layer *layer
    CODE:
        manager->layers[manager->length] = layer;
        layer->index                     = manager->length;
        layer->manager                   = (SDLx_LayerManager *)manager;
        manager->length++;

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
        if(index >= 0 && index < manager->length)
            RETVAL = _sv_ref( manager->layers[index], sizeof(SDLx_Layer *), sizeof(SDLx_Layer), "SDLx::Layer" );
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

int
lmx_length( manager )
    SDLx_LayerManager *manager
    CODE:
        RETVAL = manager->length;
    OUTPUT:
        RETVAL

void
lmx_blit( manager, dest )
    SDLx_LayerManager *manager
    SDL_Surface       *dest
    CODE:
        //int x, y;
        //SDL_GetMouseState(&x, &y);
        
        int index = 0;
        while(index < manager->length)
        {
            SDLx_Layer *layer = (manager->layers)[index];
            
            SDL_BlitSurface(layer->surface, layer->clip, dest, layer->pos);
            
            index++;
        }
        
        /*
        my ( $mask, $x, $y ) = @{ SDL::Events::get_mouse_state() };
        
        if(scalar @attached_layers) {
            my $layer_index = 0;
            foreach (@layers) {
                $_->{layer}->draw($dest) unless join( ',', @attached_layers ) =~ m/\b\Q$layer_index\E\b/;
                $layer_index++;
            }
            $snapshot->blit_by($dest);
        }
        
        foreach (@attached_layers) {
            $layers[$_]->{layer}->draw_xy($dest, $x + @{$attached_distance[$_]}[0], $y + @{$attached_distance[$_]}[1]);
        }
        */

SV *
lmx_by_position( manager, x, y )
    SDLx_LayerManager* manager
    int x
    int y
    CODE:
        int i;
        int match = -1;
        for( i = manager->length - 1; i >= 0 && match < 0; i-- )
        {
            SDL_Rect    *clip = manager->layers[i]->clip;
            SDL_Rect    *pos  = manager->layers[i]->pos;
            SDL_Surface *surf = manager->layers[i]->surface;
            
            if (   pos->x <= x && x <= pos->x + clip->w
                && pos->y <= y && y <= pos->y + clip->h )
            {
                Uint8 r, g, b, a;
                Uint32 pixel = _get_pixel(surf, _calc_offset(surf, x, y));
                SDL_GetRGBA( pixel, surf->format, &r, &g, &b, &a );

                if(a > 0)
                    match = i;
            }
        }

        if(match >= 0)
            RETVAL = _sv_ref( manager->layers[match], sizeof(SDLx_Layer *), sizeof(SDLx_Layer), "SDLx::Layer" );
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

AV *
lmx_ahead( manager, index )
    SDLx_LayerManager *manager
    int               index
    CODE:
        AV *matches       = newAV();
        int matches_count = 0;
        int i;
        SDLx_Layer *layer = manager->layers[index];

        for( i = index + 1; i < manager->length; i++ )
        {
            if(
                // upper left point inside layer
                (      layer->pos->x <= manager->layers[i]->pos->x
                    && manager->layers[i]->pos->x <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= manager->layers[i]->pos->y
                    && manager->layers[i]->pos->y <= layer->pos->y + layer->clip->h
                )

                // upper right point inside layer
                || (   layer->pos->x <= manager->layers[i]->pos->x + manager->layers[i]->clip->w
                    && manager->layers[i]->pos->x + manager->layers[i]->clip->w <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= manager->layers[i]->pos->y
                    && manager->layers[i]->pos->y <= layer->pos->y + layer->clip->h )

                // lower left point inside layer
                || (   layer->pos->x <= manager->layers[i]->pos->x
                    && manager->layers[i]->pos->x <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= manager->layers[i]->pos->y + manager->layers[i]->clip->h
                    && manager->layers[i]->pos->y + manager->layers[i]->clip->h <= layer->pos->y + layer->clip->h )

                // lower right point inside layer
                || (   layer->pos->x <= manager->layers[i]->pos->x + manager->layers[i]->clip->w
                    && manager->layers[i]->pos->x + manager->layers[i]->clip->w <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= manager->layers[i]->pos->y + manager->layers[i]->clip->h
                    && manager->layers[i]->pos->y + manager->layers[i]->clip->h <= layer->pos->y + layer->clip->h )
            )
            {
                // TODO checking transparency
                av_store( matches, matches_count, _sv_ref( manager->layers[i], sizeof(SDLx_Layer *), sizeof(SDLx_Layer), "SDLx::Layer" ) );
                matches_count++;
            }
        }

        /*
        my @more_matches = ();
        while ( scalar(@matches) && ( @more_matches = $self->get_layers_ahead_layer( $matches[$#matches] ) ) )
        {
            push @matches, @more_matches;
        }*/

        RETVAL = matches;
    OUTPUT:
        RETVAL

AV *
lmx_behind( manager, index )
    SDLx_LayerManager *manager
    int               index
    CODE:
        AV *matches       = newAV();
        int matches_count = 0;
        int i;
        SDLx_Layer *layer = manager->layers[index];

        for( i = index - 1; i >= 0; i-- )
        {
            if(
                // upper left point inside layer
                (      layer->pos->x <= manager->layers[i]->pos->x
                    && manager->layers[i]->pos->x <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= manager->layers[i]->pos->y
                    && manager->layers[i]->pos->y <= layer->pos->y + layer->clip->h
                )

                // upper right point inside layer
                || (   layer->pos->x <= manager->layers[i]->pos->x + manager->layers[i]->clip->w
                    && manager->layers[i]->pos->x + manager->layers[i]->clip->w <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= manager->layers[i]->pos->y
                    && manager->layers[i]->pos->y <= layer->pos->y + layer->clip->h )

                // lower left point inside layer
                || (   layer->pos->x <= manager->layers[i]->pos->x
                    && manager->layers[i]->pos->x <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= manager->layers[i]->pos->y + manager->layers[i]->clip->h
                    && manager->layers[i]->pos->y + manager->layers[i]->clip->h <= layer->pos->y + layer->clip->h )

                // lower right point inside layer
                || (   layer->pos->x <= manager->layers[i]->pos->x + manager->layers[i]->clip->w
                    && manager->layers[i]->pos->x + manager->layers[i]->clip->w <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= manager->layers[i]->pos->y + manager->layers[i]->clip->h
                    && manager->layers[i]->pos->y + manager->layers[i]->clip->h <= layer->pos->y + layer->clip->h )
            )
            {
                // TODO checking transparency
                av_store( matches, matches_count, _sv_ref( manager->layers[i], sizeof(SDLx_Layer *), sizeof(SDLx_Layer), "SDLx::Layer" ) );
                matches_count++;
            }
        }

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
lmx_DESTROY( manager )
    SDLx_LayerManager* manager
    CODE:
        safefree(manager);
