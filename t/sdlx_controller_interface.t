use strict;
use warnings;
use Test::More;
use SDL;
use SDLx::App;
use SDLx::Controller;
use SDLx::Controller::State;
use SDLx::Controller::Interface;
use lib 't/lib';
use SDL::TestTool;
use Data::Dumper;

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy';

can_ok(
	'SDLx::Controller::Interface',
	qw( new ) #meh, put the rest in later
);

TODO: {
	local $TODO = 'methods not implemented yet';
	can_ok( 'SDLx::Controller::Interface', qw( foo ) );
}


my $obj = SDLx::Controller::Interface->new( x => 1, y => 2, v_x => 3, v_y => 4, rot => 5, ang_v => 6 );

isa_ok( $obj, 'SDLx::Controller::Interface' );
my $s = sub { pass 'ran accel'; return ( 0.0, 10, 19 ) };

$obj->set_acceleration($s);

my $av = $obj->acceleration(1);


isa_ok( $av, 'ARRAY' );
## This is reversed, maybe we fix this ... or not because acceleration will
#be called internal
is( $av->[0], 19 );
is( $av->[1], 10 );
is( $av->[2], 0.0 );

my $hv = $obj->interpolate(0.5);

isa_ok( $hv, 'SDLx::Controller::State', '[interpolate] provides state back out' );

is( $hv->x,        1 );
is( $hv->y,        2 );
is( $hv->rotation, 5 );


$obj->update( 2, 0.5 );

$hv = $obj->interpolate(0.5);

isa_ok( $hv, 'SDLx::Controller::State', '[interpolate] provides state back out' );

is( $hv->x,        1.75 );
is( $hv->y,        3.625 );
is( $hv->rotation, 7.6875 );

$obj = SDLx::Controller::Interface->new( x => 1, y => 2, v_x => 3, v_y => 4, rot => 5, ang_v => 6 );


$obj->set_acceleration( sub { $_[1]->x(2); pass '[state] is mutable'; return ( 0.0, 10, 19 ) } );

$obj->acceleration(1);
my $a   = $obj->current;
my $a_x = $a->x();
is( $a_x, 2, '[obj/state] acceleration callback copies state back to current' );


my $dummy = SDLx::App->new( init => SDL_INIT_VIDEO );
my $controller   = SDLx::Controller->new( dt => 1, delay => 200 );
my $interface    = SDLx::Controller::Interface->new();
my $event_called = 0;

require SDL::Event;
require SDL::Events;
my $eve = SDL::Event->new();

SDL::Events::push_event($eve);
my $counts = [ 0, 0, 0 ];
$controller->add_event_handler(
	sub {
		$counts->[0]++;
		return 0;
	}
);

$interface->set_acceleration(
	sub {
		$controller->stop() if $counts->[0] && $counts->[1] && $counts->[2];
		$counts->[1]++;
		isa_ok( $_[1], 'SDLx::Controller::State', '[Controller] called acceleration and gave us a state' ),
			return ( 10, 10, 10 );
	}
);

$interface->attach(
	$controller,
	sub {
		$counts->[2]++;
		isa_ok( $_[0], 'SDLx::Controller::State', '[Controller] called render and gave us a state' );
	}
);


$controller->run();

cmp_ok( $counts->[0], '>', 0, '$counts->[0] is >0' );
cmp_ok( $counts->[1], '>', 0, '$counts->[1] is >0' );
cmp_ok( $counts->[2], '>', 0, '$counts->[2] is >0' );

$interface->detach();

pass('Interface was able to deattach ');




if ($videodriver) {
	$ENV{SDL_VIDEODRIVER} = $videodriver;
} else {
	delete $ENV{SDL_VIDEODRIVER};
}


done_testing;

