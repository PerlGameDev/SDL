
typedef struct SDLx_LayerManager
{
    AV *sv_layers;
} SDLx_LayerManager;

typedef struct SDLx_Layer
{
    SDLx_LayerManager *manager;
    int               index;
    SDL_Surface       *surface;
    SDL_Rect          *clip;
    SDL_Rect          *pos;
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


