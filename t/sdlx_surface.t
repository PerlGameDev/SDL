use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Surface;
use SDL::Rect;
use SDLx::Surface;
use SDL::PixelFormat;
use SDL::Video;
use Data::Dumper;
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

$surfs[0]->[4][4] = [255,255,0,255];

is( $surfs[0]->[4][4] , 0xFFFF00FF, "Surface can set pixel with other color values");

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
	color => 0x204080FF,
	);

my $fill = SDL::Video::get_RGBA( $surfs[-1]->surface()->format(), $surfs[-1]->[0][0] );

is( $fill->[0], 0x20, 'Fill color red worked' );
is( $fill->[1], 0x40, 'Fill color green worked' );
is( $fill->[2], 0x80, 'Fill color blue worked' );
is( $fill->[3], 0xFF, 'Fill color alpha worked' );

$surfs[1]->flip();

pass 'Fliped the surface';

$surfs[0]->update();
pass 'update all surface';
$surfs[0]->update( [ 0, 10, 30, 40 ] );
pass 'Single rect update';
$surfs[0]->update( [ SDL::Rect->new( 0, 1, 2, 3 ), SDL::Rect->new( 2, 4, 5, 6 ) ] );
pass 'SDL::Rect array update';

my @colors = (
    # opaque
	[ 0xFF, 0xFF, 0xFF, 0xFF ],
	[ 0xFF, 0xFF, 0x00, 0xFF ],
	[ 0xFF, 0x00, 0xFF, 0xFF ],
	[ 0x00, 0xFF, 0xFF, 0xFF ],
	[ 0xFF, 0x00, 0x00, 0xFF ],
	[ 0x00, 0xFF, 0x00, 0xFF ],
	[ 0x00, 0x00, 0xFF, 0xFF ],
	[ 0x00, 0x00, 0x00, 0xFF ],
	[ 0x20, 0x40, 0x80, 0xFF ],
	[ 0x80, 0x20, 0x40, 0xFF ],
	[ 0x40, 0x80, 0x20, 0xFF ],

    # translucent
	[ 0xFF, 0xFF, 0xFF, 0xCC ],
	[ 0xFF, 0xFF, 0x00, 0xCC ],
	[ 0xFF, 0x00, 0xFF, 0xCC ],
	[ 0x00, 0xFF, 0xFF, 0xCC ],
	[ 0xFF, 0x00, 0x00, 0xCC ],
	[ 0x00, 0xFF, 0x00, 0xCC ],
	[ 0x00, 0x00, 0xFF, 0xCC ],
	[ 0x00, 0x00, 0x00, 0xCC ],
	[ 0x20, 0x40, 0x80, 0xCC ],
	[ 0x80, 0x20, 0x40, 0xCC ],
	[ 0x40, 0x80, 0x20, 0xCC ],

    # transparent
	[ 0xFF, 0xFF, 0xFF, 0x00 ],
	[ 0xFF, 0xFF, 0x00, 0x00 ],
	[ 0xFF, 0x00, 0xFF, 0x00 ],
	[ 0x00, 0xFF, 0xFF, 0x00 ],
	[ 0xFF, 0x00, 0x00, 0x00 ],
	[ 0x00, 0xFF, 0x00, 0x00 ],
	[ 0x00, 0x00, 0xFF, 0x00 ],
	[ 0x00, 0x00, 0x00, 0x00 ],
	[ 0x20, 0x40, 0x80, 0x00 ],
	[ 0x80, 0x20, 0x40, 0x00 ],
	[ 0x40, 0x80, 0x20, 0x00 ],
);

foreach my $c (@colors) {
	my $color = ( $c->[0] << 24 ) + ( $c->[1] << 16 ) + ( $c->[2] << 8 ) + $c->[3];
	$surfs[0]->draw_rect( [ 0, 0, 10, 20 ], $c );

	my $num = sprintf( '0x%08x', $color );

	my $rgba = SDL::Video::get_RGBA( $surfs[0]->surface()->format(), $surfs[0]->[0][0] );

	is( $rgba->[0], $c->[0], "draw_rect uses correct red for $num" );
	is( $rgba->[1], $c->[1], "draw_rect uses correct green for $num" );
	is( $rgba->[2], $c->[2], "draw_rect uses correct blue for $num" );
	is( $rgba->[3], $c->[3], "draw_rect uses correct alpha for $num" );
}
$surfs[0]->draw_rect( [ 0, 0, 10, 20 ], 0xFF00FFFF );
pass 'draw_rect works';
SKIP:
{
	skip( 'SDL_gfx_primitives needed', 2 ) unless SDL::Config->has('SDL_gfx_primitives');

	is( $surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], 0xff00ffff ), $surfs[1], 'draw_line returns self' );

	$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], 0xff00ff );
	$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], 0xff00ffff );
	$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], 0xff00ffff, 1 );
	$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], [ 255, 255, 0, 255 ] );
	$surfs[1]->draw_line( [ 0, 10 ], [ 20, 10 ], [ 255, 255, 0, 255 ], 1 );
	pass 'draw_line works';

	$surfs[1]->draw_gfx_text( [ 0, 0 ], 0xffffffff, "fooo" );
	$surfs[1]->draw_gfx_text( [ 10, 10 ], [ 20, 20, 20, 20 ], "fooo" );
	my $f = '';
	open( my $FH, '<', 'test/data/5x7.fnt' );
	binmode($FH);
	read( $FH, $f, 4096 );
	close($FH);
	my $font = { data => $f, cw => 5, ch => 7 };
	$surfs[1]->draw_gfx_text( [ 0, 0 ], 0xffffffff, "fooo", $font );
	pass 'draw_gfx_text works';
	my @colors_t = ( [ 255, 0, 0, 255 ], 0xFF0000FF, 0xFF00FF, [ 255, 0, 255 ] );

	is( $surfs[0]->draw_circle( [ 100, 10 ], 20, [ 0, 0, 0, 0] ), $surfs[0], 'draw_circle returns self' );
	foreach my $cir_color (@colors_t) {
		my $cir_color = [ 255, 0, 0, 255 ];
		$surfs[0]->draw_circle( [ 100, 10 ], 20, $cir_color ); #no fill
		$surfs[0]->draw_circle( [ 102, 12 ], 22, $cir_color , 1 );
		$surfs[0]->draw_circle_filled( [ 100, 10 ], 20, $cir_color ); #fill
		isnt( $surfs[0]->[100][10], 0 );
		pass 'draw_circle works';
		pass 'draw_circle_filled works';
	}

	is( $surfs[0]->draw_trigon( [ [100, 10], [110, 10], [110, 20] ], [ 255, 0, 0, 255 ] ), $surfs[0], 'draw_trigon returns self' );
	is( $surfs[0]->draw_trigon_filled( [ [100, 10], [110, 10], [110, 20] ], [ 255, 0, 0, 255 ] ), $surfs[0], 'draw_trigon_filled returns self' );
	foreach my $color (@colors_t) {
		my $color = [ 255, 0, 0, 255 ];
		my $verts = [ [100, 10], [110, 10], [110, 20] ];
		$surfs[0]->draw_trigon( $verts, $color ); #no fill
		$surfs[0]->draw_trigon( $verts, $color, 1 );
		$surfs[0]->draw_trigon_filled( $verts, $color ); #fill
		isnt( $surfs[0]->[100][10], 0 );
		pass 'draw_trigon works';
		pass 'draw_trigon_filled works';
	}

	is( $surfs[0]->draw_polygon( [ [100, 10], [110, 10], [110, 20] ], [ 255, 0, 0, 255 ] ), $surfs[0], 'draw_polygon returns self' );
	is( $surfs[0]->draw_polygon_filled( [ [100, 10], [110, 10], [110, 20] ], [ 255, 0, 0, 255 ] ), $surfs[0], 'draw_polygon_filled returns self' );
	foreach my $color (@colors_t) {
		my $color = [ 255, 0, 0, 255 ];
		my $verts = [ [100, 10], [110, 10], [110, 20], [100, 20] ];
		$surfs[0]->draw_polygon( $verts, $color ); #no fill
		$surfs[0]->draw_polygon( $verts, $color, 1 );
		$surfs[0]->draw_polygon_filled( $verts, $color ); #fill
		isnt( $surfs[0]->[100][10], 0 );
		pass 'draw_polygon works';
		pass 'draw_polygon_filled works';
	}
}


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
