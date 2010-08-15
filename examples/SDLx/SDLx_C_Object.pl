use strict;
use warnings;
use Time::HiRes qw( time sleep );
use SDL;
use SDLx::App;
use SDL::Event;
use SDL::Events;

use SDLx::Controller::Object;
my $app          = SDLx::App->new( w => 200, h => 200, title => "timestep" );



my $spring  = SDLx::Controller::Object->new(x=> 100, y => 100);

my $accel = sub {
    my ( $t, $state ) = @_;
    my $k = 10;
    my $b = 1;
    my $ax = ( ( -1 * $k ) * ($state->x) - $b * $state->v_x );

   return($ax,0,0)
 };
$spring->set_acceleration( $accel);
 

my $event = sub
{	
     return 0 if $_[0]->type == SDL_QUIT;
     return 1;
};

my $render = sub 
{ 
    my $state = shift;
    $app->draw_rect( [ 0, 0, $app->w, $app->h ], 0x0 );
    $app->draw_rect(  [ 100 - $state->x , $state->y, 2, 2 ], 0xFF0FFF );
    $app->update();
};

$app->add_event_handler($event);
$app->add_object( $spring, $render );

$app->run_test();



