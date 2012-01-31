use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDLx::FPS;
use lib 't/lib';
use SDL::TestTool;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
	plan( skip_all => 'Failed to init video' );
} elsif ( !SDL::Config->has('SDL_image') ) {
	plan( skip_all => 'SDL_image support not compiled' );
}

can_ok( 'SDLx::FPS', qw( new set get delay framecount rateticks lastticks rate ) );

my $_fps = 5;

my $ticks_start = SDL::get_ticks();
my $fps = SDLx::FPS->new( fps => $_fps );
my $ticks_init = SDL::get_ticks();

isa_ok( $fps, 'SDLx::FPS' );

is( $fps->get, $_fps, 'fps->get' );
is( $fps->rate, $_fps, 'fps->rate' );

cmp_ok( $fps->lastticks, '>=', $ticks_start, 'fps->lastticks' );
cmp_ok( $fps->lastticks, '<=', $ticks_init,  'fps->lastticks' );

# rateticks is Uint32, so precision differs
ok( $fps->rateticks - 1000 / $_fps < 0.000001, 'fps->rateticks' );

my $count = 10;
for ( 1 .. $count ) {
	$fps->delay;
}
cmp_ok( $fps->framecount, '>', 0, 'fps->framecount' );

$_fps = 20;
$fps->set($_fps);
is( $fps->get, $_fps, 'fps->get after fps->set' );

my $ticks_pre_delay = SDL::get_ticks();
$fps->delay;
my $ticks_post_delay = SDL::get_ticks();

cmp_ok( $fps->lastticks, '>=', $ticks_pre_delay,  'fps->lastticks after fps->delay' );
cmp_ok( $fps->lastticks, '<=', $ticks_post_delay, 'fps->lastticks after fps->delay' );

$fps = SDLx::FPS->new();
is( $fps->get, 30, 'fps->get default value' );

#reset the old video driver
if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}

pass 'Final SegFault test';

done_testing;
