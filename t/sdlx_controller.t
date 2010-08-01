use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDL::Color;
use SDLx::Controller;
use lib 't/lib';
use SDL::TestTool;

can_ok(
	'SDLx::Controller',
	qw( new ) #meh, put the rest in later
);

TODO: {
	local $TODO = 'methods not implemented yet';
	can_ok( 'SDLx::Controller', qw( ) );
}


my $app = SDLx::Controller->new();

isa_ok( $app, 'SDLx::Controller' );

sub dummy_sub {1}

is( $app->add_move_handler( \&dummy_sub ), 0, 'index got from added handler' );

is( $app->move_handlers->[0], \&dummy_sub, 'handler added correctly' );

$app->remove_move_handler( \&dummy_sub );

is( scalar @{ $app->move_handlers }, 0, 'handler removed with coderef' );

done_testing;
