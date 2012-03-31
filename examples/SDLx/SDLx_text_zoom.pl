#TODO: shadow, shadow_color, shadow_offset

use strict;
use warnings;
use lib '../lib';
use SDL;
use SDLx::App;
use SDLx::Text;

my $app = SDLx::App->new( width => 400, height => 100 );

my $text = SDLx::Text->new;

my $size = 1;
my $direction = 1;
$app->add_move_handler( sub {
    $size += $direction;
    $text->size( $size );

    if ($direction == 1) {
        $direction = -1 if $size > 60;
    }
    else {
        $direction = 1 if $size < 2;
    }
});

$app->add_show_handler( sub {
    $app->draw_rect( [0, 0, $app->w, $app->h], 0x00ffff );
    $text->write_to( $app, 'Hello, World!' );
    $app->update;
});

$app->run;
