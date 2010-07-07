use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDLx::Color;
use lib 't/lib';
use SDL::TestTool;


can_ok('SDLx::Color', qw( new rgb ) );

my $color = SDLx::Color->new( [ 10, 20, 30, 40 ]);
isa_ok($color, 'SDLx::Color');


TODO:
{
	local $TODO = "Arrayref overload fails";
	#print @{$color}[0];
	fail( "Array overload fails");

}

done_testing;


