#include <SDL.h>
#include "SDL_thread.h"
/* */
/* defines.h */
/* */
/* Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org> */
/* */
/* ------------------------------------------------------------------------------ */
/* */
/* This library is free software; you can redistribute it and/or */
/* modify it under the terms of the GNU Lesser General Public */
/* License as published by the Free Software Foundation; either */
/* version 2.1 of the License, or (at your option) any later version. */
/*  */
/* This library is distributed in the hope that it will be useful, */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU */
/* Lesser General Public License for more details. */
/*  */
/* You should have received a copy of the GNU Lesser General Public */
/* License along with this library; if not, write to the Free Software */
/* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA */
/* */
/* ------------------------------------------------------------------------------ */
/* */
/* Please feel free to send questions, suggestions or improvements to: */
/* */
/*	David J. Goehrig */
/*	dgoehrig@cpan.org */
/* */

#ifndef SDL_PERL_DEFINES_H
#define SDL_PERL_DEFINES_H

#ifdef USE_THREADS
PerlInterpreter *parent_perl = NULL;
extern PerlInterpreter *parent_perl;
PerlInterpreter *current_perl = NULL;
#define GET_TLS_CONTEXT eval_pv("require DynaLoader;", TRUE); \
        if(!current_perl) { \
            parent_perl = PERL_GET_CONTEXT; \
            current_perl = perl_clone(parent_perl, CLONEf_KEEP_PTR_TABLE); \
            PERL_SET_CONTEXT(parent_perl); \
        }
#define ENTER_TLS_CONTEXT { \
            if(!PERL_GET_CONTEXT) { \
                PERL_SET_CONTEXT(current_perl); \
            }
#define LEAVE_TLS_CONTEXT }
#else
PerlInterpreter *parent_perl = NULL;
extern PerlInterpreter *parent_perl;
#define GET_TLS_CONTEXT         /* TLS context not enabled */
#define ENTER_TLS_CONTEXT       /* TLS context not enabled */
#define LEAVE_TLS_CONTEXT       /* TLS context not enabled */
#endif

#endif
