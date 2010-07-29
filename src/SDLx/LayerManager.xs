#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include "SDLx/LayerManager.h"

#define SDLX_MAX_LAYER_SIZE 256

SV *layers[SDLX_MAX_LAYER_SIZE];
SV *attached_layers[SDLX_MAX_LAYER_SIZE];

Uint8 _length()
{
    int i = 0;
    while(i < SDLX_MAX_LAYER_SIZE && layers[i] != NULL)
    {
        i++;
    }
    
    return i;
}

int _call_method(SV *ref, char *method)
{
    dSP;
    int count;
    int retval = 0;
    
    ENTER;
    SAVETMPS;
    
    PUSHMARK(SP);
    XPUSHs(ref);
    PUTBACK;
    
    count = call_method(method, G_SCALAR);
    
    SPAGAIN;
    if (count == 1)
        retval = POPi;
    PUTBACK;
    
    FREETMPS;
    LEAVE;
    
    return retval;
}

MODULE = SDLx::LayerManager    PACKAGE = SDLx::LayerManager    PREFIX = lmx_

SDLx_LayerManager *
lmx_new( CLASS, ... )
    char* CLASS
    CODE:
        RETVAL = (SDLx_LayerManager *)safemalloc( sizeof(SDLx_LayerManager) );
        RETVAL->layers = newAV();
    OUTPUT:
        RETVAL

void *
lmx_add( manager, ... )
    SDLx_LayerManager *manager
    CODE:
        int i = 1;
        while( i < items )
        {
            av_push(manager->layers, (SV *)newSVsv(ST(i)));
            
            /*printf("is object: %d\n",       sv_isobject((SV *)ST(i)));
            printf("is SDLx::Sprite: %d\n", sv_derived_from((SV *)ST(i), "SDLx::Sprite"));
            
            printf("x is %d\n", _call_method((SV *)ST(i), "x"));

            PUSHMARK(SP);
            XPUSHs((SV *)ST(i));
            XPUSHs(sv_2mortal(newSViv(7)));
            PUTBACK;
            call_method("x", G_DISCARD);
            
            printf("x is %d\n", _call_method((SV *)ST(i), "x"));*/

            i++;
        }

AV *
lmx_layers( manager )
    SDLx_LayerManager *manager
    CODE:
        RETVAL = manager->layers;
    OUTPUT:
        RETVAL

SV *
lmx_layer( manager, index )
    SDLx_LayerManager *manager
    int index
    CODE:
        if(index <= av_len(manager->layers))
        {
            RETVAL = *av_fetch(manager->layers, index, 0);
            SvREFCNT_inc(RETVAL);
        }
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

int
lmx_length( manager )
    SDLx_LayerManager *manager
    CODE:
        RETVAL = av_len(manager->layers) + 1;
    OUTPUT:
        RETVAL

void
lmx_DESTROY( manager )
    SDLx_LayerManager* manager
    CODE:
        safefree(manager);
