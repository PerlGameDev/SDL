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
		new run stop stopped pause paused
		dt min_t delay event stop_handler default_stop_handler
		time sleep
		add_move_handler add_event_handler add_show_handler
		move_handlers event_handlers show_handlers
		remove_move_handler remove_event_handler remove_show_handler
		remove_all_move_handlers remove_all_event_handlers remove_all_show_handlers
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
is($app->stop_handler, \&SDLx::Controller::default_stop_handler, 'stop_handler defaults to &default_stop_handler' );
ok( $app->stopped, 'default stopped' );
ok( !$app->paused, 'default not paused' );

# modifying with param methods
$app->stop_handler(\&dummy_sub);
is( $app->stop_handler, \&dummy_sub, 'stop_handler changed with method' );
is( scalar @{ $app->event_handlers }, 0, 'stop_handler does not trigger event handlers' );
$app->remove_all_event_handlers;
ok( $app->stop_handler, 'stop_handler is not an event handler' );
$app->remove_all_handlers;
ok( $app->stop_handler, 'stop_handler is not removed by remove all handlers' );
$app->stop_handler(undef);
is( $app->stop_handler, undef, 'stop_handler can be undefined' );

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

# stop and pause
$app->stop;
ok( $app->stopped, 'stopped true when used stop' );

# $app = SDLx::Controller->new;
# $app->pause(\&dummy_sub);
# ok( $app->paused, 'paused true when used pause' );
# is( $app->paused, \&dummy_sub, 'paused set to correct callback' );
# $app->pause(\&dummy_sub2);
# is( $app->paused, \&dummy_sub2, 'paused set to correct callback again' );
# $app->stop;
# ok( $app->stopped, 'stopped true when used stop after pause' );
# ok( !$app->paused, 'paused false when used stop after pause' );
# $app->pause(\&dummy_sub);
# ok( !$app->paused, 'paused remains false when used after stop' );

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
	time            => 99,
	stop_handler     => \&dummy_sub2,
);

isa_ok( $app, 'SDLx::Controller' );
is($app->dt, 0.1255, 'dt set in constructor');
is($app->min_t, 0.467, 'min_t set in constructor' );
is($app->event, $event, 'event set in constructor' );
is($app->event_handlers, $dummy_ref1, 'event_handlers set in constructor' );
is($app->move_handlers, $dummy_ref2, 'move_handlers set in constructor' );
is($app->show_handlers, $dummy_ref3, 'show_handlers set in constructor' );
is($app->delay, 0.262, 'delay set in constructor' );
is($app->time, 99, 'time set in constructor' );
is($app->stop_handler, \&dummy_sub2, 'stop_handler set in constructor' );

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
ok( $app->stopped, 'stopped is true after the app is stopped' );
ok( !$app->paused, 'paused is false. none of that' );

# deprecated
cmp_ok( $app->ticks, '>', 0, 'ticks is deprecated but still works' );

done_testing;
