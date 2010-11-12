
#ifndef SDL_PERL_HELPER_H
#define SDL_PERL_HELPER_H

PerlInterpreter * perl = NULL;

void *bag2obj( SV *bag )
{
    void *obj = NULL;

    if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) ) {
        void **pointers = (void **)(SvIV((SV *)SvRV( bag ))); 
        obj           = (void *)(pointers[0]);
    }
    
    return obj;
}

SV *obj2bag( int size_ptr,  void *obj, char *CLASS )
{
    SV *   objref   = newSV( size_ptr );
    void** pointers = malloc(2 * sizeof(void*));
    pointers[0]     = (void*)obj;
    pointers[1]     = (void*)PERL_GET_CONTEXT;
    sv_setref_pv( objref, CLASS, (void *)pointers);
    
    return objref;
}

SV *cpy2bag( void *object, int p_size, int s_size, char *package )
{
    SV   *ref  = newSV( p_size );
    void *copy = safemalloc( s_size );
    memcpy( copy, object, s_size );

    void** pointers = malloc(2 * sizeof(void*));
    pointers[0]     = (void*)copy;
    pointers[1]     = (void*)PERL_GET_CONTEXT;

    return newSVsv(sv_setref_pv(ref, package, (void *)pointers));
}

void objDESTROY(SV *bag, void (* callback)(void *object))
{
    if( sv_isobject(bag) && (SvTYPE(SvRV(bag)) == SVt_PVMG) )
    {
        void** pointers = (void**)(SvIV((SV*)SvRV( bag )));
        void* object = pointers[0];
        if (PERL_GET_CONTEXT == pointers[1])
        {
            pointers[0] = NULL;
            if(object)
                callback(object);
            safefree(pointers);
        }
    }
}

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

#endif
