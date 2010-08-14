use strict;
use warnings;
use Test::More;
use SDLx::Controller::Object;
use lib 't/lib';
use SDL::TestTool;

can_ok(
	'SDLx::Controller::Object',
	qw( new ) #meh, put the rest in later
);

TODO: {
	local $TODO = 'methods not implemented yet';
	can_ok( 'SDLx::Controller::Object', qw( ) );
}


my $obj = SDLx::Controller::Object->new();


isa_ok( $obj, 'SDLx::Controller::Object' );

done_testing;
