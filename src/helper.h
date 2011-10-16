
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
    SV* a            = sv_setref_pv(ref, package, (void *)pointers);
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

    return sv_setref_pv(ref, package, (void *)pointers);
}

void _svinta_free(Sint16* av, int len_from_av_len)
{
    if( av == NULL )
        return;
    safefree( av ); /* we only need to free the malloc'd array. It is one block. */
    av = NULL;
}

Sint16* av_to_sint16 (AV* av)
{
    int len = av_len(av);
    if( len != -1)
    {
        int i;
        Sint16* table = (Sint16 *)safemalloc(sizeof(Sint16)*(len+1));
        for ( i = 0; i < len+1 ; i++ )
        { 
            SV ** temp = av_fetch(av,i,0);
            if( temp != NULL )
                table[i] = (Sint16) SvIV ( *temp  );
            else
                table[i] = 0;
        }
        return table;

    }
    return NULL;
}

void _int_range( int *val, int min, int max )
{
    if( *val < min  )
       *val = min;
    else if ( *val > max )
       *val = max;
}

#endif
