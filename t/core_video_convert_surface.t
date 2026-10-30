use strict;
use warnings;
use SDL;
use SDL::Rect;
use SDL::Color;
use SDL::Video;
use SDL::Surface;
use SDL::PixelFormat;
use SDL::Palette;
use Test::More;

use Data::Dumper;
use Devel::Peek;

use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
}

my $hwdisplay = SDL::Video::set_video_mode( 640, 480, 8, SDL_HWSURFACE );

my $surface = SDL::Video::convert_surface( $hwdisplay, $hwdisplay->format, 0 );
isa_ok(
	$surface, 'SDL::Surface',
	'[convert_surface] makes copy of surface correctly'
);
warn 'Copy conversion failed: ' . SDL::get_error if !$surface;

my $display = SDL::Surface->new( SDL_HWSURFACE, 640, 480, 8, 0, 0, 0, 0 );
my $surface2 = SDL::Video::convert_surface( $display, $hwdisplay->format, 0 );
isa_ok(
	$surface2, 'SDL::Surface',
	'[convert_surface] makes copy of surface converted surface HW->HW'
);

warn 'HW->HW conversion failed: ' . SDL::get_error if !$surface2;

$display = SDL::Surface->new( SDL_SWSURFACE, 640, 480, 8, 0, 0, 0, 0 );
my $surface3 = SDL::Video::convert_surface( $display, $hwdisplay->format, 0 );
isa_ok(
	$surface3, 'SDL::Surface',
	'[convert_surface] makes copy of surface converted surface SW->SW'
);

warn 'SW->SW conversion failed: ' . SDL::get_error if !$surface3;

if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

done_testing;
