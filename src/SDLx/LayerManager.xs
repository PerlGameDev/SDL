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
	RETVAL->sv_layers = newAV();
        RETVAL->length = 0;
    OUTPUT:
        RETVAL

void 
lmx_add( manager, bag )
    SDLx_LayerManager *manager
    SV* bag 
    CODE:
        //manager->layers[manager->length] = layer;
	
	if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
			   void** pointers = (void**)(SvIV((SV*)SvRV( bag ))); 
			   SDLx_Layer * layer = (SDLx_Layer*)(pointers[0]);
			   layer->index = av_len( manager->sv_layers );
			   layer->manager = (SDLx_LayerManager *)manager;
			   av_push( manager->sv_layers, bag);
               SvREFCNT_inc(bag);
		           manager->length++;
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
        if(index >= 0 && index < manager->length)
        {
             RETVAL = *av_fetch( manager->sv_layers, index, 0 ) ;
            //RETVAL = _sv_ref( manager->layers[index], sizeof(SDLx_Layer *), sizeof(SDLx_Layer), "SDLx::Layer" );
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
            //SDLx_Layer *layer = (manager->layers)[index];
            SDLx_Layer *layer = bag_to_layer(*av_fetch(manager->sv_layers, index, 0));
            
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
            SDLx_Layer *layer = (SDLx_Layer *)SvRV(*av_fetch(manager->sv_layers, i, 0));
            SDL_Rect    *clip = layer->clip;
            SDL_Rect    *pos  = layer->pos;
            SDL_Surface *surf = layer->surface;
            
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
            //RETVAL = _sv_ref( manager->layers[match], sizeof(SDLx_Layer *), sizeof(SDLx_Layer), "SDLx::Layer" );
            RETVAL = *av_fetch(manager->sv_layers, match, 0);
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
        SDLx_Layer *layer = bag_to_layer(*av_fetch(manager->sv_layers, index, 0));

        for( i = index + 1; i < manager->length; i++ )
        {
            SDLx_Layer *layer_ = bag_to_layer(*av_fetch(manager->sv_layers, i, 0));
            if(
                // upper left point inside layer
                (      layer->pos->x <= layer_->pos->x
                    && layer_->pos->x <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= layer_->pos->y
                    && layer_->pos->y <= layer->pos->y + layer->clip->h
                )

                // upper right point inside layer
                || (   layer->pos->x <= layer_->pos->x + layer_->clip->w
                    && layer_->pos->x + layer_->clip->w <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= layer_->pos->y
                    && layer_->pos->y <= layer->pos->y + layer->clip->h )

                // lower left point inside layer
                || (   layer->pos->x <= layer_->pos->x
                    && layer_->pos->x <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= layer_->pos->y + layer_->clip->h
                    && layer_->pos->y + layer_->clip->h <= layer->pos->y + layer->clip->h )

                // lower right point inside layer
                || (   layer->pos->x <= layer_->pos->x + layer_->clip->w
                    && layer_->pos->x + layer_->clip->w <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= layer_->pos->y + layer_->clip->h
                    && layer_->pos->y + layer_->clip->h <= layer->pos->y + layer->clip->h )
            )
            {
                // TODO checking transparency
                //av_store( matches, matches_count, _sv_ref( manager->layers[i], sizeof(SDLx_Layer *), sizeof(SDLx_Layer), "SDLx::Layer" ) );
                av_store( matches, matches_count, *av_fetch(manager->sv_layers, i, 0) );
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
        SDLx_Layer *layer = bag_to_layer(*av_fetch(manager->sv_layers, index, 0));

        for( i = index - 1; i >= 0; i-- )
        {
            SDLx_Layer *layer_ = bag_to_layer(*av_fetch(manager->sv_layers, i, 0));
            if(
                // upper left point inside layer
                (      layer->pos->x <= layer_->pos->x
                    && layer_->pos->x <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= layer_->pos->y
                    && layer_->pos->y <= layer->pos->y + layer->clip->h
                )

                // upper right point inside layer
                || (   layer->pos->x <= layer_->pos->x + layer_->clip->w
                    && layer_->pos->x + layer_->clip->w <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= layer_->pos->y
                    && layer_->pos->y <= layer->pos->y + layer->clip->h )

                // lower left point inside layer
                || (   layer->pos->x <= layer_->pos->x
                    && layer_->pos->x <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= layer_->pos->y + layer_->clip->h
                    && layer_->pos->y + layer_->clip->h <= layer->pos->y + layer->clip->h )

                // lower right point inside layer
                || (   layer->pos->x <= layer_->pos->x + layer_->clip->w
                    && layer_->pos->x + layer_->clip->w <= layer->pos->x + layer->clip->w
                    && layer->pos->y <= layer_->pos->y + layer_->clip->h
                    && layer_->pos->y + layer_->clip->h <= layer->pos->y + layer->clip->h )
            )
            {
                // TODO checking transparency
                //av_store( matches, matches_count, _sv_ref( manager->layers[i], sizeof(SDLx_Layer *), sizeof(SDLx_Layer), "SDLx::Layer" ) );
                av_store( matches, matches_count, *av_fetch(manager->sv_layers, i, 0) );
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
