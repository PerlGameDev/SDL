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

TODO:
{
	local $TODO = "Constructor needs to be fixed";
my $color = SDLx::Color->new( [ 10, 20, 30, 40 ]);

}

done_testing;


