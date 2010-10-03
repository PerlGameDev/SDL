use strict;
use warnings;
use Test::More;
use SDL;
use SDL::Config;
use SDL::Video;
use SDL::Color;
use SDLx::Controller;
use lib 't/lib';
# use SDL::TestTool;

can_ok(
	'SDLx::Controller',
	qw(
		new run stop pause dt min_t current_time
		add_move_handler add_event_handler add_show_handler
		remove_move_handler remove_event_handler remove_show_handler
		remove_all_move_handlers remove_all_event_handlers remove_all_show_handlers
		move_handlers event_handlers show_handlers
	)
);

TODO: {
	local $TODO = 'methods not implemented yet';
	can_ok( 'SDLx::Controller', qw( ) );
}


my $app = SDLx::Controller->new(
	dt     => 0.1,
	min_t => 0.5,
);

isa_ok( $app, 'SDLx::Controller' );

sub dummy_sub  {1}
sub dummy_sub2 {1}

my $index_1 = $app->add_move_handler( \&dummy_sub );
my $index_2 = $app->add_move_handler( \&dummy_sub2 );

is($index_1 , 0, 'index got from added handler' );
is($index_2 , 1, 'index got from added handler' );

is( $app->move_handlers->[0], \&dummy_sub, 'handler added correctly' );
is( $app->move_handlers->[1], \&dummy_sub2, 'handler added correctly' );

$app->remove_move_handler( \&dummy_sub );
$app->remove_move_handler( $index_2 );

is( scalar @{ $app->move_handlers }, 0, 'handlers removed correctly' );

sub test_move {
	my $part = shift;
	ok( do {$part > 0 and $part <= 1}, "move handle \$_[0] of $part was > 0 and <= 1" );
}
sub test_show {
	my $ticks = shift;
	ok( $ticks >= 0.5, "show handle \$_[0] of $ticks was >= 0.5" );
	$app->stop();
}

$app->add_move_handler(\&test_move);
$app->add_show_handler(\&test_show);
$app->run();

done_testing;
