use SDL::Event;
use SDLx::App;

my $app = SDLx::App->new(
		title  => "Test",
		width  => 640,
		height => 480,
		);



sub draw_line { $app->draw_line([0,1], [10,10], 0xFFFFFFFF); $app->update(); }

sub event_handle { my $e = shift; return  if($e->type == SDL_QUIT); return 1}

$app->add_event_handler( &event_handle );
$app->add_show_handler( &draw_line );

$app->run();


