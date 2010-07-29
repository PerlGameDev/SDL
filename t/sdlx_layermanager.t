use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Surface;
use SDL::Rect;
use SDLx::LayerManager;
use SDLx::Surface;
use SDLx::Sprite;
use SDL::PixelFormat;
use SDL::Video;
use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
    plan( skip_all => 'Failed to init video' );
}

my $display = SDL::Video::set_video_mode( 800, 600, 32, SDL_SWSURFACE );

my $manager = SDLx::LayerManager->new();

isa_ok( $manager, 'SDLx::LayerManager' , '[new] returns SDLx::LayerManager');

is( $manager->length, 0 , '[length] is zero');

my $sprite1 =
  SDLx::Sprite->new( image => 'test/data/picture.bmp', x => 10, y => 20 );
my $sprite2 =
  SDLx::Sprite->new( image => 'test/data/picture.bmp', x => 60, y => 70 );
my $sprite3 =
  SDLx::Sprite->new( image => 'test/data/picture.bmp', x => 10, y => 120 );

$manager->add( $sprite1 );

is( $manager->length, 1, '[length] is one');

isa_ok( $manager->layers,   'ARRAY',        '[layers] returns an ARRAY' );
isa_ok( $manager->layer(0), 'SDLx::Sprite', '[layer(0)] gives us the SDLx::Sprite' );
is(     $manager->layer(1), undef,          '[layer(1)] returns undef' );
is( $manager->layer(0)->x,  10,             '[layer(0)->x] is 10 by default' );
    $manager->layer(0)->x(42);        pass( '[layer(0)->x(42)] set to 42' );
is( $manager->layer(0)->x,  42,             '[layer(0)->x] is 42 now' );








#$manager->blit($display);
#SDL::Video::update_rect( $display, 0, 0, 0, 0 );

#is( $manager->get_layer_by_position( 20, 130 ), 2 );

#my $sprite4 =
#  SDLx::Sprite->new( image => 'test/data/picture.bmp', x => 400, y => 20 );

#$manager->add($sprite4, {});

#my @layers_ahead = $manager->get_layers_ahead_layer(0);
#is_deeply( \@layers_ahead, [ 1, 2 ] );

sleep(1);

if ($videodriver) {
    $ENV{SDL_VIDEODRIVER} = $videodriver;
}
else {
    delete $ENV{SDL_VIDEODRIVER};
}

pass 'Final SegFault test';

done_testing;
