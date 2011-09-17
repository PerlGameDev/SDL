use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDL::Color;
use SDLx::Controller;
use Scalar::Util 'refaddr';
use lib 't/lib';
use SDL::TestTool;

can_ok(
	'SDLx::Controller',
	qw(
		new run stop pause dt min_t current_time
		add_move_handler add_event_handler add_show_handler
		remove_move_handler remove_event_handler remove_show_handler
		remove_all_move_handlers remove_all_event_handlers remove_all_show_handlers
		move_handlers event_handlers show_handlers eoq exit_on_quit
	)
);

TODO: {
	local $TODO = 'methods not implemented yet';
	can_ok( 'SDLx::Controller', qw( ) );
}

my $app = SDLx::Controller->new;
isa_ok( $app, 'SDLx::Controller', 'default controller can be spawned' );
is($app->dt, 0.1, 'default dt set to 0.1');
is($app->min_t, 1 / 60, 'default min_t set to 1/60' );
is($app->eoq, 0, 'no eoq by default');
is($app->exit_on_quit, 0, 'no exit_on_quit by default');
is( scalar @{ $app->move_handlers }, 0, 'no motion handlers by default' );
is( scalar @{ $app->show_handlers }, 0, 'no show handlers by default' );
is( scalar @{ $app->event_handlers }, 0, 'no event handlers by default' );

is( $app->exit_on_quit, 0, 'exit_on_quit is not set by default' );
is( $app->eoq, 0, 'eoq() is a method alias to exit_on_quit()' );
$app->exit_on_quit(1);
is( scalar @{ $app->event_handlers }, 0, 'exit_on_quit does not trigger event handlers' );
is( $app->exit_on_quit, 1, 'exit_on_quit can be set dynamically' );
is( $app->eoq, 1, 'eoq() follows exit_on_quit()' );
$app->remove_all_event_handlers;
is( $app->exit_on_quit, 1, 'exit_on_quit is not an event handler' );
is( $app->eoq, 1, 'eoq() still follows exit_on_quit()' );
$app->eoq(0);
is( $app->eoq, 0, 'eoq can be set dynamically' );
is( $app->exit_on_quit, 0, 'exit_on_quit() follows eoq()' );

$app = SDLx::Controller->new(
	dt     => 0.1,
	min_t => 0.5,
);

isa_ok( $app, 'SDLx::Controller' );
is($app->dt, 0.1, 'new dt set to 0.1');
is($app->min_t, 0.5, 'new min_t set to 0.5' );


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

done_testing;
