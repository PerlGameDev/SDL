
#include "helper.h"

typedef struct SDLx_LayerManager
{
    AV          *layers;
    SDL_Surface *saveshot;
    SDL_Surface *dest;
    int          saved;
} SDLx_LayerManager;

typedef struct SDLx_Layer
{
    SDLx_LayerManager *manager;
    int                index;
    int                attached;
    int                touched;
    SDL_Surface       *surface;
    SDL_Rect          *clip;
    SDL_Rect          *pos;
    SDL_Rect          *attached_pos;
    SDL_Rect          *attached_rel;
    HV                *data;
} SDLx_Layer;

int intersection( SDLx_Layer *layer1, SDLx_Layer *layer2 )
{
    if(
        // upper left point inside layer
        (   layer1->pos->x <= layer2->pos->x
            && layer2->pos->x < layer1->pos->x + layer1->clip->w
            && layer1->pos->y <= layer2->pos->y
            && layer2->pos->y < layer1->pos->y + layer1->clip->h
        )

        // upper right point inside layer
        || (   layer1->pos->x < layer2->pos->x + layer2->clip->w
            && layer2->pos->x + layer2->clip->w <= layer1->pos->x + layer1->clip->w
            && layer1->pos->y <= layer2->pos->y
            && layer2->pos->y < layer1->pos->y + layer1->clip->h )

        // lower left point inside layer
        || (   layer1->pos->x <= layer2->pos->x
            && layer2->pos->x < layer1->pos->x + layer1->clip->w
            && layer1->pos->y < layer2->pos->y + layer2->clip->h
            && layer2->pos->y + layer2->clip->h <= layer1->pos->y + layer1->clip->h )

        // lower right point inside layer
        || (   layer1->pos->x < layer2->pos->x + layer2->clip->w
            && layer2->pos->x + layer2->clip->w <= layer1->pos->x + layer1->clip->w
            && layer1->pos->y < layer2->pos->y + layer2->clip->h
            && layer2->pos->y + layer2->clip->h <= layer1->pos->y + layer1->clip->h )
    ){
        return 1;
    }
    
    return 0;
}

AV *layers_behind( SDLx_Layer *layer)
{
    AV *matches = newAV();
    int i;
    int count = 0;

    for( i = layer->index - 1; i >= 0; i-- )
    {
        SV *bag            = *av_fetch(layer->manager->layers, i, 0);
        SDLx_Layer *layer2 = (SDLx_Layer *)bag2obj(bag);
        if(intersection( layer, layer2 ) || intersection( layer2, layer ))
        {
            // TODO checking transparency
            SvREFCNT_inc(bag);
            av_store( matches, count, bag );
            count++;
        }
    }
    
    if(count)
    {
        AV *behind = layers_behind((SDLx_Layer *)bag2obj(*av_fetch(matches, av_len(matches), 0)));
        if(av_len(behind) >= 0)
        {
            for( i = 0; i <= av_len(behind); i++ )
            {
                av_store( matches, count, *av_fetch(behind, i, 0));
                count++;
            }
        }
    }

    return matches;
}

AV *layers_ahead( SDLx_Layer *layer )
{
    AV *matches = newAV();
    int i;
    int count = 0;

    for( i = layer->index + 1; i <= av_len(layer->manager->layers); i++ )
    {
        SV *bag            = *av_fetch(layer->manager->layers, i, 0);
        SDLx_Layer *layer2 = (SDLx_Layer *)bag2obj(bag);
        if(intersection( layer, layer2 ) || intersection( layer2, layer ))
        {
            // TODO checking transparency
            SvREFCNT_inc(bag);
            av_store( matches, count, bag );
            count++;
        }
    }
    
    if(count)
    {
        AV *ahead = layers_ahead((SDLx_Layer *)bag2obj(*av_fetch(matches, av_len(matches), 0)));
        if(av_len(ahead) >= 0)
        {
            for( i = 0; i <= av_len(ahead); i++ )
            {
                av_store( matches, count, *av_fetch(ahead, i, 0));
                count++;
            }
        }
    }
    
    return matches;
}

