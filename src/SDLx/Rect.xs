#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#ifndef min
#define min(a, b) (a < b ? a : b)
#endif

#ifndef max
#define max(a, b) (a > b ? a : b)
#endif

#include <SDL.h>

// remove undef elements
void _cleanup_rects( AV *a ) {
    if( !a || av_len(a)<0 )
        return;

    int off    = 0;
    int k      = 0;
    int length = av_len(a);

    /*
        473 380 32 4  k=0, off=0
        undef         k=1, off=1, [1]=[2], [2]=NULL
        443 332 32 4  k=2, off=2, [2]=[4], [2]=NULL
        undef
        undef
        443 336 62 44

        473 380 32 4
        443 332 32 4
        undef
    */

    //printf("1: length is now %d (length=%d, off=%d)\n", length - off, length, off);
    for( k = 0; k <= length - off; k++ ) {
        if( off || !SvOK(AvARRAY(a)[k]) ) {
            while( k + off <= length && !SvOK(AvARRAY(a)[k+off]) )
                off++;

            AvARRAY(a)[k]       = AvARRAY(a)[k + off];
            AvARRAY(a)[k + off] = NULL;
        }
    }

    //printf("2: length is now %d (length=%d, off=%d)\n", length - off, length, off);
    AvMAX(a)   = length - off;
    AvFILLp(a) = length - off;
}

// AV *a is an array of rects (AABBs), we are doing one-to-one tests
// int i is counter for rect one, will be passed recusivly
int _optimize_rects( AV *a, int i ) {
    if( !a || av_len(a)<0 )
        return 0;

    int length = av_len(a);

    while( !SvOK(AvARRAY(a)[i]) && i < length )
        i++;

    if( !SvOK(AvARRAY(a)[i]) )
        return 0;

    SDL_Rect *r1 = (SDL_Rect *)bag2obj( AvARRAY(a)[i] );
    int r1_xw    = r1->x + r1->w;
    int r1_yh    = r1->y + r1->h;
    int found    = 0;                  // we will stop if found stays zero
    int k        = 0;                  // counter for rect two

    for( k = 0; k <= length; k++ ) {
        if( SvOK(AvARRAY(a)[k]) && AvARRAY(a)[k] != AvARRAY(a)[i]) { // compare rects
            SDL_Rect *r2 = (SDL_Rect *)bag2obj( AvARRAY(a)[k] );
            //warn("%d\n", __LINE__);
            int r2_xw    = r2->x + r2->w;
            int r2_yh    = r2->y + r2->h;

            // if intersection
            if(!( (r1_xw <= r2->x) // r1 is at left
               || (r1_yh <= r2->y) // r1 is at top
               || (r1->x >= r2_xw) // r1 is at right
               || (r1->y >= r2_yh) // r1 is at bottom
                )) {
                //warn("%d\n", __LINE__);
                found = 1;

                // one rect covers the other
                if((r1->x == r2->x && r1->w == r2->w)
                || (r1->y == r2->y && r1->h == r2->h)
                || (r1->x == r2->x && r1->y <= r2->y && r1_xw >= r2_xw && r1_yh >= r2_yh)
                || (r2->x == r1->x && r2->y <= r1->y && r2_xw >= r1_xw && r2_yh >= r1_yh)) {
                    r1->x = min(r1->x, r2->x);
                    r1->y = min(r1->y, r2->y);
                    r1->w = (r1_yh > r2_yh ? r1_xw : r2_xw) - r1->x;
                    r1->h = max(r1_yh, r2_yh) - r1->y;
                    r1_xw = r1->x + r1->w;
                    r1_yh = r1->y + r1->h;
                    i     = -1;
                    //SvREFCNT_dec(AvARRAY(a)[k]);
                    //warn("%d\n", __LINE__);
                    AvARRAY(a)[k] = &PL_sv_undef;
                    //warn("%d\n", __LINE__);
                }

                // there is a partial intersection, so we have up to three rects,
                // 1) above the intersection, 2) the intersection including what is at left and right
                // and 3) below the intersection
                else {
                    SDL_Rect *is = safemalloc( sizeof(SDL_Rect) );
                    is->x        = min(r1->x, r2->x);
                    is->y        = max(r1->y, r2->y);
                    is->w        = max(r1->x+r1->w, r2->x+r2->w) - min(r1->x, r2->x);
                    is->h        = min(r1->y+r1->h, r2->y+r2->h) - max(r1->y, r2->y);
                    //warn("%d\n", __LINE__);
                    SV *bag = obj2bag( sizeof(SDL_Rect), is, "SDL::Rect" );
                    SvREFCNT_inc( bag );
                    av_push(a, sv_2mortal(bag));
                    //warn("%d\n", __LINE__);

                    if(r1->y == r2->y) {
                        r1->x = max(r1->x, r2->x);
                        r1->y = is->y + is->h;
                        r1->w = min(r1_xw, r2_xw) - r1->x;
                        r1->h = max(r1_yh, r2_yh) - r1->y;
                        r2->h = 0;
                        r2->w = 0;
                        //warn("%d\n", __LINE__);
                    }
                    else if(r1->y < r2->y) { // r1 on top of r2
                        r1->h = is->y - r1->y;
                        r2->y = is->y + is->h;
                        if(r1_yh == r2_yh) {
                            r2->x = min(r1->x, r2->x);
                            r2->w = max(r1_xw, r2_xw) - r2->x;
                            r2->h = r1_yh - r2->y;
                        }
                        else if(r1_yh > r2_yh) { // r1 tiefer als r2
                            r2->x = r1->x;
                            r2->w = r1->w;
                            r2->h = r1_yh - r2->y;
                        }
                        else { // r2 tiefer als r1
                            r2->h = r2_yh - r2->y;
                        }
                        //warn("%d\n", __LINE__);
                    }
                    else { // r2 on top of r1
                        r2->h = is->y - r2->y;
                        r1->y = is->y + is->h;
                        if(r1_yh == r2_yh) {
                            r1->x = min(r1->x, r2->x);
                            r1->w = max(r1_xw, r2_xw) - r1->x;
                            r1->h = r2_yh - r1->y;
                        }
                        else if(r2_yh > r1_yh) { // r2 tiefer als r1
                            r1->x = r2->x;
                            r1->w = r2->w;
                            r1->h = r2_yh - r1->y;
                        }
                        else { // r1 tiefer als r2
                            r1->h = r1_yh - r1->y;
                        }
                        //warn("%d\n", __LINE__);
                    }
                    r1_xw = r1->x + r1->w;
                    r1_yh = r1->y + r1->h;

                    if(!is->w || !is->h) {
                        //SvREFCNT_dec(AvARRAY(a)[k]);
                        //warn("%d\n", __LINE__);
                        AvARRAY(a)[av_len(a)] = &PL_sv_undef;
                        //warn("%d\n", __LINE__);
                    }

                    if(!r2->w || !r2->h) {
                        //SvREFCNT_dec(AvARRAY(a)[k]);
                        //warn("%d\n", __LINE__);
                        AvARRAY(a)[k] = &PL_sv_undef;
                        //warn("%d\n", __LINE__);
                        i             = -1;
                    }

                    if(!r1->w || !r1->h) {
                        //SvREFCNT_dec( AvARRAY(a)[i] );
                        //warn("%d\n", __LINE__);
                        AvARRAY(a)[i] = &PL_sv_undef;
                        //warn("%d\n", __LINE__);
                        i             = -1;
                    }
                }
            }
            else {
                //warn("%d\n", __LINE__);
            }
        }
    }

    //warn("%d %d<%d\n", __LINE__, i, av_len(a));
    //_cleanup_rects(a);
    if( i < av_len(a) ) {
        found = _optimize_rects( a, i + 1 ) || found;
    }

    return found;
}

MODULE = SDLx::Rect    PACKAGE = SDLx::Rect    PREFIX = rectx_

void
rectx_optimize_rects( rects )
    AV *rects;
    CODE:
        _optimize_rects( rects, 0 );
        //_cleanup_rects( rects );
        //_cleanup_rects( rects );

void
rectx_cleanup_rects( rects )
    AV *rects;
    CODE:
        _cleanup_rects( rects );
