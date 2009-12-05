#!perl
use strict;
use warnings;
use SDL;
use SDL::Config;
use SDL::GFX::Framerate;
use SDL::GFX::FPSManager;
use Test::More;

use lib 't/lib';
use SDL::TestTool;

if( !SDL::TestTool->init(SDL_INIT_VIDEO) )
{
    plan( skip_all => 'Failed to init video' );
}
elsif( !SDL::Config->has('SDL_gfx') )
{
    plan( skip_all => 'SDL_gfx support not compiled' );
}
else
{
    plan( tests => 11 );
}

my @done =qw/
framecount
/;

my $fps = SDL::GFX::FPSManager->new(0, 0, 0, 0);

isa_ok( $fps, 'SDL::GFX::FPSManager' );
is( $fps->framecount, 0, 'fps has framecount' );
is( $fps->rateticks,  0, 'fps has rateticks' );
is( $fps->lastticks,  0, 'fps has lastticks' );
is( $fps->rate,       0, 'fps has rate' );

$fps->framecount(1);
$fps->rateticks(2);
$fps->lastticks(3);
$fps->rate(4);

is( $fps->framecount, 1, 'fps has framecount' );
is( $fps->rateticks,  2, 'fps has rateticks' );
is( $fps->lastticks,  3, 'fps has lastticks' );
is( $fps->rate,       4, 'fps has rate' );



SDL::delay(100);

my @left = qw/
/;

my $why = '[Percentage Completion] '.int( 100 * ($#done +1 ) / ($#done + $#left + 2  ) ) .'% implementation. '.($#done +1 ).'/'.($#done+$#left + 2 ); 

TODO:
{
	local $TODO = $why;
	pass "\nThe following functions:\n".join ",", @left; 
}
if( $done[0] eq 'none'){ diag '0% done 0/'.$#left } else { diag  $why} 

pass 'Are we still alive? Checking for segfaults';

done_testing;


