
typedef struct SDLx_Layer
{
    int          index;
    SDL_Surface *surface;
    SDL_Rect    *clip;
    SDL_Rect    *pos;
    HV          *data;
} SDLx_Layer;
