use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Surface;
use SDL::Rect;
use SDLx::Surface;
use SDL::PixelFormat;
use SDL::Video;
use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
}

my $app = SDL::Video::set_video_mode( 400, 200, 32, SDL_SWSURFACE );

my $app_x = SDLx::Surface::display();

is_deeply(
	$app_x->surface->get_pixels_ptr,
	$app->get_pixels_ptr, '[display] works'
);

my $surface = SDL::Surface->new( SDL_SWSURFACE, 400, 200, 32 );
my @surfs = (
	SDLx::Surface->new( surface => $surface ),
	SDLx::Surface->new( width   => 400, height => 200 ),
	SDLx::Surface->new(
		width  => 400,
		height => 200,
		flags  => SDL_SWSURFACE,
		depth  => 32
	),
	SDLx::Surface->new(
		width     => 400,
		height    => 200,
		flags     => SDL_SWSURFACE,
		depth     => 32,
		greenmask => 0xFF000000
	),
);

foreach my $a (@surfs) {
	isa_ok( $a, 'SDLx::Surface' );

	isa_ok( $a->surface(), 'SDL::Surface' );

	my $color = $a->[0][0];
	is( $color, 0, 'Right color returned' );

	$a->[0][0] = 0x00FF00FF;
	is( $a->[0][0], 0x00FF00FF, 'Right color returned' );

	is( @{$a}, 200, 'Correct Y value' );

	is( @{ $a->[0] }, 400, 'Correct X value' );

}

#my $source = SDLx::Surface->new( width=> 400, height=>200, flags=> SDL_SWSURFACE, depth=>32 ),

is( $surfs[0]->[1][2], 0, 'Checking source pixel is 0' );
is( $surfs[1]->[1][2], 0, 'Checking dest pixel is 0' );

$surfs[0]->[1][2] = 0x00FF00FF;

is( $surfs[0]->[1][2], 0x00FF00FF, 'Checking that source pixel got written' );

$surfs[0]->blit( $surfs[1] );

#SDL::Video::blit_surface( $surfs[0]->surface, SDL::Rect->new(0,0,400,200), $surfs[1]->surface, SDL::Rect->new(0,0,400,200));

isnt( $surfs[1]->[1][2], 0, 'Pixel blitted from one surface to another' );

$surfs[1]->blit_by( $surfs[0], undef, [ 1, 0, 0, 0 ] );

isnt( $surfs[1]->[2][2], 0, 'Pixel by_blitted to another surface with offset' );

push @surfs,
	SDLx::Surface->new(
	w     => 1,
	h     => 1,
	color => 1,
	);

is( $surfs[-1]->[0][0], 1, 'Fill color worked' );

$surfs[1]->flip();

pass 'Fliped the surface';

$surfs[0]->update();
pass 'update all surface';
$surfs[0]->update( [ 0, 10, 30, 40 ] );
pass 'Single rect update';
$surfs[0]->update( [ SDL::Rect->new( 0, 1, 2, 3 ), SDL::Rect->new( 2, 4, 5, 6 ) ] );
pass 'SDL::Rect array update';

$surfs[0]->draw_rect( [ 0, 0, 10, 20 ], 0xFF00FFFF );
pass 'draw_rect works';

SKIP:
{
    skip ('SDL_gfx_primitives needed', 2) unless SDL::Config->has('SDL_gfx_primitives');
$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], 0xff00ff );
$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], 0xff00ffff );
$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], 0xff00ffff, 1 );
$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], [ 255, 255, 0, 255 ] );
$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], [ 255, 255, 0, 255 ], 1 );
pass 'draw_line works';

$surfs[1]->draw_gfx_text( [0,0], 0xffffffff, "fooo");
$surfs[1]->draw_gfx_text( [10,10], [20,20,20,20], "fooo");
my $f = '';
open( my $FH, '<', 'test/data/5x7.fnt');
binmode ($FH);
read($FH, $f, 4096);
close ($FH);
my $font =  {data=>$f, cw => 5, ch => 7};
$surfs[1]->draw_gfx_text( [0,0], 0xffffffff, "fooo", $font );
pass 'draw_gfx_text works';
}


my $cir_color = [255,0,0,255];
$surfs[0]->draw_circle( [ 100, 10 ], 20, $cir_color ); #no fill
$surfs[0]->draw_circle_filled( [ 100, 10 ], 20, $cir_color ); #fill

isnt( $surfs[0]->[100][10], 0 );

my $surf_dup = SDLx::Surface::duplicate( $surfs[1] );

is( $surf_dup->w,     $surfs[1]->w,     'Duplicate surf has same width' );
is( $surf_dup->h,     $surfs[1]->h,     'Duplicate surf has same flags' );
is( $surf_dup->flags, $surfs[1]->flags, 'Duplicate surf has same flags' );
is( $surf_dup->format->BitsPerPixel,
	$surfs[1]->format->BitsPerPixel,
	'Duplicate surf has same bpp'
);

if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

pass 'Final SegFault test';

done_testing;
