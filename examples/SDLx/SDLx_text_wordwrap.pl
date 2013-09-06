use strict;
use warnings;
use lib '../lib';
use SDL;
use SDLx::App;
use SDLx::Text;

my $app = SDLx::App->new();

my $text = SDLx::Text->new( word_wrap => 450 );

$app->draw_rect( [ 0, 0, $app->w, $app->h ], 0x00ffff );

my $message = <<'EOT';
All lines come from a single string.

- Really?
Yup.

- But... but... what if I say a lot of things in a single line.  Won't that become trucated or something?

Not if you set "word_wrap" to a particular width, like we do here :-)
EOT

$text->write_to( $app, $message );
$app->update;

$app->run;
