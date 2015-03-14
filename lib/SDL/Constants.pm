#!/usr/bin/env perl
package SDL::Constants;

use warnings;
use base 'Exporter';
use Config;

our @EXPORT_OK   = ();
our %EXPORT_TAGS = (
	'SDL/defaults' => [
		qw(
			SDL_LIL_ENDIAN
			SDL_BIG_ENDIAN
			SDL_BYTEORDER

			)
	],
	'SDL/init' => [
		qw(
			SDL_INIT_AUDIO
			SDL_INIT_CDROM
			SDL_INIT_EVENTTHREAD
			SDL_INIT_EVERYTHING
			SDL_INIT_JOYSTICK
			SDL_INIT_NOPARACHUTE
			SDL_INIT_TIMER
			SDL_INIT_VIDEO
			)
	],
	'SDL::Audio/format' => [
		qw(
			AUDIO_U8
			AUDIO_S8
			AUDIO_U16LSB
			AUDIO_S16LSB
			AUDIO_U16MSB
			AUDIO_S16MSB
			AUDIO_U16
			AUDIO_S16
			AUDIO_U16SYS
			AUDIO_S16SYS
			)
	],
	'SDL::Audio/status' => [
		qw(
			SDL_AUDIO_STOPPED
			SDL_AUDIO_PLAYING
			SDL_AUDIO_PAUSED
			)
	],
	'SDL::CDROM/defaults' => [
		qw(
			CD_FPS
			SDL_MAX_TRACKS
			)
	],
	'SDL::CDROM/status' => [
		qw(
			CD_TRAYEMPTY
			CD_STOPPED
			CD_PLAYING
			CD_PAUSED
			CD_ERROR
			)
	],
	'SDL::CDROM/track_type' => [
		qw(
			SDL_AUDIO_TRACK
			SDL_DATA_TRACK
			)
	],
	'SDL::Events/type' => [
		qw(
			SDL_ACTIVEEVENT
			SDL_KEYDOWN
			SDL_KEYUP
			SDL_MOUSEMOTION
			SDL_MOUSEBUTTONDOWN
			SDL_MOUSEBUTTONUP
			SDL_JOYAXISMOTION
			SDL_JOYBALLMOTION
			SDL_JOYHATMOTION
			SDL_JOYBUTTONDOWN
			SDL_JOYBUTTONUP
			SDL_QUIT
			SDL_SYSWMEVENT
			SDL_VIDEORESIZE
			SDL_VIDEOEXPOSE
			SDL_USEREVENT
			SDL_NUMEVENTS
			)
	],
	'SDL::Events/mask' => [
		qw(
			SDL_EVENTMASK
			SDL_ACTIVEEVENTMASK
			SDL_KEYDOWNMASK
			SDL_KEYUPMASK
			SDL_KEYEVENTMASK
			SDL_MOUSEMOTIONMASK
			SDL_MOUSEBUTTONDOWNMASK
			SDL_MOUSEBUTTONUPMASK
			SDL_MOUSEEVENTMASK
			SDL_JOYAXISMOTIONMASK
			SDL_JOYBALLMOTIONMASK
			SDL_JOYHATMOTIONMASK
			SDL_JOYBUTTONDOWNMASK
			SDL_JOYBUTTONUPMASK
			SDL_JOYEVENTMASK
			SDL_VIDEORESIZEMASK
			SDL_VIDEOEXPOSEMASK
			SDL_QUITMASK
			SDL_SYSWMEVENTMASK
			SDL_ALLEVENTS
			)
	],
	'SDL::Events/action' => [
		qw(
			SDL_ADDEVENT
			SDL_PEEKEVENT
			SDL_GETEVENT
			)
	],
	'SDL::Events/state' => [
		qw(
			SDL_QUERY
			SDL_IGNORE
			SDL_DISABLE
			SDL_ENABLE
			SDL_RELEASED
			SDL_PRESSED
			)
	],
	'SDL::Events/hat' => [
		qw(
			SDL_HAT_CENTERED
			SDL_HAT_UP
			SDL_HAT_RIGHT
			SDL_HAT_DOWN
			SDL_HAT_LEFT
			SDL_HAT_RIGHTUP
			SDL_HAT_RIGHTDOWN
			SDL_HAT_LEFTUP
			SDL_HAT_LEFTDOWN
			)
	],
	'SDL::Events/app' => [
		qw(
			SDL_APPMOUSEFOCUS
			SDL_APPINPUTFOCUS
			SDL_APPACTIVE
			)
	],
	'SDL::Events/button' => [
		qw(
			SDL_BUTTON
			SDL_BUTTON_LEFT
			SDL_BUTTON_MIDDLE
			SDL_BUTTON_RIGHT
			SDL_BUTTON_WHEELUP
			SDL_BUTTON_WHEELDOWN
			SDL_BUTTON_X1
			SDL_BUTTON_X2
			SDL_BUTTON_LMASK
			SDL_BUTTON_MMASK
			SDL_BUTTON_RMASK
			SDL_BUTTON_X1MASK
			SDL_BUTTON_X2MASK
			)
	],
	'SDL::Events/keysym' => [
		qw(
			SDLK_UNKNOWN
			SDLK_FIRST
			SDLK_BACKSPACE
			SDLK_TAB
			SDLK_CLEAR
			SDLK_RETURN
			SDLK_PAUSE
			SDLK_ESCAPE
			SDLK_SPACE
			SDLK_EXCLAIM
			SDLK_QUOTEDBL
			SDLK_HASH
			SDLK_DOLLAR
			SDLK_AMPERSAND
			SDLK_QUOTE
			SDLK_LEFTPAREN
			SDLK_RIGHTPAREN
			SDLK_ASTERISK
			SDLK_PLUS
			SDLK_COMMA
			SDLK_MINUS
			SDLK_PERIOD
			SDLK_SLASH
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
			SDLK_COLON
			SDLK_SEMICOLON
			SDLK_LESS
			SDLK_EQUALS
			SDLK_GREATER
			SDLK_QUESTION
			SDLK_AT
			SDLK_LEFTBRACKET
			SDLK_BACKSLASH
			SDLK_RIGHTBRACKET
			SDLK_CARET
			SDLK_UNDERSCORE
			SDLK_BACKQUOTE
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
			SDLK_DELETE
			SDLK_WORLD_0
			SDLK_WORLD_1
			SDLK_WORLD_2
			SDLK_WORLD_3
			SDLK_WORLD_4
			SDLK_WORLD_5
			SDLK_WORLD_6
			SDLK_WORLD_7
			SDLK_WORLD_8
			SDLK_WORLD_9
			SDLK_WORLD_10
			SDLK_WORLD_11
			SDLK_WORLD_12
			SDLK_WORLD_13
			SDLK_WORLD_14
			SDLK_WORLD_15
			SDLK_WORLD_16
			SDLK_WORLD_17
			SDLK_WORLD_18
			SDLK_WORLD_19
			SDLK_WORLD_20
			SDLK_WORLD_21
			SDLK_WORLD_22
			SDLK_WORLD_23
			SDLK_WORLD_24
			SDLK_WORLD_25
			SDLK_WORLD_26
			SDLK_WORLD_27
			SDLK_WORLD_28
			SDLK_WORLD_29
			SDLK_WORLD_30
			SDLK_WORLD_31
			SDLK_WORLD_32
			SDLK_WORLD_33
			SDLK_WORLD_34
			SDLK_WORLD_35
			SDLK_WORLD_36
			SDLK_WORLD_37
			SDLK_WORLD_38
			SDLK_WORLD_39
			SDLK_WORLD_40
			SDLK_WORLD_41
			SDLK_WORLD_42
			SDLK_WORLD_43
			SDLK_WORLD_44
			SDLK_WORLD_45
			SDLK_WORLD_46
			SDLK_WORLD_47
			SDLK_WORLD_48
			SDLK_WORLD_49
			SDLK_WORLD_50
			SDLK_WORLD_51
			SDLK_WORLD_52
			SDLK_WORLD_53
			SDLK_WORLD_54
			SDLK_WORLD_55
			SDLK_WORLD_56
			SDLK_WORLD_57
			SDLK_WORLD_58
			SDLK_WORLD_59
			SDLK_WORLD_60
			SDLK_WORLD_61
			SDLK_WORLD_62
			SDLK_WORLD_63
			SDLK_WORLD_64
			SDLK_WORLD_65
			SDLK_WORLD_66
			SDLK_WORLD_67
			SDLK_WORLD_68
			SDLK_WORLD_69
			SDLK_WORLD_70
			SDLK_WORLD_71
			SDLK_WORLD_72
			SDLK_WORLD_73
			SDLK_WORLD_74
			SDLK_WORLD_75
			SDLK_WORLD_76
			SDLK_WORLD_77
			SDLK_WORLD_78
			SDLK_WORLD_79
			SDLK_WORLD_80
			SDLK_WORLD_81
			SDLK_WORLD_82
			SDLK_WORLD_83
			SDLK_WORLD_84
			SDLK_WORLD_85
			SDLK_WORLD_86
			SDLK_WORLD_87
			SDLK_WORLD_88
			SDLK_WORLD_89
			SDLK_WORLD_90
			SDLK_WORLD_91
			SDLK_WORLD_92
			SDLK_WORLD_93
			SDLK_WORLD_94
			SDLK_WORLD_95
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
			SDLK_KP_PERIOD
			SDLK_KP_DIVIDE
			SDLK_KP_MULTIPLY
			SDLK_KP_MINUS
			SDLK_KP_PLUS
			SDLK_KP_ENTER
			SDLK_KP_EQUALS
			SDLK_UP
			SDLK_DOWN
			SDLK_RIGHT
			SDLK_LEFT
			SDLK_INSERT
			SDLK_HOME
			SDLK_END
			SDLK_PAGEUP
			SDLK_PAGEDOWN
			SDLK_F1
			SDLK_F2
			SDLK_F3
			SDLK_F4
			SDLK_F5
			SDLK_F6
			SDLK_F7
			SDLK_F8
			SDLK_F9
			SDLK_F10
			SDLK_F11
			SDLK_F12
			SDLK_F13
			SDLK_F14
			SDLK_F15
			SDLK_NUMLOCK
			SDLK_CAPSLOCK
			SDLK_SCROLLOCK
			SDLK_RSHIFT
			SDLK_LSHIFT
			SDLK_RCTRL
			SDLK_LCTRL
			SDLK_RALT
			SDLK_LALT
			SDLK_RMETA
			SDLK_LMETA
			SDLK_LSUPER
			SDLK_RSUPER
			SDLK_MODE
			SDLK_COMPOSE
			SDLK_HELP
			SDLK_PRINT
			SDLK_SYSREQ
			SDLK_BREAK
			SDLK_MENU
			SDLK_POWER
			SDLK_EURO
			SDLK_UNDO
			)
	],
	'SDL::Events/keymod' => [
		qw(
			KMOD_NONE
			KMOD_LSHIFT
			KMOD_RSHIFT
			KMOD_LCTRL
			KMOD_RCTRL
			KMOD_LALT
			KMOD_RALT
			KMOD_LMETA
			KMOD_RMETA
			KMOD_NUM
			KMOD_CAPS
			KMOD_MODE
			KMOD_RESERVED
			KMOD_CTRL
			KMOD_SHIFT
			KMOD_ALT
			KMOD_META
			)
	],
	'SDL::GFX/smoothing' => [
		qw(
			SMOOTHING_OFF
			SMOOTHING_ON
			)
	],
	'SDL::Image/init' => [
		qw(
			IMG_INIT_JPG
			IMG_INIT_PNG
			IMG_INIT_TIF
			)
	],
	'SDL::Net/defaults' => [
		qw(
			INADDR_ANY
			INADDR_NONE
			INADDR_BROADCAST
			SDLNET_MAX_UDPCHANNELS
			SDLNET_MAX_UDPADDRESSES
			)
	],
	'SDL::Mixer/init' => [
		qw(
			MIX_INIT_FLAC
			MIX_INIT_MOD
			MIX_INIT_MP3
			MIX_INIT_OGG
			)
	],
	'SDL::Mixer/defaults' => [
		qw(
			MIX_CHANNELS
			MIX_DEFAULT_FORMAT
			MIX_DEFAULT_FREQUENCY
			MIX_DEFAULT_CHANNELS
			MIX_MAX_VOLUME
			MIX_CHANNEL_POST
			)
	],
	'SDL::Mixer/fading' => [
		qw(
			MIX_NO_FADING
			MIX_FADING_OUT
			MIX_FADING_IN
			)
	],
	'SDL::Mixer/type' => [
		qw(
			MUS_NONE
			MUS_CMD
			MUS_WAV
			MUS_MOD
			MUS_MID
			MUS_OGG
			MUS_MP3
			MUS_MP3_MAD
			MUS_MP3_FLAC
			)
	],
	'SDL::Pango/direction' => [
		qw(
			SDLPANGO_DIRECTION_LTR
			SDLPANGO_DIRECTION_RTL
			SDLPANGO_DIRECTION_WEAK_LTR
			SDLPANGO_DIRECTION_WEAK_RTL
			SDLPANGO_DIRECTION_NEUTRAL
			)
	],
	'SDL::Pango/align' => [
		qw(
			SDLPANGO_ALIGN_LEFT
			SDLPANGO_ALIGN_CENTER
			SDLPANGO_ALIGN_RIGHT
			)
	],
	'SDL::RWOps/defaults' => [
		qw(
			RW_SEEK_SET
			RW_SEEK_CUR
			RW_SEEK_END
			)
	],
	'SDL::TTF/hinting' => [
		qw(
			TTF_HINTING_NORMAL
			TTF_HINTING_LIGHT
			TTF_HINTING_MONO
			TTF_HINTING_NONE
			)
	],
	'SDL::TTF/style' => [
		qw(
			TTF_STYLE_NORMAL
			TTF_STYLE_BOLD
			TTF_STYLE_ITALIC
			TTF_STYLE_UNDERLINE
			TTF_STYLE_STRIKETHROUGH
			)
	],
	'SDL::Video/color' => [
		qw(
			SDL_ALPHA_OPAQUE
			SDL_ALPHA_TRANSPARENT
			)
	],
	'SDL::Video/surface' => [
		qw(
			SDL_SWSURFACE
			SDL_HWSURFACE
			SDL_ASYNCBLIT
			)
	],
	'SDL::Video/video' => [
		qw(
			SDL_SWSURFACE
			SDL_HWSURFACE
			SDL_ASYNCBLIT
			SDL_ANYFORMAT
			SDL_HWPALETTE
			SDL_DOUBLEBUF
			SDL_FULLSCREEN
			SDL_OPENGL
			SDL_OPENGLBLIT
			SDL_RESIZABLE
			SDL_NOFRAME
			SDL_HWACCEL
			SDL_SRCCOLORKEY
			SDL_RLEACCELOK
			SDL_RLEACCEL
			SDL_SRCALPHA
			SDL_PREALLOC
			)
	],
	'SDL::Video/overlay' => [
		qw(
			SDL_YV12_OVERLAY
			SDL_IYUV_OVERLAY
			SDL_YUY2_OVERLAY
			SDL_UYVY_OVERLAY
			SDL_YVYU_OVERLAY
			)
	],
	'SDL::Video/palette' => [
		qw(
			SDL_LOGPAL
			SDL_PHYSPAL
			)
	],
	'SDL::Video/grab' => [
		qw(
			SDL_GRAB_QUERY
			SDL_GRAB_OFF
			SDL_GRAB_ON
			SDL_GRAB_FULLSCREEN
			)
	],
	'SDL::Video/gl' => [
		qw(
			SDL_GL_RED_SIZE
			SDL_GL_GREEN_SIZE
			SDL_GL_BLUE_SIZE
			SDL_GL_ALPHA_SIZE
			SDL_GL_BUFFER_SIZE
			SDL_GL_DOUBLEBUFFER
			SDL_GL_DEPTH_SIZE
			SDL_GL_STENCIL_SIZE
			SDL_GL_ACCUM_RED_SIZE
			SDL_GL_ACCUM_GREEN_SIZE
			SDL_GL_ACCUM_BLUE_SIZE
			SDL_GL_ACCUM_ALPHA_SIZE
			SDL_GL_STEREO
			SDL_GL_MULTISAMPLEBUFFERS
			SDL_GL_MULTISAMPLESAMPLES
			SDL_GL_ACCELERATED_VISUAL
			SDL_GL_SWAP_CONTROL
			)
	],
);

# 1. all constants from %EXPORT_TAGS are gonna pushed into @EXPORT
# 2. tags like 'package/tag' and 'package/next_tag' are merged into tag 'package'
my %seen;
foreach my $package ( keys %EXPORT_TAGS ) {
	my $super_package = $package;
	$super_package =~ s/\/.*$//;
	push( @{ $EXPORT_TAGS{$super_package} }, @{ $EXPORT_TAGS{$package} } )
		if $super_package ne $package;
	push( @EXPORT_OK, grep { !$seen{$_}++ } @{ $EXPORT_TAGS{$package} } );
}

use constant {
	SDL_INIT_TIMER       => 0x00000001,
	SDL_INIT_AUDIO       => 0x00000010,
	SDL_INIT_VIDEO       => 0x00000020,
	SDL_INIT_CDROM       => 0x00000100,
	SDL_INIT_JOYSTICK    => 0x00000200,
	SDL_INIT_NOPARACHUTE => 0x00100000,
	SDL_INIT_EVENTTHREAD => 0x01000000,
	SDL_INIT_EVERYTHING  => 0x0000FFFF,
}; # SDL/init

use constant {
	SDL_LIL_ENDIAN => 1234,
	SDL_BIG_ENDIAN => 4321,
	SDL_BYTEORDER  => $Config{byteorder}
}; # SDL/defaults

use constant {
	AUDIO_U8     => 0x0008,
	AUDIO_S8     => 0x8008,
	AUDIO_U16LSB => 0x0010,
	AUDIO_S16LSB => 0x8010,
	AUDIO_U16MSB => 0x1010,
	AUDIO_S16MSB => 0x9010,
	AUDIO_U16    => 0x0010,
	AUDIO_S16    => 0x8010,
}; # SDL::Audio/format

use constant {
	AUDIO_U16SYS => ( $Config{byteorder} == 1234 ? 0x0010 : 0x1010 ),
	AUDIO_S16SYS => ( $Config{byteorder} == 1234 ? 0x8010 : 0x9010 ),
}; # SDL::Audio/format

use constant {
	SDL_AUDIO_STOPPED => 0,
	SDL_AUDIO_PLAYING => 1,
	SDL_AUDIO_PAUSED  => 2,
}; # SDL::Audio/status

use constant {
	CD_FPS         => 75,
	SDL_MAX_TRACKS => 99,
}; # SDL::CDROM/defaults

use constant {
	CD_TRAYEMPTY => 0,
	CD_STOPPED   => 1,
	CD_PLAYING   => 2,
	CD_PAUSED    => 3,
	CD_ERROR     => -1,
}; # SDL::CDROM/status

use constant {
	SDL_AUDIO_TRACK => 0,
	SDL_DATA_TRACK  => 4,
}; # SDL::CDROM/track_type

use constant {
	SDL_ACTIVEEVENT     => 1,
	SDL_KEYDOWN         => 2,
	SDL_KEYUP           => 3,
	SDL_MOUSEMOTION     => 4,
	SDL_MOUSEBUTTONDOWN => 5,
	SDL_MOUSEBUTTONUP   => 6,
	SDL_JOYAXISMOTION   => 7,
	SDL_JOYBALLMOTION   => 8,
	SDL_JOYHATMOTION    => 9,
	SDL_JOYBUTTONDOWN   => 10,
	SDL_JOYBUTTONUP     => 11,
	SDL_QUIT            => 12,
	SDL_SYSWMEVENT      => 13,
	SDL_VIDEORESIZE     => 16,
	SDL_VIDEOEXPOSE     => 17,
	SDL_USEREVENT       => 24,
	SDL_NUMEVENTS       => 32,
}; # SDL::Events/type

sub SDL_EVENTMASK { return 1 << shift; }

use constant {
	SDL_ACTIVEEVENTMASK     => SDL_EVENTMASK(SDL_ACTIVEEVENT),
	SDL_KEYDOWNMASK         => SDL_EVENTMASK(SDL_KEYDOWN),
	SDL_KEYUPMASK           => SDL_EVENTMASK(SDL_KEYUP),
	SDL_KEYEVENTMASK        => SDL_EVENTMASK(SDL_KEYDOWN) | SDL_EVENTMASK(SDL_KEYUP),
	SDL_MOUSEMOTIONMASK     => SDL_EVENTMASK(SDL_MOUSEMOTION),
	SDL_MOUSEBUTTONDOWNMASK => SDL_EVENTMASK(SDL_MOUSEBUTTONDOWN),
	SDL_MOUSEBUTTONUPMASK   => SDL_EVENTMASK(SDL_MOUSEBUTTONUP),
	SDL_MOUSEEVENTMASK      => SDL_EVENTMASK(SDL_MOUSEMOTION) |
		SDL_EVENTMASK(SDL_MOUSEBUTTONDOWN) | SDL_EVENTMASK(SDL_MOUSEBUTTONUP),
	SDL_JOYAXISMOTIONMASK => SDL_EVENTMASK(SDL_JOYAXISMOTION),
	SDL_JOYBALLMOTIONMASK => SDL_EVENTMASK(SDL_JOYBALLMOTION),
	SDL_JOYHATMOTIONMASK  => SDL_EVENTMASK(SDL_JOYHATMOTION),
	SDL_JOYBUTTONDOWNMASK => SDL_EVENTMASK(SDL_JOYBUTTONDOWN),
	SDL_JOYBUTTONUPMASK   => SDL_EVENTMASK(SDL_JOYBUTTONUP),
	SDL_JOYEVENTMASK      => SDL_EVENTMASK(SDL_JOYAXISMOTION) |
		SDL_EVENTMASK(SDL_JOYBALLMOTION) | SDL_EVENTMASK(SDL_JOYHATMOTION) |
		SDL_EVENTMASK(SDL_JOYBUTTONDOWN) | SDL_EVENTMASK(SDL_JOYBUTTONUP),
	SDL_VIDEORESIZEMASK => SDL_EVENTMASK(SDL_VIDEORESIZE),
	SDL_VIDEOEXPOSEMASK => SDL_EVENTMASK(SDL_VIDEOEXPOSE),
	SDL_QUITMASK        => SDL_EVENTMASK(SDL_QUIT),
	SDL_SYSWMEVENTMASK  => SDL_EVENTMASK(SDL_SYSWMEVENT),
	SDL_ALLEVENTS       => 0xFFFFFFFF,
}; # SDL::Events/mask

use constant {
	SDL_ADDEVENT  => 0,
	SDL_PEEKEVENT => 1,
	SDL_GETEVENT  => 2,
}; # SDL::Events/action

use constant {
	SDL_QUERY    => -1,
	SDL_IGNORE   => 0,
	SDL_DISABLE  => 0,
	SDL_ENABLE   => 1,
	SDL_RELEASED => 0,
	SDL_PRESSED  => 1,
}; # SDL::Events/state

use constant {
	SDL_HAT_CENTERED  => 0x00,
	SDL_HAT_UP        => 0x01,
	SDL_HAT_RIGHT     => 0x02,
	SDL_HAT_DOWN      => 0x04,
	SDL_HAT_LEFT      => 0x08,
	SDL_HAT_RIGHTUP   => ( 0x02 | 0x01 ),
	SDL_HAT_RIGHTDOWN => ( 0x02 | 0x04 ),
	SDL_HAT_LEFTUP    => ( 0x08 | 0x01 ),
	SDL_HAT_LEFTDOWN  => ( 0x08 | 0x04 ),
}; # SDL::Events/hat

use constant {
	SDL_APPMOUSEFOCUS => 0x01,
	SDL_APPINPUTFOCUS => 0x02,
	SDL_APPACTIVE     => 0x04,
}; # SDL::Events/app

sub SDL_BUTTON { return ( 1 << ( ( $_[0] ) - 1 ) ); }

use constant {
	SDL_BUTTON_LEFT      => 1,
	SDL_BUTTON_MIDDLE    => 2,
	SDL_BUTTON_RIGHT     => 3,
	SDL_BUTTON_WHEELUP   => 4,
	SDL_BUTTON_WHEELDOWN => 5,
	SDL_BUTTON_X1        => 6,
	SDL_BUTTON_X2        => 7,
	SDL_BUTTON_LMASK     => SDL_BUTTON(1),
	SDL_BUTTON_MMASK     => SDL_BUTTON(2),
	SDL_BUTTON_RMASK     => SDL_BUTTON(3),
	SDL_BUTTON_X1MASK    => SDL_BUTTON(6),
	SDL_BUTTON_X2MASK    => SDL_BUTTON(7),
}; # SDL::Events/button

use constant {
	SDLK_UNKNOWN      => 0,
	SDLK_FIRST        => 0,
	SDLK_BACKSPACE    => 8,
	SDLK_TAB          => 9,
	SDLK_CLEAR        => 12,
	SDLK_RETURN       => 13,
	SDLK_PAUSE        => 19,
	SDLK_ESCAPE       => 27,
	SDLK_SPACE        => 32,
	SDLK_EXCLAIM      => 33,
	SDLK_QUOTEDBL     => 34,
	SDLK_HASH         => 35,
	SDLK_DOLLAR       => 36,
	SDLK_AMPERSAND    => 38,
	SDLK_QUOTE        => 39,
	SDLK_LEFTPAREN    => 40,
	SDLK_RIGHTPAREN   => 41,
	SDLK_ASTERISK     => 42,
	SDLK_PLUS         => 43,
	SDLK_COMMA        => 44,
	SDLK_MINUS        => 45,
	SDLK_PERIOD       => 46,
	SDLK_SLASH        => 47,
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
	SDLK_COLON        => 58,
	SDLK_SEMICOLON    => 59,
	SDLK_LESS         => 60,
	SDLK_EQUALS       => 61,
	SDLK_GREATER      => 62,
	SDLK_QUESTION     => 63,
	SDLK_AT           => 64,
	SDLK_LEFTBRACKET  => 91,
	SDLK_BACKSLASH    => 92,
	SDLK_RIGHTBRACKET => 93,
	SDLK_CARET        => 94,
	SDLK_UNDERSCORE   => 95,
	SDLK_BACKQUOTE    => 96,
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
	SDLK_DELETE       => 127,
	SDLK_WORLD_0      => 160,
	SDLK_WORLD_1      => 161,
	SDLK_WORLD_2      => 162,
	SDLK_WORLD_3      => 163,
	SDLK_WORLD_4      => 164,
	SDLK_WORLD_5      => 165,
	SDLK_WORLD_6      => 166,
	SDLK_WORLD_7      => 167,
	SDLK_WORLD_8      => 168,
	SDLK_WORLD_9      => 169,
	SDLK_WORLD_10     => 170,
	SDLK_WORLD_11     => 171,
	SDLK_WORLD_12     => 172,
	SDLK_WORLD_13     => 173,
	SDLK_WORLD_14     => 174,
	SDLK_WORLD_15     => 175,
	SDLK_WORLD_16     => 176,
	SDLK_WORLD_17     => 177,
	SDLK_WORLD_18     => 178,
	SDLK_WORLD_19     => 179,
	SDLK_WORLD_20     => 180,
	SDLK_WORLD_21     => 181,
	SDLK_WORLD_22     => 182,
	SDLK_WORLD_23     => 183,
	SDLK_WORLD_24     => 184,
	SDLK_WORLD_25     => 185,
	SDLK_WORLD_26     => 186,
	SDLK_WORLD_27     => 187,
	SDLK_WORLD_28     => 188,
	SDLK_WORLD_29     => 189,
	SDLK_WORLD_30     => 190,
	SDLK_WORLD_31     => 191,
	SDLK_WORLD_32     => 192,
	SDLK_WORLD_33     => 193,
	SDLK_WORLD_34     => 194,
	SDLK_WORLD_35     => 195,
	SDLK_WORLD_36     => 196,
	SDLK_WORLD_37     => 197,
	SDLK_WORLD_38     => 198,
	SDLK_WORLD_39     => 199,
	SDLK_WORLD_40     => 200,
	SDLK_WORLD_41     => 201,
	SDLK_WORLD_42     => 202,
	SDLK_WORLD_43     => 203,
	SDLK_WORLD_44     => 204,
	SDLK_WORLD_45     => 205,
	SDLK_WORLD_46     => 206,
	SDLK_WORLD_47     => 207,
	SDLK_WORLD_48     => 208,
	SDLK_WORLD_49     => 209,
	SDLK_WORLD_50     => 210,
	SDLK_WORLD_51     => 211,
	SDLK_WORLD_52     => 212,
	SDLK_WORLD_53     => 213,
	SDLK_WORLD_54     => 214,
	SDLK_WORLD_55     => 215,
	SDLK_WORLD_56     => 216,
	SDLK_WORLD_57     => 217,
	SDLK_WORLD_58     => 218,
	SDLK_WORLD_59     => 219,
	SDLK_WORLD_60     => 220,
	SDLK_WORLD_61     => 221,
	SDLK_WORLD_62     => 222,
	SDLK_WORLD_63     => 223,
	SDLK_WORLD_64     => 224,
	SDLK_WORLD_65     => 225,
	SDLK_WORLD_66     => 226,
	SDLK_WORLD_67     => 227,
	SDLK_WORLD_68     => 228,
	SDLK_WORLD_69     => 229,
	SDLK_WORLD_70     => 230,
	SDLK_WORLD_71     => 231,
	SDLK_WORLD_72     => 232,
	SDLK_WORLD_73     => 233,
	SDLK_WORLD_74     => 234,
	SDLK_WORLD_75     => 235,
	SDLK_WORLD_76     => 236,
	SDLK_WORLD_77     => 237,
	SDLK_WORLD_78     => 238,
	SDLK_WORLD_79     => 239,
	SDLK_WORLD_80     => 240,
	SDLK_WORLD_81     => 241,
	SDLK_WORLD_82     => 242,
	SDLK_WORLD_83     => 243,
	SDLK_WORLD_84     => 244,
	SDLK_WORLD_85     => 245,
	SDLK_WORLD_86     => 246,
	SDLK_WORLD_87     => 247,
	SDLK_WORLD_88     => 248,
	SDLK_WORLD_89     => 249,
	SDLK_WORLD_90     => 250,
	SDLK_WORLD_91     => 251,
	SDLK_WORLD_92     => 252,
	SDLK_WORLD_93     => 253,
	SDLK_WORLD_94     => 254,
	SDLK_WORLD_95     => 255,
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
	SDLK_KP_PERIOD    => 266,
	SDLK_KP_DIVIDE    => 267,
	SDLK_KP_MULTIPLY  => 268,
	SDLK_KP_MINUS     => 269,
	SDLK_KP_PLUS      => 270,
	SDLK_KP_ENTER     => 271,
	SDLK_KP_EQUALS    => 272,
	SDLK_UP           => 273,
	SDLK_DOWN         => 274,
	SDLK_RIGHT        => 275,
	SDLK_LEFT         => 276,
	SDLK_INSERT       => 277,
	SDLK_HOME         => 278,
	SDLK_END          => 279,
	SDLK_PAGEUP       => 280,
	SDLK_PAGEDOWN     => 281,
	SDLK_F1           => 282,
	SDLK_F2           => 283,
	SDLK_F3           => 284,
	SDLK_F4           => 285,
	SDLK_F5           => 286,
	SDLK_F6           => 287,
	SDLK_F7           => 288,
	SDLK_F8           => 289,
	SDLK_F9           => 290,
	SDLK_F10          => 291,
	SDLK_F11          => 292,
	SDLK_F12          => 293,
	SDLK_F13          => 294,
	SDLK_F14          => 295,
	SDLK_F15          => 296,
	SDLK_NUMLOCK      => 300,
	SDLK_CAPSLOCK     => 301,
	SDLK_SCROLLOCK    => 302,
	SDLK_RSHIFT       => 303,
	SDLK_LSHIFT       => 304,
	SDLK_RCTRL        => 305,
	SDLK_LCTRL        => 306,
	SDLK_RALT         => 307,
	SDLK_LALT         => 308,
	SDLK_RMETA        => 309,
	SDLK_LMETA        => 310,
	SDLK_LSUPER       => 311,
	SDLK_RSUPER       => 312,
	SDLK_MODE         => 313,
	SDLK_COMPOSE      => 314,
	SDLK_HELP         => 315,
	SDLK_PRINT        => 316,
	SDLK_SYSREQ       => 317,
	SDLK_BREAK        => 318,
	SDLK_MENU         => 319,
	SDLK_POWER        => 320,
	SDLK_EURO         => 321,
	SDLK_UNDO         => 322,
}; # SDL::Events/keysym

use constant {
	KMOD_NONE     => 0x0000,
	KMOD_LSHIFT   => 0x0001,
	KMOD_RSHIFT   => 0x0002,
	KMOD_LCTRL    => 0x0040,
	KMOD_RCTRL    => 0x0080,
	KMOD_LALT     => 0x0100,
	KMOD_RALT     => 0x0200,
	KMOD_LMETA    => 0x0400,
	KMOD_RMETA    => 0x0800,
	KMOD_NUM      => 0x1000,
	KMOD_CAPS     => 0x2000,
	KMOD_MODE     => 0x4000,
	KMOD_RESERVED => 0x8000
}; # SDL::Events/keymod

use constant {
	KMOD_CTRL  => ( KMOD_LCTRL | KMOD_RCTRL ),
	KMOD_SHIFT => ( KMOD_LSHIFT | KMOD_RSHIFT ),
	KMOD_ALT   => ( KMOD_LALT | KMOD_RALT ),
	KMOD_META  => ( KMOD_LMETA | KMOD_RMETA ),
}; # SDL::Events/keymod

use constant {
	SDL_DEFAULT_REPEAT_DELAY    => 500,
	SDL_DEFAULT_REPEAT_INTERVAL => 30,
}; # SDL::Events/repeat

use constant {
	SMOOTHING_OFF => 0,
	SMOOTHING_ON  => 1,
}; # SDL::GFX/smoothing

use constant {
	IMG_INIT_JPG => 0x00000001,
	IMG_INIT_PNG => 0x00000002,
	IMG_INIT_TIF => 0x00000004,
}; # SDL::Image

use constant {
	MIX_INIT_FLAC => 0x00000001,
	MIX_INIT_MOD  => 0x00000002,
	MIX_INIT_MP3  => 0x00000004,
	MIX_INIT_OGG  => 0x00000008
}; # SDL::Mixer/init

use constant {
	MIX_CHANNELS          => 8,
	MIX_DEFAULT_FORMAT    => 32784,
	MIX_DEFAULT_FREQUENCY => 22050,
	MIX_DEFAULT_CHANNELS  => 2,
	MIX_MAX_VOLUME        => 128,
	MIX_CHANNEL_POST      => -2,
}; # SDL::Mixer/defaults

use constant {
	MIX_NO_FADING  => 0,
	MIX_FADING_OUT => 1,
	MIX_FADING_IN  => 2,
}; # SDL::Mixer/fading

use constant {
	MUS_NONE     => 0,
	MUS_CMD      => 1,
	MUS_WAV      => 2,
	MUS_MOD      => 3,
	MUS_MID      => 4,
	MUS_OGG      => 5,
	MUS_MP3      => 6,
	MUS_MP3_MAD  => 7,
	MUS_MP3_FLAC => 8,
}; # SDL::Mixer/type

use constant {
	INADDR_ANY              => 0x00000000,
	INADDR_NONE             => 0xFFFFFFFF,
	INADDR_BROADCAST        => 0xFFFFFFFF,
	SDLNET_MAX_UDPCHANNELS  => 32,
	SDLNET_MAX_UDPADDRESSES => 4
}; # SDL::Net

use constant {
	SDLPANGO_DIRECTION_LTR      => 0,
	SDLPANGO_DIRECTION_RTL      => 1,
	SDLPANGO_DIRECTION_WEAK_LTR => 2,
	SDLPANGO_DIRECTION_WEAK_RTL => 3,
	SDLPANGO_DIRECTION_NEUTRAL  => 4
}; # SDL::Pango/direction

use constant {
	SDLPANGO_ALIGN_LEFT   => 0,
	SDLPANGO_ALIGN_CENTER => 1,
	SDLPANGO_ALIGN_RIGHT  => 2
}; # SDL::Pango/align

use constant {
	RW_SEEK_SET => 0,
	RW_SEEK_CUR => 1,
	RW_SEEK_END => 2,
}; # SDL::RWOps/defaults

use constant {
	TTF_HINTING_NORMAL      => 0,
	TTF_HINTING_LIGHT       => 1,
	TTF_HINTING_MONO        => 2,
	TTF_HINTING_NONE        => 3,
	TTF_STYLE_NORMAL        => 0,
	TTF_STYLE_BOLD          => 1,
	TTF_STYLE_ITALIC        => 2,
	TTF_STYLE_UNDERLINE     => 4,
	TTF_STYLE_STRIKETHROUGH => 8,
}; # SDL::TTF

use constant {
	SDL_ALPHA_OPAQUE      => 255,
	SDL_ALPHA_TRANSPARENT => 0,

	SDL_SWSURFACE   => 0x00000000, # for SDL::Surface->new() and set_video_mode()
	SDL_HWSURFACE   => 0x00000001, # for SDL::Surface->new() and set_video_mode()
	SDL_ASYNCBLIT   => 0x00000004, # for SDL::Surface->new() and set_video_mode()
	SDL_ANYFORMAT   => 0x10000000, # set_video_mode()
	SDL_HWPALETTE   => 0x20000000, # set_video_mode()
	SDL_DOUBLEBUF   => 0x40000000, # set_video_mode()
	SDL_FULLSCREEN  => 0x80000000, # set_video_mode()
	SDL_OPENGL      => 0x00000002, # set_video_mode()
	SDL_OPENGLBLIT  => 0x0000000A, # set_video_mode()
	SDL_RESIZABLE   => 0x00000010, # set_video_mode()
	SDL_NOFRAME     => 0x00000020, # set_video_mode()
	SDL_HWACCEL     => 0x00000100, # set_video_mode()
	SDL_SRCCOLORKEY => 0x00001000, # set_video_mode()
	SDL_RLEACCELOK  => 0x00002000, # set_video_mode()
	SDL_RLEACCEL    => 0x00004000, # set_video_mode()
	SDL_SRCALPHA    => 0x00010000, # set_video_mode()
	SDL_PREALLOC    => 0x01000000, # set_video_mode()

	SDL_YV12_OVERLAY => 0x32315659, # Planar mode: Y + V + U  (3 planes)
	SDL_IYUV_OVERLAY => 0x56555949, # Planar mode: Y + U + V  (3 planes)
	SDL_YUY2_OVERLAY => 0x32595559, # Packed mode: Y0+U0+Y1+V0 (1 plane)
	SDL_UYVY_OVERLAY => 0x59565955, # Packed mode: U0+Y0+V0+Y1 (1 plane)
	SDL_YVYU_OVERLAY => 0x55595659, # Packed mode: Y0+V0+Y1+U0 (1 plane)

	SDL_LOGPAL  => 0x01,            # for set_palette()
	SDL_PHYSPAL => 0x02,            # for set_palette()

	SDL_GRAB_QUERY      => -1,      # SDL_GrabMode
	SDL_GRAB_OFF        => 0,       # SDL_GrabMode
	SDL_GRAB_ON         => 1,       # SDL_GrabMode
	SDL_GRAB_FULLSCREEN => 2,       # SDL_GrabMode, used internally
}; # SDL::Video/...

use constant {
	SDL_GL_RED_SIZE           => 0,
	SDL_GL_GREEN_SIZE         => 1,
	SDL_GL_BLUE_SIZE          => 2,
	SDL_GL_ALPHA_SIZE         => 3,
	SDL_GL_BUFFER_SIZE        => 4,
	SDL_GL_DOUBLEBUFFER       => 5,
	SDL_GL_DEPTH_SIZE         => 6,
	SDL_GL_STENCIL_SIZE       => 7,
	SDL_GL_ACCUM_RED_SIZE     => 8,
	SDL_GL_ACCUM_GREEN_SIZE   => 9,
	SDL_GL_ACCUM_BLUE_SIZE    => 10,
	SDL_GL_ACCUM_ALPHA_SIZE   => 11,
	SDL_GL_STEREO             => 12,
	SDL_GL_MULTISAMPLEBUFFERS => 13,
	SDL_GL_MULTISAMPLESAMPLES => 14,
	SDL_GL_ACCELERATED_VISUAL => 15,
	SDL_GL_SWAP_CONTROL       => 16,
}; # SDL::Video/gl

1;

__END__

our @EXPORT=qw(
	SMPEG_ERROR
	SMPEG_PLAYING
	SMPEG_STOPPED
	SDL_SVG_FLAG_DIRECT
	SDL_SVG_FLAG_COMPOSITE
	SDL_SAMPLEFLAG_NONE
	SDL_SAMPLEFLAG_CANSEEK
	SDL_SAMPLEFLAG_EOF
	SDL_SAMPLEFLAG_ERROR
	SDL_SAMPLEFLAG_EAGAIN
);

use constant {
	SDL_HAS_64BIT_TYPE                                  => 1,
	SDL_AUDIO_DRIVER_DISK                               => 1,
	SDL_AUDIO_DRIVER_DUMMY                              => 1,
	SDL_AUDIO_DRIVER_DSOUND                             => 1,
	SDL_AUDIO_DRIVER_WAVEOUT                            => 1,
	SDL_CDROM_WIN32                                     => 1,
	SDL_JOYSTICK_WINMM                                  => 1,
	SDL_LOADSO_WIN32                                    => 1,
	SDL_THREAD_WIN32                                    => 1,
	SDL_TIMER_WIN32                                     => 1,
	SDL_VIDEO_DRIVER_DDRAW                              => 1,
	SDL_VIDEO_DRIVER_DUMMY                              => 1,
	SDL_VIDEO_DRIVER_WINDIB                             => 1,
	SDL_VIDEO_OPENGL                                    => 1,
	SDL_VIDEO_OPENGL_WGL                                => 1,
	SDL_VIDEO_DISABLE_SCREENSAVER                       => 1,
	SDL_ASSEMBLY_ROUTINES                               => 1,
	SDL_HERMES_BLITTERS                                 => 1,
	SDL_LIL_ENDIAN                                      => 1234,
	SDL_BIG_ENDIAN                                      => 4321,
};

use constant {
	FPS_UPPER_LIMIT                                     => 200,
	FPS_LOWER_LIMIT                                     => 1,
	FPS_DEFAULT                                         => 30,
	SDL_ALL_HOTKEYS                                     => 0xFFFFFFFF,
};

use constant {
	SDL_MUTEX_TIMEDOUT                                  => 1,
	NeedFunctionPrototypes                              => 1,
	SDLNET_MAX_UDPCHANNELS                              => 32,
	SDLNET_MAX_UDPADDRESSES                             => 4,
	WIN32_LEAN_AND_MEAN                                 => 1,
	GL_GLEXT_VERSION                                    => 29,
	GL_UNSIGNED_BYTE_3_3_2                              => 0x8032,
	GL_UNSIGNED_SHORT_4_4_4_4                           => 0x8033,
	GL_UNSIGNED_SHORT_5_5_5_1                           => 0x8034,
	GL_UNSIGNED_INT_8_8_8_8                             => 0x8035,
	GL_UNSIGNED_INT_10_10_10_2                          => 0x8036,
	GL_RESCALE_NORMAL                                   => 0x803A,
	GL_TEXTURE_BINDING_3D                               => 0x806A,
	GL_PACK_SKIP_IMAGES                                 => 0x806B,
	GL_PACK_IMAGE_HEIGHT                                => 0x806C,
	GL_UNPACK_SKIP_IMAGES                               => 0x806D,
	GL_UNPACK_IMAGE_HEIGHT                              => 0x806E,
	GL_TEXTURE_3D                                       => 0x806F,
	GL_PROXY_TEXTURE_3D                                 => 0x8070,
	GL_TEXTURE_DEPTH                                    => 0x8071,
	GL_TEXTURE_WRAP_R                                   => 0x8072,
	GL_MAX_3D_TEXTURE_SIZE                              => 0x8073,
	GL_UNSIGNED_BYTE_2_3_3_REV                          => 0x8362,
	GL_UNSIGNED_SHORT_5_6_5                             => 0x8363,
	GL_UNSIGNED_SHORT_5_6_5_REV                         => 0x8364,
	GL_UNSIGNED_SHORT_4_4_4_4_REV                       => 0x8365,
	GL_UNSIGNED_SHORT_1_5_5_5_REV                       => 0x8366,
	GL_UNSIGNED_INT_8_8_8_8_REV                         => 0x8367,
	GL_UNSIGNED_INT_2_10_10_10_REV                      => 0x8368,
	GL_BGR                                              => 0x80E0,
	GL_BGRA                                             => 0x80E1,
	GL_MAX_ELEMENTS_VERTICES                            => 0x80E8,
	GL_MAX_ELEMENTS_INDICES                             => 0x80E9,
	GL_CLAMP_TO_EDGE                                    => 0x812F,
	GL_TEXTURE_MIN_LOD                                  => 0x813A,
	GL_TEXTURE_MAX_LOD                                  => 0x813B,
	GL_TEXTURE_BASE_LEVEL                               => 0x813C,
	GL_TEXTURE_MAX_LEVEL                                => 0x813D,
	GL_LIGHT_MODEL_COLOR_CONTROL                        => 0x81F8,
	GL_SINGLE_COLOR                                     => 0x81F9,
	GL_SEPARATE_SPECULAR_COLOR                          => 0x81FA,
	GL_SMOOTH_POINT_SIZE_RANGE                          => 0x0B12,
	GL_SMOOTH_POINT_SIZE_GRANULARITY                    => 0x0B13,
	GL_SMOOTH_LINE_WIDTH_RANGE                          => 0x0B22,
	GL_SMOOTH_LINE_WIDTH_GRANULARITY                    => 0x0B23,
	GL_ALIASED_POINT_SIZE_RANGE                         => 0x846D,
	GL_ALIASED_LINE_WIDTH_RANGE                         => 0x846E,
	GL_CONSTANT_COLOR                                   => 0x8001,
	GL_ONE_MINUS_CONSTANT_COLOR                         => 0x8002,
	GL_CONSTANT_ALPHA                                   => 0x8003,
	GL_ONE_MINUS_CONSTANT_ALPHA                         => 0x8004,
	GL_BLEND_COLOR                                      => 0x8005,
	GL_FUNC_ADD                                         => 0x8006,
	GL_MIN                                              => 0x8007,
	GL_MAX                                              => 0x8008,
	GL_BLEND_EQUATION                                   => 0x8009,
	GL_FUNC_SUBTRACT                                    => 0x800A,
	GL_FUNC_REVERSE_SUBTRACT                            => 0x800B,
	GL_CONVOLUTION_1D                                   => 0x8010,
	GL_CONVOLUTION_2D                                   => 0x8011,
	GL_SEPARABLE_2D                                     => 0x8012,
	GL_CONVOLUTION_BORDER_MODE                          => 0x8013,
	GL_CONVOLUTION_FILTER_SCALE                         => 0x8014,
	GL_CONVOLUTION_FILTER_BIAS                          => 0x8015,
	GL_REDUCE                                           => 0x8016,
	GL_CONVOLUTION_FORMAT                               => 0x8017,
	GL_CONVOLUTION_WIDTH                                => 0x8018,
	GL_CONVOLUTION_HEIGHT                               => 0x8019,
	GL_MAX_CONVOLUTION_WIDTH                            => 0x801A,
	GL_MAX_CONVOLUTION_HEIGHT                           => 0x801B,
	GL_POST_CONVOLUTION_RED_SCALE                       => 0x801C,
	GL_POST_CONVOLUTION_GREEN_SCALE                     => 0x801D,
	GL_POST_CONVOLUTION_BLUE_SCALE                      => 0x801E,
	GL_POST_CONVOLUTION_ALPHA_SCALE                     => 0x801F,
	GL_POST_CONVOLUTION_RED_BIAS                        => 0x8020,
	GL_POST_CONVOLUTION_GREEN_BIAS                      => 0x8021,
	GL_POST_CONVOLUTION_BLUE_BIAS                       => 0x8022,
	GL_POST_CONVOLUTION_ALPHA_BIAS                      => 0x8023,
	GL_HISTOGRAM                                        => 0x8024,
	GL_PROXY_HISTOGRAM                                  => 0x8025,
	GL_HISTOGRAM_WIDTH                                  => 0x8026,
	GL_HISTOGRAM_FORMAT                                 => 0x8027,
	GL_HISTOGRAM_RED_SIZE                               => 0x8028,
	GL_HISTOGRAM_GREEN_SIZE                             => 0x8029,
	GL_HISTOGRAM_BLUE_SIZE                              => 0x802A,
	GL_HISTOGRAM_ALPHA_SIZE                             => 0x802B,
	GL_HISTOGRAM_LUMINANCE_SIZE                         => 0x802C,
	GL_HISTOGRAM_SINK                                   => 0x802D,
	GL_MINMAX                                           => 0x802E,
	GL_MINMAX_FORMAT                                    => 0x802F,
	GL_MINMAX_SINK                                      => 0x8030,
	GL_TABLE_TOO_LARGE                                  => 0x8031,
	GL_COLOR_MATRIX                                     => 0x80B1,
	GL_COLOR_MATRIX_STACK_DEPTH                         => 0x80B2,
	GL_MAX_COLOR_MATRIX_STACK_DEPTH                     => 0x80B3,
	GL_POST_COLOR_MATRIX_RED_SCALE                      => 0x80B4,
	GL_POST_COLOR_MATRIX_GREEN_SCALE                    => 0x80B5,
	GL_POST_COLOR_MATRIX_BLUE_SCALE                     => 0x80B6,
	GL_POST_COLOR_MATRIX_ALPHA_SCALE                    => 0x80B7,
	GL_POST_COLOR_MATRIX_RED_BIAS                       => 0x80B8,
	GL_POST_COLOR_MATRIX_GREEN_BIAS                     => 0x80B9,
	GL_POST_COLOR_MATRIX_BLUE_BIAS                      => 0x80BA,
	GL_POST_COLOR_MATRIX_ALPHA_BIAS                     => 0x80BB,
	GL_COLOR_TABLE                                      => 0x80D0,
	GL_POST_CONVOLUTION_COLOR_TABLE                     => 0x80D1,
	GL_POST_COLOR_MATRIX_COLOR_TABLE                    => 0x80D2,
	GL_PROXY_COLOR_TABLE                                => 0x80D3,
	GL_PROXY_POST_CONVOLUTION_COLOR_TABLE               => 0x80D4,
	GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE              => 0x80D5,
	GL_COLOR_TABLE_SCALE                                => 0x80D6,
	GL_COLOR_TABLE_BIAS                                 => 0x80D7,
	GL_COLOR_TABLE_FORMAT                               => 0x80D8,
	GL_COLOR_TABLE_WIDTH                                => 0x80D9,
	GL_COLOR_TABLE_RED_SIZE                             => 0x80DA,
	GL_COLOR_TABLE_GREEN_SIZE                           => 0x80DB,
	GL_COLOR_TABLE_BLUE_SIZE                            => 0x80DC,
	GL_COLOR_TABLE_ALPHA_SIZE                           => 0x80DD,
	GL_COLOR_TABLE_LUMINANCE_SIZE                       => 0x80DE,
	GL_COLOR_TABLE_INTENSITY_SIZE                       => 0x80DF,
	GL_CONSTANT_BORDER                                  => 0x8151,
	GL_REPLICATE_BORDER                                 => 0x8153,
	GL_CONVOLUTION_BORDER_COLOR                         => 0x8154,
	GL_TEXTURE0                                         => 0x84C0,
	GL_TEXTURE1                                         => 0x84C1,
	GL_TEXTURE2                                         => 0x84C2,
	GL_TEXTURE3                                         => 0x84C3,
	GL_TEXTURE4                                         => 0x84C4,
	GL_TEXTURE5                                         => 0x84C5,
	GL_TEXTURE6                                         => 0x84C6,
	GL_TEXTURE7                                         => 0x84C7,
	GL_TEXTURE8                                         => 0x84C8,
	GL_TEXTURE9                                         => 0x84C9,
	GL_TEXTURE10                                        => 0x84CA,
	GL_TEXTURE11                                        => 0x84CB,
	GL_TEXTURE12                                        => 0x84CC,
	GL_TEXTURE13                                        => 0x84CD,
	GL_TEXTURE14                                        => 0x84CE,
	GL_TEXTURE15                                        => 0x84CF,
	GL_TEXTURE16                                        => 0x84D0,
	GL_TEXTURE17                                        => 0x84D1,
	GL_TEXTURE18                                        => 0x84D2,
	GL_TEXTURE19                                        => 0x84D3,
	GL_TEXTURE20                                        => 0x84D4,
	GL_TEXTURE21                                        => 0x84D5,
	GL_TEXTURE22                                        => 0x84D6,
	GL_TEXTURE23                                        => 0x84D7,
	GL_TEXTURE24                                        => 0x84D8,
	GL_TEXTURE25                                        => 0x84D9,
	GL_TEXTURE26                                        => 0x84DA,
	GL_TEXTURE27                                        => 0x84DB,
	GL_TEXTURE28                                        => 0x84DC,
	GL_TEXTURE29                                        => 0x84DD,
	GL_TEXTURE30                                        => 0x84DE,
	GL_TEXTURE31                                        => 0x84DF,
	GL_ACTIVE_TEXTURE                                   => 0x84E0,
	GL_CLIENT_ACTIVE_TEXTURE                            => 0x84E1,
	GL_MAX_TEXTURE_UNITS                                => 0x84E2,
	GL_TRANSPOSE_MODELVIEW_MATRIX                       => 0x84E3,
	GL_TRANSPOSE_PROJECTION_MATRIX                      => 0x84E4,
	GL_TRANSPOSE_TEXTURE_MATRIX                         => 0x84E5,
	GL_TRANSPOSE_COLOR_MATRIX                           => 0x84E6,
	GL_MULTISAMPLE                                      => 0x809D,
	GL_SAMPLE_ALPHA_TO_COVERAGE                         => 0x809E,
	GL_SAMPLE_ALPHA_TO_ONE                              => 0x809F,
	GL_SAMPLE_COVERAGE                                  => 0x80A0,
	GL_SAMPLE_BUFFERS                                   => 0x80A8,
	GL_SAMPLES                                          => 0x80A9,
	GL_SAMPLE_COVERAGE_VALUE                            => 0x80AA,
	GL_SAMPLE_COVERAGE_INVERT                           => 0x80AB,
	GL_MULTISAMPLE_BIT                                  => 0x20000000,
	GL_NORMAL_MAP                                       => 0x8511,
	GL_REFLECTION_MAP                                   => 0x8512,
	GL_TEXTURE_CUBE_MAP                                 => 0x8513,
	GL_TEXTURE_BINDING_CUBE_MAP                         => 0x8514,
	GL_TEXTURE_CUBE_MAP_POSITIVE_X                      => 0x8515,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_X                      => 0x8516,
	GL_TEXTURE_CUBE_MAP_POSITIVE_Y                      => 0x8517,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_Y                      => 0x8518,
	GL_TEXTURE_CUBE_MAP_POSITIVE_Z                      => 0x8519,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_Z                      => 0x851A,
	GL_PROXY_TEXTURE_CUBE_MAP                           => 0x851B,
	GL_MAX_CUBE_MAP_TEXTURE_SIZE                        => 0x851C,
	GL_COMPRESSED_ALPHA                                 => 0x84E9,
	GL_COMPRESSED_LUMINANCE                             => 0x84EA,
	GL_COMPRESSED_LUMINANCE_ALPHA                       => 0x84EB,
	GL_COMPRESSED_INTENSITY                             => 0x84EC,
	GL_COMPRESSED_RGB                                   => 0x84ED,
	GL_COMPRESSED_RGBA                                  => 0x84EE,
	GL_TEXTURE_COMPRESSION_HINT                         => 0x84EF,
	GL_TEXTURE_COMPRESSED_IMAGE_SIZE                    => 0x86A0,
	GL_TEXTURE_COMPRESSED                               => 0x86A1,
	GL_NUM_COMPRESSED_TEXTURE_FORMATS                   => 0x86A2,
	GL_COMPRESSED_TEXTURE_FORMATS                       => 0x86A3,
	GL_CLAMP_TO_BORDER                                  => 0x812D,
	GL_COMBINE                                          => 0x8570,
	GL_COMBINE_RGB                                      => 0x8571,
	GL_COMBINE_ALPHA                                    => 0x8572,
	GL_SOURCE0_RGB                                      => 0x8580,
	GL_SOURCE1_RGB                                      => 0x8581,
	GL_SOURCE2_RGB                                      => 0x8582,
	GL_SOURCE0_ALPHA                                    => 0x8588,
	GL_SOURCE1_ALPHA                                    => 0x8589,
	GL_SOURCE2_ALPHA                                    => 0x858A,
	GL_OPERAND0_RGB                                     => 0x8590,
	GL_OPERAND1_RGB                                     => 0x8591,
	GL_OPERAND2_RGB                                     => 0x8592,
	GL_OPERAND0_ALPHA                                   => 0x8598,
	GL_OPERAND1_ALPHA                                   => 0x8599,
	GL_OPERAND2_ALPHA                                   => 0x859A,
	GL_RGB_SCALE                                        => 0x8573,
	GL_ADD_SIGNED                                       => 0x8574,
	GL_INTERPOLATE                                      => 0x8575,
	GL_SUBTRACT                                         => 0x84E7,
	GL_CONSTANT                                         => 0x8576,
	GL_PRIMARY_COLOR                                    => 0x8577,
	GL_PREVIOUS                                         => 0x8578,
	GL_DOT3_RGB                                         => 0x86AE,
	GL_DOT3_RGBA                                        => 0x86AF,
	GL_BLEND_DST_RGB                                    => 0x80C8,
	GL_BLEND_SRC_RGB                                    => 0x80C9,
	GL_BLEND_DST_ALPHA                                  => 0x80CA,
	GL_BLEND_SRC_ALPHA                                  => 0x80CB,
	GL_POINT_SIZE_MIN                                   => 0x8126,
	GL_POINT_SIZE_MAX                                   => 0x8127,
	GL_POINT_FADE_THRESHOLD_SIZE                        => 0x8128,
	GL_POINT_DISTANCE_ATTENUATION                       => 0x8129,
	GL_GENERATE_MIPMAP                                  => 0x8191,
	GL_GENERATE_MIPMAP_HINT                             => 0x8192,
	GL_DEPTH_COMPONENT16                                => 0x81A5,
	GL_DEPTH_COMPONENT24                                => 0x81A6,
	GL_DEPTH_COMPONENT32                                => 0x81A7,
	GL_MIRRORED_REPEAT                                  => 0x8370,
	GL_FOG_COORDINATE_SOURCE                            => 0x8450,
	GL_FOG_COORDINATE                                   => 0x8451,
	GL_FRAGMENT_DEPTH                                   => 0x8452,
	GL_CURRENT_FOG_COORDINATE                           => 0x8453,
	GL_FOG_COORDINATE_ARRAY_TYPE                        => 0x8454,
	GL_FOG_COORDINATE_ARRAY_STRIDE                      => 0x8455,
	GL_FOG_COORDINATE_ARRAY_POINTER                     => 0x8456,
	GL_FOG_COORDINATE_ARRAY                             => 0x8457,
	GL_COLOR_SUM                                        => 0x8458,
	GL_CURRENT_SECONDARY_COLOR                          => 0x8459,
	GL_SECONDARY_COLOR_ARRAY_SIZE                       => 0x845A,
	GL_SECONDARY_COLOR_ARRAY_TYPE                       => 0x845B,
	GL_SECONDARY_COLOR_ARRAY_STRIDE                     => 0x845C,
	GL_SECONDARY_COLOR_ARRAY_POINTER                    => 0x845D,
	GL_SECONDARY_COLOR_ARRAY                            => 0x845E,
	GL_MAX_TEXTURE_LOD_BIAS                             => 0x84FD,
	GL_TEXTURE_FILTER_CONTROL                           => 0x8500,
	GL_TEXTURE_LOD_BIAS                                 => 0x8501,
	GL_INCR_WRAP                                        => 0x8507,
	GL_DECR_WRAP                                        => 0x8508,
	GL_TEXTURE_DEPTH_SIZE                               => 0x884A,
	GL_DEPTH_TEXTURE_MODE                               => 0x884B,
	GL_TEXTURE_COMPARE_MODE                             => 0x884C,
	GL_TEXTURE_COMPARE_FUNC                             => 0x884D,
	GL_COMPARE_R_TO_TEXTURE                             => 0x884E,
	GL_BUFFER_SIZE                                      => 0x8764,
	GL_BUFFER_USAGE                                     => 0x8765,
	GL_QUERY_COUNTER_BITS                               => 0x8864,
	GL_CURRENT_QUERY                                    => 0x8865,
	GL_QUERY_RESULT                                     => 0x8866,
	GL_QUERY_RESULT_AVAILABLE                           => 0x8867,
	GL_ARRAY_BUFFER                                     => 0x8892,
	GL_ELEMENT_ARRAY_BUFFER                             => 0x8893,
	GL_ARRAY_BUFFER_BINDING                             => 0x8894,
	GL_ELEMENT_ARRAY_BUFFER_BINDING                     => 0x8895,
	GL_VERTEX_ARRAY_BUFFER_BINDING                      => 0x8896,
	GL_NORMAL_ARRAY_BUFFER_BINDING                      => 0x8897,
	GL_COLOR_ARRAY_BUFFER_BINDING                       => 0x8898,
	GL_INDEX_ARRAY_BUFFER_BINDING                       => 0x8899,
	GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING               => 0x889A,
	GL_EDGE_FLAG_ARRAY_BUFFER_BINDING                   => 0x889B,
	GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING             => 0x889C,
	GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING              => 0x889D,
	GL_WEIGHT_ARRAY_BUFFER_BINDING                      => 0x889E,
	GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING               => 0x889F,
	GL_READ_ONLY                                        => 0x88B8,
	GL_WRITE_ONLY                                       => 0x88B9,
	GL_READ_WRITE                                       => 0x88BA,
	GL_BUFFER_ACCESS                                    => 0x88BB,
	GL_BUFFER_MAPPED                                    => 0x88BC,
	GL_BUFFER_MAP_POINTER                               => 0x88BD,
	GL_STREAM_DRAW                                      => 0x88E0,
	GL_STREAM_READ                                      => 0x88E1,
	GL_STREAM_COPY                                      => 0x88E2,
	GL_STATIC_DRAW                                      => 0x88E4,
	GL_STATIC_READ                                      => 0x88E5,
	GL_STATIC_COPY                                      => 0x88E6,
	GL_DYNAMIC_DRAW                                     => 0x88E8,
	GL_DYNAMIC_READ                                     => 0x88E9,
	GL_DYNAMIC_COPY                                     => 0x88EA,
	GL_SAMPLES_PASSED                                   => 0x8914,
	GL_FOG_COORD_SRC                                    => 0x8450,
	GL_FOG_COORD                                        => 0x8451,
	GL_CURRENT_FOG_COORD                                => 0x8453,
	GL_FOG_COORD_ARRAY_TYPE                             => 0x8454,
	GL_FOG_COORD_ARRAY_STRIDE                           => 0x8455,
	GL_FOG_COORD_ARRAY_POINTER                          => 0x8456,
	GL_FOG_COORD_ARRAY                                  => 0x8457,
	GL_FOG_COORD_ARRAY_BUFFER_BINDING                   => 0x889D,
	GL_SRC0_RGB                                         => 0x8580,
	GL_SRC1_RGB                                         => 0x8581,
	GL_SRC2_RGB                                         => 0x8582,
	GL_SRC0_ALPHA                                       => 0x8588,
	GL_SRC1_ALPHA                                       => 0x8589,
	GL_SRC2_ALPHA                                       => 0x858A,
	GL_BLEND_EQUATION_RGB                               => 0x8009,
	GL_VERTEX_ATTRIB_ARRAY_ENABLED                      => 0x8622,
	GL_VERTEX_ATTRIB_ARRAY_SIZE                         => 0x8623,
	GL_VERTEX_ATTRIB_ARRAY_STRIDE                       => 0x8624,
	GL_VERTEX_ATTRIB_ARRAY_TYPE                         => 0x8625,
	GL_CURRENT_VERTEX_ATTRIB                            => 0x8626,
	GL_VERTEX_PROGRAM_POINT_SIZE                        => 0x8642,
	GL_VERTEX_PROGRAM_TWO_SIDE                          => 0x8643,
	GL_VERTEX_ATTRIB_ARRAY_POINTER                      => 0x8645,
	GL_STENCIL_BACK_FUNC                                => 0x8800,
	GL_STENCIL_BACK_FAIL                                => 0x8801,
	GL_STENCIL_BACK_PASS_DEPTH_FAIL                     => 0x8802,
	GL_STENCIL_BACK_PASS_DEPTH_PASS                     => 0x8803,
	GL_MAX_DRAW_BUFFERS                                 => 0x8824,
	GL_DRAW_BUFFER0                                     => 0x8825,
	GL_DRAW_BUFFER1                                     => 0x8826,
	GL_DRAW_BUFFER2                                     => 0x8827,
	GL_DRAW_BUFFER3                                     => 0x8828,
	GL_DRAW_BUFFER4                                     => 0x8829,
	GL_DRAW_BUFFER5                                     => 0x882A,
	GL_DRAW_BUFFER6                                     => 0x882B,
	GL_DRAW_BUFFER7                                     => 0x882C,
	GL_DRAW_BUFFER8                                     => 0x882D,
	GL_DRAW_BUFFER9                                     => 0x882E,
	GL_DRAW_BUFFER10                                    => 0x882F,
	GL_DRAW_BUFFER11                                    => 0x8830,
	GL_DRAW_BUFFER12                                    => 0x8831,
	GL_DRAW_BUFFER13                                    => 0x8832,
	GL_DRAW_BUFFER14                                    => 0x8833,
	GL_DRAW_BUFFER15                                    => 0x8834,
	GL_BLEND_EQUATION_ALPHA                             => 0x883D,
	GL_POINT_SPRITE                                     => 0x8861,
	GL_COORD_REPLACE                                    => 0x8862,
	GL_MAX_VERTEX_ATTRIBS                               => 0x8869,
	GL_VERTEX_ATTRIB_ARRAY_NORMALIZED                   => 0x886A,
	GL_MAX_TEXTURE_COORDS                               => 0x8871,
	GL_MAX_TEXTURE_IMAGE_UNITS                          => 0x8872,
	GL_FRAGMENT_SHADER                                  => 0x8B30,
	GL_VERTEX_SHADER                                    => 0x8B31,
	GL_MAX_FRAGMENT_UNIFORM_COMPONENTS                  => 0x8B49,
	GL_MAX_VERTEX_UNIFORM_COMPONENTS                    => 0x8B4A,
	GL_MAX_VARYING_FLOATS                               => 0x8B4B,
	GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS                   => 0x8B4C,
	GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS                 => 0x8B4D,
	GL_SHADER_TYPE                                      => 0x8B4F,
	GL_FLOAT_VEC2                                       => 0x8B50,
	GL_FLOAT_VEC3                                       => 0x8B51,
	GL_FLOAT_VEC4                                       => 0x8B52,
	GL_INT_VEC2                                         => 0x8B53,
	GL_INT_VEC3                                         => 0x8B54,
	GL_INT_VEC4                                         => 0x8B55,
	GL_BOOL                                             => 0x8B56,
	GL_BOOL_VEC2                                        => 0x8B57,
	GL_BOOL_VEC3                                        => 0x8B58,
	GL_BOOL_VEC4                                        => 0x8B59,
	GL_FLOAT_MAT2                                       => 0x8B5A,
	GL_FLOAT_MAT3                                       => 0x8B5B,
	GL_FLOAT_MAT4                                       => 0x8B5C,
	GL_SAMPLER_1D                                       => 0x8B5D,
	GL_SAMPLER_2D                                       => 0x8B5E,
	GL_SAMPLER_3D                                       => 0x8B5F,
	GL_SAMPLER_CUBE                                     => 0x8B60,
	GL_SAMPLER_1D_SHADOW                                => 0x8B61,
	GL_SAMPLER_2D_SHADOW                                => 0x8B62,
	GL_DELETE_STATUS                                    => 0x8B80,
	GL_COMPILE_STATUS                                   => 0x8B81,
	GL_LINK_STATUS                                      => 0x8B82,
	GL_VALIDATE_STATUS                                  => 0x8B83,
	GL_INFO_LOG_LENGTH                                  => 0x8B84,
	GL_ATTACHED_SHADERS                                 => 0x8B85,
	GL_ACTIVE_UNIFORMS                                  => 0x8B86,
	GL_ACTIVE_UNIFORM_MAX_LENGTH                        => 0x8B87,
	GL_SHADER_SOURCE_LENGTH                             => 0x8B88,
	GL_ACTIVE_ATTRIBUTES                                => 0x8B89,
	GL_ACTIVE_ATTRIBUTE_MAX_LENGTH                      => 0x8B8A,
	GL_FRAGMENT_SHADER_DERIVATIVE_HINT                  => 0x8B8B,
	GL_SHADING_LANGUAGE_VERSION                         => 0x8B8C,
	GL_CURRENT_PROGRAM                                  => 0x8B8D,
	GL_POINT_SPRITE_COORD_ORIGIN                        => 0x8CA0,
	GL_LOWER_LEFT                                       => 0x8CA1,
	GL_UPPER_LEFT                                       => 0x8CA2,
	GL_STENCIL_BACK_REF                                 => 0x8CA3,
	GL_STENCIL_BACK_VALUE_MASK                          => 0x8CA4,
	GL_STENCIL_BACK_WRITEMASK                           => 0x8CA5,
	GL_TEXTURE0_ARB                                     => 0x84C0,
	GL_TEXTURE1_ARB                                     => 0x84C1,
	GL_TEXTURE2_ARB                                     => 0x84C2,
	GL_TEXTURE3_ARB                                     => 0x84C3,
	GL_TEXTURE4_ARB                                     => 0x84C4,
	GL_TEXTURE5_ARB                                     => 0x84C5,
	GL_TEXTURE6_ARB                                     => 0x84C6,
	GL_TEXTURE7_ARB                                     => 0x84C7,
	GL_TEXTURE8_ARB                                     => 0x84C8,
	GL_TEXTURE9_ARB                                     => 0x84C9,
	GL_TEXTURE10_ARB                                    => 0x84CA,
	GL_TEXTURE11_ARB                                    => 0x84CB,
	GL_TEXTURE12_ARB                                    => 0x84CC,
	GL_TEXTURE13_ARB                                    => 0x84CD,
	GL_TEXTURE14_ARB                                    => 0x84CE,
	GL_TEXTURE15_ARB                                    => 0x84CF,
	GL_TEXTURE16_ARB                                    => 0x84D0,
	GL_TEXTURE17_ARB                                    => 0x84D1,
	GL_TEXTURE18_ARB                                    => 0x84D2,
	GL_TEXTURE19_ARB                                    => 0x84D3,
	GL_TEXTURE20_ARB                                    => 0x84D4,
	GL_TEXTURE21_ARB                                    => 0x84D5,
	GL_TEXTURE22_ARB                                    => 0x84D6,
	GL_TEXTURE23_ARB                                    => 0x84D7,
	GL_TEXTURE24_ARB                                    => 0x84D8,
	GL_TEXTURE25_ARB                                    => 0x84D9,
	GL_TEXTURE26_ARB                                    => 0x84DA,
	GL_TEXTURE27_ARB                                    => 0x84DB,
	GL_TEXTURE28_ARB                                    => 0x84DC,
	GL_TEXTURE29_ARB                                    => 0x84DD,
	GL_TEXTURE30_ARB                                    => 0x84DE,
	GL_TEXTURE31_ARB                                    => 0x84DF,
	GL_ACTIVE_TEXTURE_ARB                               => 0x84E0,
	GL_CLIENT_ACTIVE_TEXTURE_ARB                        => 0x84E1,
	GL_MAX_TEXTURE_UNITS_ARB                            => 0x84E2,
	GL_TRANSPOSE_MODELVIEW_MATRIX_ARB                   => 0x84E3,
	GL_TRANSPOSE_PROJECTION_MATRIX_ARB                  => 0x84E4,
	GL_TRANSPOSE_TEXTURE_MATRIX_ARB                     => 0x84E5,
	GL_TRANSPOSE_COLOR_MATRIX_ARB                       => 0x84E6,
	GL_MULTISAMPLE_ARB                                  => 0x809D,
	GL_SAMPLE_ALPHA_TO_COVERAGE_ARB                     => 0x809E,
	GL_SAMPLE_ALPHA_TO_ONE_ARB                          => 0x809F,
	GL_SAMPLE_COVERAGE_ARB                              => 0x80A0,
	GL_SAMPLE_BUFFERS_ARB                               => 0x80A8,
	GL_SAMPLES_ARB                                      => 0x80A9,
	GL_SAMPLE_COVERAGE_VALUE_ARB                        => 0x80AA,
	GL_SAMPLE_COVERAGE_INVERT_ARB                       => 0x80AB,
	GL_MULTISAMPLE_BIT_ARB                              => 0x20000000,
	GL_NORMAL_MAP_ARB                                   => 0x8511,
	GL_REFLECTION_MAP_ARB                               => 0x8512,
	GL_TEXTURE_CUBE_MAP_ARB                             => 0x8513,
	GL_TEXTURE_BINDING_CUBE_MAP_ARB                     => 0x8514,
	GL_TEXTURE_CUBE_MAP_POSITIVE_X_ARB                  => 0x8515,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_X_ARB                  => 0x8516,
	GL_TEXTURE_CUBE_MAP_POSITIVE_Y_ARB                  => 0x8517,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_ARB                  => 0x8518,
	GL_TEXTURE_CUBE_MAP_POSITIVE_Z_ARB                  => 0x8519,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_ARB                  => 0x851A,
	GL_PROXY_TEXTURE_CUBE_MAP_ARB                       => 0x851B,
	GL_MAX_CUBE_MAP_TEXTURE_SIZE_ARB                    => 0x851C,
	GL_COMPRESSED_ALPHA_ARB                             => 0x84E9,
	GL_COMPRESSED_LUMINANCE_ARB                         => 0x84EA,
	GL_COMPRESSED_LUMINANCE_ALPHA_ARB                   => 0x84EB,
	GL_COMPRESSED_INTENSITY_ARB                         => 0x84EC,
	GL_COMPRESSED_RGB_ARB                               => 0x84ED,
	GL_COMPRESSED_RGBA_ARB                              => 0x84EE,
	GL_TEXTURE_COMPRESSION_HINT_ARB                     => 0x84EF,
	GL_TEXTURE_COMPRESSED_IMAGE_SIZE_ARB                => 0x86A0,
	GL_TEXTURE_COMPRESSED_ARB                           => 0x86A1,
	GL_NUM_COMPRESSED_TEXTURE_FORMATS_ARB               => 0x86A2,
	GL_COMPRESSED_TEXTURE_FORMATS_ARB                   => 0x86A3,
	GL_CLAMP_TO_BORDER_ARB                              => 0x812D,
	GL_POINT_SIZE_MIN_ARB                               => 0x8126,
	GL_POINT_SIZE_MAX_ARB                               => 0x8127,
	GL_POINT_FADE_THRESHOLD_SIZE_ARB                    => 0x8128,
	GL_POINT_DISTANCE_ATTENUATION_ARB                   => 0x8129,
	GL_MAX_VERTEX_UNITS_ARB                             => 0x86A4,
	GL_ACTIVE_VERTEX_UNITS_ARB                          => 0x86A5,
	GL_WEIGHT_SUM_UNITY_ARB                             => 0x86A6,
	GL_VERTEX_BLEND_ARB                                 => 0x86A7,
	GL_CURRENT_WEIGHT_ARB                               => 0x86A8,
	GL_WEIGHT_ARRAY_TYPE_ARB                            => 0x86A9,
	GL_WEIGHT_ARRAY_STRIDE_ARB                          => 0x86AA,
	GL_WEIGHT_ARRAY_SIZE_ARB                            => 0x86AB,
	GL_WEIGHT_ARRAY_POINTER_ARB                         => 0x86AC,
	GL_WEIGHT_ARRAY_ARB                                 => 0x86AD,
	GL_MODELVIEW0_ARB                                   => 0x1700,
	GL_MODELVIEW1_ARB                                   => 0x850A,
	GL_MODELVIEW2_ARB                                   => 0x8722,
	GL_MODELVIEW3_ARB                                   => 0x8723,
	GL_MODELVIEW4_ARB                                   => 0x8724,
	GL_MODELVIEW5_ARB                                   => 0x8725,
	GL_MODELVIEW6_ARB                                   => 0x8726,
	GL_MODELVIEW7_ARB                                   => 0x8727,
	GL_MODELVIEW8_ARB                                   => 0x8728,
	GL_MODELVIEW9_ARB                                   => 0x8729,
	GL_MODELVIEW10_ARB                                  => 0x872A,
	GL_MODELVIEW11_ARB                                  => 0x872B,
	GL_MODELVIEW12_ARB                                  => 0x872C,
	GL_MODELVIEW13_ARB                                  => 0x872D,
	GL_MODELVIEW14_ARB                                  => 0x872E,
	GL_MODELVIEW15_ARB                                  => 0x872F,
	GL_MODELVIEW16_ARB                                  => 0x8730,
	GL_MODELVIEW17_ARB                                  => 0x8731,
	GL_MODELVIEW18_ARB                                  => 0x8732,
	GL_MODELVIEW19_ARB                                  => 0x8733,
	GL_MODELVIEW20_ARB                                  => 0x8734,
	GL_MODELVIEW21_ARB                                  => 0x8735,
	GL_MODELVIEW22_ARB                                  => 0x8736,
	GL_MODELVIEW23_ARB                                  => 0x8737,
	GL_MODELVIEW24_ARB                                  => 0x8738,
	GL_MODELVIEW25_ARB                                  => 0x8739,
	GL_MODELVIEW26_ARB                                  => 0x873A,
	GL_MODELVIEW27_ARB                                  => 0x873B,
	GL_MODELVIEW28_ARB                                  => 0x873C,
	GL_MODELVIEW29_ARB                                  => 0x873D,
	GL_MODELVIEW30_ARB                                  => 0x873E,
	GL_MODELVIEW31_ARB                                  => 0x873F,
	GL_MATRIX_PALETTE_ARB                               => 0x8840,
	GL_MAX_MATRIX_PALETTE_STACK_DEPTH_ARB               => 0x8841,
	GL_MAX_PALETTE_MATRICES_ARB                         => 0x8842,
	GL_CURRENT_PALETTE_MATRIX_ARB                       => 0x8843,
	GL_MATRIX_INDEX_ARRAY_ARB                           => 0x8844,
	GL_CURRENT_MATRIX_INDEX_ARB                         => 0x8845,
	GL_MATRIX_INDEX_ARRAY_SIZE_ARB                      => 0x8846,
	GL_MATRIX_INDEX_ARRAY_TYPE_ARB                      => 0x8847,
	GL_MATRIX_INDEX_ARRAY_STRIDE_ARB                    => 0x8848,
	GL_MATRIX_INDEX_ARRAY_POINTER_ARB                   => 0x8849,
	GL_COMBINE_ARB                                      => 0x8570,
	GL_COMBINE_RGB_ARB                                  => 0x8571,
	GL_COMBINE_ALPHA_ARB                                => 0x8572,
	GL_SOURCE0_RGB_ARB                                  => 0x8580,
	GL_SOURCE1_RGB_ARB                                  => 0x8581,
	GL_SOURCE2_RGB_ARB                                  => 0x8582,
	GL_SOURCE0_ALPHA_ARB                                => 0x8588,
	GL_SOURCE1_ALPHA_ARB                                => 0x8589,
	GL_SOURCE2_ALPHA_ARB                                => 0x858A,
	GL_OPERAND0_RGB_ARB                                 => 0x8590,
	GL_OPERAND1_RGB_ARB                                 => 0x8591,
	GL_OPERAND2_RGB_ARB                                 => 0x8592,
	GL_OPERAND0_ALPHA_ARB                               => 0x8598,
	GL_OPERAND1_ALPHA_ARB                               => 0x8599,
	GL_OPERAND2_ALPHA_ARB                               => 0x859A,
	GL_RGB_SCALE_ARB                                    => 0x8573,
	GL_ADD_SIGNED_ARB                                   => 0x8574,
	GL_INTERPOLATE_ARB                                  => 0x8575,
	GL_SUBTRACT_ARB                                     => 0x84E7,
	GL_CONSTANT_ARB                                     => 0x8576,
	GL_PRIMARY_COLOR_ARB                                => 0x8577,
	GL_PREVIOUS_ARB                                     => 0x8578,
	GL_DOT3_RGB_ARB                                     => 0x86AE,
	GL_DOT3_RGBA_ARB                                    => 0x86AF,
	GL_MIRRORED_REPEAT_ARB                              => 0x8370,
	GL_DEPTH_COMPONENT16_ARB                            => 0x81A5,
	GL_DEPTH_COMPONENT24_ARB                            => 0x81A6,
	GL_DEPTH_COMPONENT32_ARB                            => 0x81A7,
	GL_TEXTURE_DEPTH_SIZE_ARB                           => 0x884A,
	GL_DEPTH_TEXTURE_MODE_ARB                           => 0x884B,
	GL_TEXTURE_COMPARE_MODE_ARB                         => 0x884C,
	GL_TEXTURE_COMPARE_FUNC_ARB                         => 0x884D,
	GL_COMPARE_R_TO_TEXTURE_ARB                         => 0x884E,
	GL_TEXTURE_COMPARE_FAIL_VALUE_ARB                   => 0x80BF,
	GL_COLOR_SUM_ARB                                    => 0x8458,
	GL_VERTEX_PROGRAM_ARB                               => 0x8620,
	GL_VERTEX_ATTRIB_ARRAY_ENABLED_ARB                  => 0x8622,
	GL_VERTEX_ATTRIB_ARRAY_SIZE_ARB                     => 0x8623,
	GL_VERTEX_ATTRIB_ARRAY_STRIDE_ARB                   => 0x8624,
	GL_VERTEX_ATTRIB_ARRAY_TYPE_ARB                     => 0x8625,
	GL_CURRENT_VERTEX_ATTRIB_ARB                        => 0x8626,
	GL_PROGRAM_LENGTH_ARB                               => 0x8627,
	GL_PROGRAM_STRING_ARB                               => 0x8628,
	GL_MAX_PROGRAM_MATRIX_STACK_DEPTH_ARB               => 0x862E,
	GL_MAX_PROGRAM_MATRICES_ARB                         => 0x862F,
	GL_CURRENT_MATRIX_STACK_DEPTH_ARB                   => 0x8640,
	GL_CURRENT_MATRIX_ARB                               => 0x8641,
	GL_VERTEX_PROGRAM_POINT_SIZE_ARB                    => 0x8642,
	GL_VERTEX_PROGRAM_TWO_SIDE_ARB                      => 0x8643,
	GL_VERTEX_ATTRIB_ARRAY_POINTER_ARB                  => 0x8645,
	GL_PROGRAM_ERROR_POSITION_ARB                       => 0x864B,
	GL_PROGRAM_BINDING_ARB                              => 0x8677,
	GL_MAX_VERTEX_ATTRIBS_ARB                           => 0x8869,
	GL_VERTEX_ATTRIB_ARRAY_NORMALIZED_ARB               => 0x886A,
	GL_PROGRAM_ERROR_STRING_ARB                         => 0x8874,
	GL_PROGRAM_FORMAT_ASCII_ARB                         => 0x8875,
	GL_PROGRAM_FORMAT_ARB                               => 0x8876,
	GL_PROGRAM_INSTRUCTIONS_ARB                         => 0x88A0,
	GL_MAX_PROGRAM_INSTRUCTIONS_ARB                     => 0x88A1,
	GL_PROGRAM_NATIVE_INSTRUCTIONS_ARB                  => 0x88A2,
	GL_MAX_PROGRAM_NATIVE_INSTRUCTIONS_ARB              => 0x88A3,
	GL_PROGRAM_TEMPORARIES_ARB                          => 0x88A4,
	GL_MAX_PROGRAM_TEMPORARIES_ARB                      => 0x88A5,
	GL_PROGRAM_NATIVE_TEMPORARIES_ARB                   => 0x88A6,
	GL_MAX_PROGRAM_NATIVE_TEMPORARIES_ARB               => 0x88A7,
	GL_PROGRAM_PARAMETERS_ARB                           => 0x88A8,
	GL_MAX_PROGRAM_PARAMETERS_ARB                       => 0x88A9,
	GL_PROGRAM_NATIVE_PARAMETERS_ARB                    => 0x88AA,
	GL_MAX_PROGRAM_NATIVE_PARAMETERS_ARB                => 0x88AB,
	GL_PROGRAM_ATTRIBS_ARB                              => 0x88AC,
	GL_MAX_PROGRAM_ATTRIBS_ARB                          => 0x88AD,
	GL_PROGRAM_NATIVE_ATTRIBS_ARB                       => 0x88AE,
	GL_MAX_PROGRAM_NATIVE_ATTRIBS_ARB                   => 0x88AF,
	GL_PROGRAM_ADDRESS_REGISTERS_ARB                    => 0x88B0,
	GL_MAX_PROGRAM_ADDRESS_REGISTERS_ARB                => 0x88B1,
	GL_PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB             => 0x88B2,
	GL_MAX_PROGRAM_NATIVE_ADDRESS_REGISTERS_ARB         => 0x88B3,
	GL_MAX_PROGRAM_LOCAL_PARAMETERS_ARB                 => 0x88B4,
	GL_MAX_PROGRAM_ENV_PARAMETERS_ARB                   => 0x88B5,
	GL_PROGRAM_UNDER_NATIVE_LIMITS_ARB                  => 0x88B6,
	GL_TRANSPOSE_CURRENT_MATRIX_ARB                     => 0x88B7,
	GL_MATRIX0_ARB                                      => 0x88C0,
	GL_MATRIX1_ARB                                      => 0x88C1,
	GL_MATRIX2_ARB                                      => 0x88C2,
	GL_MATRIX3_ARB                                      => 0x88C3,
	GL_MATRIX4_ARB                                      => 0x88C4,
	GL_MATRIX5_ARB                                      => 0x88C5,
	GL_MATRIX6_ARB                                      => 0x88C6,
	GL_MATRIX7_ARB                                      => 0x88C7,
	GL_MATRIX8_ARB                                      => 0x88C8,
	GL_MATRIX9_ARB                                      => 0x88C9,
	GL_MATRIX10_ARB                                     => 0x88CA,
	GL_MATRIX11_ARB                                     => 0x88CB,
	GL_MATRIX12_ARB                                     => 0x88CC,
	GL_MATRIX13_ARB                                     => 0x88CD,
	GL_MATRIX14_ARB                                     => 0x88CE,
	GL_MATRIX15_ARB                                     => 0x88CF,
	GL_MATRIX16_ARB                                     => 0x88D0,
	GL_MATRIX17_ARB                                     => 0x88D1,
	GL_MATRIX18_ARB                                     => 0x88D2,
	GL_MATRIX19_ARB                                     => 0x88D3,
	GL_MATRIX20_ARB                                     => 0x88D4,
	GL_MATRIX21_ARB                                     => 0x88D5,
	GL_MATRIX22_ARB                                     => 0x88D6,
	GL_MATRIX23_ARB                                     => 0x88D7,
	GL_MATRIX24_ARB                                     => 0x88D8,
	GL_MATRIX25_ARB                                     => 0x88D9,
	GL_MATRIX26_ARB                                     => 0x88DA,
	GL_MATRIX27_ARB                                     => 0x88DB,
	GL_MATRIX28_ARB                                     => 0x88DC,
	GL_MATRIX29_ARB                                     => 0x88DD,
	GL_MATRIX30_ARB                                     => 0x88DE,
	GL_MATRIX31_ARB                                     => 0x88DF,
	GL_FRAGMENT_PROGRAM_ARB                             => 0x8804,
	GL_PROGRAM_ALU_INSTRUCTIONS_ARB                     => 0x8805,
	GL_PROGRAM_TEX_INSTRUCTIONS_ARB                     => 0x8806,
	GL_PROGRAM_TEX_INDIRECTIONS_ARB                     => 0x8807,
	GL_PROGRAM_NATIVE_ALU_INSTRUCTIONS_ARB              => 0x8808,
	GL_PROGRAM_NATIVE_TEX_INSTRUCTIONS_ARB              => 0x8809,
	GL_PROGRAM_NATIVE_TEX_INDIRECTIONS_ARB              => 0x880A,
	GL_MAX_PROGRAM_ALU_INSTRUCTIONS_ARB                 => 0x880B,
	GL_MAX_PROGRAM_TEX_INSTRUCTIONS_ARB                 => 0x880C,
	GL_MAX_PROGRAM_TEX_INDIRECTIONS_ARB                 => 0x880D,
	GL_MAX_PROGRAM_NATIVE_ALU_INSTRUCTIONS_ARB          => 0x880E,
	GL_MAX_PROGRAM_NATIVE_TEX_INSTRUCTIONS_ARB          => 0x880F,
	GL_MAX_PROGRAM_NATIVE_TEX_INDIRECTIONS_ARB          => 0x8810,
	GL_MAX_TEXTURE_COORDS_ARB                           => 0x8871,
	GL_MAX_TEXTURE_IMAGE_UNITS_ARB                      => 0x8872,
	GL_BUFFER_SIZE_ARB                                  => 0x8764,
	GL_BUFFER_USAGE_ARB                                 => 0x8765,
	GL_ARRAY_BUFFER_ARB                                 => 0x8892,
	GL_ELEMENT_ARRAY_BUFFER_ARB                         => 0x8893,
	GL_ARRAY_BUFFER_BINDING_ARB                         => 0x8894,
	GL_ELEMENT_ARRAY_BUFFER_BINDING_ARB                 => 0x8895,
	GL_VERTEX_ARRAY_BUFFER_BINDING_ARB                  => 0x8896,
	GL_NORMAL_ARRAY_BUFFER_BINDING_ARB                  => 0x8897,
	GL_COLOR_ARRAY_BUFFER_BINDING_ARB                   => 0x8898,
	GL_INDEX_ARRAY_BUFFER_BINDING_ARB                   => 0x8899,
	GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING_ARB           => 0x889A,
	GL_EDGE_FLAG_ARRAY_BUFFER_BINDING_ARB               => 0x889B,
	GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING_ARB         => 0x889C,
	GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING_ARB          => 0x889D,
	GL_WEIGHT_ARRAY_BUFFER_BINDING_ARB                  => 0x889E,
	GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING_ARB           => 0x889F,
	GL_READ_ONLY_ARB                                    => 0x88B8,
	GL_WRITE_ONLY_ARB                                   => 0x88B9,
	GL_READ_WRITE_ARB                                   => 0x88BA,
	GL_BUFFER_ACCESS_ARB                                => 0x88BB,
	GL_BUFFER_MAPPED_ARB                                => 0x88BC,
	GL_BUFFER_MAP_POINTER_ARB                           => 0x88BD,
	GL_STREAM_DRAW_ARB                                  => 0x88E0,
	GL_STREAM_READ_ARB                                  => 0x88E1,
	GL_STREAM_COPY_ARB                                  => 0x88E2,
	GL_STATIC_DRAW_ARB                                  => 0x88E4,
	GL_STATIC_READ_ARB                                  => 0x88E5,
	GL_STATIC_COPY_ARB                                  => 0x88E6,
	GL_DYNAMIC_DRAW_ARB                                 => 0x88E8,
	GL_DYNAMIC_READ_ARB                                 => 0x88E9,
	GL_DYNAMIC_COPY_ARB                                 => 0x88EA,
	GL_QUERY_COUNTER_BITS_ARB                           => 0x8864,
	GL_CURRENT_QUERY_ARB                                => 0x8865,
	GL_QUERY_RESULT_ARB                                 => 0x8866,
	GL_QUERY_RESULT_AVAILABLE_ARB                       => 0x8867,
	GL_SAMPLES_PASSED_ARB                               => 0x8914,
	GL_PROGRAM_OBJECT_ARB                               => 0x8B40,
	GL_SHADER_OBJECT_ARB                                => 0x8B48,
	GL_OBJECT_TYPE_ARB                                  => 0x8B4E,
	GL_OBJECT_SUBTYPE_ARB                               => 0x8B4F,
	GL_FLOAT_VEC2_ARB                                   => 0x8B50,
	GL_FLOAT_VEC3_ARB                                   => 0x8B51,
	GL_FLOAT_VEC4_ARB                                   => 0x8B52,
	GL_INT_VEC2_ARB                                     => 0x8B53,
	GL_INT_VEC3_ARB                                     => 0x8B54,
	GL_INT_VEC4_ARB                                     => 0x8B55,
	GL_BOOL_ARB                                         => 0x8B56,
	GL_BOOL_VEC2_ARB                                    => 0x8B57,
	GL_BOOL_VEC3_ARB                                    => 0x8B58,
	GL_BOOL_VEC4_ARB                                    => 0x8B59,
	GL_FLOAT_MAT2_ARB                                   => 0x8B5A,
	GL_FLOAT_MAT3_ARB                                   => 0x8B5B,
	GL_FLOAT_MAT4_ARB                                   => 0x8B5C,
	GL_SAMPLER_1D_ARB                                   => 0x8B5D,
	GL_SAMPLER_2D_ARB                                   => 0x8B5E,
	GL_SAMPLER_3D_ARB                                   => 0x8B5F,
	GL_SAMPLER_CUBE_ARB                                 => 0x8B60,
	GL_SAMPLER_1D_SHADOW_ARB                            => 0x8B61,
	GL_SAMPLER_2D_SHADOW_ARB                            => 0x8B62,
	GL_SAMPLER_2D_RECT_ARB                              => 0x8B63,
	GL_SAMPLER_2D_RECT_SHADOW_ARB                       => 0x8B64,
	GL_OBJECT_DELETE_STATUS_ARB                         => 0x8B80,
	GL_OBJECT_COMPILE_STATUS_ARB                        => 0x8B81,
	GL_OBJECT_LINK_STATUS_ARB                           => 0x8B82,
	GL_OBJECT_VALIDATE_STATUS_ARB                       => 0x8B83,
	GL_OBJECT_INFO_LOG_LENGTH_ARB                       => 0x8B84,
	GL_OBJECT_ATTACHED_OBJECTS_ARB                      => 0x8B85,
	GL_OBJECT_ACTIVE_UNIFORMS_ARB                       => 0x8B86,
	GL_OBJECT_ACTIVE_UNIFORM_MAX_LENGTH_ARB             => 0x8B87,
	GL_OBJECT_SHADER_SOURCE_LENGTH_ARB                  => 0x8B88,
	GL_VERTEX_SHADER_ARB                                => 0x8B31,
	GL_MAX_VERTEX_UNIFORM_COMPONENTS_ARB                => 0x8B4A,
	GL_MAX_VARYING_FLOATS_ARB                           => 0x8B4B,
	GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS_ARB               => 0x8B4C,
	GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS_ARB             => 0x8B4D,
	GL_OBJECT_ACTIVE_ATTRIBUTES_ARB                     => 0x8B89,
	GL_OBJECT_ACTIVE_ATTRIBUTE_MAX_LENGTH_ARB           => 0x8B8A,
	GL_FRAGMENT_SHADER_ARB                              => 0x8B30,
	GL_MAX_FRAGMENT_UNIFORM_COMPONENTS_ARB              => 0x8B49,
	GL_FRAGMENT_SHADER_DERIVATIVE_HINT_ARB              => 0x8B8B,
	GL_SHADING_LANGUAGE_VERSION_ARB                     => 0x8B8C,
	GL_POINT_SPRITE_ARB                                 => 0x8861,
	GL_COORD_REPLACE_ARB                                => 0x8862,
	GL_MAX_DRAW_BUFFERS_ARB                             => 0x8824,
	GL_DRAW_BUFFER0_ARB                                 => 0x8825,
	GL_DRAW_BUFFER1_ARB                                 => 0x8826,
	GL_DRAW_BUFFER2_ARB                                 => 0x8827,
	GL_DRAW_BUFFER3_ARB                                 => 0x8828,
	GL_DRAW_BUFFER4_ARB                                 => 0x8829,
	GL_DRAW_BUFFER5_ARB                                 => 0x882A,
	GL_DRAW_BUFFER6_ARB                                 => 0x882B,
	GL_DRAW_BUFFER7_ARB                                 => 0x882C,
	GL_DRAW_BUFFER8_ARB                                 => 0x882D,
	GL_DRAW_BUFFER9_ARB                                 => 0x882E,
	GL_DRAW_BUFFER10_ARB                                => 0x882F,
	GL_DRAW_BUFFER11_ARB                                => 0x8830,
	GL_DRAW_BUFFER12_ARB                                => 0x8831,
	GL_DRAW_BUFFER13_ARB                                => 0x8832,
	GL_DRAW_BUFFER14_ARB                                => 0x8833,
	GL_DRAW_BUFFER15_ARB                                => 0x8834,
	GL_TEXTURE_RECTANGLE_ARB                            => 0x84F5,
	GL_TEXTURE_BINDING_RECTANGLE_ARB                    => 0x84F6,
	GL_PROXY_TEXTURE_RECTANGLE_ARB                      => 0x84F7,
	GL_MAX_RECTANGLE_TEXTURE_SIZE_ARB                   => 0x84F8,
	GL_RGBA_FLOAT_MODE_ARB                              => 0x8820,
	GL_CLAMP_VERTEX_COLOR_ARB                           => 0x891A,
	GL_CLAMP_FRAGMENT_COLOR_ARB                         => 0x891B,
	GL_CLAMP_READ_COLOR_ARB                             => 0x891C,
	GL_FIXED_ONLY_ARB                                   => 0x891D,
	GL_HALF_FLOAT_ARB                                   => 0x140B,
	GL_TEXTURE_RED_TYPE_ARB                             => 0x8C10,
	GL_TEXTURE_GREEN_TYPE_ARB                           => 0x8C11,
	GL_TEXTURE_BLUE_TYPE_ARB                            => 0x8C12,
	GL_TEXTURE_ALPHA_TYPE_ARB                           => 0x8C13,
	GL_TEXTURE_LUMINANCE_TYPE_ARB                       => 0x8C14,
	GL_TEXTURE_INTENSITY_TYPE_ARB                       => 0x8C15,
	GL_TEXTURE_DEPTH_TYPE_ARB                           => 0x8C16,
	GL_UNSIGNED_NORMALIZED_ARB                          => 0x8C17,
	GL_RGBA32F_ARB                                      => 0x8814,
	GL_RGB32F_ARB                                       => 0x8815,
	GL_ALPHA32F_ARB                                     => 0x8816,
	GL_INTENSITY32F_ARB                                 => 0x8817,
	GL_LUMINANCE32F_ARB                                 => 0x8818,
	GL_LUMINANCE_ALPHA32F_ARB                           => 0x8819,
	GL_RGBA16F_ARB                                      => 0x881A,
	GL_RGB16F_ARB                                       => 0x881B,
	GL_ALPHA16F_ARB                                     => 0x881C,
	GL_INTENSITY16F_ARB                                 => 0x881D,
	GL_LUMINANCE16F_ARB                                 => 0x881E,
	GL_LUMINANCE_ALPHA16F_ARB                           => 0x881F,
	GL_PIXEL_PACK_BUFFER_ARB                            => 0x88EB,
	GL_PIXEL_UNPACK_BUFFER_ARB                          => 0x88EC,
	GL_PIXEL_PACK_BUFFER_BINDING_ARB                    => 0x88ED,
	GL_PIXEL_UNPACK_BUFFER_BINDING_ARB                  => 0x88EF,
	GL_ABGR_EXT                                         => 0x8000,
	GL_CONSTANT_COLOR_EXT                               => 0x8001,
	GL_ONE_MINUS_CONSTANT_COLOR_EXT                     => 0x8002,
	GL_CONSTANT_ALPHA_EXT                               => 0x8003,
	GL_ONE_MINUS_CONSTANT_ALPHA_EXT                     => 0x8004,
	GL_BLEND_COLOR_EXT                                  => 0x8005,
	GL_POLYGON_OFFSET_EXT                               => 0x8037,
	GL_POLYGON_OFFSET_FACTOR_EXT                        => 0x8038,
	GL_POLYGON_OFFSET_BIAS_EXT                          => 0x8039,
	GL_ALPHA4_EXT                                       => 0x803B,
	GL_ALPHA8_EXT                                       => 0x803C,
	GL_ALPHA12_EXT                                      => 0x803D,
	GL_ALPHA16_EXT                                      => 0x803E,
	GL_LUMINANCE4_EXT                                   => 0x803F,
	GL_LUMINANCE8_EXT                                   => 0x8040,
	GL_LUMINANCE12_EXT                                  => 0x8041,
	GL_LUMINANCE16_EXT                                  => 0x8042,
	GL_LUMINANCE4_ALPHA4_EXT                            => 0x8043,
	GL_LUMINANCE6_ALPHA2_EXT                            => 0x8044,
	GL_LUMINANCE8_ALPHA8_EXT                            => 0x8045,
	GL_LUMINANCE12_ALPHA4_EXT                           => 0x8046,
	GL_LUMINANCE12_ALPHA12_EXT                          => 0x8047,
	GL_LUMINANCE16_ALPHA16_EXT                          => 0x8048,
	GL_INTENSITY_EXT                                    => 0x8049,
	GL_INTENSITY4_EXT                                   => 0x804A,
	GL_INTENSITY8_EXT                                   => 0x804B,
	GL_INTENSITY12_EXT                                  => 0x804C,
	GL_INTENSITY16_EXT                                  => 0x804D,
	GL_RGB2_EXT                                         => 0x804E,
	GL_RGB4_EXT                                         => 0x804F,
	GL_RGB5_EXT                                         => 0x8050,
	GL_RGB8_EXT                                         => 0x8051,
	GL_RGB10_EXT                                        => 0x8052,
	GL_RGB12_EXT                                        => 0x8053,
	GL_RGB16_EXT                                        => 0x8054,
	GL_RGBA2_EXT                                        => 0x8055,
	GL_RGBA4_EXT                                        => 0x8056,
	GL_RGB5_A1_EXT                                      => 0x8057,
	GL_RGBA8_EXT                                        => 0x8058,
	GL_RGB10_A2_EXT                                     => 0x8059,
	GL_RGBA12_EXT                                       => 0x805A,
	GL_RGBA16_EXT                                       => 0x805B,
	GL_TEXTURE_RED_SIZE_EXT                             => 0x805C,
	GL_TEXTURE_GREEN_SIZE_EXT                           => 0x805D,
	GL_TEXTURE_BLUE_SIZE_EXT                            => 0x805E,
	GL_TEXTURE_ALPHA_SIZE_EXT                           => 0x805F,
	GL_TEXTURE_LUMINANCE_SIZE_EXT                       => 0x8060,
	GL_TEXTURE_INTENSITY_SIZE_EXT                       => 0x8061,
	GL_REPLACE_EXT                                      => 0x8062,
	GL_PROXY_TEXTURE_1D_EXT                             => 0x8063,
	GL_PROXY_TEXTURE_2D_EXT                             => 0x8064,
	GL_TEXTURE_TOO_LARGE_EXT                            => 0x8065,
	GL_PACK_SKIP_IMAGES_EXT                             => 0x806B,
	GL_PACK_IMAGE_HEIGHT_EXT                            => 0x806C,
	GL_UNPACK_SKIP_IMAGES_EXT                           => 0x806D,
	GL_UNPACK_IMAGE_HEIGHT_EXT                          => 0x806E,
	GL_TEXTURE_3D_EXT                                   => 0x806F,
	GL_PROXY_TEXTURE_3D_EXT                             => 0x8070,
	GL_TEXTURE_DEPTH_EXT                                => 0x8071,
	GL_TEXTURE_WRAP_R_EXT                               => 0x8072,
	GL_MAX_3D_TEXTURE_SIZE_EXT                          => 0x8073,
	GL_FILTER4_SGIS                                     => 0x8146,
	GL_TEXTURE_FILTER4_SIZE_SGIS                        => 0x8147,
	GL_HISTOGRAM_EXT                                    => 0x8024,
	GL_PROXY_HISTOGRAM_EXT                              => 0x8025,
	GL_HISTOGRAM_WIDTH_EXT                              => 0x8026,
	GL_HISTOGRAM_FORMAT_EXT                             => 0x8027,
	GL_HISTOGRAM_RED_SIZE_EXT                           => 0x8028,
	GL_HISTOGRAM_GREEN_SIZE_EXT                         => 0x8029,
	GL_HISTOGRAM_BLUE_SIZE_EXT                          => 0x802A,
	GL_HISTOGRAM_ALPHA_SIZE_EXT                         => 0x802B,
	GL_HISTOGRAM_LUMINANCE_SIZE_EXT                     => 0x802C,
	GL_HISTOGRAM_SINK_EXT                               => 0x802D,
	GL_MINMAX_EXT                                       => 0x802E,
	GL_MINMAX_FORMAT_EXT                                => 0x802F,
	GL_MINMAX_SINK_EXT                                  => 0x8030,
	GL_TABLE_TOO_LARGE_EXT                              => 0x8031,
	GL_CONVOLUTION_1D_EXT                               => 0x8010,
	GL_CONVOLUTION_2D_EXT                               => 0x8011,
	GL_SEPARABLE_2D_EXT                                 => 0x8012,
	GL_CONVOLUTION_BORDER_MODE_EXT                      => 0x8013,
	GL_CONVOLUTION_FILTER_SCALE_EXT                     => 0x8014,
	GL_CONVOLUTION_FILTER_BIAS_EXT                      => 0x8015,
	GL_REDUCE_EXT                                       => 0x8016,
	GL_CONVOLUTION_FORMAT_EXT                           => 0x8017,
	GL_CONVOLUTION_WIDTH_EXT                            => 0x8018,
	GL_CONVOLUTION_HEIGHT_EXT                           => 0x8019,
	GL_MAX_CONVOLUTION_WIDTH_EXT                        => 0x801A,
	GL_MAX_CONVOLUTION_HEIGHT_EXT                       => 0x801B,
	GL_POST_CONVOLUTION_RED_SCALE_EXT                   => 0x801C,
	GL_POST_CONVOLUTION_GREEN_SCALE_EXT                 => 0x801D,
	GL_POST_CONVOLUTION_BLUE_SCALE_EXT                  => 0x801E,
	GL_POST_CONVOLUTION_ALPHA_SCALE_EXT                 => 0x801F,
	GL_POST_CONVOLUTION_RED_BIAS_EXT                    => 0x8020,
	GL_POST_CONVOLUTION_GREEN_BIAS_EXT                  => 0x8021,
	GL_POST_CONVOLUTION_BLUE_BIAS_EXT                   => 0x8022,
	GL_POST_CONVOLUTION_ALPHA_BIAS_EXT                  => 0x8023,
	GL_COLOR_MATRIX_SGI                                 => 0x80B1,
	GL_COLOR_MATRIX_STACK_DEPTH_SGI                     => 0x80B2,
	GL_MAX_COLOR_MATRIX_STACK_DEPTH_SGI                 => 0x80B3,
	GL_POST_COLOR_MATRIX_RED_SCALE_SGI                  => 0x80B4,
	GL_POST_COLOR_MATRIX_GREEN_SCALE_SGI                => 0x80B5,
	GL_POST_COLOR_MATRIX_BLUE_SCALE_SGI                 => 0x80B6,
	GL_POST_COLOR_MATRIX_ALPHA_SCALE_SGI                => 0x80B7,
	GL_POST_COLOR_MATRIX_RED_BIAS_SGI                   => 0x80B8,
	GL_POST_COLOR_MATRIX_GREEN_BIAS_SGI                 => 0x80B9,
	GL_POST_COLOR_MATRIX_BLUE_BIAS_SGI                  => 0x80BA,
	GL_POST_COLOR_MATRIX_ALPHA_BIAS_SGI                 => 0x80BB,
	GL_COLOR_TABLE_SGI                                  => 0x80D0,
	GL_POST_CONVOLUTION_COLOR_TABLE_SGI                 => 0x80D1,
	GL_POST_COLOR_MATRIX_COLOR_TABLE_SGI                => 0x80D2,
	GL_PROXY_COLOR_TABLE_SGI                            => 0x80D3,
	GL_PROXY_POST_CONVOLUTION_COLOR_TABLE_SGI           => 0x80D4,
	GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE_SGI          => 0x80D5,
	GL_COLOR_TABLE_SCALE_SGI                            => 0x80D6,
	GL_COLOR_TABLE_BIAS_SGI                             => 0x80D7,
	GL_COLOR_TABLE_FORMAT_SGI                           => 0x80D8,
	GL_COLOR_TABLE_WIDTH_SGI                            => 0x80D9,
	GL_COLOR_TABLE_RED_SIZE_SGI                         => 0x80DA,
	GL_COLOR_TABLE_GREEN_SIZE_SGI                       => 0x80DB,
	GL_COLOR_TABLE_BLUE_SIZE_SGI                        => 0x80DC,
	GL_COLOR_TABLE_ALPHA_SIZE_SGI                       => 0x80DD,
	GL_COLOR_TABLE_LUMINANCE_SIZE_SGI                   => 0x80DE,
	GL_COLOR_TABLE_INTENSITY_SIZE_SGI                   => 0x80DF,
	GL_PIXEL_TEXTURE_SGIS                               => 0x8353,
	GL_PIXEL_FRAGMENT_RGB_SOURCE_SGIS                   => 0x8354,
	GL_PIXEL_FRAGMENT_ALPHA_SOURCE_SGIS                 => 0x8355,
	GL_PIXEL_GROUP_COLOR_SGIS                           => 0x8356,
	GL_PIXEL_TEX_GEN_SGIX                               => 0x8139,
	GL_PIXEL_TEX_GEN_MODE_SGIX                          => 0x832B,
	GL_PACK_SKIP_VOLUMES_SGIS                           => 0x8130,
	GL_PACK_IMAGE_DEPTH_SGIS                            => 0x8131,
	GL_UNPACK_SKIP_VOLUMES_SGIS                         => 0x8132,
	GL_UNPACK_IMAGE_DEPTH_SGIS                          => 0x8133,
	GL_TEXTURE_4D_SGIS                                  => 0x8134,
	GL_PROXY_TEXTURE_4D_SGIS                            => 0x8135,
	GL_TEXTURE_4DSIZE_SGIS                              => 0x8136,
	GL_TEXTURE_WRAP_Q_SGIS                              => 0x8137,
	GL_MAX_4D_TEXTURE_SIZE_SGIS                         => 0x8138,
	GL_TEXTURE_4D_BINDING_SGIS                          => 0x814F,
	GL_TEXTURE_COLOR_TABLE_SGI                          => 0x80BC,
	GL_PROXY_TEXTURE_COLOR_TABLE_SGI                    => 0x80BD,
	GL_CMYK_EXT                                         => 0x800C,
	GL_CMYKA_EXT                                        => 0x800D,
	GL_PACK_CMYK_HINT_EXT                               => 0x800E,
	GL_UNPACK_CMYK_HINT_EXT                             => 0x800F,
	GL_TEXTURE_PRIORITY_EXT                             => 0x8066,
	GL_TEXTURE_RESIDENT_EXT                             => 0x8067,
	GL_TEXTURE_1D_BINDING_EXT                           => 0x8068,
	GL_TEXTURE_2D_BINDING_EXT                           => 0x8069,
	GL_TEXTURE_3D_BINDING_EXT                           => 0x806A,
	GL_DETAIL_TEXTURE_2D_SGIS                           => 0x8095,
	GL_DETAIL_TEXTURE_2D_BINDING_SGIS                   => 0x8096,
	GL_LINEAR_DETAIL_SGIS                               => 0x8097,
	GL_LINEAR_DETAIL_ALPHA_SGIS                         => 0x8098,
	GL_LINEAR_DETAIL_COLOR_SGIS                         => 0x8099,
	GL_DETAIL_TEXTURE_LEVEL_SGIS                        => 0x809A,
	GL_DETAIL_TEXTURE_MODE_SGIS                         => 0x809B,
	GL_DETAIL_TEXTURE_FUNC_POINTS_SGIS                  => 0x809C,
	GL_LINEAR_SHARPEN_SGIS                              => 0x80AD,
	GL_LINEAR_SHARPEN_ALPHA_SGIS                        => 0x80AE,
	GL_LINEAR_SHARPEN_COLOR_SGIS                        => 0x80AF,
	GL_SHARPEN_TEXTURE_FUNC_POINTS_SGIS                 => 0x80B0,
	GL_UNSIGNED_BYTE_3_3_2_EXT                          => 0x8032,
	GL_UNSIGNED_SHORT_4_4_4_4_EXT                       => 0x8033,
	GL_UNSIGNED_SHORT_5_5_5_1_EXT                       => 0x8034,
	GL_UNSIGNED_INT_8_8_8_8_EXT                         => 0x8035,
	GL_UNSIGNED_INT_10_10_10_2_EXT                      => 0x8036,
	GL_TEXTURE_MIN_LOD_SGIS                             => 0x813A,
	GL_TEXTURE_MAX_LOD_SGIS                             => 0x813B,
	GL_TEXTURE_BASE_LEVEL_SGIS                          => 0x813C,
	GL_TEXTURE_MAX_LEVEL_SGIS                           => 0x813D,
	GL_MULTISAMPLE_SGIS                                 => 0x809D,
	GL_SAMPLE_ALPHA_TO_MASK_SGIS                        => 0x809E,
	GL_SAMPLE_ALPHA_TO_ONE_SGIS                         => 0x809F,
	GL_SAMPLE_MASK_SGIS                                 => 0x80A0,
	GL_1PASS_SGIS                                       => 0x80A1,
	GL_2PASS_0_SGIS                                     => 0x80A2,
	GL_2PASS_1_SGIS                                     => 0x80A3,
	GL_4PASS_0_SGIS                                     => 0x80A4,
	GL_4PASS_1_SGIS                                     => 0x80A5,
	GL_4PASS_2_SGIS                                     => 0x80A6,
	GL_4PASS_3_SGIS                                     => 0x80A7,
	GL_SAMPLE_BUFFERS_SGIS                              => 0x80A8,
	GL_SAMPLES_SGIS                                     => 0x80A9,
	GL_SAMPLE_MASK_VALUE_SGIS                           => 0x80AA,
	GL_SAMPLE_MASK_INVERT_SGIS                          => 0x80AB,
	GL_SAMPLE_PATTERN_SGIS                              => 0x80AC,
	GL_RESCALE_NORMAL_EXT                               => 0x803A,
	GL_VERTEX_ARRAY_EXT                                 => 0x8074,
	GL_NORMAL_ARRAY_EXT                                 => 0x8075,
	GL_COLOR_ARRAY_EXT                                  => 0x8076,
	GL_INDEX_ARRAY_EXT                                  => 0x8077,
	GL_TEXTURE_COORD_ARRAY_EXT                          => 0x8078,
	GL_EDGE_FLAG_ARRAY_EXT                              => 0x8079,
	GL_VERTEX_ARRAY_SIZE_EXT                            => 0x807A,
	GL_VERTEX_ARRAY_TYPE_EXT                            => 0x807B,
	GL_VERTEX_ARRAY_STRIDE_EXT                          => 0x807C,
	GL_VERTEX_ARRAY_COUNT_EXT                           => 0x807D,
	GL_NORMAL_ARRAY_TYPE_EXT                            => 0x807E,
	GL_NORMAL_ARRAY_STRIDE_EXT                          => 0x807F,
	GL_NORMAL_ARRAY_COUNT_EXT                           => 0x8080,
	GL_COLOR_ARRAY_SIZE_EXT                             => 0x8081,
	GL_COLOR_ARRAY_TYPE_EXT                             => 0x8082,
	GL_COLOR_ARRAY_STRIDE_EXT                           => 0x8083,
	GL_COLOR_ARRAY_COUNT_EXT                            => 0x8084,
	GL_INDEX_ARRAY_TYPE_EXT                             => 0x8085,
	GL_INDEX_ARRAY_STRIDE_EXT                           => 0x8086,
	GL_INDEX_ARRAY_COUNT_EXT                            => 0x8087,
	GL_TEXTURE_COORD_ARRAY_SIZE_EXT                     => 0x8088,
	GL_TEXTURE_COORD_ARRAY_TYPE_EXT                     => 0x8089,
	GL_TEXTURE_COORD_ARRAY_STRIDE_EXT                   => 0x808A,
	GL_TEXTURE_COORD_ARRAY_COUNT_EXT                    => 0x808B,
	GL_EDGE_FLAG_ARRAY_STRIDE_EXT                       => 0x808C,
	GL_EDGE_FLAG_ARRAY_COUNT_EXT                        => 0x808D,
	GL_VERTEX_ARRAY_POINTER_EXT                         => 0x808E,
	GL_NORMAL_ARRAY_POINTER_EXT                         => 0x808F,
	GL_COLOR_ARRAY_POINTER_EXT                          => 0x8090,
	GL_INDEX_ARRAY_POINTER_EXT                          => 0x8091,
	GL_TEXTURE_COORD_ARRAY_POINTER_EXT                  => 0x8092,
	GL_EDGE_FLAG_ARRAY_POINTER_EXT                      => 0x8093,
	GL_GENERATE_MIPMAP_SGIS                             => 0x8191,
	GL_GENERATE_MIPMAP_HINT_SGIS                        => 0x8192,
	GL_LINEAR_CLIPMAP_LINEAR_SGIX                       => 0x8170,
	GL_TEXTURE_CLIPMAP_CENTER_SGIX                      => 0x8171,
	GL_TEXTURE_CLIPMAP_FRAME_SGIX                       => 0x8172,
	GL_TEXTURE_CLIPMAP_OFFSET_SGIX                      => 0x8173,
	GL_TEXTURE_CLIPMAP_VIRTUAL_DEPTH_SGIX               => 0x8174,
	GL_TEXTURE_CLIPMAP_LOD_OFFSET_SGIX                  => 0x8175,
	GL_TEXTURE_CLIPMAP_DEPTH_SGIX                       => 0x8176,
	GL_MAX_CLIPMAP_DEPTH_SGIX                           => 0x8177,
	GL_MAX_CLIPMAP_VIRTUAL_DEPTH_SGIX                   => 0x8178,
	GL_NEAREST_CLIPMAP_NEAREST_SGIX                     => 0x844D,
	GL_NEAREST_CLIPMAP_LINEAR_SGIX                      => 0x844E,
	GL_LINEAR_CLIPMAP_NEAREST_SGIX                      => 0x844F,
	GL_TEXTURE_COMPARE_SGIX                             => 0x819A,
	GL_TEXTURE_COMPARE_OPERATOR_SGIX                    => 0x819B,
	GL_TEXTURE_LEQUAL_R_SGIX                            => 0x819C,
	GL_TEXTURE_GEQUAL_R_SGIX                            => 0x819D,
	GL_CLAMP_TO_EDGE_SGIS                               => 0x812F,
	GL_CLAMP_TO_BORDER_SGIS                             => 0x812D,
	GL_FUNC_ADD_EXT                                     => 0x8006,
	GL_MIN_EXT                                          => 0x8007,
	GL_MAX_EXT                                          => 0x8008,
	GL_BLEND_EQUATION_EXT                               => 0x8009,
	GL_FUNC_SUBTRACT_EXT                                => 0x800A,
	GL_FUNC_REVERSE_SUBTRACT_EXT                        => 0x800B,
	GL_INTERLACE_SGIX                                   => 0x8094,
	GL_PIXEL_TILE_BEST_ALIGNMENT_SGIX                   => 0x813E,
	GL_PIXEL_TILE_CACHE_INCREMENT_SGIX                  => 0x813F,
	GL_PIXEL_TILE_WIDTH_SGIX                            => 0x8140,
	GL_PIXEL_TILE_HEIGHT_SGIX                           => 0x8141,
	GL_PIXEL_TILE_GRID_WIDTH_SGIX                       => 0x8142,
	GL_PIXEL_TILE_GRID_HEIGHT_SGIX                      => 0x8143,
	GL_PIXEL_TILE_GRID_DEPTH_SGIX                       => 0x8144,
	GL_PIXEL_TILE_CACHE_SIZE_SGIX                       => 0x8145,
	GL_DUAL_ALPHA4_SGIS                                 => 0x8110,
	GL_DUAL_ALPHA8_SGIS                                 => 0x8111,
	GL_DUAL_ALPHA12_SGIS                                => 0x8112,
	GL_DUAL_ALPHA16_SGIS                                => 0x8113,
	GL_DUAL_LUMINANCE4_SGIS                             => 0x8114,
	GL_DUAL_LUMINANCE8_SGIS                             => 0x8115,
	GL_DUAL_LUMINANCE12_SGIS                            => 0x8116,
	GL_DUAL_LUMINANCE16_SGIS                            => 0x8117,
	GL_DUAL_INTENSITY4_SGIS                             => 0x8118,
	GL_DUAL_INTENSITY8_SGIS                             => 0x8119,
	GL_DUAL_INTENSITY12_SGIS                            => 0x811A,
	GL_DUAL_INTENSITY16_SGIS                            => 0x811B,
	GL_DUAL_LUMINANCE_ALPHA4_SGIS                       => 0x811C,
	GL_DUAL_LUMINANCE_ALPHA8_SGIS                       => 0x811D,
	GL_QUAD_ALPHA4_SGIS                                 => 0x811E,
	GL_QUAD_ALPHA8_SGIS                                 => 0x811F,
	GL_QUAD_LUMINANCE4_SGIS                             => 0x8120,
	GL_QUAD_LUMINANCE8_SGIS                             => 0x8121,
	GL_QUAD_INTENSITY4_SGIS                             => 0x8122,
	GL_QUAD_INTENSITY8_SGIS                             => 0x8123,
	GL_DUAL_TEXTURE_SELECT_SGIS                         => 0x8124,
	GL_QUAD_TEXTURE_SELECT_SGIS                         => 0x8125,
	GL_SPRITE_SGIX                                      => 0x8148,
	GL_SPRITE_MODE_SGIX                                 => 0x8149,
	GL_SPRITE_AXIS_SGIX                                 => 0x814A,
	GL_SPRITE_TRANSLATION_SGIX                          => 0x814B,
	GL_SPRITE_AXIAL_SGIX                                => 0x814C,
	GL_SPRITE_OBJECT_ALIGNED_SGIX                       => 0x814D,
	GL_SPRITE_EYE_ALIGNED_SGIX                          => 0x814E,
	GL_TEXTURE_MULTI_BUFFER_HINT_SGIX                   => 0x812E,
	GL_POINT_SIZE_MIN_EXT                               => 0x8126,
	GL_POINT_SIZE_MAX_EXT                               => 0x8127,
	GL_POINT_FADE_THRESHOLD_SIZE_EXT                    => 0x8128,
	GL_DISTANCE_ATTENUATION_EXT                         => 0x8129,
	GL_POINT_SIZE_MIN_SGIS                              => 0x8126,
	GL_POINT_SIZE_MAX_SGIS                              => 0x8127,
	GL_POINT_FADE_THRESHOLD_SIZE_SGIS                   => 0x8128,
	GL_DISTANCE_ATTENUATION_SGIS                        => 0x8129,
	GL_INSTRUMENT_BUFFER_POINTER_SGIX                   => 0x8180,
	GL_INSTRUMENT_MEASUREMENTS_SGIX                     => 0x8181,
	GL_POST_TEXTURE_FILTER_BIAS_SGIX                    => 0x8179,
	GL_POST_TEXTURE_FILTER_SCALE_SGIX                   => 0x817A,
	GL_POST_TEXTURE_FILTER_BIAS_RANGE_SGIX              => 0x817B,
	GL_POST_TEXTURE_FILTER_SCALE_RANGE_SGIX             => 0x817C,
	GL_FRAMEZOOM_SGIX                                   => 0x818B,
	GL_FRAMEZOOM_FACTOR_SGIX                            => 0x818C,
	GL_MAX_FRAMEZOOM_FACTOR_SGIX                        => 0x818D,
	GL_TEXTURE_DEFORMATION_BIT_SGIX                     => 0x00000001,
	GL_GEOMETRY_DEFORMATION_BIT_SGIX                    => 0x00000002,
	GL_GEOMETRY_DEFORMATION_SGIX                        => 0x8194,
	GL_TEXTURE_DEFORMATION_SGIX                         => 0x8195,
	GL_DEFORMATIONS_MASK_SGIX                           => 0x8196,
	GL_MAX_DEFORMATION_ORDER_SGIX                       => 0x8197,
	GL_REFERENCE_PLANE_SGIX                             => 0x817D,
	GL_REFERENCE_PLANE_EQUATION_SGIX                    => 0x817E,
	GL_DEPTH_COMPONENT16_SGIX                           => 0x81A5,
	GL_DEPTH_COMPONENT24_SGIX                           => 0x81A6,
	GL_DEPTH_COMPONENT32_SGIX                           => 0x81A7,
	GL_FOG_FUNC_SGIS                                    => 0x812A,
	GL_FOG_FUNC_POINTS_SGIS                             => 0x812B,
	GL_MAX_FOG_FUNC_POINTS_SGIS                         => 0x812C,
	GL_FOG_OFFSET_SGIX                                  => 0x8198,
	GL_FOG_OFFSET_VALUE_SGIX                            => 0x8199,
	GL_IMAGE_SCALE_X_HP                                 => 0x8155,
	GL_IMAGE_SCALE_Y_HP                                 => 0x8156,
	GL_IMAGE_TRANSLATE_X_HP                             => 0x8157,
	GL_IMAGE_TRANSLATE_Y_HP                             => 0x8158,
	GL_IMAGE_ROTATE_ANGLE_HP                            => 0x8159,
	GL_IMAGE_ROTATE_ORIGIN_X_HP                         => 0x815A,
	GL_IMAGE_ROTATE_ORIGIN_Y_HP                         => 0x815B,
	GL_IMAGE_MAG_FILTER_HP                              => 0x815C,
	GL_IMAGE_MIN_FILTER_HP                              => 0x815D,
	GL_IMAGE_CUBIC_WEIGHT_HP                            => 0x815E,
	GL_CUBIC_HP                                         => 0x815F,
	GL_AVERAGE_HP                                       => 0x8160,
	GL_IMAGE_TRANSFORM_2D_HP                            => 0x8161,
	GL_POST_IMAGE_TRANSFORM_COLOR_TABLE_HP              => 0x8162,
	GL_PROXY_POST_IMAGE_TRANSFORM_COLOR_TABLE_HP        => 0x8163,
	GL_IGNORE_BORDER_HP                                 => 0x8150,
	GL_CONSTANT_BORDER_HP                               => 0x8151,
	GL_REPLICATE_BORDER_HP                              => 0x8153,
	GL_CONVOLUTION_BORDER_COLOR_HP                      => 0x8154,
	GL_TEXTURE_ENV_BIAS_SGIX                            => 0x80BE,
	GL_VERTEX_DATA_HINT_PGI                             => 0x1A22A,
	GL_VERTEX_CONSISTENT_HINT_PGI                       => 0x1A22B,
	GL_MATERIAL_SIDE_HINT_PGI                           => 0x1A22C,
	GL_MAX_VERTEX_HINT_PGI                              => 0x1A22D,
	GL_COLOR3_BIT_PGI                                   => 0x00010000,
	GL_COLOR4_BIT_PGI                                   => 0x00020000,
	GL_EDGEFLAG_BIT_PGI                                 => 0x00040000,
	GL_INDEX_BIT_PGI                                    => 0x00080000,
	GL_MAT_AMBIENT_BIT_PGI                              => 0x00100000,
	GL_MAT_AMBIENT_AND_DIFFUSE_BIT_PGI                  => 0x00200000,
	GL_MAT_DIFFUSE_BIT_PGI                              => 0x00400000,
	GL_MAT_EMISSION_BIT_PGI                             => 0x00800000,
	GL_MAT_COLOR_INDEXES_BIT_PGI                        => 0x01000000,
	GL_MAT_SHININESS_BIT_PGI                            => 0x02000000,
	GL_MAT_SPECULAR_BIT_PGI                             => 0x04000000,
	GL_NORMAL_BIT_PGI                                   => 0x08000000,
	GL_TEXCOORD1_BIT_PGI                                => 0x10000000,
	GL_TEXCOORD2_BIT_PGI                                => 0x20000000,
	GL_TEXCOORD3_BIT_PGI                                => 0x40000000,
	GL_TEXCOORD4_BIT_PGI                                => 0x80000000,
	GL_VERTEX23_BIT_PGI                                 => 0x00000004,
	GL_VERTEX4_BIT_PGI                                  => 0x00000008,
	GL_PREFER_DOUBLEBUFFER_HINT_PGI                     => 0x1A1F8,
	GL_CONSERVE_MEMORY_HINT_PGI                         => 0x1A1FD,
	GL_RECLAIM_MEMORY_HINT_PGI                          => 0x1A1FE,
	GL_NATIVE_GRAPHICS_HANDLE_PGI                       => 0x1A202,
	GL_NATIVE_GRAPHICS_BEGIN_HINT_PGI                   => 0x1A203,
	GL_NATIVE_GRAPHICS_END_HINT_PGI                     => 0x1A204,
	GL_ALWAYS_FAST_HINT_PGI                             => 0x1A20C,
	GL_ALWAYS_SOFT_HINT_PGI                             => 0x1A20D,
	GL_ALLOW_DRAW_OBJ_HINT_PGI                          => 0x1A20E,
	GL_ALLOW_DRAW_WIN_HINT_PGI                          => 0x1A20F,
	GL_ALLOW_DRAW_FRG_HINT_PGI                          => 0x1A210,
	GL_ALLOW_DRAW_MEM_HINT_PGI                          => 0x1A211,
	GL_STRICT_DEPTHFUNC_HINT_PGI                        => 0x1A216,
	GL_STRICT_LIGHTING_HINT_PGI                         => 0x1A217,
	GL_STRICT_SCISSOR_HINT_PGI                          => 0x1A218,
	GL_FULL_STIPPLE_HINT_PGI                            => 0x1A219,
	GL_CLIP_NEAR_HINT_PGI                               => 0x1A220,
	GL_CLIP_FAR_HINT_PGI                                => 0x1A221,
	GL_WIDE_LINE_HINT_PGI                               => 0x1A222,
	GL_BACK_NORMALS_HINT_PGI                            => 0x1A223,
	GL_COLOR_INDEX1_EXT                                 => 0x80E2,
	GL_COLOR_INDEX2_EXT                                 => 0x80E3,
	GL_COLOR_INDEX4_EXT                                 => 0x80E4,
	GL_COLOR_INDEX8_EXT                                 => 0x80E5,
	GL_COLOR_INDEX12_EXT                                => 0x80E6,
	GL_COLOR_INDEX16_EXT                                => 0x80E7,
	GL_TEXTURE_INDEX_SIZE_EXT                           => 0x80ED,
	GL_CLIP_VOLUME_CLIPPING_HINT_EXT                    => 0x80F0,
	GL_LIST_PRIORITY_SGIX                               => 0x8182,
	GL_IR_INSTRUMENT1_SGIX                              => 0x817F,
	GL_CALLIGRAPHIC_FRAGMENT_SGIX                       => 0x8183,
	GL_TEXTURE_LOD_BIAS_S_SGIX                          => 0x818E,
	GL_TEXTURE_LOD_BIAS_T_SGIX                          => 0x818F,
	GL_TEXTURE_LOD_BIAS_R_SGIX                          => 0x8190,
	GL_SHADOW_AMBIENT_SGIX                              => 0x80BF,
	GL_INDEX_MATERIAL_EXT                               => 0x81B8,
	GL_INDEX_MATERIAL_PARAMETER_EXT                     => 0x81B9,
	GL_INDEX_MATERIAL_FACE_EXT                          => 0x81BA,
	GL_INDEX_TEST_EXT                                   => 0x81B5,
	GL_INDEX_TEST_FUNC_EXT                              => 0x81B6,
	GL_INDEX_TEST_REF_EXT                               => 0x81B7,
	GL_IUI_V2F_EXT                                      => 0x81AD,
	GL_IUI_V3F_EXT                                      => 0x81AE,
	GL_IUI_N3F_V2F_EXT                                  => 0x81AF,
	GL_IUI_N3F_V3F_EXT                                  => 0x81B0,
	GL_T2F_IUI_V2F_EXT                                  => 0x81B1,
	GL_T2F_IUI_V3F_EXT                                  => 0x81B2,
	GL_T2F_IUI_N3F_V2F_EXT                              => 0x81B3,
	GL_T2F_IUI_N3F_V3F_EXT                              => 0x81B4,
	GL_ARRAY_ELEMENT_LOCK_FIRST_EXT                     => 0x81A8,
	GL_ARRAY_ELEMENT_LOCK_COUNT_EXT                     => 0x81A9,
	GL_CULL_VERTEX_EXT                                  => 0x81AA,
	GL_CULL_VERTEX_EYE_POSITION_EXT                     => 0x81AB,
	GL_CULL_VERTEX_OBJECT_POSITION_EXT                  => 0x81AC,
	GL_YCRCB_422_SGIX                                   => 0x81BB,
	GL_YCRCB_444_SGIX                                   => 0x81BC,
	GL_FRAGMENT_LIGHTING_SGIX                           => 0x8400,
	GL_FRAGMENT_COLOR_MATERIAL_SGIX                     => 0x8401,
	GL_FRAGMENT_COLOR_MATERIAL_FACE_SGIX                => 0x8402,
	GL_FRAGMENT_COLOR_MATERIAL_PARAMETER_SGIX           => 0x8403,
	GL_MAX_FRAGMENT_LIGHTS_SGIX                         => 0x8404,
	GL_MAX_ACTIVE_LIGHTS_SGIX                           => 0x8405,
	GL_CURRENT_RASTER_NORMAL_SGIX                       => 0x8406,
	GL_LIGHT_ENV_MODE_SGIX                              => 0x8407,
	GL_FRAGMENT_LIGHT_MODEL_LOCAL_VIEWER_SGIX           => 0x8408,
	GL_FRAGMENT_LIGHT_MODEL_TWO_SIDE_SGIX               => 0x8409,
	GL_FRAGMENT_LIGHT_MODEL_AMBIENT_SGIX                => 0x840A,
	GL_FRAGMENT_LIGHT_MODEL_NORMAL_INTERPOLATION_SGIX   => 0x840B,
	GL_FRAGMENT_LIGHT0_SGIX                             => 0x840C,
	GL_FRAGMENT_LIGHT1_SGIX                             => 0x840D,
	GL_FRAGMENT_LIGHT2_SGIX                             => 0x840E,
	GL_FRAGMENT_LIGHT3_SGIX                             => 0x840F,
	GL_FRAGMENT_LIGHT4_SGIX                             => 0x8410,
	GL_FRAGMENT_LIGHT5_SGIX                             => 0x8411,
	GL_FRAGMENT_LIGHT6_SGIX                             => 0x8412,
	GL_FRAGMENT_LIGHT7_SGIX                             => 0x8413,
	GL_RASTER_POSITION_UNCLIPPED_IBM                    => 0x19262,
	GL_TEXTURE_LIGHTING_MODE_HP                         => 0x8167,
	GL_TEXTURE_POST_SPECULAR_HP                         => 0x8168,
	GL_TEXTURE_PRE_SPECULAR_HP                          => 0x8169,
	GL_MAX_ELEMENTS_VERTICES_EXT                        => 0x80E8,
	GL_MAX_ELEMENTS_INDICES_EXT                         => 0x80E9,
	GL_PHONG_WIN                                        => 0x80EA,
	GL_PHONG_HINT_WIN                                   => 0x80EB,
	GL_FOG_SPECULAR_TEXTURE_WIN                         => 0x80EC,
	GL_FRAGMENT_MATERIAL_EXT                            => 0x8349,
	GL_FRAGMENT_NORMAL_EXT                              => 0x834A,
	GL_FRAGMENT_COLOR_EXT                               => 0x834C,
	GL_ATTENUATION_EXT                                  => 0x834D,
	GL_SHADOW_ATTENUATION_EXT                           => 0x834E,
	GL_TEXTURE_APPLICATION_MODE_EXT                     => 0x834F,
	GL_TEXTURE_LIGHT_EXT                                => 0x8350,
	GL_TEXTURE_MATERIAL_FACE_EXT                        => 0x8351,
	GL_TEXTURE_MATERIAL_PARAMETER_EXT                   => 0x8352,
	GL_ALPHA_MIN_SGIX                                   => 0x8320,
	GL_ALPHA_MAX_SGIX                                   => 0x8321,
	GL_PIXEL_TEX_GEN_Q_CEILING_SGIX                     => 0x8184,
	GL_PIXEL_TEX_GEN_Q_ROUND_SGIX                       => 0x8185,
	GL_PIXEL_TEX_GEN_Q_FLOOR_SGIX                       => 0x8186,
	GL_PIXEL_TEX_GEN_ALPHA_REPLACE_SGIX                 => 0x8187,
	GL_PIXEL_TEX_GEN_ALPHA_NO_REPLACE_SGIX              => 0x8188,
	GL_PIXEL_TEX_GEN_ALPHA_LS_SGIX                      => 0x8189,
	GL_PIXEL_TEX_GEN_ALPHA_MS_SGIX                      => 0x818A,
	GL_BGR_EXT                                          => 0x80E0,
	GL_BGRA_EXT                                         => 0x80E1,
	GL_ASYNC_MARKER_SGIX                                => 0x8329,
	GL_ASYNC_TEX_IMAGE_SGIX                             => 0x835C,
	GL_ASYNC_DRAW_PIXELS_SGIX                           => 0x835D,
	GL_ASYNC_READ_PIXELS_SGIX                           => 0x835E,
	GL_MAX_ASYNC_TEX_IMAGE_SGIX                         => 0x835F,
	GL_MAX_ASYNC_DRAW_PIXELS_SGIX                       => 0x8360,
	GL_MAX_ASYNC_READ_PIXELS_SGIX                       => 0x8361,
	GL_ASYNC_HISTOGRAM_SGIX                             => 0x832C,
	GL_MAX_ASYNC_HISTOGRAM_SGIX                         => 0x832D,
	GL_PARALLEL_ARRAYS_INTEL                            => 0x83F4,
	GL_VERTEX_ARRAY_PARALLEL_POINTERS_INTEL             => 0x83F5,
	GL_NORMAL_ARRAY_PARALLEL_POINTERS_INTEL             => 0x83F6,
	GL_COLOR_ARRAY_PARALLEL_POINTERS_INTEL              => 0x83F7,
	GL_TEXTURE_COORD_ARRAY_PARALLEL_POINTERS_INTEL      => 0x83F8,
	GL_OCCLUSION_TEST_HP                                => 0x8165,
	GL_OCCLUSION_TEST_RESULT_HP                         => 0x8166,
	GL_PIXEL_TRANSFORM_2D_EXT                           => 0x8330,
	GL_PIXEL_MAG_FILTER_EXT                             => 0x8331,
	GL_PIXEL_MIN_FILTER_EXT                             => 0x8332,
	GL_PIXEL_CUBIC_WEIGHT_EXT                           => 0x8333,
	GL_CUBIC_EXT                                        => 0x8334,
	GL_AVERAGE_EXT                                      => 0x8335,
	GL_PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT               => 0x8336,
	GL_MAX_PIXEL_TRANSFORM_2D_STACK_DEPTH_EXT           => 0x8337,
	GL_PIXEL_TRANSFORM_2D_MATRIX_EXT                    => 0x8338,
	GL_SHARED_TEXTURE_PALETTE_EXT                       => 0x81FB,
	GL_LIGHT_MODEL_COLOR_CONTROL_EXT                    => 0x81F8,
	GL_SINGLE_COLOR_EXT                                 => 0x81F9,
	GL_SEPARATE_SPECULAR_COLOR_EXT                      => 0x81FA,
	GL_COLOR_SUM_EXT                                    => 0x8458,
	GL_CURRENT_SECONDARY_COLOR_EXT                      => 0x8459,
	GL_SECONDARY_COLOR_ARRAY_SIZE_EXT                   => 0x845A,
	GL_SECONDARY_COLOR_ARRAY_TYPE_EXT                   => 0x845B,
	GL_SECONDARY_COLOR_ARRAY_STRIDE_EXT                 => 0x845C,
	GL_SECONDARY_COLOR_ARRAY_POINTER_EXT                => 0x845D,
	GL_SECONDARY_COLOR_ARRAY_EXT                        => 0x845E,
	GL_PERTURB_EXT                                      => 0x85AE,
	GL_TEXTURE_NORMAL_EXT                               => 0x85AF,
	GL_FOG_COORDINATE_SOURCE_EXT                        => 0x8450,
	GL_FOG_COORDINATE_EXT                               => 0x8451,
	GL_FRAGMENT_DEPTH_EXT                               => 0x8452,
	GL_CURRENT_FOG_COORDINATE_EXT                       => 0x8453,
	GL_FOG_COORDINATE_ARRAY_TYPE_EXT                    => 0x8454,
	GL_FOG_COORDINATE_ARRAY_STRIDE_EXT                  => 0x8455,
	GL_FOG_COORDINATE_ARRAY_POINTER_EXT                 => 0x8456,
	GL_FOG_COORDINATE_ARRAY_EXT                         => 0x8457,
	GL_SCREEN_COORDINATES_REND                          => 0x8490,
	GL_INVERTED_SCREEN_W_REND                           => 0x8491,
	GL_TANGENT_ARRAY_EXT                                => 0x8439,
	GL_BINORMAL_ARRAY_EXT                               => 0x843A,
	GL_CURRENT_TANGENT_EXT                              => 0x843B,
	GL_CURRENT_BINORMAL_EXT                             => 0x843C,
	GL_TANGENT_ARRAY_TYPE_EXT                           => 0x843E,
	GL_TANGENT_ARRAY_STRIDE_EXT                         => 0x843F,
	GL_BINORMAL_ARRAY_TYPE_EXT                          => 0x8440,
	GL_BINORMAL_ARRAY_STRIDE_EXT                        => 0x8441,
	GL_TANGENT_ARRAY_POINTER_EXT                        => 0x8442,
	GL_BINORMAL_ARRAY_POINTER_EXT                       => 0x8443,
	GL_MAP1_TANGENT_EXT                                 => 0x8444,
	GL_MAP2_TANGENT_EXT                                 => 0x8445,
	GL_MAP1_BINORMAL_EXT                                => 0x8446,
	GL_MAP2_BINORMAL_EXT                                => 0x8447,
	GL_COMBINE_EXT                                      => 0x8570,
	GL_COMBINE_RGB_EXT                                  => 0x8571,
	GL_COMBINE_ALPHA_EXT                                => 0x8572,
	GL_RGB_SCALE_EXT                                    => 0x8573,
	GL_ADD_SIGNED_EXT                                   => 0x8574,
	GL_INTERPOLATE_EXT                                  => 0x8575,
	GL_CONSTANT_EXT                                     => 0x8576,
	GL_PRIMARY_COLOR_EXT                                => 0x8577,
	GL_PREVIOUS_EXT                                     => 0x8578,
	GL_SOURCE0_RGB_EXT                                  => 0x8580,
	GL_SOURCE1_RGB_EXT                                  => 0x8581,
	GL_SOURCE2_RGB_EXT                                  => 0x8582,
	GL_SOURCE0_ALPHA_EXT                                => 0x8588,
	GL_SOURCE1_ALPHA_EXT                                => 0x8589,
	GL_SOURCE2_ALPHA_EXT                                => 0x858A,
	GL_OPERAND0_RGB_EXT                                 => 0x8590,
	GL_OPERAND1_RGB_EXT                                 => 0x8591,
	GL_OPERAND2_RGB_EXT                                 => 0x8592,
	GL_OPERAND0_ALPHA_EXT                               => 0x8598,
	GL_OPERAND1_ALPHA_EXT                               => 0x8599,
	GL_OPERAND2_ALPHA_EXT                               => 0x859A,
	GL_LIGHT_MODEL_SPECULAR_VECTOR_APPLE                => 0x85B0,
	GL_TRANSFORM_HINT_APPLE                             => 0x85B1,
	GL_FOG_SCALE_SGIX                                   => 0x81FC,
	GL_FOG_SCALE_VALUE_SGIX                             => 0x81FD,
	GL_UNPACK_CONSTANT_DATA_SUNX                        => 0x81D5,
	GL_TEXTURE_CONSTANT_DATA_SUNX                       => 0x81D6,
	GL_GLOBAL_ALPHA_SUN                                 => 0x81D9,
	GL_GLOBAL_ALPHA_FACTOR_SUN                          => 0x81DA,
	GL_RESTART_SUN                                      => 0x0001,
	GL_REPLACE_MIDDLE_SUN                               => 0x0002,
	GL_REPLACE_OLDEST_SUN                               => 0x0003,
	GL_TRIANGLE_LIST_SUN                                => 0x81D7,
	GL_REPLACEMENT_CODE_SUN                             => 0x81D8,
	GL_REPLACEMENT_CODE_ARRAY_SUN                       => 0x85C0,
	GL_REPLACEMENT_CODE_ARRAY_TYPE_SUN                  => 0x85C1,
	GL_REPLACEMENT_CODE_ARRAY_STRIDE_SUN                => 0x85C2,
	GL_REPLACEMENT_CODE_ARRAY_POINTER_SUN               => 0x85C3,
	GL_R1UI_V3F_SUN                                     => 0x85C4,
	GL_R1UI_C4UB_V3F_SUN                                => 0x85C5,
	GL_R1UI_C3F_V3F_SUN                                 => 0x85C6,
	GL_R1UI_N3F_V3F_SUN                                 => 0x85C7,
	GL_R1UI_C4F_N3F_V3F_SUN                             => 0x85C8,
	GL_R1UI_T2F_V3F_SUN                                 => 0x85C9,
	GL_R1UI_T2F_N3F_V3F_SUN                             => 0x85CA,
	GL_R1UI_T2F_C4F_N3F_V3F_SUN                         => 0x85CB,
	GL_BLEND_DST_RGB_EXT                                => 0x80C8,
	GL_BLEND_SRC_RGB_EXT                                => 0x80C9,
	GL_BLEND_DST_ALPHA_EXT                              => 0x80CA,
	GL_BLEND_SRC_ALPHA_EXT                              => 0x80CB,
	GL_RED_MIN_CLAMP_INGR                               => 0x8560,
	GL_GREEN_MIN_CLAMP_INGR                             => 0x8561,
	GL_BLUE_MIN_CLAMP_INGR                              => 0x8562,
	GL_ALPHA_MIN_CLAMP_INGR                             => 0x8563,
	GL_RED_MAX_CLAMP_INGR                               => 0x8564,
	GL_GREEN_MAX_CLAMP_INGR                             => 0x8565,
	GL_BLUE_MAX_CLAMP_INGR                              => 0x8566,
	GL_ALPHA_MAX_CLAMP_INGR                             => 0x8567,
	GL_INTERLACE_READ_INGR                              => 0x8568,
	GL_INCR_WRAP_EXT                                    => 0x8507,
	GL_DECR_WRAP_EXT                                    => 0x8508,
	GL_422_EXT                                          => 0x80CC,
	GL_422_REV_EXT                                      => 0x80CD,
	GL_422_AVERAGE_EXT                                  => 0x80CE,
	GL_422_REV_AVERAGE_EXT                              => 0x80CF,
	GL_NORMAL_MAP_NV                                    => 0x8511,
	GL_REFLECTION_MAP_NV                                => 0x8512,
	GL_NORMAL_MAP_EXT                                   => 0x8511,
	GL_REFLECTION_MAP_EXT                               => 0x8512,
	GL_TEXTURE_CUBE_MAP_EXT                             => 0x8513,
	GL_TEXTURE_BINDING_CUBE_MAP_EXT                     => 0x8514,
	GL_TEXTURE_CUBE_MAP_POSITIVE_X_EXT                  => 0x8515,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_X_EXT                  => 0x8516,
	GL_TEXTURE_CUBE_MAP_POSITIVE_Y_EXT                  => 0x8517,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_Y_EXT                  => 0x8518,
	GL_TEXTURE_CUBE_MAP_POSITIVE_Z_EXT                  => 0x8519,
	GL_TEXTURE_CUBE_MAP_NEGATIVE_Z_EXT                  => 0x851A,
	GL_PROXY_TEXTURE_CUBE_MAP_EXT                       => 0x851B,
	GL_MAX_CUBE_MAP_TEXTURE_SIZE_EXT                    => 0x851C,
	GL_WRAP_BORDER_SUN                                  => 0x81D4,
	GL_MAX_TEXTURE_LOD_BIAS_EXT                         => 0x84FD,
	GL_TEXTURE_FILTER_CONTROL_EXT                       => 0x8500,
	GL_TEXTURE_LOD_BIAS_EXT                             => 0x8501,
	GL_TEXTURE_MAX_ANISOTROPY_EXT                       => 0x84FE,
	GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT                   => 0x84FF,
	GL_MODELVIEW0_STACK_DEPTH_EXT                       => GL_MODELVIEW_STACK_DEPTH,
	GL_MODELVIEW1_STACK_DEPTH_EXT                       => 0x8502,
	GL_MODELVIEW0_MATRIX_EXT                            => GL_MODELVIEW_MATRIX,
	GL_MODELVIEW1_MATRIX_EXT                            => 0x8506,
	GL_VERTEX_WEIGHTING_EXT                             => 0x8509,
	GL_MODELVIEW0_EXT                                   => GL_MODELVIEW,
	GL_MODELVIEW1_EXT                                   => 0x850A,
	GL_CURRENT_VERTEX_WEIGHT_EXT                        => 0x850B,
	GL_VERTEX_WEIGHT_ARRAY_EXT                          => 0x850C,
	GL_VERTEX_WEIGHT_ARRAY_SIZE_EXT                     => 0x850D,
	GL_VERTEX_WEIGHT_ARRAY_TYPE_EXT                     => 0x850E,
	GL_VERTEX_WEIGHT_ARRAY_STRIDE_EXT                   => 0x850F,
	GL_VERTEX_WEIGHT_ARRAY_POINTER_EXT                  => 0x8510,
	GL_MAX_SHININESS_NV                                 => 0x8504,
	GL_MAX_SPOT_EXPONENT_NV                             => 0x8505,
	GL_VERTEX_ARRAY_RANGE_NV                            => 0x851D,
	GL_VERTEX_ARRAY_RANGE_LENGTH_NV                     => 0x851E,
	GL_VERTEX_ARRAY_RANGE_VALID_NV                      => 0x851F,
	GL_MAX_VERTEX_ARRAY_RANGE_ELEMENT_NV                => 0x8520,
	GL_VERTEX_ARRAY_RANGE_POINTER_NV                    => 0x8521,
	GL_REGISTER_COMBINERS_NV                            => 0x8522,
	GL_VARIABLE_A_NV                                    => 0x8523,
	GL_VARIABLE_B_NV                                    => 0x8524,
	GL_VARIABLE_C_NV                                    => 0x8525,
	GL_VARIABLE_D_NV                                    => 0x8526,
	GL_VARIABLE_E_NV                                    => 0x8527,
	GL_VARIABLE_F_NV                                    => 0x8528,
	GL_VARIABLE_G_NV                                    => 0x8529,
	GL_CONSTANT_COLOR0_NV                               => 0x852A,
	GL_CONSTANT_COLOR1_NV                               => 0x852B,
	GL_PRIMARY_COLOR_NV                                 => 0x852C,
	GL_SECONDARY_COLOR_NV                               => 0x852D,
	GL_SPARE0_NV                                        => 0x852E,
	GL_SPARE1_NV                                        => 0x852F,
	GL_DISCARD_NV                                       => 0x8530,
	GL_E_TIMES_F_NV                                     => 0x8531,
	GL_SPARE0_PLUS_SECONDARY_COLOR_NV                   => 0x8532,
	GL_UNSIGNED_IDENTITY_NV                             => 0x8536,
	GL_UNSIGNED_INVERT_NV                               => 0x8537,
	GL_EXPAND_NORMAL_NV                                 => 0x8538,
	GL_EXPAND_NEGATE_NV                                 => 0x8539,
	GL_HALF_BIAS_NORMAL_NV                              => 0x853A,
	GL_HALF_BIAS_NEGATE_NV                              => 0x853B,
	GL_SIGNED_IDENTITY_NV                               => 0x853C,
	GL_SIGNED_NEGATE_NV                                 => 0x853D,
	GL_SCALE_BY_TWO_NV                                  => 0x853E,
	GL_SCALE_BY_FOUR_NV                                 => 0x853F,
	GL_SCALE_BY_ONE_HALF_NV                             => 0x8540,
	GL_BIAS_BY_NEGATIVE_ONE_HALF_NV                     => 0x8541,
	GL_COMBINER_INPUT_NV                                => 0x8542,
	GL_COMBINER_MAPPING_NV                              => 0x8543,
	GL_COMBINER_COMPONENT_USAGE_NV                      => 0x8544,
	GL_COMBINER_AB_DOT_PRODUCT_NV                       => 0x8545,
	GL_COMBINER_CD_DOT_PRODUCT_NV                       => 0x8546,
	GL_COMBINER_MUX_SUM_NV                              => 0x8547,
	GL_COMBINER_SCALE_NV                                => 0x8548,
	GL_COMBINER_BIAS_NV                                 => 0x8549,
	GL_COMBINER_AB_OUTPUT_NV                            => 0x854A,
	GL_COMBINER_CD_OUTPUT_NV                            => 0x854B,
	GL_COMBINER_SUM_OUTPUT_NV                           => 0x854C,
	GL_MAX_GENERAL_COMBINERS_NV                         => 0x854D,
	GL_NUM_GENERAL_COMBINERS_NV                         => 0x854E,
	GL_COLOR_SUM_CLAMP_NV                               => 0x854F,
	GL_COMBINER0_NV                                     => 0x8550,
	GL_COMBINER1_NV                                     => 0x8551,
	GL_COMBINER2_NV                                     => 0x8552,
	GL_COMBINER3_NV                                     => 0x8553,
	GL_COMBINER4_NV                                     => 0x8554,
	GL_COMBINER5_NV                                     => 0x8555,
	GL_COMBINER6_NV                                     => 0x8556,
	GL_COMBINER7_NV                                     => 0x8557,
	GL_FOG_DISTANCE_MODE_NV                             => 0x855A,
	GL_EYE_RADIAL_NV                                    => 0x855B,
	GL_EYE_PLANE_ABSOLUTE_NV                            => 0x855C,
	GL_EMBOSS_LIGHT_NV                                  => 0x855D,
	GL_EMBOSS_CONSTANT_NV                               => 0x855E,
	GL_EMBOSS_MAP_NV                                    => 0x855F,
	GL_COMBINE4_NV                                      => 0x8503,
	GL_SOURCE3_RGB_NV                                   => 0x8583,
	GL_SOURCE3_ALPHA_NV                                 => 0x858B,
	GL_OPERAND3_RGB_NV                                  => 0x8593,
	GL_OPERAND3_ALPHA_NV                                => 0x859B,
	GL_COMPRESSED_RGB_S3TC_DXT1_EXT                     => 0x83F0,
	GL_COMPRESSED_RGBA_S3TC_DXT1_EXT                    => 0x83F1,
	GL_COMPRESSED_RGBA_S3TC_DXT3_EXT                    => 0x83F2,
	GL_COMPRESSED_RGBA_S3TC_DXT5_EXT                    => 0x83F3,
	GL_CULL_VERTEX_IBM                                  => 103050,
	GL_VERTEX_ARRAY_LIST_IBM                            => 103070,
	GL_NORMAL_ARRAY_LIST_IBM                            => 103071,
	GL_COLOR_ARRAY_LIST_IBM                             => 103072,
	GL_INDEX_ARRAY_LIST_IBM                             => 103073,
	GL_TEXTURE_COORD_ARRAY_LIST_IBM                     => 103074,
	GL_EDGE_FLAG_ARRAY_LIST_IBM                         => 103075,
	GL_FOG_COORDINATE_ARRAY_LIST_IBM                    => 103076,
	GL_SECONDARY_COLOR_ARRAY_LIST_IBM                   => 103077,
	GL_VERTEX_ARRAY_LIST_STRIDE_IBM                     => 103080,
	GL_NORMAL_ARRAY_LIST_STRIDE_IBM                     => 103081,
	GL_COLOR_ARRAY_LIST_STRIDE_IBM                      => 103082,
	GL_INDEX_ARRAY_LIST_STRIDE_IBM                      => 103083,
	GL_TEXTURE_COORD_ARRAY_LIST_STRIDE_IBM              => 103084,
	GL_EDGE_FLAG_ARRAY_LIST_STRIDE_IBM                  => 103085,
	GL_FOG_COORDINATE_ARRAY_LIST_STRIDE_IBM             => 103086,
	GL_SECONDARY_COLOR_ARRAY_LIST_STRIDE_IBM            => 103087,
	GL_PACK_SUBSAMPLE_RATE_SGIX                         => 0x85A0,
	GL_UNPACK_SUBSAMPLE_RATE_SGIX                       => 0x85A1,
	GL_PIXEL_SUBSAMPLE_4444_SGIX                        => 0x85A2,
	GL_PIXEL_SUBSAMPLE_2424_SGIX                        => 0x85A3,
	GL_PIXEL_SUBSAMPLE_4242_SGIX                        => 0x85A4,
	GL_YCRCB_SGIX                                       => 0x8318,
	GL_YCRCBA_SGIX                                      => 0x8319,
	GL_DEPTH_PASS_INSTRUMENT_SGIX                       => 0x8310,
	GL_DEPTH_PASS_INSTRUMENT_COUNTERS_SGIX              => 0x8311,
	GL_DEPTH_PASS_INSTRUMENT_MAX_SGIX                   => 0x8312,
	GL_COMPRESSED_RGB_FXT1_3DFX                         => 0x86B0,
	GL_COMPRESSED_RGBA_FXT1_3DFX                        => 0x86B1,
	GL_MULTISAMPLE_3DFX                                 => 0x86B2,
	GL_SAMPLE_BUFFERS_3DFX                              => 0x86B3,
	GL_SAMPLES_3DFX                                     => 0x86B4,
	GL_MULTISAMPLE_BIT_3DFX                             => 0x20000000,
	GL_MULTISAMPLE_EXT                                  => 0x809D,
	GL_SAMPLE_ALPHA_TO_MASK_EXT                         => 0x809E,
	GL_SAMPLE_ALPHA_TO_ONE_EXT                          => 0x809F,
	GL_SAMPLE_MASK_EXT                                  => 0x80A0,
	GL_1PASS_EXT                                        => 0x80A1,
	GL_2PASS_0_EXT                                      => 0x80A2,
	GL_2PASS_1_EXT                                      => 0x80A3,
	GL_4PASS_0_EXT                                      => 0x80A4,
	GL_4PASS_1_EXT                                      => 0x80A5,
	GL_4PASS_2_EXT                                      => 0x80A6,
	GL_4PASS_3_EXT                                      => 0x80A7,
	GL_SAMPLE_BUFFERS_EXT                               => 0x80A8,
	GL_SAMPLES_EXT                                      => 0x80A9,
	GL_SAMPLE_MASK_VALUE_EXT                            => 0x80AA,
	GL_SAMPLE_MASK_INVERT_EXT                           => 0x80AB,
	GL_SAMPLE_PATTERN_EXT                               => 0x80AC,
	GL_MULTISAMPLE_BIT_EXT                              => 0x20000000,
	GL_VERTEX_PRECLIP_SGIX                              => 0x83EE,
	GL_VERTEX_PRECLIP_HINT_SGIX                         => 0x83EF,
	GL_CONVOLUTION_HINT_SGIX                            => 0x8316,
	GL_PACK_RESAMPLE_SGIX                               => 0x842C,
	GL_UNPACK_RESAMPLE_SGIX                             => 0x842D,
	GL_RESAMPLE_REPLICATE_SGIX                          => 0x842E,
	GL_RESAMPLE_ZERO_FILL_SGIX                          => 0x842F,
	GL_RESAMPLE_DECIMATE_SGIX                           => 0x8430,
	GL_EYE_DISTANCE_TO_POINT_SGIS                       => 0x81F0,
	GL_OBJECT_DISTANCE_TO_POINT_SGIS                    => 0x81F1,
	GL_EYE_DISTANCE_TO_LINE_SGIS                        => 0x81F2,
	GL_OBJECT_DISTANCE_TO_LINE_SGIS                     => 0x81F3,
	GL_EYE_POINT_SGIS                                   => 0x81F4,
	GL_OBJECT_POINT_SGIS                                => 0x81F5,
	GL_EYE_LINE_SGIS                                    => 0x81F6,
	GL_OBJECT_LINE_SGIS                                 => 0x81F7,
	GL_TEXTURE_COLOR_WRITEMASK_SGIS                     => 0x81EF,
	GL_DOT3_RGB_EXT                                     => 0x8740,
	GL_DOT3_RGBA_EXT                                    => 0x8741,
	GL_MIRROR_CLAMP_ATI                                 => 0x8742,
	GL_MIRROR_CLAMP_TO_EDGE_ATI                         => 0x8743,
	GL_ALL_COMPLETED_NV                                 => 0x84F2,
	GL_FENCE_STATUS_NV                                  => 0x84F3,
	GL_FENCE_CONDITION_NV                               => 0x84F4,
	GL_MIRRORED_REPEAT_IBM                              => 0x8370,
	GL_EVAL_2D_NV                                       => 0x86C0,
	GL_EVAL_TRIANGULAR_2D_NV                            => 0x86C1,
	GL_MAP_TESSELLATION_NV                              => 0x86C2,
	GL_MAP_ATTRIB_U_ORDER_NV                            => 0x86C3,
	GL_MAP_ATTRIB_V_ORDER_NV                            => 0x86C4,
	GL_EVAL_FRACTIONAL_TESSELLATION_NV                  => 0x86C5,
	GL_EVAL_VERTEX_ATTRIB0_NV                           => 0x86C6,
	GL_EVAL_VERTEX_ATTRIB1_NV                           => 0x86C7,
	GL_EVAL_VERTEX_ATTRIB2_NV                           => 0x86C8,
	GL_EVAL_VERTEX_ATTRIB3_NV                           => 0x86C9,
	GL_EVAL_VERTEX_ATTRIB4_NV                           => 0x86CA,
	GL_EVAL_VERTEX_ATTRIB5_NV                           => 0x86CB,
	GL_EVAL_VERTEX_ATTRIB6_NV                           => 0x86CC,
	GL_EVAL_VERTEX_ATTRIB7_NV                           => 0x86CD,
	GL_EVAL_VERTEX_ATTRIB8_NV                           => 0x86CE,
	GL_EVAL_VERTEX_ATTRIB9_NV                           => 0x86CF,
	GL_EVAL_VERTEX_ATTRIB10_NV                          => 0x86D0,
	GL_EVAL_VERTEX_ATTRIB11_NV                          => 0x86D1,
	GL_EVAL_VERTEX_ATTRIB12_NV                          => 0x86D2,
	GL_EVAL_VERTEX_ATTRIB13_NV                          => 0x86D3,
	GL_EVAL_VERTEX_ATTRIB14_NV                          => 0x86D4,
	GL_EVAL_VERTEX_ATTRIB15_NV                          => 0x86D5,
	GL_MAX_MAP_TESSELLATION_NV                          => 0x86D6,
	GL_MAX_RATIONAL_EVAL_ORDER_NV                       => 0x86D7,
	GL_DEPTH_STENCIL_NV                                 => 0x84F9,
	GL_UNSIGNED_INT_24_8_NV                             => 0x84FA,
	GL_PER_STAGE_CONSTANTS_NV                           => 0x8535,
	GL_TEXTURE_RECTANGLE_NV                             => 0x84F5,
	GL_TEXTURE_BINDING_RECTANGLE_NV                     => 0x84F6,
	GL_PROXY_TEXTURE_RECTANGLE_NV                       => 0x84F7,
	GL_MAX_RECTANGLE_TEXTURE_SIZE_NV                    => 0x84F8,
	GL_OFFSET_TEXTURE_RECTANGLE_NV                      => 0x864C,
	GL_OFFSET_TEXTURE_RECTANGLE_SCALE_NV                => 0x864D,
	GL_DOT_PRODUCT_TEXTURE_RECTANGLE_NV                 => 0x864E,
	GL_RGBA_UNSIGNED_DOT_PRODUCT_MAPPING_NV             => 0x86D9,
	GL_UNSIGNED_INT_S8_S8_8_8_NV                        => 0x86DA,
	GL_UNSIGNED_INT_8_8_S8_S8_REV_NV                    => 0x86DB,
	GL_DSDT_MAG_INTENSITY_NV                            => 0x86DC,
	GL_SHADER_CONSISTENT_NV                             => 0x86DD,
	GL_TEXTURE_SHADER_NV                                => 0x86DE,
	GL_SHADER_OPERATION_NV                              => 0x86DF,
	GL_CULL_MODES_NV                                    => 0x86E0,
	GL_OFFSET_TEXTURE_MATRIX_NV                         => 0x86E1,
	GL_OFFSET_TEXTURE_SCALE_NV                          => 0x86E2,
	GL_OFFSET_TEXTURE_BIAS_NV                           => 0x86E3,
	GL_OFFSET_TEXTURE_2D_MATRIX_NV                      => 0x86E1,
	GL_OFFSET_TEXTURE_2D_SCALE_NV                       => 0x86E2,
	GL_OFFSET_TEXTURE_2D_BIAS_NV                        => 0x86E3,
	GL_PREVIOUS_TEXTURE_INPUT_NV                        => 0x86E4,
	GL_CONST_EYE_NV                                     => 0x86E5,
	GL_PASS_THROUGH_NV                                  => 0x86E6,
	GL_CULL_FRAGMENT_NV                                 => 0x86E7,
	GL_OFFSET_TEXTURE_2D_NV                             => 0x86E8,
	GL_DEPENDENT_AR_TEXTURE_2D_NV                       => 0x86E9,
	GL_DEPENDENT_GB_TEXTURE_2D_NV                       => 0x86EA,
	GL_DOT_PRODUCT_NV                                   => 0x86EC,
	GL_DOT_PRODUCT_DEPTH_REPLACE_NV                     => 0x86ED,
	GL_DOT_PRODUCT_TEXTURE_2D_NV                        => 0x86EE,
	GL_DOT_PRODUCT_TEXTURE_CUBE_MAP_NV                  => 0x86F0,
	GL_DOT_PRODUCT_DIFFUSE_CUBE_MAP_NV                  => 0x86F1,
	GL_DOT_PRODUCT_REFLECT_CUBE_MAP_NV                  => 0x86F2,
	GL_DOT_PRODUCT_CONST_EYE_REFLECT_CUBE_MAP_NV        => 0x86F3,
	GL_HILO_NV                                          => 0x86F4,
	GL_DSDT_NV                                          => 0x86F5,
	GL_DSDT_MAG_NV                                      => 0x86F6,
	GL_DSDT_MAG_VIB_NV                                  => 0x86F7,
	GL_HILO16_NV                                        => 0x86F8,
	GL_SIGNED_HILO_NV                                   => 0x86F9,
	GL_SIGNED_HILO16_NV                                 => 0x86FA,
	GL_SIGNED_RGBA_NV                                   => 0x86FB,
	GL_SIGNED_RGBA8_NV                                  => 0x86FC,
	GL_SIGNED_RGB_NV                                    => 0x86FE,
	GL_SIGNED_RGB8_NV                                   => 0x86FF,
	GL_SIGNED_LUMINANCE_NV                              => 0x8701,
	GL_SIGNED_LUMINANCE8_NV                             => 0x8702,
	GL_SIGNED_LUMINANCE_ALPHA_NV                        => 0x8703,
	GL_SIGNED_LUMINANCE8_ALPHA8_NV                      => 0x8704,
	GL_SIGNED_ALPHA_NV                                  => 0x8705,
	GL_SIGNED_ALPHA8_NV                                 => 0x8706,
	GL_SIGNED_INTENSITY_NV                              => 0x8707,
	GL_SIGNED_INTENSITY8_NV                             => 0x8708,
	GL_DSDT8_NV                                         => 0x8709,
	GL_DSDT8_MAG8_NV                                    => 0x870A,
	GL_DSDT8_MAG8_INTENSITY8_NV                         => 0x870B,
	GL_SIGNED_RGB_UNSIGNED_ALPHA_NV                     => 0x870C,
	GL_SIGNED_RGB8_UNSIGNED_ALPHA8_NV                   => 0x870D,
	GL_HI_SCALE_NV                                      => 0x870E,
	GL_LO_SCALE_NV                                      => 0x870F,
	GL_DS_SCALE_NV                                      => 0x8710,
	GL_DT_SCALE_NV                                      => 0x8711,
	GL_MAGNITUDE_SCALE_NV                               => 0x8712,
	GL_VIBRANCE_SCALE_NV                                => 0x8713,
	GL_HI_BIAS_NV                                       => 0x8714,
	GL_LO_BIAS_NV                                       => 0x8715,
	GL_DS_BIAS_NV                                       => 0x8716,
	GL_DT_BIAS_NV                                       => 0x8717,
	GL_MAGNITUDE_BIAS_NV                                => 0x8718,
	GL_VIBRANCE_BIAS_NV                                 => 0x8719,
	GL_TEXTURE_BORDER_VALUES_NV                         => 0x871A,
	GL_TEXTURE_HI_SIZE_NV                               => 0x871B,
	GL_TEXTURE_LO_SIZE_NV                               => 0x871C,
	GL_TEXTURE_DS_SIZE_NV                               => 0x871D,
	GL_TEXTURE_DT_SIZE_NV                               => 0x871E,
	GL_TEXTURE_MAG_SIZE_NV                              => 0x871F,
	GL_DOT_PRODUCT_TEXTURE_3D_NV                        => 0x86EF,
	GL_VERTEX_ARRAY_RANGE_WITHOUT_FLUSH_NV              => 0x8533,
	GL_VERTEX_PROGRAM_NV                                => 0x8620,
	GL_VERTEX_STATE_PROGRAM_NV                          => 0x8621,
	GL_ATTRIB_ARRAY_SIZE_NV                             => 0x8623,
	GL_ATTRIB_ARRAY_STRIDE_NV                           => 0x8624,
	GL_ATTRIB_ARRAY_TYPE_NV                             => 0x8625,
	GL_CURRENT_ATTRIB_NV                                => 0x8626,
	GL_PROGRAM_LENGTH_NV                                => 0x8627,
	GL_PROGRAM_STRING_NV                                => 0x8628,
	GL_MODELVIEW_PROJECTION_NV                          => 0x8629,
	GL_IDENTITY_NV                                      => 0x862A,
	GL_INVERSE_NV                                       => 0x862B,
	GL_TRANSPOSE_NV                                     => 0x862C,
	GL_INVERSE_TRANSPOSE_NV                             => 0x862D,
	GL_MAX_TRACK_MATRIX_STACK_DEPTH_NV                  => 0x862E,
	GL_MAX_TRACK_MATRICES_NV                            => 0x862F,
	GL_MATRIX0_NV                                       => 0x8630,
	GL_MATRIX1_NV                                       => 0x8631,
	GL_MATRIX2_NV                                       => 0x8632,
	GL_MATRIX3_NV                                       => 0x8633,
	GL_MATRIX4_NV                                       => 0x8634,
	GL_MATRIX5_NV                                       => 0x8635,
	GL_MATRIX6_NV                                       => 0x8636,
	GL_MATRIX7_NV                                       => 0x8637,
	GL_CURRENT_MATRIX_STACK_DEPTH_NV                    => 0x8640,
	GL_CURRENT_MATRIX_NV                                => 0x8641,
	GL_VERTEX_PROGRAM_POINT_SIZE_NV                     => 0x8642,
	GL_VERTEX_PROGRAM_TWO_SIDE_NV                       => 0x8643,
	GL_PROGRAM_PARAMETER_NV                             => 0x8644,
	GL_ATTRIB_ARRAY_POINTER_NV                          => 0x8645,
	GL_PROGRAM_TARGET_NV                                => 0x8646,
	GL_PROGRAM_RESIDENT_NV                              => 0x8647,
	GL_TRACK_MATRIX_NV                                  => 0x8648,
	GL_TRACK_MATRIX_TRANSFORM_NV                        => 0x8649,
	GL_VERTEX_PROGRAM_BINDING_NV                        => 0x864A,
	GL_PROGRAM_ERROR_POSITION_NV                        => 0x864B,
	GL_VERTEX_ATTRIB_ARRAY0_NV                          => 0x8650,
	GL_VERTEX_ATTRIB_ARRAY1_NV                          => 0x8651,
	GL_VERTEX_ATTRIB_ARRAY2_NV                          => 0x8652,
	GL_VERTEX_ATTRIB_ARRAY3_NV                          => 0x8653,
	GL_VERTEX_ATTRIB_ARRAY4_NV                          => 0x8654,
	GL_VERTEX_ATTRIB_ARRAY5_NV                          => 0x8655,
	GL_VERTEX_ATTRIB_ARRAY6_NV                          => 0x8656,
	GL_VERTEX_ATTRIB_ARRAY7_NV                          => 0x8657,
	GL_VERTEX_ATTRIB_ARRAY8_NV                          => 0x8658,
	GL_VERTEX_ATTRIB_ARRAY9_NV                          => 0x8659,
	GL_VERTEX_ATTRIB_ARRAY10_NV                         => 0x865A,
	GL_VERTEX_ATTRIB_ARRAY11_NV                         => 0x865B,
	GL_VERTEX_ATTRIB_ARRAY12_NV                         => 0x865C,
	GL_VERTEX_ATTRIB_ARRAY13_NV                         => 0x865D,
	GL_VERTEX_ATTRIB_ARRAY14_NV                         => 0x865E,
	GL_VERTEX_ATTRIB_ARRAY15_NV                         => 0x865F,
	GL_MAP1_VERTEX_ATTRIB0_4_NV                         => 0x8660,
	GL_MAP1_VERTEX_ATTRIB1_4_NV                         => 0x8661,
	GL_MAP1_VERTEX_ATTRIB2_4_NV                         => 0x8662,
	GL_MAP1_VERTEX_ATTRIB3_4_NV                         => 0x8663,
	GL_MAP1_VERTEX_ATTRIB4_4_NV                         => 0x8664,
	GL_MAP1_VERTEX_ATTRIB5_4_NV                         => 0x8665,
	GL_MAP1_VERTEX_ATTRIB6_4_NV                         => 0x8666,
	GL_MAP1_VERTEX_ATTRIB7_4_NV                         => 0x8667,
	GL_MAP1_VERTEX_ATTRIB8_4_NV                         => 0x8668,
	GL_MAP1_VERTEX_ATTRIB9_4_NV                         => 0x8669,
	GL_MAP1_VERTEX_ATTRIB10_4_NV                        => 0x866A,
	GL_MAP1_VERTEX_ATTRIB11_4_NV                        => 0x866B,
	GL_MAP1_VERTEX_ATTRIB12_4_NV                        => 0x866C,
	GL_MAP1_VERTEX_ATTRIB13_4_NV                        => 0x866D,
	GL_MAP1_VERTEX_ATTRIB14_4_NV                        => 0x866E,
	GL_MAP1_VERTEX_ATTRIB15_4_NV                        => 0x866F,
	GL_MAP2_VERTEX_ATTRIB0_4_NV                         => 0x8670,
	GL_MAP2_VERTEX_ATTRIB1_4_NV                         => 0x8671,
	GL_MAP2_VERTEX_ATTRIB2_4_NV                         => 0x8672,
	GL_MAP2_VERTEX_ATTRIB3_4_NV                         => 0x8673,
	GL_MAP2_VERTEX_ATTRIB4_4_NV                         => 0x8674,
	GL_MAP2_VERTEX_ATTRIB5_4_NV                         => 0x8675,
	GL_MAP2_VERTEX_ATTRIB6_4_NV                         => 0x8676,
	GL_MAP2_VERTEX_ATTRIB7_4_NV                         => 0x8677,
	GL_MAP2_VERTEX_ATTRIB8_4_NV                         => 0x8678,
	GL_MAP2_VERTEX_ATTRIB9_4_NV                         => 0x8679,
	GL_MAP2_VERTEX_ATTRIB10_4_NV                        => 0x867A,
	GL_MAP2_VERTEX_ATTRIB11_4_NV                        => 0x867B,
	GL_MAP2_VERTEX_ATTRIB12_4_NV                        => 0x867C,
	GL_MAP2_VERTEX_ATTRIB13_4_NV                        => 0x867D,
	GL_MAP2_VERTEX_ATTRIB14_4_NV                        => 0x867E,
	GL_MAP2_VERTEX_ATTRIB15_4_NV                        => 0x867F,
	GL_TEXTURE_MAX_CLAMP_S_SGIX                         => 0x8369,
	GL_TEXTURE_MAX_CLAMP_T_SGIX                         => 0x836A,
	GL_TEXTURE_MAX_CLAMP_R_SGIX                         => 0x836B,
	GL_SCALEBIAS_HINT_SGIX                              => 0x8322,
	GL_INTERLACE_OML                                    => 0x8980,
	GL_INTERLACE_READ_OML                               => 0x8981,
	GL_FORMAT_SUBSAMPLE_24_24_OML                       => 0x8982,
	GL_FORMAT_SUBSAMPLE_244_244_OML                     => 0x8983,
	GL_PACK_RESAMPLE_OML                                => 0x8984,
	GL_UNPACK_RESAMPLE_OML                              => 0x8985,
	GL_RESAMPLE_REPLICATE_OML                           => 0x8986,
	GL_RESAMPLE_ZERO_FILL_OML                           => 0x8987,
	GL_RESAMPLE_AVERAGE_OML                             => 0x8988,
	GL_RESAMPLE_DECIMATE_OML                            => 0x8989,
	GL_DEPTH_STENCIL_TO_RGBA_NV                         => 0x886E,
	GL_DEPTH_STENCIL_TO_BGRA_NV                         => 0x886F,
	GL_BUMP_ROT_MATRIX_ATI                              => 0x8775,
	GL_BUMP_ROT_MATRIX_SIZE_ATI                         => 0x8776,
	GL_BUMP_NUM_TEX_UNITS_ATI                           => 0x8777,
	GL_BUMP_TEX_UNITS_ATI                               => 0x8778,
	GL_DUDV_ATI                                         => 0x8779,
	GL_DU8DV8_ATI                                       => 0x877A,
	GL_BUMP_ENVMAP_ATI                                  => 0x877B,
	GL_BUMP_TARGET_ATI                                  => 0x877C,
	GL_FRAGMENT_SHADER_ATI                              => 0x8920,
	GL_REG_0_ATI                                        => 0x8921,
	GL_REG_1_ATI                                        => 0x8922,
	GL_REG_2_ATI                                        => 0x8923,
	GL_REG_3_ATI                                        => 0x8924,
	GL_REG_4_ATI                                        => 0x8925,
	GL_REG_5_ATI                                        => 0x8926,
	GL_REG_6_ATI                                        => 0x8927,
	GL_REG_7_ATI                                        => 0x8928,
	GL_REG_8_ATI                                        => 0x8929,
	GL_REG_9_ATI                                        => 0x892A,
	GL_REG_10_ATI                                       => 0x892B,
	GL_REG_11_ATI                                       => 0x892C,
	GL_REG_12_ATI                                       => 0x892D,
	GL_REG_13_ATI                                       => 0x892E,
	GL_REG_14_ATI                                       => 0x892F,
	GL_REG_15_ATI                                       => 0x8930,
	GL_REG_16_ATI                                       => 0x8931,
	GL_REG_17_ATI                                       => 0x8932,
	GL_REG_18_ATI                                       => 0x8933,
	GL_REG_19_ATI                                       => 0x8934,
	GL_REG_20_ATI                                       => 0x8935,
	GL_REG_21_ATI                                       => 0x8936,
	GL_REG_22_ATI                                       => 0x8937,
	GL_REG_23_ATI                                       => 0x8938,
	GL_REG_24_ATI                                       => 0x8939,
	GL_REG_25_ATI                                       => 0x893A,
	GL_REG_26_ATI                                       => 0x893B,
	GL_REG_27_ATI                                       => 0x893C,
	GL_REG_28_ATI                                       => 0x893D,
	GL_REG_29_ATI                                       => 0x893E,
	GL_REG_30_ATI                                       => 0x893F,
	GL_REG_31_ATI                                       => 0x8940,
	GL_CON_0_ATI                                        => 0x8941,
	GL_CON_1_ATI                                        => 0x8942,
	GL_CON_2_ATI                                        => 0x8943,
	GL_CON_3_ATI                                        => 0x8944,
	GL_CON_4_ATI                                        => 0x8945,
	GL_CON_5_ATI                                        => 0x8946,
	GL_CON_6_ATI                                        => 0x8947,
	GL_CON_7_ATI                                        => 0x8948,
	GL_CON_8_ATI                                        => 0x8949,
	GL_CON_9_ATI                                        => 0x894A,
	GL_CON_10_ATI                                       => 0x894B,
	GL_CON_11_ATI                                       => 0x894C,
	GL_CON_12_ATI                                       => 0x894D,
	GL_CON_13_ATI                                       => 0x894E,
	GL_CON_14_ATI                                       => 0x894F,
	GL_CON_15_ATI                                       => 0x8950,
	GL_CON_16_ATI                                       => 0x8951,
	GL_CON_17_ATI                                       => 0x8952,
	GL_CON_18_ATI                                       => 0x8953,
	GL_CON_19_ATI                                       => 0x8954,
	GL_CON_20_ATI                                       => 0x8955,
	GL_CON_21_ATI                                       => 0x8956,
	GL_CON_22_ATI                                       => 0x8957,
	GL_CON_23_ATI                                       => 0x8958,
	GL_CON_24_ATI                                       => 0x8959,
	GL_CON_25_ATI                                       => 0x895A,
	GL_CON_26_ATI                                       => 0x895B,
	GL_CON_27_ATI                                       => 0x895C,
	GL_CON_28_ATI                                       => 0x895D,
	GL_CON_29_ATI                                       => 0x895E,
	GL_CON_30_ATI                                       => 0x895F,
	GL_CON_31_ATI                                       => 0x8960,
	GL_MOV_ATI                                          => 0x8961,
	GL_ADD_ATI                                          => 0x8963,
	GL_MUL_ATI                                          => 0x8964,
	GL_SUB_ATI                                          => 0x8965,
	GL_DOT3_ATI                                         => 0x8966,
	GL_DOT4_ATI                                         => 0x8967,
	GL_MAD_ATI                                          => 0x8968,
	GL_LERP_ATI                                         => 0x8969,
	GL_CND_ATI                                          => 0x896A,
	GL_CND0_ATI                                         => 0x896B,
	GL_DOT2_ADD_ATI                                     => 0x896C,
	GL_SECONDARY_INTERPOLATOR_ATI                       => 0x896D,
	GL_NUM_FRAGMENT_REGISTERS_ATI                       => 0x896E,
	GL_NUM_FRAGMENT_CONSTANTS_ATI                       => 0x896F,
	GL_NUM_PASSES_ATI                                   => 0x8970,
	GL_NUM_INSTRUCTIONS_PER_PASS_ATI                    => 0x8971,
	GL_NUM_INSTRUCTIONS_TOTAL_ATI                       => 0x8972,
	GL_NUM_INPUT_INTERPOLATOR_COMPONENTS_ATI            => 0x8973,
	GL_NUM_LOOPBACK_COMPONENTS_ATI                      => 0x8974,
	GL_COLOR_ALPHA_PAIRING_ATI                          => 0x8975,
	GL_SWIZZLE_STR_ATI                                  => 0x8976,
	GL_SWIZZLE_STQ_ATI                                  => 0x8977,
	GL_SWIZZLE_STR_DR_ATI                               => 0x8978,
	GL_SWIZZLE_STQ_DQ_ATI                               => 0x8979,
	GL_SWIZZLE_STRQ_ATI                                 => 0x897A,
	GL_SWIZZLE_STRQ_DQ_ATI                              => 0x897B,
	GL_RED_BIT_ATI                                      => 0x00000001,
	GL_GREEN_BIT_ATI                                    => 0x00000002,
	GL_BLUE_BIT_ATI                                     => 0x00000004,
	GL_2X_BIT_ATI                                       => 0x00000001,
	GL_4X_BIT_ATI                                       => 0x00000002,
	GL_8X_BIT_ATI                                       => 0x00000004,
	GL_HALF_BIT_ATI                                     => 0x00000008,
	GL_QUARTER_BIT_ATI                                  => 0x00000010,
	GL_EIGHTH_BIT_ATI                                   => 0x00000020,
	GL_SATURATE_BIT_ATI                                 => 0x00000040,
	GL_COMP_BIT_ATI                                     => 0x00000002,
	GL_NEGATE_BIT_ATI                                   => 0x00000004,
	GL_BIAS_BIT_ATI                                     => 0x00000008,
	GL_PN_TRIANGLES_ATI                                 => 0x87F0,
	GL_MAX_PN_TRIANGLES_TESSELATION_LEVEL_ATI           => 0x87F1,
	GL_PN_TRIANGLES_POINT_MODE_ATI                      => 0x87F2,
	GL_PN_TRIANGLES_NORMAL_MODE_ATI                     => 0x87F3,
	GL_PN_TRIANGLES_TESSELATION_LEVEL_ATI               => 0x87F4,
	GL_PN_TRIANGLES_POINT_MODE_LINEAR_ATI               => 0x87F5,
	GL_PN_TRIANGLES_POINT_MODE_CUBIC_ATI                => 0x87F6,
	GL_PN_TRIANGLES_NORMAL_MODE_LINEAR_ATI              => 0x87F7,
	GL_PN_TRIANGLES_NORMAL_MODE_QUADRATIC_ATI           => 0x87F8,
	GL_STATIC_ATI                                       => 0x8760,
	GL_DYNAMIC_ATI                                      => 0x8761,
	GL_PRESERVE_ATI                                     => 0x8762,
	GL_DISCARD_ATI                                      => 0x8763,
	GL_OBJECT_BUFFER_SIZE_ATI                           => 0x8764,
	GL_OBJECT_BUFFER_USAGE_ATI                          => 0x8765,
	GL_ARRAY_OBJECT_BUFFER_ATI                          => 0x8766,
	GL_ARRAY_OBJECT_OFFSET_ATI                          => 0x8767,
	GL_VERTEX_SHADER_EXT                                => 0x8780,
	GL_VERTEX_SHADER_BINDING_EXT                        => 0x8781,
	GL_OP_INDEX_EXT                                     => 0x8782,
	GL_OP_NEGATE_EXT                                    => 0x8783,
	GL_OP_DOT3_EXT                                      => 0x8784,
	GL_OP_DOT4_EXT                                      => 0x8785,
	GL_OP_MUL_EXT                                       => 0x8786,
	GL_OP_ADD_EXT                                       => 0x8787,
	GL_OP_MADD_EXT                                      => 0x8788,
	GL_OP_FRAC_EXT                                      => 0x8789,
	GL_OP_MAX_EXT                                       => 0x878A,
	GL_OP_MIN_EXT                                       => 0x878B,
	GL_OP_SET_GE_EXT                                    => 0x878C,
	GL_OP_SET_LT_EXT                                    => 0x878D,
	GL_OP_CLAMP_EXT                                     => 0x878E,
	GL_OP_FLOOR_EXT                                     => 0x878F,
	GL_OP_ROUND_EXT                                     => 0x8790,
	GL_OP_EXP_BASE_2_EXT                                => 0x8791,
	GL_OP_LOG_BASE_2_EXT                                => 0x8792,
	GL_OP_POWER_EXT                                     => 0x8793,
	GL_OP_RECIP_EXT                                     => 0x8794,
	GL_OP_RECIP_SQRT_EXT                                => 0x8795,
	GL_OP_SUB_EXT                                       => 0x8796,
	GL_OP_CROSS_PRODUCT_EXT                             => 0x8797,
	GL_OP_MULTIPLY_MATRIX_EXT                           => 0x8798,
	GL_OP_MOV_EXT                                       => 0x8799,
	GL_OUTPUT_VERTEX_EXT                                => 0x879A,
	GL_OUTPUT_COLOR0_EXT                                => 0x879B,
	GL_OUTPUT_COLOR1_EXT                                => 0x879C,
	GL_OUTPUT_TEXTURE_COORD0_EXT                        => 0x879D,
	GL_OUTPUT_TEXTURE_COORD1_EXT                        => 0x879E,
	GL_OUTPUT_TEXTURE_COORD2_EXT                        => 0x879F,
	GL_OUTPUT_TEXTURE_COORD3_EXT                        => 0x87A0,
	GL_OUTPUT_TEXTURE_COORD4_EXT                        => 0x87A1,
	GL_OUTPUT_TEXTURE_COORD5_EXT                        => 0x87A2,
	GL_OUTPUT_TEXTURE_COORD6_EXT                        => 0x87A3,
	GL_OUTPUT_TEXTURE_COORD7_EXT                        => 0x87A4,
	GL_OUTPUT_TEXTURE_COORD8_EXT                        => 0x87A5,
	GL_OUTPUT_TEXTURE_COORD9_EXT                        => 0x87A6,
	GL_OUTPUT_TEXTURE_COORD10_EXT                       => 0x87A7,
	GL_OUTPUT_TEXTURE_COORD11_EXT                       => 0x87A8,
	GL_OUTPUT_TEXTURE_COORD12_EXT                       => 0x87A9,
	GL_OUTPUT_TEXTURE_COORD13_EXT                       => 0x87AA,
	GL_OUTPUT_TEXTURE_COORD14_EXT                       => 0x87AB,
	GL_OUTPUT_TEXTURE_COORD15_EXT                       => 0x87AC,
	GL_OUTPUT_TEXTURE_COORD16_EXT                       => 0x87AD,
	GL_OUTPUT_TEXTURE_COORD17_EXT                       => 0x87AE,
	GL_OUTPUT_TEXTURE_COORD18_EXT                       => 0x87AF,
	GL_OUTPUT_TEXTURE_COORD19_EXT                       => 0x87B0,
	GL_OUTPUT_TEXTURE_COORD20_EXT                       => 0x87B1,
	GL_OUTPUT_TEXTURE_COORD21_EXT                       => 0x87B2,
	GL_OUTPUT_TEXTURE_COORD22_EXT                       => 0x87B3,
	GL_OUTPUT_TEXTURE_COORD23_EXT                       => 0x87B4,
	GL_OUTPUT_TEXTURE_COORD24_EXT                       => 0x87B5,
	GL_OUTPUT_TEXTURE_COORD25_EXT                       => 0x87B6,
	GL_OUTPUT_TEXTURE_COORD26_EXT                       => 0x87B7,
	GL_OUTPUT_TEXTURE_COORD27_EXT                       => 0x87B8,
	GL_OUTPUT_TEXTURE_COORD28_EXT                       => 0x87B9,
	GL_OUTPUT_TEXTURE_COORD29_EXT                       => 0x87BA,
	GL_OUTPUT_TEXTURE_COORD30_EXT                       => 0x87BB,
	GL_OUTPUT_TEXTURE_COORD31_EXT                       => 0x87BC,
	GL_OUTPUT_FOG_EXT                                   => 0x87BD,
	GL_SCALAR_EXT                                       => 0x87BE,
	GL_VECTOR_EXT                                       => 0x87BF,
	GL_MATRIX_EXT                                       => 0x87C0,
	GL_VARIANT_EXT                                      => 0x87C1,
	GL_INVARIANT_EXT                                    => 0x87C2,
	GL_LOCAL_CONSTANT_EXT                               => 0x87C3,
	GL_LOCAL_EXT                                        => 0x87C4,
	GL_MAX_VERTEX_SHADER_INSTRUCTIONS_EXT               => 0x87C5,
	GL_MAX_VERTEX_SHADER_VARIANTS_EXT                   => 0x87C6,
	GL_MAX_VERTEX_SHADER_INVARIANTS_EXT                 => 0x87C7,
	GL_MAX_VERTEX_SHADER_LOCAL_CONSTANTS_EXT            => 0x87C8,
	GL_MAX_VERTEX_SHADER_LOCALS_EXT                     => 0x87C9,
	GL_MAX_OPTIMIZED_VERTEX_SHADER_INSTRUCTIONS_EXT     => 0x87CA,
	GL_MAX_OPTIMIZED_VERTEX_SHADER_VARIANTS_EXT         => 0x87CB,
	GL_MAX_OPTIMIZED_VERTEX_SHADER_LOCAL_CONSTANTS_EXT  => 0x87CC,
	GL_MAX_OPTIMIZED_VERTEX_SHADER_INVARIANTS_EXT       => 0x87CD,
	GL_MAX_OPTIMIZED_VERTEX_SHADER_LOCALS_EXT           => 0x87CE,
	GL_VERTEX_SHADER_INSTRUCTIONS_EXT                   => 0x87CF,
	GL_VERTEX_SHADER_VARIANTS_EXT                       => 0x87D0,
	GL_VERTEX_SHADER_INVARIANTS_EXT                     => 0x87D1,
	GL_VERTEX_SHADER_LOCAL_CONSTANTS_EXT                => 0x87D2,
	GL_VERTEX_SHADER_LOCALS_EXT                         => 0x87D3,
	GL_VERTEX_SHADER_OPTIMIZED_EXT                      => 0x87D4,
	GL_X_EXT                                            => 0x87D5,
	GL_Y_EXT                                            => 0x87D6,
	GL_Z_EXT                                            => 0x87D7,
	GL_W_EXT                                            => 0x87D8,
	GL_NEGATIVE_X_EXT                                   => 0x87D9,
	GL_NEGATIVE_Y_EXT                                   => 0x87DA,
	GL_NEGATIVE_Z_EXT                                   => 0x87DB,
	GL_NEGATIVE_W_EXT                                   => 0x87DC,
	GL_ZERO_EXT                                         => 0x87DD,
	GL_ONE_EXT                                          => 0x87DE,
	GL_NEGATIVE_ONE_EXT                                 => 0x87DF,
	GL_NORMALIZED_RANGE_EXT                             => 0x87E0,
	GL_FULL_RANGE_EXT                                   => 0x87E1,
	GL_CURRENT_VERTEX_EXT                               => 0x87E2,
	GL_MVP_MATRIX_EXT                                   => 0x87E3,
	GL_VARIANT_VALUE_EXT                                => 0x87E4,
	GL_VARIANT_DATATYPE_EXT                             => 0x87E5,
	GL_VARIANT_ARRAY_STRIDE_EXT                         => 0x87E6,
	GL_VARIANT_ARRAY_TYPE_EXT                           => 0x87E7,
	GL_VARIANT_ARRAY_EXT                                => 0x87E8,
	GL_VARIANT_ARRAY_POINTER_EXT                        => 0x87E9,
	GL_INVARIANT_VALUE_EXT                              => 0x87EA,
	GL_INVARIANT_DATATYPE_EXT                           => 0x87EB,
	GL_LOCAL_CONSTANT_VALUE_EXT                         => 0x87EC,
	GL_LOCAL_CONSTANT_DATATYPE_EXT                      => 0x87ED,
	GL_MAX_VERTEX_STREAMS_ATI                           => 0x876B,
	GL_VERTEX_STREAM0_ATI                               => 0x876C,
	GL_VERTEX_STREAM1_ATI                               => 0x876D,
	GL_VERTEX_STREAM2_ATI                               => 0x876E,
	GL_VERTEX_STREAM3_ATI                               => 0x876F,
	GL_VERTEX_STREAM4_ATI                               => 0x8770,
	GL_VERTEX_STREAM5_ATI                               => 0x8771,
	GL_VERTEX_STREAM6_ATI                               => 0x8772,
	GL_VERTEX_STREAM7_ATI                               => 0x8773,
	GL_VERTEX_SOURCE_ATI                                => 0x8774,
	GL_ELEMENT_ARRAY_ATI                                => 0x8768,
	GL_ELEMENT_ARRAY_TYPE_ATI                           => 0x8769,
	GL_ELEMENT_ARRAY_POINTER_ATI                        => 0x876A,
	GL_QUAD_MESH_SUN                                    => 0x8614,
	GL_TRIANGLE_MESH_SUN                                => 0x8615,
	GL_SLICE_ACCUM_SUN                                  => 0x85CC,
	GL_MULTISAMPLE_FILTER_HINT_NV                       => 0x8534,
	GL_DEPTH_CLAMP_NV                                   => 0x864F,
	GL_PIXEL_COUNTER_BITS_NV                            => 0x8864,
	GL_CURRENT_OCCLUSION_QUERY_ID_NV                    => 0x8865,
	GL_PIXEL_COUNT_NV                                   => 0x8866,
	GL_PIXEL_COUNT_AVAILABLE_NV                         => 0x8867,
	GL_POINT_SPRITE_NV                                  => 0x8861,
	GL_COORD_REPLACE_NV                                 => 0x8862,
	GL_POINT_SPRITE_R_MODE_NV                           => 0x8863,
	GL_OFFSET_PROJECTIVE_TEXTURE_2D_NV                  => 0x8850,
	GL_OFFSET_PROJECTIVE_TEXTURE_2D_SCALE_NV            => 0x8851,
	GL_OFFSET_PROJECTIVE_TEXTURE_RECTANGLE_NV           => 0x8852,
	GL_OFFSET_PROJECTIVE_TEXTURE_RECTANGLE_SCALE_NV     => 0x8853,
	GL_OFFSET_HILO_TEXTURE_2D_NV                        => 0x8854,
	GL_OFFSET_HILO_TEXTURE_RECTANGLE_NV                 => 0x8855,
	GL_OFFSET_HILO_PROJECTIVE_TEXTURE_2D_NV             => 0x8856,
	GL_OFFSET_HILO_PROJECTIVE_TEXTURE_RECTANGLE_NV      => 0x8857,
	GL_DEPENDENT_HILO_TEXTURE_2D_NV                     => 0x8858,
	GL_DEPENDENT_RGB_TEXTURE_3D_NV                      => 0x8859,
	GL_DEPENDENT_RGB_TEXTURE_CUBE_MAP_NV                => 0x885A,
	GL_DOT_PRODUCT_PASS_THROUGH_NV                      => 0x885B,
	GL_DOT_PRODUCT_TEXTURE_1D_NV                        => 0x885C,
	GL_DOT_PRODUCT_AFFINE_DEPTH_REPLACE_NV              => 0x885D,
	GL_HILO8_NV                                         => 0x885E,
	GL_SIGNED_HILO8_NV                                  => 0x885F,
	GL_FORCE_BLUE_TO_ONE_NV                             => 0x8860,
	GL_STENCIL_TEST_TWO_SIDE_EXT                        => 0x8910,
	GL_ACTIVE_STENCIL_FACE_EXT                          => 0x8911,
	GL_TEXT_FRAGMENT_SHADER_ATI                         => 0x8200,
	GL_UNPACK_CLIENT_STORAGE_APPLE                      => 0x85B2,
	GL_ELEMENT_ARRAY_APPLE                              => 0x8768,
	GL_ELEMENT_ARRAY_TYPE_APPLE                         => 0x8769,
	GL_ELEMENT_ARRAY_POINTER_APPLE                      => 0x876A,
	GL_DRAW_PIXELS_APPLE                                => 0x8A0A,
	GL_FENCE_APPLE                                      => 0x8A0B,
	GL_VERTEX_ARRAY_BINDING_APPLE                       => 0x85B5,
	GL_VERTEX_ARRAY_RANGE_APPLE                         => 0x851D,
	GL_VERTEX_ARRAY_RANGE_LENGTH_APPLE                  => 0x851E,
	GL_VERTEX_ARRAY_STORAGE_HINT_APPLE                  => 0x851F,
	GL_VERTEX_ARRAY_RANGE_POINTER_APPLE                 => 0x8521,
	GL_STORAGE_CACHED_APPLE                             => 0x85BE,
	GL_STORAGE_SHARED_APPLE                             => 0x85BF,
	GL_YCBCR_422_APPLE                                  => 0x85B9,
	GL_UNSIGNED_SHORT_8_8_APPLE                         => 0x85BA,
	GL_UNSIGNED_SHORT_8_8_REV_APPLE                     => 0x85BB,
	GL_RGB_S3TC                                         => 0x83A0,
	GL_RGB4_S3TC                                        => 0x83A1,
	GL_RGBA_S3TC                                        => 0x83A2,
	GL_RGBA4_S3TC                                       => 0x83A3,
	GL_MAX_DRAW_BUFFERS_ATI                             => 0x8824,
	GL_DRAW_BUFFER0_ATI                                 => 0x8825,
	GL_DRAW_BUFFER1_ATI                                 => 0x8826,
	GL_DRAW_BUFFER2_ATI                                 => 0x8827,
	GL_DRAW_BUFFER3_ATI                                 => 0x8828,
	GL_DRAW_BUFFER4_ATI                                 => 0x8829,
	GL_DRAW_BUFFER5_ATI                                 => 0x882A,
	GL_DRAW_BUFFER6_ATI                                 => 0x882B,
	GL_DRAW_BUFFER7_ATI                                 => 0x882C,
	GL_DRAW_BUFFER8_ATI                                 => 0x882D,
	GL_DRAW_BUFFER9_ATI                                 => 0x882E,
	GL_DRAW_BUFFER10_ATI                                => 0x882F,
	GL_DRAW_BUFFER11_ATI                                => 0x8830,
	GL_DRAW_BUFFER12_ATI                                => 0x8831,
	GL_DRAW_BUFFER13_ATI                                => 0x8832,
	GL_DRAW_BUFFER14_ATI                                => 0x8833,
	GL_DRAW_BUFFER15_ATI                                => 0x8834,
	GL_TYPE_RGBA_FLOAT_ATI                              => 0x8820,
	GL_COLOR_CLEAR_UNCLAMPED_VALUE_ATI                  => 0x8835,
	GL_MODULATE_ADD_ATI                                 => 0x8744,
	GL_MODULATE_SIGNED_ADD_ATI                          => 0x8745,
	GL_MODULATE_SUBTRACT_ATI                            => 0x8746,
	GL_RGBA_FLOAT32_ATI                                 => 0x8814,
	GL_RGB_FLOAT32_ATI                                  => 0x8815,
	GL_ALPHA_FLOAT32_ATI                                => 0x8816,
	GL_INTENSITY_FLOAT32_ATI                            => 0x8817,
	GL_LUMINANCE_FLOAT32_ATI                            => 0x8818,
	GL_LUMINANCE_ALPHA_FLOAT32_ATI                      => 0x8819,
	GL_RGBA_FLOAT16_ATI                                 => 0x881A,
	GL_RGB_FLOAT16_ATI                                  => 0x881B,
	GL_ALPHA_FLOAT16_ATI                                => 0x881C,
	GL_INTENSITY_FLOAT16_ATI                            => 0x881D,
	GL_LUMINANCE_FLOAT16_ATI                            => 0x881E,
	GL_LUMINANCE_ALPHA_FLOAT16_ATI                      => 0x881F,
	GL_FLOAT_R_NV                                       => 0x8880,
	GL_FLOAT_RG_NV                                      => 0x8881,
	GL_FLOAT_RGB_NV                                     => 0x8882,
	GL_FLOAT_RGBA_NV                                    => 0x8883,
	GL_FLOAT_R16_NV                                     => 0x8884,
	GL_FLOAT_R32_NV                                     => 0x8885,
	GL_FLOAT_RG16_NV                                    => 0x8886,
	GL_FLOAT_RG32_NV                                    => 0x8887,
	GL_FLOAT_RGB16_NV                                   => 0x8888,
	GL_FLOAT_RGB32_NV                                   => 0x8889,
	GL_FLOAT_RGBA16_NV                                  => 0x888A,
	GL_FLOAT_RGBA32_NV                                  => 0x888B,
	GL_TEXTURE_FLOAT_COMPONENTS_NV                      => 0x888C,
	GL_FLOAT_CLEAR_COLOR_VALUE_NV                       => 0x888D,
	GL_FLOAT_RGBA_MODE_NV                               => 0x888E,
	GL_MAX_FRAGMENT_PROGRAM_LOCAL_PARAMETERS_NV         => 0x8868,
	GL_FRAGMENT_PROGRAM_NV                              => 0x8870,
	GL_MAX_TEXTURE_COORDS_NV                            => 0x8871,
	GL_MAX_TEXTURE_IMAGE_UNITS_NV                       => 0x8872,
	GL_FRAGMENT_PROGRAM_BINDING_NV                      => 0x8873,
	GL_PROGRAM_ERROR_STRING_NV                          => 0x8874,
	GL_HALF_FLOAT_NV                                    => 0x140B,
	GL_WRITE_PIXEL_DATA_RANGE_NV                        => 0x8878,
	GL_READ_PIXEL_DATA_RANGE_NV                         => 0x8879,
	GL_WRITE_PIXEL_DATA_RANGE_LENGTH_NV                 => 0x887A,
	GL_READ_PIXEL_DATA_RANGE_LENGTH_NV                  => 0x887B,
	GL_WRITE_PIXEL_DATA_RANGE_POINTER_NV                => 0x887C,
	GL_READ_PIXEL_DATA_RANGE_POINTER_NV                 => 0x887D,
	GL_PRIMITIVE_RESTART_NV                             => 0x8558,
	GL_PRIMITIVE_RESTART_INDEX_NV                       => 0x8559,
	GL_TEXTURE_UNSIGNED_REMAP_MODE_NV                   => 0x888F,
	GL_STENCIL_BACK_FUNC_ATI                            => 0x8800,
	GL_STENCIL_BACK_FAIL_ATI                            => 0x8801,
	GL_STENCIL_BACK_PASS_DEPTH_FAIL_ATI                 => 0x8802,
	GL_STENCIL_BACK_PASS_DEPTH_PASS_ATI                 => 0x8803,
	GL_IMPLEMENTATION_COLOR_READ_TYPE_OES               => 0x8B9A,
	GL_IMPLEMENTATION_COLOR_READ_FORMAT_OES             => 0x8B9B,
	GL_DEPTH_BOUNDS_TEST_EXT                            => 0x8890,
	GL_DEPTH_BOUNDS_EXT                                 => 0x8891,
	GL_MIRROR_CLAMP_EXT                                 => 0x8742,
	GL_MIRROR_CLAMP_TO_EDGE_EXT                         => 0x8743,
	GL_MIRROR_CLAMP_TO_BORDER_EXT                       => 0x8912,
	GL_BLEND_EQUATION_RGB_EXT                           => 0x8009,
	GL_BLEND_EQUATION_ALPHA_EXT                         => 0x883D,
	GL_PACK_INVERT_MESA                                 => 0x8758,
	GL_UNSIGNED_SHORT_8_8_MESA                          => 0x85BA,
	GL_UNSIGNED_SHORT_8_8_REV_MESA                      => 0x85BB,
	GL_YCBCR_MESA                                       => 0x8757,
	GL_PIXEL_PACK_BUFFER_EXT                            => 0x88EB,
	GL_PIXEL_UNPACK_BUFFER_EXT                          => 0x88EC,
	GL_PIXEL_PACK_BUFFER_BINDING_EXT                    => 0x88ED,
	GL_PIXEL_UNPACK_BUFFER_BINDING_EXT                  => 0x88EF,
	GL_MAX_PROGRAM_EXEC_INSTRUCTIONS_NV                 => 0x88F4,
	GL_MAX_PROGRAM_CALL_DEPTH_NV                        => 0x88F5,
	GL_MAX_PROGRAM_IF_DEPTH_NV                          => 0x88F6,
	GL_MAX_PROGRAM_LOOP_DEPTH_NV                        => 0x88F7,
	GL_MAX_PROGRAM_LOOP_COUNT_NV                        => 0x88F8,
	GL_INVALID_FRAMEBUFFER_OPERATION_EXT                => 0x0506,
	GL_MAX_RENDERBUFFER_SIZE_EXT                        => 0x84E8,
	GL_FRAMEBUFFER_BINDING_EXT                          => 0x8CA6,
	GL_RENDERBUFFER_BINDING_EXT                         => 0x8CA7,
	GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE_EXT           => 0x8CD0,
	GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME_EXT           => 0x8CD1,
	GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL_EXT         => 0x8CD2,
	GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE_EXT => 0x8CD3,
	GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_3D_ZOFFSET_EXT    => 0x8CD4,
	GL_FRAMEBUFFER_COMPLETE_EXT                         => 0x8CD5,
	GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT            => 0x8CD6,
	GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT    => 0x8CD7,
	GL_FRAMEBUFFER_INCOMPLETE_DUPLICATE_ATTACHMENT_EXT  => 0x8CD8,
	GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT            => 0x8CD9,
	GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT               => 0x8CDA,
	GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT           => 0x8CDB,
	GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT           => 0x8CDC,
	GL_FRAMEBUFFER_UNSUPPORTED_EXT                      => 0x8CDD,
	GL_MAX_COLOR_ATTACHMENTS_EXT                        => 0x8CDF,
	GL_COLOR_ATTACHMENT0_EXT                            => 0x8CE0,
	GL_COLOR_ATTACHMENT1_EXT                            => 0x8CE1,
	GL_COLOR_ATTACHMENT2_EXT                            => 0x8CE2,
	GL_COLOR_ATTACHMENT3_EXT                            => 0x8CE3,
	GL_COLOR_ATTACHMENT4_EXT                            => 0x8CE4,
	GL_COLOR_ATTACHMENT5_EXT                            => 0x8CE5,
	GL_COLOR_ATTACHMENT6_EXT                            => 0x8CE6,
	GL_COLOR_ATTACHMENT7_EXT                            => 0x8CE7,
	GL_COLOR_ATTACHMENT8_EXT                            => 0x8CE8,
	GL_COLOR_ATTACHMENT9_EXT                            => 0x8CE9,
	GL_COLOR_ATTACHMENT10_EXT                           => 0x8CEA,
	GL_COLOR_ATTACHMENT11_EXT                           => 0x8CEB,
	GL_COLOR_ATTACHMENT12_EXT                           => 0x8CEC,
	GL_COLOR_ATTACHMENT13_EXT                           => 0x8CED,
	GL_COLOR_ATTACHMENT14_EXT                           => 0x8CEE,
	GL_COLOR_ATTACHMENT15_EXT                           => 0x8CEF,
	GL_DEPTH_ATTACHMENT_EXT                             => 0x8D00,
	GL_STENCIL_ATTACHMENT_EXT                           => 0x8D20,
	GL_FRAMEBUFFER_EXT                                  => 0x8D40,
	GL_RENDERBUFFER_EXT                                 => 0x8D41,
	GL_RENDERBUFFER_WIDTH_EXT                           => 0x8D42,
	GL_RENDERBUFFER_HEIGHT_EXT                          => 0x8D43,
	GL_RENDERBUFFER_INTERNAL_FORMAT_EXT                 => 0x8D44,
	GL_STENCIL_INDEX1_EXT                               => 0x8D46,
	GL_STENCIL_INDEX4_EXT                               => 0x8D47,
	GL_STENCIL_INDEX8_EXT                               => 0x8D48,
	GL_STENCIL_INDEX16_EXT                              => 0x8D49,
	GL_RENDERBUFFER_RED_SIZE_EXT                        => 0x8D50,
	GL_RENDERBUFFER_GREEN_SIZE_EXT                      => 0x8D51,
	GL_RENDERBUFFER_BLUE_SIZE_EXT                       => 0x8D52,
	GL_RENDERBUFFER_ALPHA_SIZE_EXT                      => 0x8D53,
	GL_RENDERBUFFER_DEPTH_SIZE_EXT                      => 0x8D54,
	GL_RENDERBUFFER_STENCIL_SIZE_EXT                    => 0x8D55,
	GL_VERSION_1_2                                      => 1,
	GL_VERSION_1_3                                      => 1,
	GL_VERSION_1_4                                      => 1,
	GL_VERSION_1_5                                      => 1,
	GL_VERSION_2_0                                      => 1,
	GL_ARB_multitexture                                 => 1,
	GL_ARB_transpose_matrix                             => 1,
	GL_ARB_multisample                                  => 1,
	GL_ARB_texture_env_add                              => 1,
	GL_ARB_texture_cube_map                             => 1,
	GL_ARB_texture_compression                          => 1,
	GL_ARB_texture_border_clamp                         => 1,
	GL_ARB_point_parameters                             => 1,
	GL_ARB_vertex_blend                                 => 1,
	GL_ARB_matrix_palette                               => 1,
	GL_ARB_texture_env_combine                          => 1,
	GL_ARB_texture_env_crossbar                         => 1,
	GL_ARB_texture_env_dot3                             => 1,
	GL_ARB_texture_mirrored_repeat                      => 1,
	GL_ARB_depth_texture                                => 1,
	GL_ARB_shadow                                       => 1,
	GL_ARB_shadow_ambient                               => 1,
	GL_ARB_window_pos                                   => 1,
	GL_ARB_vertex_program                               => 1,
	GL_ARB_fragment_program                             => 1,
	GL_ARB_vertex_buffer_object                         => 1,
	GL_ARB_occlusion_query                              => 1,
	GL_ARB_shader_objects                               => 1,
	GL_ARB_vertex_shader                                => 1,
	GL_ARB_fragment_shader                              => 1,
	GL_ARB_shading_language_100                         => 1,
	GL_ARB_texture_non_power_of_two                     => 1,
	GL_ARB_point_sprite                                 => 1,
	GL_ARB_fragment_program_shadow                      => 1,
	GL_ARB_draw_buffers                                 => 1,
	GL_ARB_texture_rectangle                            => 1,
	GL_ARB_color_buffer_float                           => 1,
	GL_ARB_half_float_pixel                             => 1,
	GL_ARB_texture_float                                => 1,
	GL_ARB_pixel_buffer_object                          => 1,
	GL_EXT_abgr                                         => 1,
	GL_EXT_blend_color                                  => 1,
	GL_EXT_polygon_offset                               => 1,
	GL_EXT_texture                                      => 1,
	GL_EXT_texture3D                                    => 1,
	GL_SGIS_texture_filter4                             => 1,
	GL_EXT_subtexture                                   => 1,
	GL_EXT_copy_texture                                 => 1,
	GL_EXT_histogram                                    => 1,
	GL_EXT_convolution                                  => 1,
	GL_EXT_color_matrix                                 => 1,
	GL_SGI_color_table                                  => 1,
	GL_SGIX_pixel_texture                               => 1,
	GL_SGIS_pixel_texture                               => 1,
	GL_SGIS_texture4D                                   => 1,
	GL_SGI_texture_color_table                          => 1,
	GL_EXT_cmyka                                        => 1,
	GL_EXT_texture_object                               => 1,
	GL_SGIS_detail_texture                              => 1,
	GL_SGIS_sharpen_texture                             => 1,
	GL_EXT_packed_pixels                                => 1,
	GL_SGIS_texture_lod                                 => 1,
	GL_SGIS_multisample                                 => 1,
	GL_EXT_rescale_normal                               => 1,
	GL_EXT_vertex_array                                 => 1,
	GL_EXT_misc_attribute                               => 1,
	GL_SGIS_generate_mipmap                             => 1,
	GL_SGIX_clipmap                                     => 1,
	GL_SGIX_shadow                                      => 1,
	GL_SGIS_texture_edge_clamp                          => 1,
	GL_SGIS_texture_border_clamp                        => 1,
	GL_EXT_blend_minmax                                 => 1,
	GL_EXT_blend_subtract                               => 1,
	GL_EXT_blend_logic_op                               => 1,
	GL_SGIX_interlace                                   => 1,
	GL_SGIX_pixel_tiles                                 => 1,
	GL_SGIX_texture_select                              => 1,
	GL_SGIX_sprite                                      => 1,
	GL_SGIX_texture_multi_buffer                        => 1,
	GL_EXT_point_parameters                             => 1,
	GL_SGIS_point_parameters                            => 1,
	GL_SGIX_instruments                                 => 1,
	GL_SGIX_texture_scale_bias                          => 1,
	GL_SGIX_framezoom                                   => 1,
	GL_SGIX_tag_sample_buffer                           => 1,
	GL_SGIX_polynomial_ffd                              => 1,
	GL_SGIX_reference_plane                             => 1,
	GL_SGIX_flush_raster                                => 1,
	GL_SGIX_depth_texture                               => 1,
	GL_SGIS_fog_function                                => 1,
	GL_SGIX_fog_offset                                  => 1,
	GL_HP_image_transform                               => 1,
	GL_HP_convolution_border_modes                      => 1,
	GL_SGIX_texture_add_env                             => 1,
	GL_EXT_color_subtable                               => 1,
	GL_PGI_vertex_hints                                 => 1,
	GL_PGI_misc_hints                                   => 1,
	GL_EXT_paletted_texture                             => 1,
	GL_EXT_clip_volume_hint                             => 1,
	GL_SGIX_list_priority                               => 1,
	GL_SGIX_ir_instrument1                              => 1,
	GL_SGIX_calligraphic_fragment                       => 1,
	GL_SGIX_texture_lod_bias                            => 1,
	GL_SGIX_shadow_ambient                              => 1,
	GL_EXT_index_texture                                => 1,
	GL_EXT_index_material                               => 1,
	GL_EXT_index_func                                   => 1,
	GL_EXT_index_array_formats                          => 1,
	GL_EXT_compiled_vertex_array                        => 1,
	GL_EXT_cull_vertex                                  => 1,
	GL_SGIX_ycrcb                                       => 1,
	GL_SGIX_fragment_lighting                           => 1,
	GL_IBM_rasterpos_clip                               => 1,
	GL_HP_texture_lighting                              => 1,
	GL_EXT_draw_range_elements                          => 1,
	GL_WIN_phong_shading                                => 1,
	GL_WIN_specular_fog                                 => 1,
	GL_EXT_light_texture                                => 1,
	GL_SGIX_blend_alpha_minmax                          => 1,
	GL_EXT_bgra                                         => 1,
	GL_SGIX_async                                       => 1,
	GL_SGIX_async_pixel                                 => 1,
	GL_SGIX_async_histogram                             => 1,
	GL_INTEL_parallel_arrays                            => 1,
	GL_HP_occlusion_test                                => 1,
	GL_EXT_pixel_transform                              => 1,
	GL_EXT_pixel_transform_color_table                  => 1,
	GL_EXT_shared_texture_palette                       => 1,
	GL_EXT_separate_specular_color                      => 1,
	GL_EXT_secondary_color                              => 1,
	GL_EXT_texture_perturb_normal                       => 1,
	GL_EXT_multi_draw_arrays                            => 1,
	GL_EXT_fog_coord                                    => 1,
	GL_REND_screen_coordinates                          => 1,
	GL_EXT_coordinate_frame                             => 1,
	GL_EXT_texture_env_combine                          => 1,
	GL_APPLE_specular_vector                            => 1,
	GL_APPLE_transform_hint                             => 1,
	GL_SGIX_fog_scale                                   => 1,
	GL_SUNX_constant_data                               => 1,
	GL_SUN_global_alpha                                 => 1,
	GL_SUN_triangle_list                                => 1,
	GL_SUN_vertex                                       => 1,
	GL_EXT_blend_func_separate                          => 1,
	GL_INGR_blend_func_separate                         => 1,
	GL_INGR_color_clamp                                 => 1,
	GL_INGR_interlace_read                              => 1,
	GL_EXT_stencil_wrap                                 => 1,
	GL_EXT_422_pixels                                   => 1,
	GL_NV_texgen_reflection                             => 1,
	GL_SUN_convolution_border_modes                     => 1,
	GL_EXT_texture_env_add                              => 1,
	GL_EXT_texture_lod_bias                             => 1,
	GL_EXT_texture_filter_anisotropic                   => 1,
	GL_EXT_vertex_weighting                             => 1,
	GL_NV_light_max_exponent                            => 1,
	GL_NV_vertex_array_range                            => 1,
	GL_NV_register_combiners                            => 1,
	GL_NV_fog_distance                                  => 1,
	GL_NV_texgen_emboss                                 => 1,
	GL_NV_blend_square                                  => 1,
	GL_NV_texture_env_combine4                          => 1,
	GL_MESA_resize_buffers                              => 1,
	GL_MESA_window_pos                                  => 1,
	GL_IBM_cull_vertex                                  => 1,
	GL_IBM_multimode_draw_arrays                        => 1,
	GL_IBM_vertex_array_lists                           => 1,
	GL_SGIX_subsample                                   => 1,
	GL_SGIX_ycrcba                                      => 1,
	GL_SGIX_ycrcb_subsample                             => 1,
	GL_SGIX_depth_pass_instrument                       => 1,
	GL_3DFX_texture_compression_FXT1                    => 1,
	GL_3DFX_multisample                                 => 1,
	GL_3DFX_tbuffer                                     => 1,
	GL_EXT_multisample                                  => 1,
	GL_SGIX_vertex_preclip                              => 1,
	GL_SGIX_convolution_accuracy                        => 1,
	GL_SGIX_resample                                    => 1,
	GL_SGIS_point_line_texgen                           => 1,
	GL_SGIS_texture_color_mask                          => 1,
	GL_SGIX_igloo_interface                             => 1,
	GL_EXT_texture_env_dot3                             => 1,
	GL_ATI_texture_mirror_once                          => 1,
	GL_NV_fence                                         => 1,
	GL_NV_evaluators                                    => 1,
	GL_NV_packed_depth_stencil                          => 1,
	GL_NV_register_combiners2                           => 1,
	GL_NV_texture_compression_vtc                       => 1,
	GL_NV_texture_rectangle                             => 1,
	GL_NV_texture_shader                                => 1,
	GL_NV_texture_shader2                               => 1,
	GL_NV_vertex_array_range2                           => 1,
	GL_NV_vertex_program                                => 1,
	GL_SGIX_texture_coordinate_clamp                    => 1,
	GL_SGIX_scalebias_hint                              => 1,
	GL_OML_interlace                                    => 1,
	GL_OML_subsample                                    => 1,
	GL_OML_resample                                     => 1,
	GL_NV_copy_depth_to_color                           => 1,
	GL_ATI_envmap_bumpmap                               => 1,
	GL_ATI_fragment_shader                              => 1,
	GL_ATI_pn_triangles                                 => 1,
	GL_ATI_vertex_array_object                          => 1,
	GL_EXT_vertex_shader                                => 1,
	GL_ATI_vertex_streams                               => 1,
	GL_ATI_element_array                                => 1,
	GL_SUN_mesh_array                                   => 1,
	GL_SUN_slice_accum                                  => 1,
	GL_NV_multisample_filter_hint                       => 1,
	GL_NV_depth_clamp                                   => 1,
	GL_NV_occlusion_query                               => 1,
	GL_NV_point_sprite                                  => 1,
	GL_NV_texture_shader3                               => 1,
	GL_NV_vertex_program1_1                             => 1,
	GL_EXT_shadow_funcs                                 => 1,
	GL_EXT_stencil_two_side                             => 1,
	GL_ATI_text_fragment_shader                         => 1,
	GL_APPLE_client_storage                             => 1,
	GL_APPLE_element_array                              => 1,
	GL_APPLE_fence                                      => 1,
	GL_APPLE_vertex_array_object                        => 1,
	GL_APPLE_vertex_array_range                         => 1,
	GL_APPLE_ycbcr_422                                  => 1,
	GL_S3_s3tc                                          => 1,
	GL_ATI_draw_buffers                                 => 1,
	GL_ATI_pixel_format_float                           => 1,
	GL_ATI_texture_env_combine3                         => 1,
	GL_ATI_texture_float                                => 1,
	GL_NV_float_buffer                                  => 1,
	GL_NV_fragment_program                              => 1,
	GL_NV_half_float                                    => 1,
	GL_NV_pixel_data_range                              => 1,
	GL_NV_primitive_restart                             => 1,
	GL_NV_texture_expand_normal                         => 1,
	GL_NV_vertex_program2                               => 1,
	GL_ATI_map_object_buffer                            => 1,
	GL_ATI_separate_stencil                             => 1,
	GL_ATI_vertex_attrib_array_object                   => 1,
	GL_OES_read_format                                  => 1,
	GL_EXT_depth_bounds_test                            => 1,
	GL_EXT_texture_mirror_clamp                         => 1,
	GL_EXT_blend_equation_separate                      => 1,
	GL_MESA_pack_invert                                 => 1,
	GL_MESA_ycbcr_texture                               => 1,
	GL_EXT_pixel_buffer_object                          => 1,
	GL_NV_fragment_program_option                       => 1,
	GL_NV_fragment_program2                             => 1,
	GL_NV_vertex_program2_option                        => 1,
	GL_NV_vertex_program3                               => 1,
	GL_EXT_framebuffer_object                           => 1,
	GL_GREMEDY_string_marker                            => 1,
	RW_SEEK_SET                                         => 0,
	RW_SEEK_CUR                                         => 1,
	RW_SEEK_END                                         => 2,
};

use constant {
	SDL_FALSE                                           => 0,
	SDL_TRUE                                            => 1,
}; # SDL_bool

use constant {
	DUMMY_ENUM_VALUE                                    => 0,
}; # SDL_DUMMY_ENUM

use constant {
	SDL_SVG_FLAG_DIRECT                                 => 0,
	SDL_SVG_FLAG_COMPOSITE                              => 1,
	Cursor                                              => X11Cursor,
};

use constant {
	SDL_SYSWM_X11                                       => 0,
}; # SDL_SYSWM_TYPE

use constant {
	SDL_TIMESLICE                                       => 10,
	TIMER_RESOLUTION                                    => 10,
	SDL_ALPHA_OPAQUE                                    => 255,
	SDL_ALPHA_TRANSPARENT                               => 0,
};

# manual added!!
use constant {
	SMPEG_ERROR => -1,
	SMPEG_PLAYING => 1,
	SMPEG_STOPPED => 0,
};

1;
