
typedef struct SDLx_LayerManager
{
    AV *layers;
} SDLx_LayerManager;

typedef struct SDLx_Layer
{
    SDLx_LayerManager *manager;
    int                index;
    int                attached;
    SDL_Surface       *surface;
    SDL_Rect          *clip;
    SDL_Rect          *pos;
    SDL_Rect          *attached_pos;
    SDL_Rect          *attached_rel;
    HV                *data;
} SDLx_Layer;

SDLx_Layer *bag_to_layer( SV *bag )
{
    SDLx_Layer *layer = NULL;

    if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) )
    {
       void **pointers = (void **)(SvIV((SV *)SvRV( bag ))); 
       layer           = (SDLx_Layer *)(pointers[0]);
    }
    
    return layer;
}

SDL_Surface *bag_to_surface( SV *bag )
{
    SDL_Surface *surface = NULL;

    if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) )
    {
       void **pointers = (void **)(SvIV((SV *)SvRV( bag ))); 
       surface         = (SDL_Surface *)(pointers[0]);
    }
    
    return surface;
}

int intersection( SDLx_Layer *layer1, SDLx_Layer *layer2 )
{
    if(
        // upper left point inside layer
        (      layer1->pos->x <= layer2->pos->x
            && layer2->pos->x <= layer1->pos->x + layer1->clip->w
            && layer1->pos->y <= layer2->pos->y
            && layer2->pos->y <= layer1->pos->y + layer1->clip->h
        )

        // upper right point inside layer
        || (   layer1->pos->x <= layer2->pos->x + layer2->clip->w
            && layer2->pos->x + layer2->clip->w <= layer1->pos->x + layer1->clip->w
            && layer1->pos->y <= layer2->pos->y
            && layer2->pos->y <= layer1->pos->y + layer1->clip->h )

        // lower left point inside layer
        || (   layer1->pos->x <= layer2->pos->x
            && layer2->pos->x <= layer1->pos->x + layer1->clip->w
            && layer1->pos->y <= layer2->pos->y + layer2->clip->h
            && layer2->pos->y + layer2->clip->h <= layer1->pos->y + layer1->clip->h )

        // lower right point inside layer
        || (   layer1->pos->x <= layer2->pos->x + layer2->clip->w
            && layer2->pos->x + layer2->clip->w <= layer1->pos->x + layer1->clip->w
            && layer1->pos->y <= layer2->pos->y + layer2->clip->h
            && layer2->pos->y + layer2->clip->h <= layer1->pos->y + layer1->clip->h )
    ){
        return 1;
    }
    
    return 0;
}

AV *layers_behind( SDLx_Layer *layer )
{
    AV *matches = newAV();
    int i;
    int count = 0;

    for( i = layer->index - 1; i >= 0; i-- )
    {
        SV *bag            = *av_fetch(layer->manager->layers, i, 0);
        SDLx_Layer *layer2 = bag_to_layer(bag);
        if(intersection( layer, layer2 ))
        {
            // TODO checking transparency
            SvREFCNT_inc(bag);
            av_store( matches, count, bag );
            count++;
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
        SDLx_Layer *layer2 = bag_to_layer(bag);
        if(intersection( layer, layer2 ))
        {
            // TODO checking transparency
            SvREFCNT_inc(bag);
            av_store( matches, count, bag );
            count++;
        }
    }
    
    return matches;
}

