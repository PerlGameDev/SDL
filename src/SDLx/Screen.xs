#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#define NEED_newSV_type_GLOBAL
#include "ppport.h"
#include "helper.h"

#ifndef aTHX_
#define aTHX_
#endif

#include <SDL.h>
#include "SDLx/Validate.h"
#include <X11/Xlib.h>
#include <X11/Xutil.h>

void set_pixel(SDL_Surface * s, int x, int y, Uint8 r, Uint8 g, Uint8 b, Uint8 a) // only 32bit surfaces yet
{
    ((Uint32 *)s->pixels)[x + y * s->w] = (((r >> s->format->Rloss) << s->format->Rshift) & s->format->Rmask)
                                        | (((g >> s->format->Gloss) << s->format->Gshift) & s->format->Gmask)
                                        | (((b >> s->format->Bloss) << s->format->Bshift) & s->format->Bmask)
                                        | (((a >> s->format->Aloss) << s->format->Ashift) & s->format->Amask);
}

#ifdef HAVE_X11

static int my_handler(Display *display, XErrorEvent *error) {
    char buffer[500];

    XGetErrorText(display, error->error_code, buffer, sizeof(buffer));
    //i_push_error(error->error_code, buffer);

    return 0;
}

SDL_Surface *_get_screen() {
    int window_id;
    int own_display = 0; /* non-zero if we connect */
    Display *display;
    XImage *image;
    XWindowAttributes attr;
    int x, y;
    XColor *colors;
    XErrorHandler old_handler;

    /* we don't want the default noisy error handling */
    old_handler = XSetErrorHandler(my_handler);

    if (!display) {
        display = XOpenDisplay(NULL);
        ++own_display;
        if (!display) {
            XSetErrorHandler(old_handler);
            //i_push_error(0, "No display supplied and cannot connect");
            return NULL;
        }
    }

    if (!window_id) {
        int screen = DefaultScreen(display);
        window_id = RootWindow(display, screen);
    }

    if (!XGetWindowAttributes(display, window_id, &attr)) {
        XSetErrorHandler(old_handler);
        if (own_display)
            XCloseDisplay(display);
        //i_push_error(0, "Cannot XGetWindowAttributes");
        return NULL;
    }

    image = XGetImage(display, window_id, 0, 0, attr.width, attr.height, -1, ZPixmap);
    if (!image) {
        XSetErrorHandler(old_handler);
        if (own_display)
            XCloseDisplay(display);
        //i_push_error(0, "Cannot XGetImage");
        return NULL;
    }

    SDL_Surface *s = SDL_CreateRGBSurface(SDL_SWSURFACE, attr.width, attr.height, 32, 0xFF000000, 0xFF0000, 0xFF00, 0xFF);
    colors         = safemalloc(sizeof(XColor) * attr.width);

    for (y = 0; y < attr.height; y++) {
        for (x = 0; x < attr.width; x++) {
            colors[x].pixel = XGetPixel(image, x, y);
        }

        XQueryColors(display, attr.colormap, colors, attr.width);

        for (x = 0; x < attr.width; x++) {
            set_pixel(s, x, y, colors[x].red >> 8, colors[x].green >> 8, colors[x].blue >> 8, 255);
        }
    }

    safefree(colors);
    XDestroyImage(image);

    XSetErrorHandler(old_handler);
    if (own_display)
        XCloseDisplay(display);

    return s;
}

#endif

MODULE = SDLx::Screen 	PACKAGE = SDLx::Screen    PREFIX = screenx_

SDL_Surface *
screenx_screenshot()
    PREINIT:
        char *CLASS = "SDL::Surface";
    CODE:
        RETVAL = _get_screen();
    OUTPUT:
        RETVAL
