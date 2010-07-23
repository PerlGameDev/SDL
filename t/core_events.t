#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Event;
use SDL::Events;
use SDL::Surface;
use SDL::Video;
use Devel::Peek;
use Test::More;
use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
    plan( skip_all => 'Failed to init video' );
}

my @done = qw/
  pump_events
  peep_events
  push_event
  poll_event
  wait_event
  set_event_filter
  event_state
  get_key_state
  get_key_name
  get_mod_state
  set_mod_state
  enable_unicode
  enable_key_repeat
  get_mouse_state
  get_relative_mouse_state
  get_app_state
  joystick_event_state
  /;

my @done_event = qw/
  type
  active
  key
  motion
  button
  jaxis
  jball
  jhat
  jbutton
  resize
  expose
  quit
  user
  syswm
  /;

can_ok( 'SDL::Events', @done );
can_ok( 'SDL::Event',  @done_event );

is( SDL_ACTIVEEVENT,   1, 'SDL_ACTIVEEVENT should be imported' );
is( SDL_ACTIVEEVENT(), 1, 'SDL_ACTIVEEVENT() should also be available' );
is( SDL_ACTIVEEVENTMASK,
    SDL_EVENTMASK(SDL_ACTIVEEVENT),
    'SDL_ACTIVEVENTMASK should be imported'
);
is(
    SDL_ACTIVEEVENTMASK(),
    SDL_EVENTMASK(SDL_ACTIVEEVENT),
    'SDL_ACTIVEVENTMASK() should also be available'
);
is( SDL_ADDEVENT,    0,          'SDL_ADDEVENT should be imported' );
is( SDL_ADDEVENT(),  0,          'SDL_ADDEVENT() should also be available' );
is( SDL_ALLEVENTS,   0xFFFFFFFF, 'SDL_ALLEVENTS should be imported' );
is( SDL_ALLEVENTS(), 0xFFFFFFFF, 'SDL_ALLEVENTS() should also be available' );

is( SDL_APPACTIVE,       4, 'SDL_APPACTIVE should be imported' );
is( SDL_APPACTIVE(),     4, 'SDL_APPACTIVE() should also be available' );
is( SDL_APPINPUTFOCUS,   2, 'SDL_APPINPUTFOCUS should be imported' );
is( SDL_APPINPUTFOCUS(), 2, 'SDL_APPINPUTFOCUS() should also be available' );
is( SDL_APPMOUSEFOCUS,   1, 'SDL_APPMOUSEFOCUS should be imported' );
is( SDL_APPMOUSEFOCUS(), 1, 'SDL_APPMOUSEFOCUS() should also be available' );

is( SDL_BUTTON_LEFT,      1, 'SDL_BUTTON_LEFT should be imported' );
is( SDL_BUTTON_LEFT(),    1, 'SDL_BUTTON_LEFT() should also be available' );
is( SDL_BUTTON_MIDDLE,    2, 'SDL_BUTTON_MIDDLE should be imported' );
is( SDL_BUTTON_MIDDLE(),  2, 'SDL_BUTTON_MIDDLE() should also be available' );
is( SDL_BUTTON_RIGHT,     3, 'SDL_BUTTON_RIGHT should be imported' );
is( SDL_BUTTON_RIGHT(),   3, 'SDL_BUTTON_RIGHT() should also be available' );
is( SDL_BUTTON_WHEELUP,   4, 'SDL_BUTTON_WHEELUP should be imported' );
is( SDL_BUTTON_WHEELUP(), 4, 'SDL_BUTTON_WHEELUP() should also be available' );
is( SDL_BUTTON_WHEELDOWN, 5, 'SDL_BUTTON_WHEELDOWN should be imported' );
is( SDL_BUTTON_WHEELDOWN(), 5,
    'SDL_BUTTON_WHEELDOWN() should also be available' );

is( SDL_DISABLE,   0, 'SDL_DISABLE should be imported' );
is( SDL_DISABLE(), 0, 'SDL_DISABLE() should also be available' );

is( SDL_ENABLE,   1, 'SDL_ENABLE should be imported' );
is( SDL_ENABLE(), 1, 'SDL_ENABLE() should also be available' );

is( SDL_GETEVENT,   2, 'SDL_GETEVENT should be imported' );
is( SDL_GETEVENT(), 2, 'SDL_GETEVENT() should also be available' );

is( SDL_HAT_CENTERED,    0,  'SDL_HAT_CENTERED should be imported' );
is( SDL_HAT_CENTERED(),  0,  'SDL_HAT_CENTERED() should also be available' );
is( SDL_HAT_DOWN,        4,  'SDL_HAT_DOWN should be imported' );
is( SDL_HAT_DOWN(),      4,  'SDL_HAT_DOWN() should also be available' );
is( SDL_HAT_LEFT,        8,  'SDL_HAT_LEFT should be imported' );
is( SDL_HAT_LEFT(),      8,  'SDL_HAT_LEFT() should also be available' );
is( SDL_HAT_LEFTDOWN,    12, 'SDL_HAT_LEFTDOWN should be imported' );
is( SDL_HAT_LEFTDOWN(),  12, 'SDL_HAT_LEFTDOWN() should also be available' );
is( SDL_HAT_LEFTUP,      9,  'SDL_HAT_LEFTUP should be imported' );
is( SDL_HAT_LEFTUP(),    9,  'SDL_HAT_LEFTUP() should also be available' );
is( SDL_HAT_RIGHT,       2,  'SDL_HAT_RIGHT should be imported' );
is( SDL_HAT_RIGHT(),     2,  'SDL_HAT_RIGHT() should also be available' );
is( SDL_HAT_RIGHTDOWN,   6,  'SDL_HAT_RIGHTDOWN should be imported' );
is( SDL_HAT_RIGHTDOWN(), 6,  'SDL_HAT_RIGHTDOWN() should also be available' );
is( SDL_HAT_RIGHTUP,     3,  'SDL_HAT_RIGHTUP should be imported' );
is( SDL_HAT_RIGHTUP(),   3,  'SDL_HAT_RIGHTUP() should also be available' );
is( SDL_HAT_UP,          1,  'SDL_HAT_UP should be imported' );
is( SDL_HAT_UP(),        1,  'SDL_HAT_UP() should also be available' );

is( SDL_IGNORE,   0, 'SDL_IGNORE should be imported' );
is( SDL_IGNORE(), 0, 'SDL_IGNORE() should also be available' );

is( SDL_JOYAXISMOTION,   7,  'SDL_JOYAXISMOTION should be imported' );
is( SDL_JOYAXISMOTION(), 7,  'SDL_JOYAXISMOTION() should also be available' );
is( SDL_JOYBALLMOTION,   8,  'SDL_JOYBALLMOTION should be imported' );
is( SDL_JOYBALLMOTION(), 8,  'SDL_JOYBALLMOTION() should also be available' );
is( SDL_JOYBUTTONDOWN,   10, 'SDL_JOYBUTTONDOWN should be imported' );
is( SDL_JOYBUTTONDOWN(), 10, 'SDL_JOYBUTTONDOWN() should also be available' );
is( SDL_JOYBUTTONUP,     11, 'SDL_JOYBUTTONUP should be imported' );
is( SDL_JOYBUTTONUP(),   11, 'SDL_JOYBUTTONUP() should also be available' );
is( SDL_JOYHATMOTION,    9,  'SDL_JOYHATMOTION should be imported' );
is( SDL_JOYHATMOTION(),  9,  'SDL_JOYHATMOTION() should also be available' );
is( SDL_JOYAXISMOTIONMASK,
    SDL_EVENTMASK(SDL_JOYAXISMOTION),
    'SDL_JOYAXISMOTIONMASK should be imported'
);
is(
    SDL_JOYAXISMOTIONMASK(),
    SDL_EVENTMASK(SDL_JOYAXISMOTION),
    'SDL_JOYAXISMOTIONMASK() should also be available'
);
is( SDL_JOYBALLMOTIONMASK,
    SDL_EVENTMASK(SDL_JOYBALLMOTION),
    'SDL_JOYBALLMOTIONMASK should be imported'
);
is(
    SDL_JOYBALLMOTIONMASK(),
    SDL_EVENTMASK(SDL_JOYBALLMOTION),
    'SDL_JOYBALLMOTIONMASK() should also be available'
);
is( SDL_JOYHATMOTIONMASK,
    SDL_EVENTMASK(SDL_JOYHATMOTION),
    'SDL_JOYHATMOTIONMASK should be imported'
);
is(
    SDL_JOYHATMOTIONMASK(),
    SDL_EVENTMASK(SDL_JOYHATMOTION),
    'SDL_JOYHATMOTIONMASK() should also be available'
);
is( SDL_JOYBUTTONDOWNMASK,
    SDL_EVENTMASK(SDL_JOYBUTTONDOWN),
    'SDL_JOYBUTTONDOWNMASK should be imported'
);
is(
    SDL_JOYBUTTONDOWNMASK(),
    SDL_EVENTMASK(SDL_JOYBUTTONDOWN),
    'SDL_JOYBUTTONDOWNMASK() should also be available'
);
is( SDL_JOYBUTTONUPMASK,
    SDL_EVENTMASK(SDL_JOYBUTTONUP),
    'SDL_JOYBUTTONUPMASK should be imported'
);
is(
    SDL_JOYBUTTONUPMASK(),
    SDL_EVENTMASK(SDL_JOYBUTTONUP),
    'SDL_JOYBUTTONUPMASK() should also be available'
);
is( SDL_JOYEVENTMASK,
    SDL_EVENTMASK(SDL_JOYAXISMOTION) | SDL_EVENTMASK(SDL_JOYBALLMOTION) |
      SDL_EVENTMASK(SDL_JOYHATMOTION) | SDL_EVENTMASK(SDL_JOYBUTTONDOWN) |
      SDL_EVENTMASK(SDL_JOYBUTTONUP),
    'SDL_JOYEVENTMASK should be imported'
);
is(
    SDL_JOYEVENTMASK(),
    SDL_EVENTMASK(SDL_JOYAXISMOTION) | SDL_EVENTMASK(SDL_JOYBALLMOTION) |
      SDL_EVENTMASK(SDL_JOYHATMOTION) | SDL_EVENTMASK(SDL_JOYBUTTONDOWN) |
      SDL_EVENTMASK(SDL_JOYBUTTONUP),
    'SDL_JOYEVENTMASK() should also be available'
);

is( SDL_KEYDOWN,   2, 'SDL_KEYDOWN should be imported' );
is( SDL_KEYDOWN(), 2, 'SDL_KEYDOWN() should also be available' );
is( SDL_KEYUP,     3, 'SDL_KEYUP should be imported' );
is( SDL_KEYUP(),   3, 'SDL_KEYUP() should also be available' );
is( SDL_KEYDOWNMASK,
    SDL_EVENTMASK(SDL_KEYDOWN),
    'SDL_KEYDOWNMASK should be imported'
);
is(
    SDL_KEYDOWNMASK(),
    SDL_EVENTMASK(SDL_KEYDOWN),
    'SDL_KEYDOWNMASK() should also be available'
);
is( SDL_KEYUPMASK,
    SDL_EVENTMASK(SDL_KEYUP),
    'SDL_KEYUPMASK should be imported'
);
is(
    SDL_KEYUPMASK(),
    SDL_EVENTMASK(SDL_KEYUP),
    'SDL_KEYUPMASK() should also be available'
);
is( SDL_KEYEVENTMASK,
    SDL_EVENTMASK(SDL_KEYDOWN) | SDL_EVENTMASK(SDL_KEYUP),
    'SDL_KEYEVENTMASK should be imported'
);
is(
    SDL_KEYEVENTMASK(),
    SDL_EVENTMASK(SDL_KEYDOWN) | SDL_EVENTMASK(SDL_KEYUP),
    'SDL_KEYEVENTMASK() should also be available'
);

is( SDL_MOUSEBUTTONDOWN, 5, 'SDL_MOUSEBUTTONDOWN should be imported' );
is( SDL_MOUSEBUTTONDOWN(), 5,
    'SDL_MOUSEBUTTONDOWN() should also be available' );
is( SDL_MOUSEBUTTONUP,   6, 'SDL_MOUSEBUTTONUP should be imported' );
is( SDL_MOUSEBUTTONUP(), 6, 'SDL_MOUSEBUTTONUP() should also be available' );
is( SDL_MOUSEMOTION,     4, 'SDL_MOUSEMOTION should be imported' );
is( SDL_MOUSEMOTION(),   4, 'SDL_MOUSEMOTION() should also be available' );
is( SDL_MOUSEMOTIONMASK,
    SDL_EVENTMASK(SDL_MOUSEMOTION),
    'SDL_MOUSEMOTIONMASK should be imported'
);
is(
    SDL_MOUSEMOTIONMASK(),
    SDL_EVENTMASK(SDL_MOUSEMOTION),
    'SDL_MOUSEMOTIONMASK() should also be available'
);
is( SDL_MOUSEBUTTONDOWNMASK,
    SDL_EVENTMASK(SDL_MOUSEBUTTONDOWN),
    'SDL_MOUSEBUTTONDOWNMASK should be imported'
);
is(
    SDL_MOUSEBUTTONDOWNMASK(),
    SDL_EVENTMASK(SDL_MOUSEBUTTONDOWN),
    'SDL_MOUSEBUTTONDOWNMASK() should also be available'
);
is( SDL_MOUSEBUTTONUPMASK,
    SDL_EVENTMASK(SDL_MOUSEBUTTONUP),
    'SDL_MOUSEBUTTONUPMASK should be imported'
);
is(
    SDL_MOUSEBUTTONUPMASK(),
    SDL_EVENTMASK(SDL_MOUSEBUTTONUP),
    'SDL_MOUSEBUTTONUPMASK() should also be available'
);
is( SDL_MOUSEEVENTMASK,
    SDL_EVENTMASK(SDL_MOUSEMOTION) | SDL_EVENTMASK(SDL_MOUSEBUTTONDOWN) |
      SDL_EVENTMASK(SDL_MOUSEBUTTONUP),
    'SDL_MOUSEEVENTMASK should be imported'
);
is(
    SDL_MOUSEEVENTMASK(),
    SDL_EVENTMASK(SDL_MOUSEMOTION) | SDL_EVENTMASK(SDL_MOUSEBUTTONDOWN) |
      SDL_EVENTMASK(SDL_MOUSEBUTTONUP),
    'SDL_MOUSEEVENTMASK() should also be available'
);

is( SDL_NUMEVENTS,   32, 'SDL_NUMEVENTS should be imported' );
is( SDL_NUMEVENTS(), 32, 'SDL_NUMEVENTS() should also be available' );

is( SDL_PEEKEVENT,   1,  'SDL_PEEKEVENT should be imported' );
is( SDL_PEEKEVENT(), 1,  'SDL_PEEKEVENT() should also be available' );
is( SDL_PRESSED,     1,  'SDL_PRESSED should be imported' );
is( SDL_PRESSED(),   1,  'SDL_PRESSED() should also be available' );
is( SDL_QUERY,       -1, 'SDL_QUERY should be imported' );
is( SDL_QUERY(),     -1, 'SDL_QUERY() should also be available' );
is( SDL_QUIT,        12, 'SDL_QUIT should be imported' );
is( SDL_QUIT(),      12, 'SDL_QUIT() should also be available' );
is( SDL_QUITMASK, SDL_EVENTMASK(SDL_QUIT), 'SDL_QUITMASK should be imported' );
is( SDL_QUITMASK(), SDL_EVENTMASK(SDL_QUIT),
    'SDL_QUITMASK() should also be available' );

is( SDL_RELEASED,   0, 'SDL_RELEASED should be imported' );
is( SDL_RELEASED(), 0, 'SDL_RELEASED() should also be available' );

is( SDL_SYSWMEVENT,   13, 'SDL_SYSWMEVENT should be imported' );
is( SDL_SYSWMEVENT(), 13, 'SDL_SYSWMEVENT() should also be available' );
is( SDL_SYSWMEVENTMASK,
    SDL_EVENTMASK(SDL_SYSWMEVENT),
    'SDL_SYSWMEVENTMASK should be imported'
);
is(
    SDL_SYSWMEVENTMASK(),
    SDL_EVENTMASK(SDL_SYSWMEVENT),
    'SDL_SYSWMEVENTMASK() should also be available'
);

is( SDL_USEREVENT,   24, 'SDL_USEREVENT should be imported' );
is( SDL_USEREVENT(), 24, 'SDL_USEREVENT() should also be available' );

is( SDL_VIDEOEXPOSE,   17, 'SDL_VIDEOEXPOSE should be imported' );
is( SDL_VIDEOEXPOSE(), 17, 'SDL_VIDEOEXPOSE() should also be available' );
is( SDL_VIDEOEXPOSEMASK,
    SDL_EVENTMASK(SDL_VIDEOEXPOSE),
    'SDL_VIDEOEXPOSEMASK should be imported'
);
is(
    SDL_VIDEOEXPOSEMASK(),
    SDL_EVENTMASK(SDL_VIDEOEXPOSE),
    'SDL_VIDEOEXPOSEMASK() should also be available'
);
is( SDL_VIDEORESIZE,   16, 'SDL_VIDEORESIZE should be imported' );
is( SDL_VIDEORESIZE(), 16, 'SDL_VIDEORESIZE() should also be available' );
is( SDL_VIDEORESIZEMASK,
    SDL_EVENTMASK(SDL_VIDEORESIZE),
    'SDL_VIDEORESIZEMASK should be imported'
);
is(
    SDL_VIDEORESIZEMASK(),
    SDL_EVENTMASK(SDL_VIDEORESIZE),
    'SDL_VIDEORESIZEMASK() should also be available'
);

is( KMOD_ALT,      768,             'KMOD_ALT should be imported' );
is( KMOD_ALT(),    768,             'KMOD_ALT() should also be available' );
is( KMOD_CAPS,     8192,            'KMOD_CAPS should be imported' );
is( KMOD_CAPS(),   8192,            'KMOD_CAPS() should also be available' );
is( KMOD_CTRL,     192,             'KMOD_CTRL should be imported' );
is( KMOD_CTRL(),   192,             'KMOD_CTRL() should also be available' );
is( KMOD_LALT,     256,             'KMOD_LALT should be imported' );
is( KMOD_LALT(),   256,             'KMOD_LALT() should also be available' );
is( KMOD_LCTRL,    64,              'KMOD_LCTRL should be imported' );
is( KMOD_LCTRL(),  64,              'KMOD_LCTRL() should also be available' );
is( KMOD_LMETA,    0x0400,          'KMOD_LMETA should be imported' );
is( KMOD_LMETA(),  0x0400,          'KMOD_LMETA() should also be available' );
is( KMOD_LSHIFT,   1,               'KMOD_LSHIFT should be imported' );
is( KMOD_LSHIFT(), 1,               'KMOD_LSHIFT() should also be available' );
is( KMOD_META,     0x0400 | 0x0800, 'KMOD_META should be imported' );
is( KMOD_META(),   0x0400 | 0x0800, 'KMOD_META() should also be available' );
is( KMOD_MODE,     0x4000,          'KMOD_MODE should be imported' );
is( KMOD_MODE(),   0x4000,          'KMOD_MODE() should also be available' );
is( KMOD_NONE,     0,               'KMOD_NONE should be imported' );
is( KMOD_NONE(),   0,               'KMOD_NONE() should also be available' );
is( KMOD_NUM,      4096,            'KMOD_NUM should be imported' );
is( KMOD_NUM(),    4096,            'KMOD_NUM() should also be available' );
is( KMOD_RESERVED, 0x8000,          'KMOD_RESERVED should be imported' );
is( KMOD_RESERVED(), 0x8000, 'KMOD_RESERVED() should also be available' );
is( KMOD_RALT,       512,    'KMOD_RALT should be imported' );
is( KMOD_RALT(),     512,    'KMOD_RALT() should also be available' );
is( KMOD_RCTRL,      128,    'KMOD_RCTRL should be imported' );
is( KMOD_RCTRL(),    128,    'KMOD_RCTRL() should also be available' );
is( KMOD_RMETA,      0x0800, 'KMOD_RMETA should be imported' );
is( KMOD_RMETA(),    0x0800, 'KMOD_RMETA() should also be available' );
is( KMOD_RSHIFT,     2,      'KMOD_RSHIFT should be imported' );
is( KMOD_RSHIFT(),   2,      'KMOD_RSHIFT() should also be available' );
is( KMOD_SHIFT,      3,      'KMOD_SHIFT should be imported' );
is( KMOD_SHIFT(),    3,      'KMOD_SHIFT() should also be available' );

is( SDLK_0,              48,  'SDLK_0 should be imported' );
is( SDLK_0(),            48,  'SDLK_0() should also be available' );
is( SDLK_1,              49,  'SDLK_1 should be imported' );
is( SDLK_1(),            49,  'SDLK_1() should also be available' );
is( SDLK_2,              50,  'SDLK_2 should be imported' );
is( SDLK_2(),            50,  'SDLK_2() should also be available' );
is( SDLK_3,              51,  'SDLK_3 should be imported' );
is( SDLK_3(),            51,  'SDLK_3() should also be available' );
is( SDLK_4,              52,  'SDLK_4 should be imported' );
is( SDLK_4(),            52,  'SDLK_4() should also be available' );
is( SDLK_5,              53,  'SDLK_5 should be imported' );
is( SDLK_5(),            53,  'SDLK_5() should also be available' );
is( SDLK_6,              54,  'SDLK_6 should be imported' );
is( SDLK_6(),            54,  'SDLK_6() should also be available' );
is( SDLK_7,              55,  'SDLK_7 should be imported' );
is( SDLK_7(),            55,  'SDLK_7() should also be available' );
is( SDLK_8,              56,  'SDLK_8 should be imported' );
is( SDLK_8(),            56,  'SDLK_8() should also be available' );
is( SDLK_9,              57,  'SDLK_9 should be imported' );
is( SDLK_9(),            57,  'SDLK_9() should also be available' );
is( SDLK_AMPERSAND,      38,  'SDLK_AMPERSAND should be imported' );
is( SDLK_AMPERSAND(),    38,  'SDLK_AMPERSAND() should also be available' );
is( SDLK_ASTERISK,       42,  'SDLK_ASTERISK should be imported' );
is( SDLK_ASTERISK(),     42,  'SDLK_ASTERISK() should also be available' );
is( SDLK_AT,             64,  'SDLK_AT should be imported' );
is( SDLK_AT(),           64,  'SDLK_AT() should also be available' );
is( SDLK_BACKQUOTE,      96,  'SDLK_BACKQUOTE should be imported' );
is( SDLK_BACKQUOTE(),    96,  'SDLK_BACKQUOTE() should also be available' );
is( SDLK_BACKSLASH,      92,  'SDLK_BACKSLASH should be imported' );
is( SDLK_BACKSLASH(),    92,  'SDLK_BACKSLASH() should also be available' );
is( SDLK_BACKSPACE,      8,   'SDLK_BACKSPACE should be imported' );
is( SDLK_BACKSPACE(),    8,   'SDLK_BACKSPACE() should also be available' );
is( SDLK_BREAK,          318, 'SDLK_BREAK should be imported' );
is( SDLK_BREAK(),        318, 'SDLK_BREAK() should also be available' );
is( SDLK_CAPSLOCK,       301, 'SDLK_CAPSLOCK should be imported' );
is( SDLK_CAPSLOCK(),     301, 'SDLK_CAPSLOCK() should also be available' );
is( SDLK_CARET,          94,  'SDLK_CARET should be imported' );
is( SDLK_CARET(),        94,  'SDLK_CARET() should also be available' );
is( SDLK_CLEAR,          12,  'SDLK_CLEAR should be imported' );
is( SDLK_CLEAR(),        12,  'SDLK_CLEAR() should also be available' );
is( SDLK_COLON,          58,  'SDLK_COLON should be imported' );
is( SDLK_COLON(),        58,  'SDLK_COLON() should also be available' );
is( SDLK_COMMA,          44,  'SDLK_COMMA should be imported' );
is( SDLK_COMMA(),        44,  'SDLK_COMMA() should also be available' );
is( SDLK_COMPOSE,        314, 'SDLK_COMPOSE should be imported' );
is( SDLK_COMPOSE(),      314, 'SDLK_COMPOSE() should also be available' );
is( SDLK_DELETE,         127, 'SDLK_DELETE should be imported' );
is( SDLK_DELETE(),       127, 'SDLK_DELETE() should also be available' );
is( SDLK_DOLLAR,         36,  'SDLK_DOLLAR should be imported' );
is( SDLK_DOLLAR(),       36,  'SDLK_DOLLAR() should also be available' );
is( SDLK_DOWN,           274, 'SDLK_DOWN should be imported' );
is( SDLK_DOWN(),         274, 'SDLK_DOWN() should also be available' );
is( SDLK_END,            279, 'SDLK_END should be imported' );
is( SDLK_END(),          279, 'SDLK_END() should also be available' );
is( SDLK_EQUALS,         61,  'SDLK_EQUALS should be imported' );
is( SDLK_EQUALS(),       61,  'SDLK_EQUALS() should also be available' );
is( SDLK_ESCAPE,         27,  'SDLK_ESCAPE should be imported' );
is( SDLK_ESCAPE(),       27,  'SDLK_ESCAPE() should also be available' );
is( SDLK_EURO,           321, 'SDLK_EURO should be imported' );
is( SDLK_EURO(),         321, 'SDLK_EURO() should also be available' );
is( SDLK_EXCLAIM,        33,  'SDLK_EXCLAIM should be imported' );
is( SDLK_EXCLAIM(),      33,  'SDLK_EXCLAIM() should also be available' );
is( SDLK_F1,             282, 'SDLK_F1 should be imported' );
is( SDLK_F1(),           282, 'SDLK_F1() should also be available' );
is( SDLK_F10,            291, 'SDLK_F10 should be imported' );
is( SDLK_F10(),          291, 'SDLK_F10() should also be available' );
is( SDLK_F11,            292, 'SDLK_F11 should be imported' );
is( SDLK_F11(),          292, 'SDLK_F11() should also be available' );
is( SDLK_F12,            293, 'SDLK_F12 should be imported' );
is( SDLK_F12(),          293, 'SDLK_F12() should also be available' );
is( SDLK_F13,            294, 'SDLK_F13 should be imported' );
is( SDLK_F13(),          294, 'SDLK_F13() should also be available' );
is( SDLK_F14,            295, 'SDLK_F14 should be imported' );
is( SDLK_F14(),          295, 'SDLK_F14() should also be available' );
is( SDLK_F15,            296, 'SDLK_F15 should be imported' );
is( SDLK_F15(),          296, 'SDLK_F15() should also be available' );
is( SDLK_F2,             283, 'SDLK_F2 should be imported' );
is( SDLK_F2(),           283, 'SDLK_F2() should also be available' );
is( SDLK_F3,             284, 'SDLK_F3 should be imported' );
is( SDLK_F3(),           284, 'SDLK_F3() should also be available' );
is( SDLK_F4,             285, 'SDLK_F4 should be imported' );
is( SDLK_F4(),           285, 'SDLK_F4() should also be available' );
is( SDLK_F5,             286, 'SDLK_F5 should be imported' );
is( SDLK_F5(),           286, 'SDLK_F5() should also be available' );
is( SDLK_F6,             287, 'SDLK_F6 should be imported' );
is( SDLK_F6(),           287, 'SDLK_F6() should also be available' );
is( SDLK_F7,             288, 'SDLK_F7 should be imported' );
is( SDLK_F7(),           288, 'SDLK_F7() should also be available' );
is( SDLK_F8,             289, 'SDLK_F8 should be imported' );
is( SDLK_F8(),           289, 'SDLK_F8() should also be available' );
is( SDLK_F9,             290, 'SDLK_F9 should be imported' );
is( SDLK_F9(),           290, 'SDLK_F9() should also be available' );
is( SDLK_FIRST,          0,   'SDLK_FIRST should be imported' );
is( SDLK_FIRST(),        0,   'SDLK_FIRST() should also be available' );
is( SDLK_GREATER,        62,  'SDLK_GREATER should be imported' );
is( SDLK_GREATER(),      62,  'SDLK_GREATER() should also be available' );
is( SDLK_HASH,           35,  'SDLK_HASH should be imported' );
is( SDLK_HASH(),         35,  'SDLK_HASH() should also be available' );
is( SDLK_HELP,           315, 'SDLK_HELP should be imported' );
is( SDLK_HELP(),         315, 'SDLK_HELP() should also be available' );
is( SDLK_HOME,           278, 'SDLK_HOME should be imported' );
is( SDLK_HOME(),         278, 'SDLK_HOME() should also be available' );
is( SDLK_INSERT,         277, 'SDLK_INSERT should be imported' );
is( SDLK_INSERT(),       277, 'SDLK_INSERT() should also be available' );
is( SDLK_KP0,            256, 'SDLK_KP0 should be imported' );
is( SDLK_KP0(),          256, 'SDLK_KP0() should also be available' );
is( SDLK_KP1,            257, 'SDLK_KP1 should be imported' );
is( SDLK_KP1(),          257, 'SDLK_KP1() should also be available' );
is( SDLK_KP2,            258, 'SDLK_KP2 should be imported' );
is( SDLK_KP2(),          258, 'SDLK_KP2() should also be available' );
is( SDLK_KP3,            259, 'SDLK_KP3 should be imported' );
is( SDLK_KP3(),          259, 'SDLK_KP3() should also be available' );
is( SDLK_KP4,            260, 'SDLK_KP4 should be imported' );
is( SDLK_KP4(),          260, 'SDLK_KP4() should also be available' );
is( SDLK_KP5,            261, 'SDLK_KP5 should be imported' );
is( SDLK_KP5(),          261, 'SDLK_KP5() should also be available' );
is( SDLK_KP6,            262, 'SDLK_KP6 should be imported' );
is( SDLK_KP6(),          262, 'SDLK_KP6() should also be available' );
is( SDLK_KP7,            263, 'SDLK_KP7 should be imported' );
is( SDLK_KP7(),          263, 'SDLK_KP7() should also be available' );
is( SDLK_KP8,            264, 'SDLK_KP8 should be imported' );
is( SDLK_KP8(),          264, 'SDLK_KP8() should also be available' );
is( SDLK_KP9,            265, 'SDLK_KP9 should be imported' );
is( SDLK_KP9(),          265, 'SDLK_KP9() should also be available' );
is( SDLK_KP_DIVIDE,      267, 'SDLK_KP_DIVIDE should be imported' );
is( SDLK_KP_DIVIDE(),    267, 'SDLK_KP_DIVIDE() should also be available' );
is( SDLK_KP_ENTER,       271, 'SDLK_KP_ENTER should be imported' );
is( SDLK_KP_ENTER(),     271, 'SDLK_KP_ENTER() should also be available' );
is( SDLK_KP_EQUALS,      272, 'SDLK_KP_EQUALS should be imported' );
is( SDLK_KP_EQUALS(),    272, 'SDLK_KP_EQUALS() should also be available' );
is( SDLK_KP_MINUS,       269, 'SDLK_KP_MINUS should be imported' );
is( SDLK_KP_MINUS(),     269, 'SDLK_KP_MINUS() should also be available' );
is( SDLK_KP_MULTIPLY,    268, 'SDLK_KP_MULTIPLY should be imported' );
is( SDLK_KP_MULTIPLY(),  268, 'SDLK_KP_MULTIPLY() should also be available' );
is( SDLK_KP_PERIOD,      266, 'SDLK_KP_PERIOD should be imported' );
is( SDLK_KP_PERIOD(),    266, 'SDLK_KP_PERIOD() should also be available' );
is( SDLK_KP_PLUS,        270, 'SDLK_KP_PLUS should be imported' );
is( SDLK_KP_PLUS(),      270, 'SDLK_KP_PLUS() should also be available' );
is( SDLK_LALT,           308, 'SDLK_LALT should be imported' );
is( SDLK_LALT(),         308, 'SDLK_LALT() should also be available' );
is( SDLK_LCTRL,          306, 'SDLK_LCTRL should be imported' );
is( SDLK_LCTRL(),        306, 'SDLK_LCTRL() should also be available' );
is( SDLK_LEFT,           276, 'SDLK_LEFT should be imported' );
is( SDLK_LEFT(),         276, 'SDLK_LEFT() should also be available' );
is( SDLK_LEFTBRACKET,    91,  'SDLK_LEFTBRACKET should be imported' );
is( SDLK_LEFTBRACKET(),  91,  'SDLK_LEFTBRACKET() should also be available' );
is( SDLK_LEFTPAREN,      40,  'SDLK_LEFTPAREN should be imported' );
is( SDLK_LEFTPAREN(),    40,  'SDLK_LEFTPAREN() should also be available' );
is( SDLK_LESS,           60,  'SDLK_LESS should be imported' );
is( SDLK_LESS(),         60,  'SDLK_LESS() should also be available' );
is( SDLK_LMETA,          310, 'SDLK_LMETA should be imported' );
is( SDLK_LMETA(),        310, 'SDLK_LMETA() should also be available' );
is( SDLK_LSHIFT,         304, 'SDLK_LSHIFT should be imported' );
is( SDLK_LSHIFT(),       304, 'SDLK_LSHIFT() should also be available' );
is( SDLK_LSUPER,         311, 'SDLK_LSUPER should be imported' );
is( SDLK_LSUPER(),       311, 'SDLK_LSUPER() should also be available' );
is( SDLK_MENU,           319, 'SDLK_MENU should be imported' );
is( SDLK_MENU(),         319, 'SDLK_MENU() should also be available' );
is( SDLK_MINUS,          45,  'SDLK_MINUS should be imported' );
is( SDLK_MINUS(),        45,  'SDLK_MINUS() should also be available' );
is( SDLK_MODE,           313, 'SDLK_MODE should be imported' );
is( SDLK_MODE(),         313, 'SDLK_MODE() should also be available' );
is( SDLK_NUMLOCK,        300, 'SDLK_NUMLOCK should be imported' );
is( SDLK_NUMLOCK(),      300, 'SDLK_NUMLOCK() should also be available' );
is( SDLK_PAGEDOWN,       281, 'SDLK_PAGEDOWN should be imported' );
is( SDLK_PAGEDOWN(),     281, 'SDLK_PAGEDOWN() should also be available' );
is( SDLK_PAGEUP,         280, 'SDLK_PAGEUP should be imported' );
is( SDLK_PAGEUP(),       280, 'SDLK_PAGEUP() should also be available' );
is( SDLK_PAUSE,          19,  'SDLK_PAUSE should be imported' );
is( SDLK_PAUSE(),        19,  'SDLK_PAUSE() should also be available' );
is( SDLK_PERIOD,         46,  'SDLK_PERIOD should be imported' );
is( SDLK_PERIOD(),       46,  'SDLK_PERIOD() should also be available' );
is( SDLK_PLUS,           43,  'SDLK_PLUS should be imported' );
is( SDLK_PLUS(),         43,  'SDLK_PLUS() should also be available' );
is( SDLK_POWER,          320, 'SDLK_POWER should be imported' );
is( SDLK_POWER(),        320, 'SDLK_POWER() should also be available' );
is( SDLK_PRINT,          316, 'SDLK_PRINT should be imported' );
is( SDLK_PRINT(),        316, 'SDLK_PRINT() should also be available' );
is( SDLK_QUESTION,       63,  'SDLK_QUESTION should be imported' );
is( SDLK_QUESTION(),     63,  'SDLK_QUESTION() should also be available' );
is( SDLK_QUOTE,          39,  'SDLK_QUOTE should be imported' );
is( SDLK_QUOTE(),        39,  'SDLK_QUOTE() should also be available' );
is( SDLK_QUOTEDBL,       34,  'SDLK_QUOTEDBL should be imported' );
is( SDLK_QUOTEDBL(),     34,  'SDLK_QUOTEDBL() should also be available' );
is( SDLK_RALT,           307, 'SDLK_RALT should be imported' );
is( SDLK_RALT(),         307, 'SDLK_RALT() should also be available' );
is( SDLK_RCTRL,          305, 'SDLK_RCTRL should be imported' );
is( SDLK_RCTRL(),        305, 'SDLK_RCTRL() should also be available' );
is( SDLK_RETURN,         13,  'SDLK_RETURN should be imported' );
is( SDLK_RETURN(),       13,  'SDLK_RETURN() should also be available' );
is( SDLK_RIGHT,          275, 'SDLK_RIGHT should be imported' );
is( SDLK_RIGHT(),        275, 'SDLK_RIGHT() should also be available' );
is( SDLK_RIGHTBRACKET,   93,  'SDLK_RIGHTBRACKET should be imported' );
is( SDLK_RIGHTBRACKET(), 93,  'SDLK_RIGHTBRACKET() should also be available' );
is( SDLK_RIGHTPAREN,     41,  'SDLK_RIGHTPAREN should be imported' );
is( SDLK_RIGHTPAREN(),   41,  'SDLK_RIGHTPAREN() should also be available' );
is( SDLK_RMETA,          309, 'SDLK_RMETA should be imported' );
is( SDLK_RMETA(),        309, 'SDLK_RMETA() should also be available' );
is( SDLK_RSHIFT,         303, 'SDLK_RSHIFT should be imported' );
is( SDLK_RSHIFT(),       303, 'SDLK_RSHIFT() should also be available' );
is( SDLK_RSUPER,         312, 'SDLK_RSUPER should be imported' );
is( SDLK_RSUPER(),       312, 'SDLK_RSUPER() should also be available' );
is( SDLK_SCROLLOCK,      302, 'SDLK_SCROLLOCK should be imported' );
is( SDLK_SCROLLOCK(),    302, 'SDLK_SCROLLOCK() should also be available' );
is( SDLK_SEMICOLON,      59,  'SDLK_SEMICOLON should be imported' );
is( SDLK_SEMICOLON(),    59,  'SDLK_SEMICOLON() should also be available' );
is( SDLK_SLASH,          47,  'SDLK_SLASH should be imported' );
is( SDLK_SLASH(),        47,  'SDLK_SLASH() should also be available' );
is( SDLK_SPACE,          32,  'SDLK_SPACE should be imported' );
is( SDLK_SPACE(),        32,  'SDLK_SPACE() should also be available' );
is( SDLK_SYSREQ,         317, 'SDLK_SYSREQ should be imported' );
is( SDLK_SYSREQ(),       317, 'SDLK_SYSREQ() should also be available' );
is( SDLK_TAB,            9,   'SDLK_TAB should be imported' );
is( SDLK_TAB(),          9,   'SDLK_TAB() should also be available' );
is( SDLK_UNDERSCORE,     95,  'SDLK_UNDERSCORE should be imported' );
is( SDLK_UNDERSCORE(),   95,  'SDLK_UNDERSCORE() should also be available' );
is( SDLK_UNDO,           322, 'SDLK_UNDO should be imported' );
is( SDLK_UNDO(),         322, 'SDLK_UNDO() should also be available' );
is( SDLK_UNKNOWN,        0,   'SDLK_WORLD_95 should be imported' );
is( SDLK_UNKNOWN(),      0,   'SDLK_WORLD_95() should also be available' );
is( SDLK_UP,             273, 'SDLK_UP should be imported' );
is( SDLK_UP(),           273, 'SDLK_UP() should also be available' );
is( SDLK_WORLD_0,        160, 'SDLK_WORLD_0 should be imported' );
is( SDLK_WORLD_0(),      160, 'SDLK_WORLD_0() should also be available' );
is( SDLK_WORLD_1,        161, 'SDLK_WORLD_1 should be imported' );
is( SDLK_WORLD_1(),      161, 'SDLK_WORLD_1() should also be available' );
is( SDLK_WORLD_2,        162, 'SDLK_WORLD_2 should be imported' );
is( SDLK_WORLD_2(),      162, 'SDLK_WORLD_2() should also be available' );
is( SDLK_WORLD_3,        163, 'SDLK_WORLD_3 should be imported' );
is( SDLK_WORLD_3(),      163, 'SDLK_WORLD_3() should also be available' );
is( SDLK_WORLD_4,        164, 'SDLK_WORLD_4 should be imported' );
is( SDLK_WORLD_4(),      164, 'SDLK_WORLD_4() should also be available' );
is( SDLK_WORLD_5,        165, 'SDLK_WORLD_5 should be imported' );
is( SDLK_WORLD_5(),      165, 'SDLK_WORLD_5() should also be available' );
is( SDLK_WORLD_6,        166, 'SDLK_WORLD_6 should be imported' );
is( SDLK_WORLD_6(),      166, 'SDLK_WORLD_6() should also be available' );
is( SDLK_WORLD_7,        167, 'SDLK_WORLD_7 should be imported' );
is( SDLK_WORLD_7(),      167, 'SDLK_WORLD_7() should also be available' );
is( SDLK_WORLD_8,        168, 'SDLK_WORLD_8 should be imported' );
is( SDLK_WORLD_8(),      168, 'SDLK_WORLD_8() should also be available' );
is( SDLK_WORLD_9,        169, 'SDLK_WORLD_9 should be imported' );
is( SDLK_WORLD_9(),      169, 'SDLK_WORLD_9() should also be available' );
is( SDLK_WORLD_10,       170, 'SDLK_WORLD_10 should be imported' );
is( SDLK_WORLD_10(),     170, 'SDLK_WORLD_10() should also be available' );
is( SDLK_WORLD_11,       171, 'SDLK_WORLD_11 should be imported' );
is( SDLK_WORLD_11(),     171, 'SDLK_WORLD_11() should also be available' );
is( SDLK_WORLD_12,       172, 'SDLK_WORLD_12 should be imported' );
is( SDLK_WORLD_12(),     172, 'SDLK_WORLD_12() should also be available' );
is( SDLK_WORLD_13,       173, 'SDLK_WORLD_13 should be imported' );
is( SDLK_WORLD_13(),     173, 'SDLK_WORLD_13() should also be available' );
is( SDLK_WORLD_14,       174, 'SDLK_WORLD_14 should be imported' );
is( SDLK_WORLD_14(),     174, 'SDLK_WORLD_14() should also be available' );
is( SDLK_WORLD_15,       175, 'SDLK_WORLD_15 should be imported' );
is( SDLK_WORLD_15(),     175, 'SDLK_WORLD_15() should also be available' );
is( SDLK_WORLD_16,       176, 'SDLK_WORLD_16 should be imported' );
is( SDLK_WORLD_16(),     176, 'SDLK_WORLD_16() should also be available' );
is( SDLK_WORLD_17,       177, 'SDLK_WORLD_17 should be imported' );
is( SDLK_WORLD_17(),     177, 'SDLK_WORLD_17() should also be available' );
is( SDLK_WORLD_18,       178, 'SDLK_WORLD_18 should be imported' );
is( SDLK_WORLD_18(),     178, 'SDLK_WORLD_18() should also be available' );
is( SDLK_WORLD_19,       179, 'SDLK_WORLD_19 should be imported' );
is( SDLK_WORLD_19(),     179, 'SDLK_WORLD_19() should also be available' );
is( SDLK_WORLD_20,       180, 'SDLK_WORLD_20 should be imported' );
is( SDLK_WORLD_20(),     180, 'SDLK_WORLD_20() should also be available' );
is( SDLK_WORLD_21,       181, 'SDLK_WORLD_21 should be imported' );
is( SDLK_WORLD_21(),     181, 'SDLK_WORLD_21() should also be available' );
is( SDLK_WORLD_22,       182, 'SDLK_WORLD_22 should be imported' );
is( SDLK_WORLD_22(),     182, 'SDLK_WORLD_22() should also be available' );
is( SDLK_WORLD_23,       183, 'SDLK_WORLD_23 should be imported' );
is( SDLK_WORLD_23(),     183, 'SDLK_WORLD_23() should also be available' );
is( SDLK_WORLD_24,       184, 'SDLK_WORLD_24 should be imported' );
is( SDLK_WORLD_24(),     184, 'SDLK_WORLD_24() should also be available' );
is( SDLK_WORLD_25,       185, 'SDLK_WORLD_25 should be imported' );
is( SDLK_WORLD_25(),     185, 'SDLK_WORLD_25() should also be available' );
is( SDLK_WORLD_26,       186, 'SDLK_WORLD_26 should be imported' );
is( SDLK_WORLD_26(),     186, 'SDLK_WORLD_26() should also be available' );
is( SDLK_WORLD_27,       187, 'SDLK_WORLD_27 should be imported' );
is( SDLK_WORLD_27(),     187, 'SDLK_WORLD_27() should also be available' );
is( SDLK_WORLD_28,       188, 'SDLK_WORLD_28 should be imported' );
is( SDLK_WORLD_28(),     188, 'SDLK_WORLD_28() should also be available' );
is( SDLK_WORLD_29,       189, 'SDLK_WORLD_29 should be imported' );
is( SDLK_WORLD_29(),     189, 'SDLK_WORLD_29() should also be available' );
is( SDLK_WORLD_30,       190, 'SDLK_WORLD_30 should be imported' );
is( SDLK_WORLD_30(),     190, 'SDLK_WORLD_30() should also be available' );
is( SDLK_WORLD_31,       191, 'SDLK_WORLD_31 should be imported' );
is( SDLK_WORLD_31(),     191, 'SDLK_WORLD_31() should also be available' );
is( SDLK_WORLD_32,       192, 'SDLK_WORLD_32 should be imported' );
is( SDLK_WORLD_32(),     192, 'SDLK_WORLD_32() should also be available' );
is( SDLK_WORLD_33,       193, 'SDLK_WORLD_33 should be imported' );
is( SDLK_WORLD_33(),     193, 'SDLK_WORLD_33() should also be available' );
is( SDLK_WORLD_34,       194, 'SDLK_WORLD_34 should be imported' );
is( SDLK_WORLD_34(),     194, 'SDLK_WORLD_34() should also be available' );
is( SDLK_WORLD_35,       195, 'SDLK_WORLD_35 should be imported' );
is( SDLK_WORLD_35(),     195, 'SDLK_WORLD_35() should also be available' );
is( SDLK_WORLD_36,       196, 'SDLK_WORLD_36 should be imported' );
is( SDLK_WORLD_36(),     196, 'SDLK_WORLD_36() should also be available' );
is( SDLK_WORLD_37,       197, 'SDLK_WORLD_37 should be imported' );
is( SDLK_WORLD_37(),     197, 'SDLK_WORLD_37() should also be available' );
is( SDLK_WORLD_38,       198, 'SDLK_WORLD_38 should be imported' );
is( SDLK_WORLD_38(),     198, 'SDLK_WORLD_38() should also be available' );
is( SDLK_WORLD_39,       199, 'SDLK_WORLD_39 should be imported' );
is( SDLK_WORLD_39(),     199, 'SDLK_WORLD_39() should also be available' );
is( SDLK_WORLD_40,       200, 'SDLK_WORLD_40 should be imported' );
is( SDLK_WORLD_40(),     200, 'SDLK_WORLD_40() should also be available' );
is( SDLK_WORLD_41,       201, 'SDLK_WORLD_41 should be imported' );
is( SDLK_WORLD_41(),     201, 'SDLK_WORLD_41() should also be available' );
is( SDLK_WORLD_42,       202, 'SDLK_WORLD_42 should be imported' );
is( SDLK_WORLD_42(),     202, 'SDLK_WORLD_42() should also be available' );
is( SDLK_WORLD_43,       203, 'SDLK_WORLD_43 should be imported' );
is( SDLK_WORLD_43(),     203, 'SDLK_WORLD_43() should also be available' );
is( SDLK_WORLD_44,       204, 'SDLK_WORLD_44 should be imported' );
is( SDLK_WORLD_44(),     204, 'SDLK_WORLD_44() should also be available' );
is( SDLK_WORLD_45,       205, 'SDLK_WORLD_45 should be imported' );
is( SDLK_WORLD_45(),     205, 'SDLK_WORLD_45() should also be available' );
is( SDLK_WORLD_46,       206, 'SDLK_WORLD_46 should be imported' );
is( SDLK_WORLD_46(),     206, 'SDLK_WORLD_46() should also be available' );
is( SDLK_WORLD_47,       207, 'SDLK_WORLD_47 should be imported' );
is( SDLK_WORLD_47(),     207, 'SDLK_WORLD_47() should also be available' );
is( SDLK_WORLD_48,       208, 'SDLK_WORLD_48 should be imported' );
is( SDLK_WORLD_48(),     208, 'SDLK_WORLD_48() should also be available' );
is( SDLK_WORLD_49,       209, 'SDLK_WORLD_49 should be imported' );
is( SDLK_WORLD_49(),     209, 'SDLK_WORLD_49() should also be available' );
is( SDLK_WORLD_50,       210, 'SDLK_WORLD_50 should be imported' );
is( SDLK_WORLD_50(),     210, 'SDLK_WORLD_50() should also be available' );
is( SDLK_WORLD_51,       211, 'SDLK_WORLD_51 should be imported' );
is( SDLK_WORLD_51(),     211, 'SDLK_WORLD_51() should also be available' );
is( SDLK_WORLD_52,       212, 'SDLK_WORLD_52 should be imported' );
is( SDLK_WORLD_52(),     212, 'SDLK_WORLD_52() should also be available' );
is( SDLK_WORLD_53,       213, 'SDLK_WORLD_53 should be imported' );
is( SDLK_WORLD_53(),     213, 'SDLK_WORLD_53() should also be available' );
is( SDLK_WORLD_54,       214, 'SDLK_WORLD_54 should be imported' );
is( SDLK_WORLD_54(),     214, 'SDLK_WORLD_54() should also be available' );
is( SDLK_WORLD_55,       215, 'SDLK_WORLD_55 should be imported' );
is( SDLK_WORLD_55(),     215, 'SDLK_WORLD_55() should also be available' );
is( SDLK_WORLD_56,       216, 'SDLK_WORLD_56 should be imported' );
is( SDLK_WORLD_56(),     216, 'SDLK_WORLD_56() should also be available' );
is( SDLK_WORLD_57,       217, 'SDLK_WORLD_57 should be imported' );
is( SDLK_WORLD_57(),     217, 'SDLK_WORLD_57() should also be available' );
is( SDLK_WORLD_58,       218, 'SDLK_WORLD_58 should be imported' );
is( SDLK_WORLD_58(),     218, 'SDLK_WORLD_58() should also be available' );
is( SDLK_WORLD_59,       219, 'SDLK_WORLD_59 should be imported' );
is( SDLK_WORLD_59(),     219, 'SDLK_WORLD_59() should also be available' );
is( SDLK_WORLD_60,       220, 'SDLK_WORLD_60 should be imported' );
is( SDLK_WORLD_60(),     220, 'SDLK_WORLD_60() should also be available' );
is( SDLK_WORLD_61,       221, 'SDLK_WORLD_61 should be imported' );
is( SDLK_WORLD_61(),     221, 'SDLK_WORLD_61() should also be available' );
is( SDLK_WORLD_62,       222, 'SDLK_WORLD_62 should be imported' );
is( SDLK_WORLD_62(),     222, 'SDLK_WORLD_62() should also be available' );
is( SDLK_WORLD_63,       223, 'SDLK_WORLD_63 should be imported' );
is( SDLK_WORLD_63(),     223, 'SDLK_WORLD_63() should also be available' );
is( SDLK_WORLD_64,       224, 'SDLK_WORLD_64 should be imported' );
is( SDLK_WORLD_64(),     224, 'SDLK_WORLD_64() should also be available' );
is( SDLK_WORLD_65,       225, 'SDLK_WORLD_65 should be imported' );
is( SDLK_WORLD_65(),     225, 'SDLK_WORLD_65() should also be available' );
is( SDLK_WORLD_66,       226, 'SDLK_WORLD_66 should be imported' );
is( SDLK_WORLD_66(),     226, 'SDLK_WORLD_66() should also be available' );
is( SDLK_WORLD_67,       227, 'SDLK_WORLD_67 should be imported' );
is( SDLK_WORLD_67(),     227, 'SDLK_WORLD_67() should also be available' );
is( SDLK_WORLD_68,       228, 'SDLK_WORLD_68 should be imported' );
is( SDLK_WORLD_68(),     228, 'SDLK_WORLD_68() should also be available' );
is( SDLK_WORLD_69,       229, 'SDLK_WORLD_69 should be imported' );
is( SDLK_WORLD_69(),     229, 'SDLK_WORLD_69() should also be available' );
is( SDLK_WORLD_70,       230, 'SDLK_WORLD_70 should be imported' );
is( SDLK_WORLD_70(),     230, 'SDLK_WORLD_70() should also be available' );
is( SDLK_WORLD_71,       231, 'SDLK_WORLD_71 should be imported' );
is( SDLK_WORLD_71(),     231, 'SDLK_WORLD_71() should also be available' );
is( SDLK_WORLD_72,       232, 'SDLK_WORLD_72 should be imported' );
is( SDLK_WORLD_72(),     232, 'SDLK_WORLD_72() should also be available' );
is( SDLK_WORLD_73,       233, 'SDLK_WORLD_73 should be imported' );
is( SDLK_WORLD_73(),     233, 'SDLK_WORLD_73() should also be available' );
is( SDLK_WORLD_74,       234, 'SDLK_WORLD_74 should be imported' );
is( SDLK_WORLD_74(),     234, 'SDLK_WORLD_74() should also be available' );
is( SDLK_WORLD_75,       235, 'SDLK_WORLD_75 should be imported' );
is( SDLK_WORLD_75(),     235, 'SDLK_WORLD_75() should also be available' );
is( SDLK_WORLD_76,       236, 'SDLK_WORLD_76 should be imported' );
is( SDLK_WORLD_76(),     236, 'SDLK_WORLD_76() should also be available' );
is( SDLK_WORLD_77,       237, 'SDLK_WORLD_77 should be imported' );
is( SDLK_WORLD_77(),     237, 'SDLK_WORLD_77() should also be available' );
is( SDLK_WORLD_78,       238, 'SDLK_WORLD_78 should be imported' );
is( SDLK_WORLD_78(),     238, 'SDLK_WORLD_78() should also be available' );
is( SDLK_WORLD_79,       239, 'SDLK_WORLD_79 should be imported' );
is( SDLK_WORLD_79(),     239, 'SDLK_WORLD_79() should also be available' );
is( SDLK_WORLD_80,       240, 'SDLK_WORLD_80 should be imported' );
is( SDLK_WORLD_80(),     240, 'SDLK_WORLD_80() should also be available' );
is( SDLK_WORLD_81,       241, 'SDLK_WORLD_81 should be imported' );
is( SDLK_WORLD_81(),     241, 'SDLK_WORLD_81() should also be available' );
is( SDLK_WORLD_82,       242, 'SDLK_WORLD_82 should be imported' );
is( SDLK_WORLD_82(),     242, 'SDLK_WORLD_82() should also be available' );
is( SDLK_WORLD_83,       243, 'SDLK_WORLD_83 should be imported' );
is( SDLK_WORLD_83(),     243, 'SDLK_WORLD_83() should also be available' );
is( SDLK_WORLD_84,       244, 'SDLK_WORLD_84 should be imported' );
is( SDLK_WORLD_84(),     244, 'SDLK_WORLD_84() should also be available' );
is( SDLK_WORLD_85,       245, 'SDLK_WORLD_85 should be imported' );
is( SDLK_WORLD_85(),     245, 'SDLK_WORLD_85() should also be available' );
is( SDLK_WORLD_86,       246, 'SDLK_WORLD_86 should be imported' );
is( SDLK_WORLD_86(),     246, 'SDLK_WORLD_86() should also be available' );
is( SDLK_WORLD_87,       247, 'SDLK_WORLD_87 should be imported' );
is( SDLK_WORLD_87(),     247, 'SDLK_WORLD_87() should also be available' );
is( SDLK_WORLD_88,       248, 'SDLK_WORLD_88 should be imported' );
is( SDLK_WORLD_88(),     248, 'SDLK_WORLD_88() should also be available' );
is( SDLK_WORLD_89,       249, 'SDLK_WORLD_89 should be imported' );
is( SDLK_WORLD_89(),     249, 'SDLK_WORLD_89() should also be available' );
is( SDLK_WORLD_90,       250, 'SDLK_WORLD_90 should be imported' );
is( SDLK_WORLD_90(),     250, 'SDLK_WORLD_90() should also be available' );
is( SDLK_WORLD_91,       251, 'SDLK_WORLD_91 should be imported' );
is( SDLK_WORLD_91(),     251, 'SDLK_WORLD_91() should also be available' );
is( SDLK_WORLD_92,       252, 'SDLK_WORLD_92 should be imported' );
is( SDLK_WORLD_92(),     252, 'SDLK_WORLD_92() should also be available' );
is( SDLK_WORLD_93,       253, 'SDLK_WORLD_93 should be imported' );
is( SDLK_WORLD_93(),     253, 'SDLK_WORLD_93() should also be available' );
is( SDLK_WORLD_94,       254, 'SDLK_WORLD_94 should be imported' );
is( SDLK_WORLD_94(),     254, 'SDLK_WORLD_94() should also be available' );
is( SDLK_WORLD_95,       255, 'SDLK_WORLD_95 should be imported' );
is( SDLK_WORLD_95(),     255, 'SDLK_WORLD_95() should also be available' );
is( SDLK_a,              97,  'SDLK_a should be imported' );
is( SDLK_a(),            97,  'SDLK_a() should also be available' );
is( SDLK_b,              98,  'SDLK_b should be imported' );
is( SDLK_b(),            98,  'SDLK_b() should also be available' );
is( SDLK_c,              99,  'SDLK_c should be imported' );
is( SDLK_c(),            99,  'SDLK_c() should also be available' );
is( SDLK_d,              100, 'SDLK_d should be imported' );
is( SDLK_d(),            100, 'SDLK_d() should also be available' );
is( SDLK_e,              101, 'SDLK_e should be imported' );
is( SDLK_e(),            101, 'SDLK_e() should also be available' );
is( SDLK_f,              102, 'SDLK_f should be imported' );
is( SDLK_f(),            102, 'SDLK_f() should also be available' );
is( SDLK_g,              103, 'SDLK_g should be imported' );
is( SDLK_g(),            103, 'SDLK_g() should also be available' );
is( SDLK_h,              104, 'SDLK_h should be imported' );
is( SDLK_h(),            104, 'SDLK_h() should also be available' );
is( SDLK_i,              105, 'SDLK_i should be imported' );
is( SDLK_i(),            105, 'SDLK_i() should also be available' );
is( SDLK_j,              106, 'SDLK_j should be imported' );
is( SDLK_j(),            106, 'SDLK_j() should also be available' );
is( SDLK_k,              107, 'SDLK_k should be imported' );
is( SDLK_k(),            107, 'SDLK_k() should also be available' );
is( SDLK_l,              108, 'SDLK_l should be imported' );
is( SDLK_l(),            108, 'SDLK_l() should also be available' );
is( SDLK_m,              109, 'SDLK_m should be imported' );
is( SDLK_m(),            109, 'SDLK_m() should also be available' );
is( SDLK_n,              110, 'SDLK_n should be imported' );
is( SDLK_n(),            110, 'SDLK_n() should also be available' );
is( SDLK_o,              111, 'SDLK_o should be imported' );
is( SDLK_o(),            111, 'SDLK_o() should also be available' );
is( SDLK_p,              112, 'SDLK_p should be imported' );
is( SDLK_p(),            112, 'SDLK_p() should also be available' );
is( SDLK_q,              113, 'SDLK_q should be imported' );
is( SDLK_q(),            113, 'SDLK_q() should also be available' );
is( SDLK_r,              114, 'SDLK_r should be imported' );
is( SDLK_r(),            114, 'SDLK_r() should also be available' );
is( SDLK_s,              115, 'SDLK_s should be imported' );
is( SDLK_s(),            115, 'SDLK_s() should also be available' );
is( SDLK_t,              116, 'SDLK_t should be imported' );
is( SDLK_t(),            116, 'SDLK_t() should also be available' );
is( SDLK_u,              117, 'SDLK_u should be imported' );
is( SDLK_u(),            117, 'SDLK_u() should also be available' );
is( SDLK_v,              118, 'SDLK_v should be imported' );
is( SDLK_v(),            118, 'SDLK_v() should also be available' );
is( SDLK_w,              119, 'SDLK_w should be imported' );
is( SDLK_w(),            119, 'SDLK_w() should also be available' );
is( SDLK_x,              120, 'SDLK_x should be imported' );
is( SDLK_x(),            120, 'SDLK_x() should also be available' );
is( SDLK_y,              121, 'SDLK_y should be imported' );
is( SDLK_y(),            121, 'SDLK_y() should also be available' );
is( SDLK_z,              122, 'SDLK_z should be imported' );
is( SDLK_z(),            122, 'SDLK_z() should also be available' );

my $display = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );

is( SDL::Events::pump_events(), undef, '[pump_events] Returns undef' );

my $event = SDL::Event->new();

my $aevent = SDL::Event->new();
$aevent->type(SDL_ACTIVEEVENT);
$aevent->active_gain(1);
$aevent->active_state(SDL_APPINPUTFOCUS);

my $userdata = SDL::Event->new();
$userdata->type(SDL_USEREVENT);
my @udata = ( 0 .. 10 );
$userdata->user_data1( \@udata );

SDL::Events::push_event($aevent);
pass '[push_event] Event can be pushed';
SDL::Events::push_event($userdata);
SDL::Events::pump_events();
pass '[pump_events] pumping events';

my $got_event = 0;

while (1) {
    SDL::Events::pump_events();

    my $ret = SDL::Events::poll_event($event);
    my $r;
    if (   $event->type == SDL_ACTIVEEVENT
        && $event->active_gain == 1
        && $event->active_state == SDL_APPINPUTFOCUS )
    {
        $got_event = 1;
        is( $got_event, 1, '[poll_event] Got an Active event back out' );
        is( $event->active_gain(), 1, '[poll_event] Got right active->gain' );
        is( $event->active_state(), SDL_APPINPUTFOCUS,
            '[poll_event] Got right active->state' );

    }
    if ( $event->type == SDL_USEREVENT ) {
        $r = $event->user_data1();
        is( @{$r}, 11, '[user_events] can hold user data now' );

    }
    last if $r && $got_event;
    last if ( $ret == 0 );
}

SDL::Events::push_event($aevent);
pass '[push_event] ran';

SDL::Events::pump_events();

my $value = SDL::Events::wait_event($event);

is( $value, 1, '[wait_event] waited for event' );

my $num_peep_events =
  SDL::Events::peep_events( $event, 127, SDL_PEEKEVENT, SDL_ALLEVENTS );
is( $num_peep_events >= 0,
    1, '[peep_events] Size of event queue is ' . $num_peep_events );

my $callback = sub { return 1; };
SDL::Events::set_event_filter($callback);
pass '[set_event_filter] takes a callback';

my $array = SDL::Events::get_key_state();
isa_ok( $array, 'ARRAY', '[get_key_state] returned and array' );

my @mods = (
    KMOD_NONE,  KMOD_LSHIFT, KMOD_RSHIFT, KMOD_LCTRL,
    KMOD_RCTRL, KMOD_LALT,   KMOD_RALT,   KMOD_LMETA,
    KMOD_RMETA, KMOD_NUM,    KMOD_CAPS,   KMOD_MODE,
);

foreach (@mods) {
    SDL::Events::set_mod_state($_);
    pass '[set_mod_state] set the mod properly';
    is( SDL::Events::get_mod_state(),
        $_, '[get_mod_state] got the mod properly' );

}

#SDL::quit();

#SDL::init(SDL_INIT_VIDEO);

$display = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );

SDL::Video::get_video_info();

is( SDL::Events::get_key_name(SDLK_ESCAPE),
    'escape', '[get_key_name] Gets name of key_sym back' );

SDL::Events::push_event($aevent);
my $nevent = SDL::Event->new();
SDL::Events::event_state( SDL_ACTIVEEVENT, SDL_IGNORE );
SDL::Events::pump_events();

my $got = 0;
while ( SDL::Events::poll_event($nevent) ) {
    $got = 1 if $nevent->type == SDL_ACTIVEEVENT;
}
is( $got, 0, '[event_state] works with SDL_IGNORE on SDL_ACTIVEEVENT' );

SDL::Events::event_state( SDL_ACTIVEEVENT, SDL_ENABLE );
SDL::Events::push_event($aevent);
SDL::Events::pump_events();
my $atleast = 0;
while ( SDL::Events::poll_event($nevent) ) {
    $atleast = 1 if $nevent->type == SDL_ACTIVEEVENT;
}
is( $atleast, 1, '[event_state] works with SDL_ENABLE on SDL_ACTIVEEVENT' );

is( SDL::Events::enable_unicode(1),  0, '[enable_unicode] return 0 took 1' );
is( SDL::Events::enable_unicode(-1), 1, '[enable_unicode] return 1 took -1' );
is( SDL::Events::enable_unicode(0),  1, '[enable_unicode] return 1 took 0' );
is( SDL::Events::enable_unicode(-1), 0, '[enable_unicode] return 1 took -1' );

#my $kr =  SDL::Events::enable_key_repeat( SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);
my $kr = SDL::Events::enable_key_repeat( 10, 10 );

is( ( $kr == -1 || $kr == 0 ),
    1, '[enable_key_repeat] returned expeceted values' );

SDL::Events::pump_events();

my $ms = SDL::Events::get_mouse_state();

isa_ok( $ms, 'ARRAY',
    '[get_mouse_state] got back array size of ' . @{$ms} . ' ' );

$ms = SDL::Events::get_relative_mouse_state();

isa_ok( $ms, 'ARRAY',
    '[get_relative_mouse_state] got back array size of ' . @{$ms} . ' ' );

$ms = SDL::Events::get_app_state();

is( ( $ms >= SDL_APPACTIVE || SDL_APPINPUTFOCUS && $ms <= SDL_APPMOUSEFOCUS ),
    1, '[get_app_state] Returns value within parameter ' . $ms );

is( SDL::Events::joystick_event_state(SDL_ENABLE),
    SDL_ENABLE, '[joystick_event_state] return SDL_IGNORE correctly' );
is( SDL::Events::joystick_event_state(SDL_QUERY),
    SDL_ENABLE, '[joystick_event_state] return SDL_ENABLE took SDL_QUERY' );
is( SDL::Events::joystick_event_state(SDL_IGNORE),
    SDL_IGNORE, '[joystick_event_state] return SDL_IGNORE correctly' );
is( SDL::Events::joystick_event_state(SDL_QUERY),
    SDL_IGNORE, '[joystick_event_state] return  SDL_IGNORE took SDL_QUERY ' );

SKIP:
{
    skip "Turn SDL_GUI_TEST on", 1 unless $ENV{'SDL_GUI_TEST'};

    SDL::quit();
    SDL::init(SDL_INIT_VIDEO);
    $display = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );
    $event = SDL::Event->new();

    #This filters out all ActiveEvents
    my $filter = sub {
        if   ( $_[0]->type == SDL_ACTIVEEVENT ) { return 0 }
        else                                    { return 1; }
    };
    my $filtered = 1;

    SDL::Events::set_event_filter($filter);

    while (1) {
        SDL::Events::pump_events();
        if ( SDL::Events::poll_event($event) ) {
            if ( $event->type == SDL_ACTIVEEVENT ) {
                diag 'We should not be in here. The next test will fail!';
                $filtered = 0;    #we got a problem!
                print "Hello Mouse!!!\n"
                  if ( $event->active_gain
                    && ( $event->active_state == SDL_APPMOUSEFOCUS ) );
                print "Bye Mouse!!!\n"
                  if ( !$event->active_gain
                    && ( $event->active_state == SDL_APPMOUSEFOCUS ) );
            }
            last if ( $event->type == SDL_QUIT );
        }
    }
    is( $filtered, 1, '[set_event_filter] Properly filtered SDL_ACTIVEEVENT' );
}

if ($videodriver) {
    $ENV{SDL_VIDEODRIVER} = $videodriver;
}
else {
    delete $ENV{SDL_VIDEODRIVER};
}

#SDL::quit();
pass 'Are we still alive? Checking for segfaults';

done_testing;

sleep(2);
