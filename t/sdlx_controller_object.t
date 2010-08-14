use strict;
use warnings;
use Test::More;
use SDLx::Controller::State;
use SDLx::Controller::Object;
use lib 't/lib';
use SDL::TestTool;
use Data::Dumper;

can_ok(
	'SDLx::Controller::Object',
	qw( new ) #meh, put the rest in later
);

TODO: {
	local $TODO = 'methods not implemented yet';
	can_ok( 'SDLx::Controller::Object', qw( ) );
}


my $obj = SDLx::Controller::Object->new(0,1,2,3,4,5,6);


isa_ok( $obj, 'SDLx::Controller::Object' );
my $s = sub { pass 'ran accel'; return (0.0,10,19)};
$obj->set_acceleration( $s);

my $av =  $obj->acceleration();

isa_ok ( $av, 'ARRAY');
## This is reversed, maybe we fix this ... or not because acceleration will
#be called internal
is($av->[0], 19);
is($av->[1], 10);
is($av->[2], 0.0);

my $hv = $obj->interpolate(0.5);

isa_ok ( $hv, 'SDLx::Controller::State'); 

done_testing;
