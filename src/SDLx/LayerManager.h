
typedef struct SDLx_Layer
{
    void *manager;
    int               index;
    SDL_Surface       *surface;
    SDL_Rect          *clip;
    SDL_Rect          *pos;
    HV                *data;
} SDLx_Layer;

typedef struct SDLx_LayerManager
{
    AV *sv_layers;
    int length;
} SDLx_LayerManager;
