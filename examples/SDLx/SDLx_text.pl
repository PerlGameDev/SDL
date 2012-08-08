use strict;
use warnings;
use lib '../lib';
use SDL;
use SDLx::App;
use SDLx::Text;

my $app = SDLx::App->new();

my $text = SDLx::Text->new;

$app->draw_rect( [ 0, 0, $app->w, $app->h ], 0x00ffff );
$text->write_to( $app, 'Hello, World!' );
$app->update;

$app->run;
