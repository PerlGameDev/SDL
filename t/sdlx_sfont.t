use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDL::Surface;
use SDLx::SFont;
use lib 't/lib';
use SDL::TestTool;

can_ok( 'SDLx::SFont', qw( new ) );

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

my $audiodriver = $ENV{SDL_AUDIODRIVER};
$ENV{SDL_AUDIODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

if ( !SDL::TestTool->init(SDL_INIT_VIDEO) ) {
    plan( skip_all => 'Failed to init video' );
}
elsif ( !SDL::Config->has('SDL_image') ) {
    plan( skip_all => 'SDL_image support not compiled' );
}

#Make a surface
#Select a font
my $d = SDL::Surface->new( SDL_SWSURFACE, 100, 100, 32 );
my $font = SDLx::SFont->new('test/data/font.png');

isa_ok( $font, 'SDL::Surface', '[new] makes surface' );

#print using $font

SDLx::SFont::print_text( $d, 10, 10, 'Huh' );

pass('[print_test] worked');

$font->use();

pass('[use] switch font worked');

SDLx::SFont::print_text( $d, 10, 10, 'Huh' );
pass('[use|printe_text] switch to font and print worked');

END {
    done_testing;

    #reset the old video driver
    if ($videodriver) {
        $ENV{SDL_VIDEODRIVER} = $videodriver;
    }
    else {
        delete $ENV{SDL_VIDEODRIVER};
    }

    if ($audiodriver) {
        $ENV{SDL_AUDIODRIVER} = $audiodriver;
    }
    else {
        delete $ENV{SDL_AUDIODRIVER};
    }
}
