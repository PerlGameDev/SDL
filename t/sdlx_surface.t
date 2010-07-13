use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Surface;
use SDL::Rect;
use SDLx::Surface;
use SDL::Video;
use lib 't/lib';
use SDL::TestTool;

my $videodriver       = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
    plan( skip_all => 'Failed to init video' );
}

my $app = SDL::Video::set_video_mode( 400,200,32, SDL_SWSURFACE);

my $app_x = SDLx::Surface::get_display();

is_deeply( $app_x->surface->get_pixels_ptr, $app->get_pixels_ptr, '[get_display] works');



my $surface = SDL::Surface->new( SDL_SWSURFACE, 400,200, 32);
my @surfs = (
	SDLx::Surface->new(  surface => $surface),
	SDLx::Surface->new( width=> 400, height=>200),
	SDLx::Surface->new( width=> 400, height=>200, flags=> SDL_SWSURFACE, depth=>32 ),
	SDLx::Surface->new( width=> 400, height=>200, flags=> SDL_SWSURFACE, depth=>32, greenmask=>0xFF000000 ),


);

foreach my $a ( @surfs)
{
	isa_ok ( $a, 'SDLx::Surface');

	isa_ok ( $a->surface(), 'SDL::Surface');

	my $color =  $a->[0][0];
	is ( $color , 0, 'Right color returned');

	$a->[0][0] = 0x00FF00FF;
	is ( $a->[0][0] , 0x00FF00FF, 'Right color returned');

	is ( @{$a} , 200 , 'Correct Y value');

	is ( @{$a->[0]} , 400 , 'Correct X value');

}

#my $source = SDLx::Surface->new( width=> 400, height=>200, flags=> SDL_SWSURFACE, depth=>32 ),
 

is( $surfs[0]->[1][2], 0 , 'Checking source pixel is 0');
is( $surfs[1]->[1][2], 0 , 'Checking dest pixel is 0');

$surfs[0]->[1][2] = 0x00FF00FF;

is( $surfs[0]->[1][2], 0x00FF00FF, 'Checking that source pixel got written' );

$surfs[0]->blit( $surfs[1] );
#SDL::Video::blit_surface( $surfs[0]->surface, SDL::Rect->new(0,0,400,200), $surfs[1]->surface, SDL::Rect->new(0,0,400,200));

isnt( $surfs[1]->[1][2], 0, 'Pixel from first surface was blitted to destination');

$surfs[1]->flip();

pass 'Fliped the surface';

$surfs[0]->update();
pass 'update all surface';
$surfs[0]->update( [0,10,30,40] );
pass 'Single rect update';
$surfs[0]->update( [ SDL::Rect->new(0,1,2,3), SDL::Rect->new(2,4,5,6)] );
pass 'SDL::Rect array update';

if($videodriver)
{
	$ENV{SDL_VIDEODRIVER} = $videodriver;
}
else
{
	delete $ENV{SDL_VIDEODRIVER};
}

pass 'Final SegFault test';


done_testing;
