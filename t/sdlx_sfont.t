use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDLx::App;
use SDLx::SFont;
use lib 't/lib';
use SDL::TestTool;

can_ok('SDLx::SFont', qw( new ) );


my $videodriver       = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

my $audiodriver       = $ENV{SDL_AUDIODRIVER};
$ENV{SDL_AUDIODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};



if( !SDL::TestTool->init(SDL_INIT_VIDEO) )
{
	plan( skip_all => 'Failed to init video' );
}
elsif( !SDL::Config->has('SDL_image') )
{
	plan( skip_all => 'SDL_image support not compiled' );
}

   #Make a surface
   #Select a font
   my $d = SDLx::App->new( -title => 'app', -width => 200, -height => 200, -depth => 32, -flags => SDL_INIT_VIDEO );

   my $font = SDLx::SFont->new('test/data/font.png');

   isa_ok( $font , 'SDL::Surface', '[new] makes surface');
  
   #print using $font
   
   SDLx::SFont::print_text( $d, 10, 10, 'Huh' );

   pass( '[print_test] worked');

   my $font2;
   $font2 = SDLx::SFont->new('test/data/font.png');
  
   isa_ok( $font2 , 'SDL::Surface', '[new] makes surface');


   #print using font2

   SDLx::SFont::print_text( $d, 10, 10, 'Huh' );

   pass( '[print_test] font2 worked');

   $font->use();

   pass( '[use] switch font worked');


   #print using $font
   
   SDLx::SFont::print_text( $d, 10, 10, 'Huh' );
   pass( '[use|printe_text] switch to font and print worked');


done_testing;

#reset the old video driver
if($videodriver)
{
	$ENV{SDL_VIDEODRIVER} = $videodriver;
}
else
{
	delete $ENV{SDL_VIDEODRIVER};
}


if($audiodriver)
{
	$ENV{SDL_AUDIODRIVER} = $audiodriver;
}
else
{
	delete $ENV{SDL_AUDIODRIVER};
}

