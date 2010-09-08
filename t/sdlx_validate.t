use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Video;
use SDLx::Surface;
use SDLx::Validate; #use_ok is checked in t/00-load.t
use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
}

my $app = SDL::Video::set_video_mode( 400, 200, 32, SDL_SWSURFACE );

can_ok(
	'SDLx::Validate',
	qw( surface rect num_rgb num_rgba list_rgb list_rgba color )
);

my @surfaces = (
	'SDL::Surface->new(0, 1, 2, 32, 0, 0, 0, 0)',
	'SDLx::Surface->new(w => 1, h => 2)',
);
for (@surfaces) {
	ok( SDLx::Validate::surface(eval)->isa("SDL::Surface"),
		"surface($_) is a SDL::Surface"
	);
}
eval { SDLx::Validate::surface( SDL::Rect->new( 0, 0, 0, 0 ) ) };
is( $@ =~ /Surface must be SDL::Surface or SDLx::Surface/, 1, "Validate detects wrong objects" );

my @rects_0 = ( '[]', '[0, 0, 0, 0]', 'SDL::Rect->new(0, 0, 0, 0)', );
for (@rects_0) {
	my $r = SDLx::Validate::rect(eval);
	is_deeply(
		[ $r->x, $r->y, $r->w, $r->h ],
		[ 0,     0,     0,     0 ],
		"rect($_) is (0, 0, 0, 0)"
	);
}

my @rects_positive = ( '[1, 2, 3, 4]', 'SDL::Rect->new(1, 2, 3, 4)', );
for (@rects_positive) {
	my $r = SDLx::Validate::rect(eval);
	is_deeply(
		[ $r->x, $r->y, $r->w, $r->h ],
		[ 1,     2,     3,     4 ],
		"rect($_) is (1, 2, 3, 4)"
	);
}

my $format       = $app->format;
my $mapped_black = SDL::Video::map_RGBA( $format, 0x00, 0x00, 0x00, 0xFF );
my $mapped_white = SDL::Video::map_RGBA( $format, 0xFF, 0xFE, 0xFD, 0xFF );

my @blacks_rgb = ( 'undef', 0, '[0, 0, 0]', '[]', 'SDL::Color->new(0, 0, 0)', );
for (@blacks_rgb) {
	is( SDLx::Validate::num_rgb(eval), 0, "num_rgb($_) is 0x000000" );
	is_deeply(
		SDLx::Validate::list_rgb(eval),
		[ 0, 0, 0 ],
		"list_rgb($_) is [0, 0, 0]"
	);
	is( SDLx::Validate::map_rgb( eval, $format ), $mapped_black, "map_rgb($_, $format) is $mapped_black" );
	my $c = SDLx::Validate::color(eval);
	is_deeply( [ $c->r, $c->g, $c->b ], [ 0, 0, 0 ], "color($_) is (0, 0, 0)" );
}

my @whites_rgb = ( '0xFFFEFD', '[0xFF, 0xFE, 0xFD]', 'SDL::Color->new(0xFF, 0xFE, 0xFD)', );
for (@whites_rgb) {
	is( SDLx::Validate::num_rgb(eval), 0xFFFEFD, "num_rgb($_) is 0xFFFEFD" );
	is_deeply(
		SDLx::Validate::list_rgb(eval),
		[ 0xFF, 0xFE, 0xFD ],
		"list_rgb($_) is [0xFF, 0xFE, 0xFD]"
	);
	is( SDLx::Validate::map_rgb( eval, $format ), $mapped_white, "map_rgb($_, $format) is $mapped_white" );
	my $c = SDLx::Validate::color(eval);
	is_deeply(
		[ $c->r, $c->g, $c->b ],
		[ 0xFF,  0xFE,  0xFD ],
		"color($_) is (0xFF, 0xFE, 0xFD)"
	);
}

my @blacks_rgba = (
	'undef',     '0x000000FF',
	'[0, 0, 0]', '[undef, undef, undef, 0xFF]',
	'[]',        'SDL::Color->new(0, 0, 0)',
);
for (@blacks_rgba) {
	is( SDLx::Validate::num_rgba(eval), 0xFF, "num_rgba($_) is 0x000000FF" );
	is_deeply(
		SDLx::Validate::list_rgba(eval),
		[ 0, 0, 0, 0xFF ],
		"list_rgba($_) is [0, 0, 0, 0xFF]"
	);
	is( SDLx::Validate::map_rgba( eval, $format ), $mapped_black, "map_rgba($_, $format) is $mapped_black" );
}

my @whites_rgba = (
	'0xFFFEFDFF',
	'[0xFF, 0xFE, 0xFD]',
	'[0xFF, 0xFE, 0xFD, 0xFF]',
	'SDL::Color->new(0xFF, 0xFE, 0xFD)',
);
for (@whites_rgba) {
	is( SDLx::Validate::num_rgba(eval),
		0xFFFEFDFF, "num_rgba($_) is 0xFFFEFDFF"
	);
	is_deeply(
		SDLx::Validate::list_rgba(eval),
		[ 0xFF, 0xFE, 0xFD, 0xFF ],
		"list_rgba($_) is [0xFF, 0xFE, 0xFD, 0xFF]"
	);
	is( SDLx::Validate::map_rgba( eval, $format ), $mapped_white, "map_rgba($_, $format) is $mapped_white" );
}

isnt( SDLx::Validate::num_rgba(0), 0xFF, "num_rgba(0) isn't 0x000000FF" );

done_testing;
