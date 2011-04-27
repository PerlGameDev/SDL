use strict;
use SDL;
use SDL::Event;
use SDL::Rect;
use lib qw(lib ../lib ../../lib);
use SDLx::App;
use SDLx::Surface;
use SDLx::Text;

# Create App
my $app = SDLx::App->new(
    width   => 800,
    height  => 800,
    exit_on_quit => 1,
    delay   => 100,
);

# Global write_to
my $text = SDLx::Text->new(
    font    => 'share/GenBasR.ttf',
    size    => 18,
    color   => 0xFF0000,
    mode    => 'utf8',
);
for my $v (qw(top middle bottom))
{
    for my $h (qw(left center right))
    {
        $text->v_align($v);
        $text->h_align($h);
        $text->write_to($app, "$h : $v");
    }
}

# Global write_xy
$text = SDLx::Text->new(
    font    => 'share/GenBasR.ttf',
    size    => 18,
    color   => 0xFFFFFFFF,
    mode    => 'utf8',
);

my $y = 200;
for my $v (qw(top middle bottom))
{
    my $x = 100;
    for my $h (qw(left center right))
    {
        $text->v_align($v);
        $text->h_align($h);
        $text->write_xy($app, $x, $y, "$h : $v");

        $app->draw_line([$x, $y-5], [$x, $y+5], 0xFF00FFFF);
        $app->draw_line([$x-5, $y], [$x+5, $y], 0xFF00FFFF);

        $x += 200;
    }
    $y += 60;
}

# Clip text
$text = SDLx::Text->new(
    font    => 'share/GenBasR.ttf',
    size    => 36,
    color   => 0xFFFF00,
    mode    => 'utf8',
    clip    => SDL::Rect->new(5, 5, 172, 23),
    h_align => 'center',
    v_align => 'top',
);
$text->write_xy($app, 400, 120, 'CLIPPED TEXT');


# Use rect for position text
$text = SDLx::Text->new(
    font    => 'share/GenBasR.ttf',
    size    => 14,
    color   => 0xFFFFFFFF,
    mode    => 'utf8',
);

my $y = 400;
my ($dx, $dy) = (30, 30);
for my $v (qw(top middle bottom))
{
    my $x = 100;
    for my $h (qw(left center right))
    {
        $app->draw_rect([$x, $y, 100, 100], 0x666666FF);
        $text->rect(SDL::Rect->new($x, $y, 100, 100));
        $text->v_align($v);
        $text->h_align($h);
        $text->write_to($app, "$h : $v");

        $text->write_xy($app, $dx, $dy, "text");

        $app->draw_line([$x+$dx, $y+$dy-5], [$x+$dx, $y+$dy+5], 0xFF00FFFF);
        $app->draw_line([$x+$dx-5, $y+$dy], [$x+$dx+5, $y+$dy], 0xFF00FFFF);

        $x += 120;
    }
    $y += 120;
}


# Help messages
my $text = SDLx::Text->new(
    font    => 'share/GenBasR.ttf',
    size    => 18,
    color   => 0xFF00FF,
    mode    => 'utf8',
    h_align => 'center',
    v_align => 'middle',
);
$text->write_xy($app, 400, 170,
    'Example of write_xy. Cyan cross show $x, $y coordinates.');
$text->color(0x999999);
$text->write_xy($app, 400, 370,
    'Example of use rect for write_to and write_xy('.$dx.', '.$dy.',"text").'.
    ' You can see write_** draw relative to rect.');
$text->color(0xFF0000);
$text->write_xy($app, 400, 70,
    'Red text is example of different aligns on write_to for SDLx::App target'.
    ' surface without any limitations.');
$text->color(0xFFFF00);
$text->write_xy($app, 400, 100,
    'Clipped text example.');

# Run application
$app->flip;
$app->run;
$app->pause;
