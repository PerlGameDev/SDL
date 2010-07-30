use SDL::Event;
use SDLx::App;

my $app = SDLx::App->new(
	title  => "Lines",
	width  => 640,
	height => 480,
);



sub draw_lines { $app->draw_line( [ 0, 0 ], [ rand( $app->w ), rand( $app->h ) ], 0xFFFFFFFF ); $app->update(); }

sub event_handle { my $e = shift; return if ( $e->type == SDL_QUIT ); return 1 }

$app->add_event_handler( \&event_handle );
$app->add_show_handler( \&draw_lines );

$app->run();


