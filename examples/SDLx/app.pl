use SDL::Event;
use SDLx::App;

my $app = SDLx::App->new(
	title  => "Lines",
	width  => 640,
	height => 480,
);

sub draw_lines {
	$app->draw_line( [ rand $app->w, rand $app->h ], [ rand $app->w, rand $app->h ], 0xFFFFFFFF );
	$app->update();
}

$app->add_show_handler( \&draw_lines );

$app->run();
