use strict;
use warnings;
use lib '../lib';
use SDL;
use SDLx::App;
use SDLx::Text;

my $app = SDLx::App->new( eoq => 1 );

my $text = SDLx::Text->new;

$app->draw_rect( [0, 0, $app->w, $app->h], 0x00ffff );

$text->write_xy( $app, 300, 10, 'Normal Text' );

$text->bold(1);
$text->write_xy( $app, 300, 50, 'Bold Text' );

$text->italic(1);
$text->write_xy( $app, 300, 90, 'Bold/Italic Text' );

$text->bold(0);
$text->write_xy( $app, 300, 130, 'Italic Text' );

$text->italic(0);
$text->underline(1);
$text->write_xy( $app, 300, 170, 'Underline Text' );

$text->underline(0);
$text->strikethrough(1);
$text->write_xy( $app, 300, 210, 'Strikethrough Text' );

$text->underline(1);
$text->bold(1);
$text->italic(1);
$text->write_xy( $app, 300, 250, 'All in one!' );


$app->update;

$app->run;
