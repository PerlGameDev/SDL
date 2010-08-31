use strict;
use warnings;
use Test::More;
use SDL;
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
	can_ok( 'SDLx::Controller::Object', qw( foo ) );
}


my $obj = SDLx::Controller::Object->new( x=> 1, y=> 2, v_x => 3, v_y => 4, rot => 5, ang_v => 6);

isa_ok( $obj, 'SDLx::Controller::Object' );
my $s = sub { pass 'ran accel'; return (0.0,10,19)};

$obj->set_acceleration( $s);

my $av =  $obj->acceleration( 1);


isa_ok ( $av, 'ARRAY');
## This is reversed, maybe we fix this ... or not because acceleration will
#be called internal
is($av->[0], 19);
is($av->[1], 10);
is($av->[2], 0.0);

my $hv = $obj->interpolate(0.5);

isa_ok ( $hv, 'SDLx::Controller::State', '[interpolate] provides state back out'); 

is($hv->x, 1);
is($hv->y, 2);
is($hv->rotation, 5);


$obj->update( 2, 0.5 );

$hv = $obj->interpolate(0.5);

isa_ok ( $hv, 'SDLx::Controller::State', '[interpolate] provides state back out'); 

is($hv->x, 1.75);
is($hv->y, 3.625);
is($hv->rotation, 7.6875);

$obj = SDLx::Controller::Object->new( x=> 1, y=> 2, v_x => 3, v_y => 4, rot => 5, ang_v => 6);


$obj->set_acceleration( sub {  $_[1]->x(2); pass '[state] is mutable'; return (0.0,10,19)});

 $obj->acceleration( 1 );
my $a = $obj->current;
my $a_x = $a->x();
is( $a_x, 2, '[obj/state] acceleration callback copies staet back to current');

done_testing;

