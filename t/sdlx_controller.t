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
	qw( new ) #meh, put the rest in later
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

sub dummy_sub {1}

is( $app->add_move_handler( \&dummy_sub ), 0, 'index got from added handler' );

is( $app->move_handlers->[0], \&dummy_sub, 'handler added correctly' );

$app->remove_move_handler( \&dummy_sub );

is( scalar @{ $app->move_handlers }, 0, 'handler removed with coderef' );

sub test_move {
	my $part = shift;
	ok( do {$part > 0 and $part <= 1}, "move handle \$_[0] of $part was > 0 and <= 1" );
}
sub test_show {
	my $ticks = shift;
	ok( $ticks >= 0.5, "show handle \$_[0] of $ticks was >= 0.5" );
	$app->quit();
}

$app->add_move_handler(\&test_move);
$app->add_show_handler(\&test_show);
$app->run();

done_testing;
