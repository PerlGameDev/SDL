use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDL::Color;
use SDL::Event;
use SDLx::Controller;
use Scalar::Util 'refaddr';
use lib 't/lib';
use SDL::TestTool;

can_ok(
	'SDLx::Controller',
	qw(
		new run stop pause paused
		dt min_t current_time delay time eoq exit_on_quit event
		add_move_handler add_event_handler add_show_handler
		remove_move_handler remove_event_handler remove_show_handler
		remove_all_move_handlers remove_all_event_handlers remove_all_show_handlers
		move_handlers event_handlers show_handlers exit_on_quit_handler eoq_handler
		time sleep
	)
);

TODO: {
	local $TODO = 'methods not implemented yet';
	can_ok( 'SDLx::Controller', qw( ) );
}

# defaults
my $app = SDLx::Controller->new;
isa_ok( $app, 'SDLx::Controller', 'default controller can be spawned' );
is($app->dt, 0.1, 'default dt set to 0.1' );
is($app->min_t, 1/60, 'default min_t set to 1/60' );
is($app->delay, 0, 'default delay set to 0' );
is( scalar @{ $app->move_handlers }, 0, 'no motion handlers by default' );
is( scalar @{ $app->show_handlers }, 0, 'no show handlers by default' );
is( scalar @{ $app->event_handlers }, 0, 'no event handlers by default' );
isa_ok($app->event, 'SDL::Event', 'SDL::Event for controller created' );
is($app->time, 0, 'time started at 0' );
ok( !$app->exit_on_quit, 'exit_on_quit is not set by default' );
ok( !$app->eoq, 'eoq() is a method alias to exit_on_quit()' );
is(ref $app->exit_on_quit_handler, 'CODE', 'default eoq handler set' );
is($app->eoq_handler, \&SDLx::Controller::_default_exit_on_quit_handler, 'eoq_handler is an alias' );
is($app->current_time, undef, 'current_time has not been set yet' );

# modifying with param methods
$app->exit_on_quit(1);
is( scalar @{ $app->event_handlers }, 0, 'exit_on_quit does not trigger event handlers' );
ok( $app->exit_on_quit, 'exit_on_quit can be set dynamically' );
ok( $app->eoq, 'eoq() follows exit_on_quit()' );
$app->remove_all_event_handlers;
ok( $app->exit_on_quit, 'exit_on_quit is not an event handler' );
ok( $app->eoq, 'eoq() still follows exit_on_quit()' );
$app->eoq(0);
ok( !$app->eoq, 'eoq can be set dynamically' );
ok( !$app->exit_on_quit, 'exit_on_quit() follows eoq()' );

$app->dt(1337);
is( $app->dt, 1337, 'dt can be changed with method' );
$app->min_t(123);
is( $app->min_t, 123, 'min_t can be changed with method' );
$app->delay(555);
is( $app->delay, 555, 'delay can be changed with method' );
my $event = SDL::Event->new;
$app->event($event);
is( $app->event, $event, 'event can be changed with method' );
$app->time(20.3);
is( $app->time, 20.3, 'time can be changed with method' );
$app->exit_on_quit_handler(\&dummy_sub);
is( $app->exit_on_quit_handler, \&dummy_sub, 'exit_on_quit_handler can be changed with method' );
is( $app->eoq_handler, \&dummy_sub, 'eoq_handler is an alias' );
$app->eoq_handler(\&dummy_sub2);
is( $app->exit_on_quit_handler, \&dummy_sub2, 'eoq_handler can be changed with method' );
is( $app->eoq_handler, \&dummy_sub2, 'and it is an alias again' );
$app->current_time(9.95);
is( $app->current_time, 9.95, 'current_time can be changed with method' );

my ($dummy_ref1, $dummy_ref2, $dummy_ref3) = ([], [sub {}, \&dummy_sub], [\&dummy_sub2, sub {}, sub {}]);

# constructor set params
$app = SDLx::Controller->new(
	dt              => 0.1255,
	min_t           => 0.467,
	event           => $event,
	event_handlers  => $dummy_ref1,
	move_handlers   => $dummy_ref2,
	show_handlers   => $dummy_ref3,
	delay           => 0.262,
	eoq             => 1,
	time            => 99,
	eoq_handler     => \&dummy_sub2,
);

isa_ok( $app, 'SDLx::Controller' );
is($app->dt, 0.1255, 'dt set in constructor');
is($app->min_t, 0.467, 'min_t set in constructor' );
is($app->event, $event, 'event set in constructor' );
is($app->event_handlers, $dummy_ref1, 'event_handlers set in constructor' );
is($app->move_handlers, $dummy_ref2, 'move_handlers set in constructor' );
is($app->show_handlers, $dummy_ref3, 'show_handlers set in constructor' );
is($app->delay, 0.262, 'delay set in constructor' );
ok($app->eoq, 'eoq set in constructor' );
is($app->time, 99, 'time set in constructor' );
is($app->eoq_handler, \&dummy_sub2, 'eoq_handler set in constructor' );

# and now the app for the next part of testing
$app = SDLx::Controller->new(
	dt    => 0.1,
	min_t => 0.5,
);

sub dummy_sub  {1}
sub dummy_sub2 {1}

my @kinds = qw(move show);

# SDL events need a video surface to work
my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};
push @kinds, 'event'
    if SDL::TestTool->init(SDL_INIT_VIDEO)
       and SDL::Video::set_video_mode( 640, 480, 32, SDL_SWSURFACE );

foreach my $kind (@kinds) {
    my $method = "add_${kind}_handler";
    my $index_1 = $app->$method( \&dummy_sub );
    my $index_2 = $app->$method( \&dummy_sub2 );

    is($index_1 , 0, "got index 0 from added $kind handler" );
    is($index_2 , 1, "got index 0 from added $kind handler" );

    $method = "${kind}_handlers";
    is( scalar @{ $app->$method }, 2, "$kind handlers added" );

    is( $app->$method->[0], \&dummy_sub, "$kind handler 0 added correctly" );
    is( $app->$method->[1], \&dummy_sub2, "$kind handler 1 added correctly" );

    $method = "remove_${kind}_handler";
    $app->$method( \&dummy_sub );
    $app->$method( $index_2 );

    $method = "${kind}_handlers";
    is( scalar @{ $app->$method }, 0, "$kind handlers removed correctly" );
}

my $move_inc  = 0;
my $move_inc2 = 0;
my $show_inc  = 0;
my $show_inc2 = 0;

sub test_event {
    my ($event, $application) = @_;
}

sub test_move_first {
    cmp_ok($move_inc, '==', $move_inc2, 'test_move_first called first');
    $move_inc++;
}

sub test_move {
	my ($part, $application, $t) = @_;
    ok(defined $part, 'got step value');
    ok(defined $application, 'got our app (motion handler)');
    ok(defined $t, 'got out time');

	ok( do {$part > 0 and $part <= 1}, "move handle \$_[0] of $part was > 0 and <= 1" );
    is(refaddr $application, refaddr $app, 'app and application are the same (motion handler)');
    cmp_ok($move_inc, '>', $move_inc2, 'test_move called second');
    $move_inc2++;
}

sub test_show_first {
    cmp_ok($show_inc, '==', $show_inc2, 'test_show_first called first');
    $show_inc++;
}

sub test_show {
	my ($ticks, $application) = @_;
    ok(defined $ticks, 'got our ticks');
    ok(defined $application, 'got our app (show handler)');

	ok( $ticks >= 0.5, "show handle \$_[0] of $ticks was >= 0.5" );
    is(refaddr $application, refaddr $app, 'app and application are the same (show handler)');

    cmp_ok($show_inc, '>', $show_inc2, 'test_show called second');
    $show_inc2++;

    if ($show_inc2 >= 30) {
        $application->stop();
    }
}

$app->add_move_handler(\&test_move_first);
$app->add_move_handler(\&test_move);

$app->add_show_handler(\&test_show_first);
$app->add_show_handler(\&test_show);

$app->run();

cmp_ok($move_inc, '>=', 30, 'called our motion handlers at least 30 times');
is($show_inc, 30, 'called our show handlers exactly 30 times');

#TODO testing:
#pause and paused
#current_time
#delay
#time
#sleep

done_testing;
