
#include "Layer.h"


typedef struct SDLx_LayerManager
{
    SDLx_Layer *layers[256];
    int length;
} SDLx_LayerManager;
