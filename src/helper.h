
#ifndef SDL_PERL_HELPER_H
#define SDL_PERL_HELPER_H

#include <SDL.h>
#include "SDL_thread.h"

PerlInterpreter * perl = NULL;

void *bag2obj( SV *bag )
{
    void *obj = NULL;

    if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) )
    {
        void **pointers = (void **)(SvIV((SV *)SvRV( bag ))); 
        obj             = (void *)(pointers[0]);
    }
    
    return obj;
}

SV *obj2bag( int size_ptr,  void *obj, char *CLASS )
{
    SV *   objref    = newSV( size_ptr );
    void** pointers  = safemalloc(3 * sizeof(void*));
    pointers[0]      = (void*)obj;
    pointers[1]      = (void*)PERL_GET_CONTEXT;
    Uint32 *threadid = (Uint32 *)safemalloc(sizeof(Uint32));
    *threadid        = SDL_ThreadID();
    pointers[2]      = (void*)threadid;
    sv_setref_pv( objref, CLASS, (void *)pointers);
    return objref;
}

SV *cpy2bag( void *object, int p_size, int s_size, char *package )
{
    SV   *ref  = newSV( p_size );
    void *copy = safemalloc( s_size );
    memcpy( copy, object, s_size );

    void** pointers  = safemalloc(3 * sizeof(void*));
    pointers[0]      = (void*)copy;
    pointers[1]      = (void*)PERL_GET_CONTEXT;
    Uint32 *threadid = (Uint32 *)safemalloc(sizeof(Uint32));
    *threadid        = SDL_ThreadID();
    pointers[2]      = (void*)threadid;
    SV* a            = newSVsv(sv_setref_pv(ref, package, (void *)pointers));
    return a;
}

void objDESTROY(SV *bag, void (* callback)(void *object))
{

    if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) )
    {
        void** pointers  = (void**)(SvIV((SV*)SvRV( bag )));
        void* object     = pointers[0];
        Uint32 *threadid = (Uint32*)(pointers[2]);
        
        if(PERL_GET_CONTEXT == pointers[1]
        && *threadid == SDL_ThreadID())
        {
            pointers[0] = NULL;
            if(object)
                callback(object);
            safefree(threadid);
            safefree(pointers);
        }
    }
}

SV *_sv_ref( void *object, int p_size, int s_size, char *package )
{
    SV   *ref  = newSV( p_size );
    void *copy = safemalloc( s_size );
    memcpy( copy, object, s_size );

    void** pointers  = safemalloc(3 * sizeof(void*));
    pointers[0]      = (void*)copy;
    pointers[1]      = (void*)perl;
    Uint32 *threadid = (Uint32 *)safemalloc(sizeof(Uint32));
    *threadid        = SDL_ThreadID();
    pointers[2]      = (void*)threadid;

    return newSVsv(sv_setref_pv(ref, package, (void *)pointers));
}

#endif
