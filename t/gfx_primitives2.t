#!perl
use strict;
use warnings;
use SDL;
use SDL::Rect;
use SDL::Config;
use SDL::Video;
use SDL::Version;
use SDL::Surface;
use SDL::GFX;
use SDL::GFX::Primitives;
use Test::More;

use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
    plan( skip_all => 'Failed to init video' );
}
elsif ( !SDL::Config->has('SDL_gfx_primitives') ) {
    plan( skip_all => 'SDL_gfx_primitives support not compiled' );
}

my $v = SDL::GFX::linked_version();
isa_ok( $v, 'SDL::Version', '[linked_version]' );
printf( "got version: %d.%d.%d\n", $v->major, $v->minor, $v->patch );

my $display = SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );
my $pixel = SDL::Video::map_RGB( $display->format, 0, 0, 0 );
SDL::Video::fill_rect( $display,
    SDL::Rect->new( 0, 0, $display->w, $display->h ), $pixel );

if ( !$display ) {
    plan skip_all => 'Couldn\'t set video mode: ' . SDL::get_error();
}

# ellipse/aaellipse/filled_ellipse tests
is( SDL::GFX::Primitives::ellipse_color( $display, 3, 245, 1, 2, 0xFF0000FF ),
    0, 'ellipse_color' );    # red
is(
    SDL::GFX::Primitives::ellipse_RGBA(
        $display, 7, 245, 1, 2, 0x00, 0xFF, 0x00, 0xFF
    ),
    0,
    'ellipse_RGBA'
);                           # green
is(
    SDL::GFX::Primitives::aaellipse_color(
        $display, 11, 245, 1, 2, 0x0000FFFF
    ),
    0,
    'aaellipse_color'
);                           # blue
is(
    SDL::GFX::Primitives::aaellipse_RGBA(
        $display, 15, 245, 1, 2, 0xFF, 0xFF, 0x00, 0xFF
    ),
    0,
    'aaellipse_RGBA'
);                           # yellow
is(
    SDL::GFX::Primitives::filled_ellipse_color(
        $display, 19, 245, 1, 2, 0x00FFFFFF
    ),
    0,
    'filled_ellipse_color'
);                           # cyan
is(
    SDL::GFX::Primitives::filled_ellipse_RGBA(
        $display, 23, 245, 1, 2, 0xFF, 0x00, 0xFF, 0xFF
    ),
    0,
    'filled_ellipse_RGBA'
);                           # magenta

# ellipse/aaellipse/filled_ellipse demo
SDL::GFX::Primitives::aaellipse_color( $display, 65, 249 + 2 * $_,
    60, 2 * $_, 0xFFFFFF80 )
  for ( 1 .. 25 );
SDL::GFX::Primitives::filled_ellipse_RGBA( $display, 65, 405, 60 - 1.2 * $_,
    50 - $_, 0xFF, 0x00, 0x00, 0x05 )
  for ( 0 .. 30 );
SDL::GFX::Primitives::filled_ellipse_RGBA( $display, 65, 405, 12, 10, 0x00,
    0x00, 0x00, 0xFF );
SDL::GFX::Primitives::aaellipse_RGBA( $display, 65, 405, 12, 10, 0x00, 0x00,
    0x00, 0xFF );

# trigon/aatrigon/filled_trigon tests
is(
    SDL::GFX::Primitives::trigon_color(
        $display, 130, 243, 132, 245, 130, 247, 0xFF0000FF
    ),
    0,
    'trigon_color'
);    # red
is(
    SDL::GFX::Primitives::trigon_RGBA(
        $display, 134, 243, 136, 245, 134, 247, 0x00, 0xFF, 0x00, 0xFF
    ),
    0,
    'trigon_RGBA'
);    # green
is(
    SDL::GFX::Primitives::aatrigon_color(
        $display, 138, 243, 140, 245, 138, 247, 0x0000FFFF
    ),
    0,
    'aatrigon_color'
);    # blue
is(
    SDL::GFX::Primitives::aatrigon_RGBA(
        $display, 142, 243, 144, 245, 142, 247, 0xFF, 0xFF, 0x00, 0xFF
    ),
    0,
    'aatrigon_RGBA'
);    # yellow
is(
    SDL::GFX::Primitives::filled_trigon_color(
        $display, 146, 243, 148, 245, 146, 247, 0x00FFFFFF
    ),
    0,
    'filled_trigon_color'
);    # cyan
is(
    SDL::GFX::Primitives::filled_trigon_RGBA(
        $display, 150, 243, 152, 245, 150, 247, 0xFF, 0x00, 0xFF, 0xFF
    ),
    0,
    'filled_trigon_RGBA'
);    # magenta

# polygon/aapolygon/filled_polygon/textured_polygon/MT/ tests

my $surf = SDL::Video::load_BMP('test/data/pattern_red_white_2x2.bmp');

is(
    SDL::GFX::Primitives::polygon_color(
        $display,
        [ 262, 266, 264, 266, 262 ],
        [ 243, 243, 245, 247, 247 ],
        5, 0xFF0000FF
    ),
    0,
    'polygon_color'
);    # red
is(
    SDL::GFX::Primitives::polygon_RGBA(
        $display,
        [ 268, 272, 270, 272, 268 ],
        [ 243, 243, 245, 247, 247 ],
        5, 0x00, 0xFF, 0x00, 0xFF
    ),
    0,
    'polygon_RGBA'
);    # green
is(
    SDL::GFX::Primitives::aapolygon_color(
        $display,
        [ 274, 278, 276, 278, 274 ],
        [ 243, 243, 245, 247, 247 ],
        5, 0x0000FFFF
    ),
    0,
    'aapolygon_color'
);    # blue
is(
    SDL::GFX::Primitives::aapolygon_RGBA(
        $display,
        [ 280, 284, 282, 284, 280 ],
        [ 243, 243, 245, 247, 247 ],
        5, 0xFF, 0xFF, 0x00, 0xFF
    ),
    0,
    'aapolygon_RGBA'
);    # yellow
is(
    SDL::GFX::Primitives::filled_polygon_color(
        $display,
        [ 286, 290, 288, 290, 286 ],
        [ 243, 243, 245, 247, 247 ],
        5, 0x00FFFFFF
    ),
    0,
    'filled_polygon_color'
);    # cyan
is(
    SDL::GFX::Primitives::filled_polygon_RGBA(
        $display,
        [ 292, 296, 294, 296, 292 ],
        [ 243, 243, 245, 247, 247 ],
        5, 0xFF, 0x00, 0xFF, 0xFF
    ),
    0,
    'filled_polygon_RGBA'
);    # magenta
SKIP:
{
    skip( 'Version 2.0.14 needed', 1 )
      unless ( $v->major >= 2 && $v->minor >= 0 && $v->patch >= 14 );
    isnt(
        SDL::GFX::Primitives::textured_polygon(
            $display,
            [ 298, 302, 300, 302, 298 ],
            [ 243, 243, 245, 247, 247 ],
            5, $surf, 0, 0
        ),
        -1,
        'textured_polygon'
    );    # texture
}
SKIP:
{
    skip( 'Version 2.0.17 needed', 3 )
      unless ( $v->major >= 2 && $v->minor >= 0 && $v->patch >= 17 );
    is(
        SDL::GFX::Primitives::filled_polygon_color_MT(
            $display,
            [ 304, 308, 306, 308, 304 ],
            [ 243, 243, 245, 247, 247 ],
            5, 0xFF0000FF, 0, 0
        ),
        0,
        'filled_polygon_color_MT'
    );    # red
    is(
        SDL::GFX::Primitives::filled_polygon_RGBA_MT(
            $display,
            [ 310, 314, 312, 314, 310 ],
            [ 243, 243, 245, 247, 247 ],
            5, 0x00, 0xFF, 0x00, 0xFF, 0, 0
        ),
        0,
        'filled_polygon_RGBA_MT'
    );    # green
    isnt(
        SDL::GFX::Primitives::textured_polygon_MT(
            $display,
            [ 316, 320, 318, 320, 316 ],
            [ 243, 243, 245, 247, 247 ],
            5, $surf, 0, 0, 0, 0
        ),
        -1,
        'textured_polygon_MT '
    );    # texture
}

# polygon demo
SDL::GFX::Primitives::filled_polygon_color(
    $display,
    [ 311, 331, 381, 301, 311, 351 ],
    [ 293, 293, 378, 378, 361, 361 ],
    6, 0xFF000080
);        # red
SDL::GFX::Primitives::filled_polygon_color(
    $display,
    [ 381, 371, 271, 311, 321, 301 ],
    [ 378, 395, 395, 327, 344, 378 ],
    6, 0x00FF0080
);        # green
SDL::GFX::Primitives::filled_polygon_color(
    $display,
    [ 271, 261, 311, 351, 331, 311 ],
    [ 395, 378, 293, 361, 361, 327 ],
    6, 0x0000FF80
);        # blue

# bezier test
is(
    SDL::GFX::Primitives::bezier_color(
        $display,
        [ 390, 392, 394, 396 ],
        [ 243, 255, 235, 247 ],
        4, 20, 0xFF00FFFF
    ),
    0,
    'polygon_color'
);        # red
is(
    SDL::GFX::Primitives::bezier_RGBA(
        $display,
        [ 398, 400, 402, 404 ],
        [ 243, 255, 235, 247 ],
        4, 20, 0x00, 0xFF, 0x00, 0xFF
    ),
    0,
    'polygon_RGBA'
);        # green

#character/string tests
is(
    SDL::GFX::Primitives::character_color(
        $display, 518, 243, 'A', 0xFF0000FF
    ),
    0,
    'character_color'
);        # red
is(
    SDL::GFX::Primitives::character_RGBA(
        $display, 526, 243, 'B', 0x00, 0xFF, 0x00, 0xFF
    ),
    0,
    'character_RGBA'
);        # green
is(
    SDL::GFX::Primitives::string_color( $display, 534, 243, 'CD', 0x0000FFFF ),
    0, 'string_color'
);        # blue
is(
    SDL::GFX::Primitives::string_RGBA(
        $display, 550, 243, 'DE', 0xFF, 0xFF, 0x00, 0xFF
    ),
    0,
    'string_RGBA'
);        # yellow

SKIP:
{
    skip ' test font not found', 1 unless -e 'test/data/5x7.fnt';
    my $font = '';
    open( FH, '<', 'test/data/5x7.fnt' );
    binmode(FH);
    read( FH, $font, 2048 );
    close(FH);

    is( SDL::GFX::Primitives::set_font( $font, 5, 7 ), undef, 'set_font' );
}

#chracater demo
SDL::GFX::Primitives::character_RGBA(
    $display,
    518 + ( $_ % 17 ) * 7,
    251 + int( $_ / 17 ) * 8,
    chr($_), 0x80 + $_ / 2,
    0xFF, 0x00, 0xFF
) for ( 0 .. 255 );

SDL::Video::update_rect( $display, 0, 0, 640, 480 );

SDL::delay(3000);

if ($videodriver) {
    $ENV{SDL_VIDEODRIVER} = $videodriver;
}
else {
    delete $ENV{SDL_VIDEODRIVER};
}

pass 'Are we still alive? Checking for segfaults';

done_testing;
