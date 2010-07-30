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
        {
            SV   *rectref  = newSV( sizeof(SDLx_Layer *) );
            void *copyRect = safemalloc( sizeof(SDLx_Layer) );
            memcpy( copyRect, (manager->layers)[index], sizeof(SDLx_Layer) );

            void** pointers = malloc(2 * sizeof(void*));
            pointers[0]     = (void*)copyRect;
            pointers[1]     = (void*)perl;

            RETVAL = newSVsv(sv_setref_pv(rectref, "SDLx::Layer", (void *)pointers));
        }
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
            //SDLx_Layer *layer = *(manager->layers);
            SDLx_Layer *layer = (manager->layers)[index];
            
            SDL_BlitSurface(layer->surface, layer->clip, dest, layer->pos);
            //SDL_UpdateRect(dest, 0, 0, 0, 0);
            
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

void
lmx_DESTROY( manager )
    SDLx_LayerManager* manager
    CODE:
        safefree(manager);
