#!perl
use strict;
use warnings;
use SDL;
use SDL::Rect;
use SDL::Config;
use SDL::Video;
use SDL::Version;
use SDL::Surface;
use SDL::PixelFormat;
use SDL::GFX;
use SDL::GFX::Rotozoom;
use Test::More;

use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
} elsif ( !SDL::Config->has('SDL_gfx_rotozoom') ) {
	plan( skip_all => 'SDL_gfx_rotozoom support not compiled' );
} else {
	plan( tests => 23 );
}

my $v = SDL::GFX::linked_version();
isa_ok( $v, 'SDL::Version', '[linked_version]' );
printf( "got version: %d.%d.%d\n", $v->major, $v->minor, $v->patch );

is( SMOOTHING_OFF,   0, 'SMOOTHING_OFF should be imported' );
is( SMOOTHING_OFF(), 0, 'SMOOTHING_OFF() should also be available' );
is( SMOOTHING_ON,    1, 'SMOOTHING_ON should be imported' );
is( SMOOTHING_ON(),  1, 'SMOOTHING_ON() should also be available' );

my $display = SDL::Video::set_video_mode( 640, 480, 32, SDL_ANYFORMAT );
my $pixel = SDL::Video::map_RGB( $display->format, 0, 0, 0 );
SDL::Video::fill_rect(
	$display,
	SDL::Rect->new( 0, 0, $display->w, $display->h ), $pixel
);

if ( !$display ) {
	plan skip_all => 'Couldn\'t set video mode: ' . SDL::get_error();
}

my $src = SDL::Video::load_BMP('test/data/picture.bmp');

draw();

# Note: new surface should be less than 16384 in width and height
isa_ok(
	SDL::GFX::Rotozoom::surface( $src, 0, 1, 0 ),
	'SDL::Surface', 'surface'
);
draw();
my ( $dest_w, $dest_h ) = @{ SDL::GFX::Rotozoom::surface_size( 100, 200, 45, 1 ) };
is( $dest_w > 100, 1, 'surface_size, resulting width raises at angle is 45' );
is( $dest_h > 200, 1, 'surface_size, resulting height raises at angle is 45' );
( $dest_w, $dest_h ) = @{ SDL::GFX::Rotozoom::surface_size( 100, 200, 45, 0.3 ) };
is( $dest_w < 100, 1, 'surface_size, resulting width decreases at zoom 0.3' );
is( $dest_h < 200, 1, 'surface_size, resulting height decreases at zoom 0.3' );

SKIP:
{
	skip( 'Version 2.0.13 needed', 1 )
		unless ( $v->major >= 2 && $v->minor >= 0 && $v->patch >= 13 );
	isa_ok(
		SDL::GFX::Rotozoom::surface_xy( $src, 1, 1, 1, 1 ),
		'SDL::Surface', 'surface_xy'
	);
	draw();
}
( $dest_w, $dest_h ) = @{ SDL::GFX::Rotozoom::surface_size_xy( 100, 200, 45, 1.3, 1.7 ) };
is( $dest_w > 100,
	1, 'surface_size_xy, resulting width raises at zoom 1.3 and angle 45'
);
is( $dest_h > 200,
	1, 'surface_size_xy, resulting height raises at zoom 1.7 ans angle 45'
);
( $dest_w, $dest_h ) = @{ SDL::GFX::Rotozoom::surface_size_xy( 100, 200, 45, 0.3, 0.2 ) };
is( $dest_w < 100,
	1, 'surface_size_xy, resulting width decreases at zoom 0.3 and angle 45'
);
is( $dest_h < 200,
	1, 'surface_size_xy, resulting height decreases at zoom 0.2 ans angle 45'
);

isa_ok(
	SDL::GFX::Rotozoom::zoom_surface( $src, 1, 1, 1 ),
	'SDL::Surface', 'zoom_surface'
);
draw();
( $dest_w, $dest_h ) = @{ SDL::GFX::Rotozoom::zoom_surface_size( 100, 200, 0.5, 0.7 ) };
is( $dest_w < 100,
	1, 'zoom_surface_size, resulting width decreases at zoom 0.5'
);
is( $dest_h < 200,
	1, 'zoom_surface_size, resulting height decreases at zoom 0.7'
);
( $dest_w, $dest_h ) = @{ SDL::GFX::Rotozoom::zoom_surface_size( 100, 200, 1.2, 7.7 ) };
is( $dest_w > 100, 1, 'zoom_surface_size, resulting width raises at zoom 1.2' );
is( $dest_h > 200, 1,
	'zoom_surface_size, resulting height raises at zoom 7.7'
);

SKIP:
{
	skip( 'Version 2.0.14 needed', 1 )
		unless ( $v->major >= 2 && $v->minor >= 0 && $v->patch >= 14 );
	isa_ok(
		SDL::GFX::Rotozoom::shrink_surface( $src, 1, 1 ),
		'SDL::Surface', 'shrink_surface'
	);
	draw();
}
$src = SDL::Surface->new( SDL_SWSURFACE, 100, 200, 32, 0, 0, 0, 0 );
SKIP:
{
	skip( 'Version 2.0.17 needed', 1 )
		unless ( $v->major >= 2 && $v->minor >= 0 && $v->patch >= 17 );
	isa_ok(
		SDL::GFX::Rotozoom::rotate_surface_90_degrees( $src, 1 ),
		'SDL::Surface', 'rotate_surface_90_degrees'
	);
}

# Note: everything but 32bit surface will crash

for ( 1 .. 5 ) {
	draw();
}

sub draw {
	my $surface = $src;
	SDL::Video::blit_surface(
		$surface,
		SDL::Rect->new( 0, 0, $surface->w, $surface->h ),
		$display,
		SDL::Rect->new( 50 * 20, 100, $surface->w + 50 + 20, $surface->h + 100 )
	);
	SDL::Video::update_rect( $display, 0, 0, 640, 480 );

}

SDL::delay(1000);

if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

pass 'Are we still alive? Checking for segfaults';

done_testing;
