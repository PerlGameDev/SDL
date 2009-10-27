#!/usr/bin/env perl
#
# Constants.pm
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
#
# ------------------------------------------------------------------------------
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ------------------------------------------------------------------------------
#
# Please feel free to send questions, suggestions or improvements to:
#
#	David J. Goehrig
#	dgoehrig@cpan.org
#

package SDL::Constants;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT=qw(
	SDL_LOGPAL
	SDL_PHYSPAL
	AUDIO_S16
	AUDIO_S16MSB
	AUDIO_S8
	AUDIO_U16
	AUDIO_U16MSB
	AUDIO_U8
	CD_ERROR
	CD_PAUSED
	CD_PLAYING
	CD_STOPPED
	CD_TRAYEMPTY
	INADDR_ANY
	INADDR_NONE
	KMOD_ALT
	KMOD_CAPS
	KMOD_CTRL
	KMOD_LALT
	KMOD_LCTRL
	KMOD_LSHIFT
	KMOD_NONE
	KMOD_NUM
	KMOD_RALT
	KMOD_RCTRL
	KMOD_RSHIFT
	KMOD_SHIFT
	MIX_DEFAULT_CHANNELS
	MIX_DEFAULT_FORMAT
	MIX_DEFAULT_FREQUENCY
	MIX_FADING_IN
	MIX_FADING_OUT
	MIX_MAX_VOLUME
	MIX_NO_FADING
	SDLK_0
	SDLK_1
	SDLK_2
	SDLK_3
	SDLK_4
	SDLK_5
	SDLK_6
	SDLK_7
	SDLK_8
	SDLK_9
	SDLK_AMPERSAND
	SDLK_ASTERISK
	SDLK_AT
	SDLK_BACKQUOTE
	SDLK_BACKSLASH
	SDLK_BACKSPACE
	SDLK_BREAK
	SDLK_CAPSLOCK
	SDLK_CARET
	SDLK_CLEAR
	SDLK_COLON
	SDLK_COMMA
	SDLK_DELETE
	SDLK_DOLLAR
	SDLK_DOWN
	SDLK_END
	SDLK_EQUALS
	SDLK_ESCAPE
	SDLK_EURO
	SDLK_EXCLAIM
	SDLK_F1
	SDLK_F10
	SDLK_F11
	SDLK_F12
	SDLK_F13
	SDLK_F14
	SDLK_F15
	SDLK_F2
	SDLK_F3
	SDLK_F4
	SDLK_F5
	SDLK_F6
	SDLK_F7
	SDLK_F8
	SDLK_F9
	SDLK_GREATER
	SDLK_HASH
	SDLK_HELP
	SDLK_HOME
	SDLK_INSERT
	SDLK_KP0
	SDLK_KP1
	SDLK_KP2
	SDLK_KP3
	SDLK_KP4
	SDLK_KP5
	SDLK_KP6
	SDLK_KP7
	SDLK_KP8
	SDLK_KP9
	SDLK_KP_DIVIDE
	SDLK_KP_ENTER
	SDLK_KP_EQUALS
	SDLK_KP_MINUS
	SDLK_KP_MULTIPLY
	SDLK_KP_PERIOD
	SDLK_KP_PLUS
	SDLK_LALT
	SDLK_LCTRL
	SDLK_LEFT
	SDLK_LEFTBRACKET
	SDLK_LEFTPAREN
	SDLK_LESS
	SDLK_LMETA
	SDLK_LSHIFT
	SDLK_LSUPER
	SDLK_MENU
	SDLK_MINUS
	SDLK_MODE
	SDLK_NUMLOCK
	SDLK_PAGEDOWN
	SDLK_PAGEUP
	SDLK_PAUSE
	SDLK_PERIOD
	SDLK_PLUS
	SDLK_POWER
	SDLK_PRINT
	SDLK_QUESTION
	SDLK_QUOTE
	SDLK_QUOTEDBL
	SDLK_RALT
	SDLK_RCTRL
	SDLK_RETURN
	SDLK_RIGHT
	SDLK_RIGHTBRACKET
	SDLK_RIGHTPAREN
	SDLK_RMETA
	SDLK_RSHIFT
	SDLK_RSUPER
	SDLK_SCROLLOCK
	SDLK_SEMICOLON
	SDLK_SLASH
	SDLK_SPACE
	SDLK_SYSREQ
	SDLK_TAB
	SDLK_UNDERSCORE
	SDLK_UP
	SDLK_a
	SDLK_b
	SDLK_c
	SDLK_d
	SDLK_e
	SDLK_f
	SDLK_g
	SDLK_h
	SDLK_i
	SDLK_j
	SDLK_k
	SDLK_l
	SDLK_m
	SDLK_n
	SDLK_o
	SDLK_p
	SDLK_q
	SDLK_r
	SDLK_s
	SDLK_t
	SDLK_u
	SDLK_v
	SDLK_w
	SDLK_x
	SDLK_y
	SDLK_z
	SDL_ACTIVEEVENT
	SDL_ANYFORMAT
	SDL_APPACTIVE
	SDL_APPINPUTFOCUS
	SDL_APPMOUSEFOCUS
	SDL_ASYNCBLIT
	SDL_AUDIO_PAUSED
	SDL_AUDIO_PLAYING
	SDL_AUDIO_STOPPED
	SDL_BUTTON_LEFT
	SDL_BUTTON_MIDDLE
	SDL_BUTTON_RIGHT
	SDL_BUTTON_WHEELUP
	SDL_BUTTON_WHEELDOWN
	SDL_DOUBLEBUF
	SDL_ENABLE
	SDL_FULLSCREEN
	SDL_GL_ACCUM_ALPHA_SIZE
	SDL_GL_ACCUM_BLUE_SIZE
	SDL_GL_ACCUM_GREEN_SIZE
	SDL_GL_ACCUM_RED_SIZE
	SDL_GL_ALPHA_SIZE
	SDL_GL_BLUE_SIZE
	SDL_GL_BUFFER_SIZE
	SDL_GL_DEPTH_SIZE
	SDL_GL_DOUBLEBUFFER
	SDL_GL_GREEN_SIZE
	SDL_GL_RED_SIZE
	SDL_GL_STENCIL_SIZE
	SDL_GRAB_OFF
	SDL_GRAB_ON
	SDL_GRAB_QUERY
	SDL_HAT_CENTERED
	SDL_HAT_DOWN
	SDL_HAT_LEFT
	SDL_HAT_LEFTDOWN
	SDL_HAT_LEFTUP
	SDL_HAT_RIGHT
	SDL_HAT_RIGHTDOWN
	SDL_HAT_RIGHTUP
	SDL_HAT_UP
	SDL_HWACCEL
	SDL_HWPALETTE
	SDL_HWSURFACE
	SDL_IGNORE
	SDL_INIT_AUDIO
	SDL_INIT_CDROM
	SDL_INIT_EVERYTHING
	SDL_INIT_JOYSTICK
	SDL_INIT_NOPARACHUTE
	SDL_INIT_TIMER
	SDL_INIT_VIDEO
	SDL_IYUV_OVERLAY
	SDL_JOYAXISMOTION
	SDL_JOYBALLMOTION
	SDL_JOYBUTTONDOWN
	SDL_JOYBUTTONUP
	SDL_JOYHATMOTION
	SDL_KEYDOWN
	SDL_KEYUP
	SDL_MIX_MAXVOLUME
	SDL_MOUSEBUTTONDOWN
	SDL_MOUSEBUTTONUP
	SDL_MOUSEMOTION
	SDL_OPENGL
	SDL_OPENGLBLIT
	SDL_PREALLOC
	SDL_PRESSED
	SDL_QUERY
	SDL_QUIT
	SDL_RELEASED
	SDL_RESIZABLE
	SDL_RLEACCEL
	SDL_RLEACCELOK
	SDL_SRCALPHA
	SDL_SRCCOLORKEY
	SDL_SWSURFACE
	SDL_SYSWMEVENT
	SDL_UYVY_OVERLAY
	SDL_VIDEOEXPOSE
	SDL_VIDEORESIZE
	SDL_YUY2_OVERLAY
	SDL_YV12_OVERLAY
	SDL_YVYU_OVERLAY
	SMPEG_ERROR
	SMPEG_PLAYING
	SMPEG_STOPPED
	TEXT_BLENDED
	TEXT_SHADED
	TEXT_SOLID
	TTF_STYLE_BOLD
	TTF_STYLE_ITALIC
	TTF_STYLE_NORMAL
	TTF_STYLE_UNDERLINE
	UNICODE_BLENDED
	UNICODE_SHADED
	UNICODE_SOLID
	UTF8_BLENDED
	UTF8_SHADED
	UTF8_SOLID
	SDL_SVG_FLAG_DIRECT
	SDL_SVG_FLAG_COMPOSITE
	SDL_SAMPLEFLAG_NONE
	SDL_SAMPLEFLAG_CANSEEK
	SDL_SAMPLEFLAG_EOF
	SDL_SAMPLEFLAG_ERROR
	SDL_SAMPLEFLAG_EAGAIN
);

use constant {
    SDL_LOGPAL   => 0x01,
    SDL_PHYSPAL  => 0x02,
    AUDIO_S16    => 32784,
    AUDIO_S16MSB => 36880,
    AUDIO_S8     => 32776,
    AUDIO_U16    => 16,
    AUDIO_U16MSB => 4112,
    AUDIO_U8     => 8,
    
    CD_ERROR     => -1,
    CD_PAUSED    => 3,
    CD_PLAYING   => 2,
    CD_STOPPED   => 1,
    CD_TRAYEMPTY => 0,
    
    INADDR_ANY  => 0,
    INADDR_NONE => -1,
    
    KMOD_ALT    => 768,
    KMOD_CAPS   => 8192,
    KMOD_CTRL   => 192,
    KMOD_LALT   => 256,
    KMOD_LCTRL  => 64,
    KMOD_LSHIFT => 1,
    KMOD_NONE   => 0,
    KMOD_NUM    => 4096,
    KMOD_RALT   => 512,
    KMOD_RCTRL  => 128,
    KMOD_RSHIFT => 2,
    KMOD_SHIFT  => 3,
    
    MIX_DEFAULT_CHANNELS  => 2,
    MIX_DEFAULT_FORMAT    => 32784,
    MIX_DEFAULT_FREQUENCY => 22050,
    MIX_FADING_IN         => 2,
    MIX_FADING_OUT        => 1,
    MIX_MAX_VOLUME        => 128,
    MIX_NO_FADING         => 0,
    
    SDLK_0            => 48,
    SDLK_1            => 49,
    SDLK_2            => 50,
    SDLK_3            => 51,
    SDLK_4            => 52,
    SDLK_5            => 53,
    SDLK_6            => 54,
    SDLK_7            => 55,
    SDLK_8            => 56,
    SDLK_9            => 57,
    SDLK_AMPERSAND    => 38,
    SDLK_ASTERISK     => 42,
    SDLK_AT           => 64,
    SDLK_BACKQUOTE    => 96,
    SDLK_BACKSLASH    => 92,
    SDLK_BACKSPACE    => 8,
    SDLK_BREAK        => 318,
    SDLK_CAPSLOCK     => 301,
    SDLK_CARET        => 94,
    SDLK_CLEAR        => 12,
    SDLK_COLON        => 58,
    SDLK_COMMA        => 44,
    SDLK_DELETE       => 127,
    SDLK_DOLLAR       => 36,
    SDLK_DOWN         => 274,
    SDLK_END          => 279,
    SDLK_EQUALS       => 61,
    SDLK_ESCAPE       => 27,
    SDLK_EURO         => 321,
    SDLK_EXCLAIM      => 33,
    SDLK_F1           => 282,
    SDLK_F10          => 291,
    SDLK_F11          => 292,
    SDLK_F12          => 293,
    SDLK_F13          => 294,
    SDLK_F14          => 295,
    SDLK_F15          => 296,
    SDLK_F2           => 283,
    SDLK_F3           => 284,
    SDLK_F4           => 285,
    SDLK_F5           => 286,
    SDLK_F6           => 287,
    SDLK_F7           => 288,
    SDLK_F8           => 289,
    SDLK_F9           => 290,
    SDLK_GREATER      => 62,
    SDLK_HASH         => 35,
    SDLK_HELP         => 315,
    SDLK_HOME         => 278,
    SDLK_INSERT       => 277,
    SDLK_KP0          => 256,
    SDLK_KP1          => 257,
    SDLK_KP2          => 258,
    SDLK_KP3          => 259,
    SDLK_KP4          => 260,
    SDLK_KP5          => 261,
    SDLK_KP6          => 262,
    SDLK_KP7          => 263,
    SDLK_KP8          => 264,
    SDLK_KP9          => 265,
    SDLK_KP_DIVIDE    => 267,
    SDLK_KP_ENTER     => 271,
    SDLK_KP_EQUALS    => 272,
    SDLK_KP_MINUS     => 269,
    SDLK_KP_MULTIPLY  => 268,
    SDLK_KP_PERIOD    => 266,
    SDLK_KP_PLUS      => 270,
    SDLK_LALT         => 308,
    SDLK_LCTRL        => 306,
    SDLK_LEFT         => 276,
    SDLK_LEFTBRACKET  => 91,
    SDLK_LEFTPAREN    => 40,
    SDLK_LESS         => 60,
    SDLK_LMETA        => 310,
    SDLK_LSHIFT       => 304,
    SDLK_LSUPER       => 311,
    SDLK_MENU         => 319,
    SDLK_MINUS        => 45,
    SDLK_MODE         => 313,
    SDLK_NUMLOCK      => 300,
    SDLK_PAGEDOWN     => 281,
    SDLK_PAGEUP       => 280,
    SDLK_PAUSE        => 19,
    SDLK_PERIOD       => 46,
    SDLK_PLUS         => 43,
    SDLK_POWER        => 320,
    SDLK_PRINT        => 316,
    SDLK_QUESTION     => 63,
    SDLK_QUOTE        => 39,
    SDLK_QUOTEDBL     => 34,
    SDLK_RALT         => 307,
    SDLK_RCTRL        => 305,
    SDLK_RETURN       => 13,
    SDLK_RIGHT        => 275,
    SDLK_RIGHTBRACKET => 93,
    SDLK_RIGHTPAREN   => 41,
    SDLK_RMETA        => 309,
    SDLK_RSHIFT       => 303,
    SDLK_RSUPER       => 312,
    SDLK_SCROLLOCK    => 302,
    SDLK_SEMICOLON    => 59,
    SDLK_SLASH        => 47,
    SDLK_SPACE        => 32,
    SDLK_SYSREQ       => 317,
    SDLK_TAB          => 9,
    SDLK_UNDERSCORE   => 95,
    SDLK_UP           => 273,
    SDLK_a            => 97,
    SDLK_b            => 98,
    SDLK_c            => 99,
    SDLK_d            => 100,
    SDLK_e            => 101,
    SDLK_f            => 102,
    SDLK_g            => 103,
    SDLK_h            => 104,
    SDLK_i            => 105,
    SDLK_j            => 106,
    SDLK_k            => 107,
    SDLK_l            => 108,
    SDLK_m            => 109,
    SDLK_n            => 110,
    SDLK_o            => 111,
    SDLK_p            => 112,
    SDLK_q            => 113,
    SDLK_r            => 114,
    SDLK_s            => 115,
    SDLK_t            => 116,
    SDLK_u            => 117,
    SDLK_v            => 118,
    SDLK_w            => 119,
    SDLK_x            => 120,
    SDLK_y            => 121,
    SDLK_z            => 122,
    
    SDL_ACTIVEEVENT => 1,
    SDL_ANYFORMAT => 268435456,
    SDL_APPACTIVE => 4,
    SDL_APPINPUTFOCUS => 2,
    SDL_APPMOUSEFOCUS => 1,
    SDL_ASYNCBLIT => 4,
    
    SDL_AUDIO_PAUSED  => 2,
    SDL_AUDIO_PLAYING => 1,
    SDL_AUDIO_STOPPED => 0,
    
    SDL_BUTTON_LEFT      => 1,
    SDL_BUTTON_MIDDLE    => 2,
    SDL_BUTTON_RIGHT     => 4,
    SDL_BUTTON_WHEELUP   => 8,
    SDL_BUTTON_WHEELDOWN => 16,
    
    SDL_DOUBLEBUF => 1073741824,
    SDL_ENABLE => 1,
    SDL_FULLSCREEN => -2147483648,
    
    SDL_GL_ACCUM_ALPHA_SIZE => 11,
    SDL_GL_ACCUM_BLUE_SIZE  => 10,
    SDL_GL_ACCUM_GREEN_SIZE => 9,
    SDL_GL_ACCUM_RED_SIZE   => 8,
    SDL_GL_ALPHA_SIZE       => 3,
    SDL_GL_BLUE_SIZE        => 2,
    SDL_GL_BUFFER_SIZE      => 4,
    SDL_GL_DEPTH_SIZE       => 6,
    SDL_GL_DOUBLEBUFFER     => 5,
    SDL_GL_GREEN_SIZE       => 1,
    SDL_GL_RED_SIZE         => 0,
    SDL_GL_STENCIL_SIZE     => 7,
    
    SDL_GRAB_OFF   => 0,
    SDL_GRAB_ON    => 1,
    SDL_GRAB_QUERY => -1,
    
    SDL_HAT_CENTERED  => 0,
    SDL_HAT_DOWN      => 4,
    SDL_HAT_LEFT      => 8,
    SDL_HAT_LEFTDOWN  => 12,
    SDL_HAT_LEFTUP    => 9,
    SDL_HAT_RIGHT     => 2,
    SDL_HAT_RIGHTDOWN => 6,
    SDL_HAT_RIGHTUP   => 3,
    SDL_HAT_UP        => 1,
    
    SDL_HWACCEL   => 256,
    SDL_HWPALETTE => 536870912,
    SDL_HWSURFACE => 1,
    
    SDL_IGNORE => 0,
    
    SDL_INIT_AUDIO       => 16,
    SDL_INIT_CDROM       => 256,
    SDL_INIT_EVERYTHING  => 65535,
    SDL_INIT_JOYSTICK    => 512,
    SDL_INIT_NOPARACHUTE => 1048576,
    SDL_INIT_TIMER       => 1,
    SDL_INIT_VIDEO       => 32,
    
    SDL_IYUV_OVERLAY => 1448433993,
    
    SDL_JOYAXISMOTION => 7,
    SDL_JOYBALLMOTION => 8,
    SDL_JOYBUTTONDOWN => 10,
    SDL_JOYBUTTONUP   => 11,
    SDL_JOYHATMOTION  => 9,
    
    SDL_KEYDOWN => 2,
    SDL_KEYUP   => 3,
    
    SDL_MIX_MAXVOLUME => 128,
    
    SDL_MOUSEBUTTONDOWN => 5,
    SDL_MOUSEBUTTONUP   => 6,
    SDL_MOUSEMOTION     => 4,
    
    SDL_OPENGL     => 2,
    SDL_OPENGLBLIT => 10,
    
    SDL_PREALLOC => 16777216,
    SDL_PRESSED => 1,
    SDL_QUERY => -1,
    SDL_QUIT => 12,
    SDL_RELEASED => 0,
    SDL_RESIZABLE => 16,
    SDL_RLEACCEL => 16384,
    SDL_RLEACCELOK => 8192,
    SDL_SRCALPHA => 65536,
    SDL_SRCCOLORKEY => 4096,
    SDL_SWSURFACE => 0,
    SDL_SYSWMEVENT => 13,
    SDL_UYVY_OVERLAY => 1498831189,
    SDL_VIDEOEXPOSE => 17,
    SDL_VIDEORESIZE => 16,
    SDL_YUY2_OVERLAY => 844715353,
    SDL_YV12_OVERLAY => 842094169,
    SDL_YVYU_OVERLAY => 1431918169,
    
    SMPEG_ERROR   => -1,
    SMPEG_PLAYING => 1,
    SMPEG_STOPPED => 0,
    
    TEXT_BLENDED => 4,
    TEXT_SHADED  => 2,
    TEXT_SOLID   => 1,
    
    TTF_STYLE_BOLD      => 1,
    TTF_STYLE_ITALIC    => 2,
    TTF_STYLE_NORMAL    => 0,
    TTF_STYLE_UNDERLINE => 4,
    
    UNICODE_BLENDED => 256,
    UNICODE_SHADED  => 128,
    UNICODE_SOLID   => 64,
    
    UTF8_BLENDED => 32,
    UTF8_SHADED  => 16,
    UTF8_SOLID   => 8,
    
    SDL_SVG_FLAG_DIRECT    => 0,
    SDL_SVG_FLAG_COMPOSITE => 1,
    
    SDL_SAMPLEFLAG_NONE    => 0,
    SDL_SAMPLEFLAG_CANSEEK => 1,
    SDL_SAMPLEFLAG_EOF     => 1<<29,
    SDL_SAMPLEFLAG_ERROR   => 1<<30,
    SDL_SAMPLEFLAG_EAGAIN  => 1<<31,
};

1;
