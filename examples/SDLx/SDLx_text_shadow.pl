#TODO: shadow, shadow_color, shadow_offset

use strict;
use warnings;
use lib '../lib';
use SDL;
use SDLx::App;
use SDLx::Text;

my $app = SDLx::App->new();

my $normal = SDLx::Text->new;
my $shadow = SDLx::Text->new( shadow => 1 );

# other variations
my $shadow_off = SDLx::Text->new( shadow => 1, shadow_offset => 4 );
my $shadow_color = SDLx::Text->new( shadow => 1, shadow_color => [150, 150, 0] );

$app->add_show_handler( sub {
    $app->draw_rect( [0, 0, $app->w, $app->h], 0x00ffff );

    $normal->write_xy( $app, 10,  0, 'Hello, World!'  );
    $shadow->write_xy( $app, 10, 50, 'Hello, Shadow!' );

    $shadow_off->write_xy(   $app, 10, 100, 'Hello, Shadow with offset!' );
    $shadow_color->write_xy( $app, 10, 150, 'Hello, colored Shadow!'     );

    $app->update;
});

$app->run;
