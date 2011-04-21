use strict;
use SDL;
use SDL::Config;
use SDL::Color;
use SDL::Rect;
use SDL::Surface;
use SDLx::App;
BEGIN {
    use FindBin;
    use Test::More;
    use lib qw(t/lib lib);
    use SDL::TestTool;

    if ( !SDL::Config->has('SDL_ttf') ) {
        plan( skip_all => 'SDL_ttf support not compiled' );
    }
}

use_ok( 'SDLx::Text' );

my $videodriver = $ENV{SDL_VIDEODRIVER};
$ENV{SDL_VIDEODRIVER} = 'dummy' unless $ENV{SDL_RELEASE_TESTING};

use File::Spec;
my $score = SDLx::Text->new(
       font => File::Spec->catfile($FindBin::Bin, '..', 'share', 'GenBasR.ttf')
);

isa_ok( $score, 'SDLx::Text');

is($score->x, 0, 'default x position');
is($score->y, 0, 'default y position');
is($score->h_align, 'left', 'default horizontal alignment');
is($score->v_align, 'top', 'default vertical alignment');
isa_ok( $score->font, 'SDL::TTF::Font' );
isa_ok($score->color, 'SDL::Color', 'default color');
is($score->size, 24, 'default size');

$score->text('Hello');

is( $score->text, 'Hello', 'text() as a getter' );
isa_ok($score->surface, 'SDL::Surface');

my $value = undef;
my $other_self = $score->text($value);
isa_ok($score, 'SDLx::Text');

# Next tests relay on fixed width=53 and height=28 fot text 'Hello'
# for GenBasR.ttf font. Draw on surface 200x200
$score->text('Hello');
is( $score->w, 53, 'Hello! is 53 px wide!' );
is( $score->h, 28, 'Hello! is 28 px high!' );

# Set rect for complete write_xx test
is $score->rect, undef, 'default rect undefined';
my ($rect_x, $rect_y, $rect_w, $rect_h) = (100, 100, 100, 100);
$score->rect( SDL::Rect->new($rect_x,$rect_y,100,100) );
isa_ok($score->rect, 'SDL::Rect');

# Coordinates for write_xy
my ($xy_x, $xy_y) = (50, 50);

# Create target surface
my $target = SDL::Surface->new(width => 200, height => 200);

# Test matrix write_xx for different aligns
my @test = (
    {   h_align => 'left',                          v_align => 'top',
        to_x => $rect_x + 0,                        to_y => $rect_y + 0,
        xy_x => $rect_x + $xy_x,                    xy_y => $rect_y + $xy_y },
    {   h_align => 'left',                          v_align => 'middle',
        to_x => $rect_x + 0,                        to_y => $rect_y + $rect_h/2-$score->h/2,
        xy_x => $rect_x + $xy_x,                    xy_y => $rect_y + $xy_y-$score->h/2 },
    {   h_align => 'left',                          v_align => 'bottom',
        to_x => $rect_x + 0,                        to_y => $rect_y + $rect_h-$score->h,
        xy_x => $rect_x + $xy_x,                    xy_y => $rect_y + $xy_y-$score->h},
    {   h_align => 'center',                        v_align => 'top',
        to_x => $rect_x + $rect_w/2-$score->w/2,    to_y => $rect_y + 0,
        xy_x => $rect_x + $xy_x-$score->w/2,        xy_y => $rect_y + $xy_y},
    {   h_align => 'center',                        v_align => 'middle',
        to_x => $rect_x + $rect_w/2-$score->w/2,    to_y => $rect_y + $rect_h/2-$score->h/2,
        xy_x => $rect_x + $xy_x-$score->w/2,        xy_y => $rect_y + $xy_y-$score->h/2},
    {   h_align => 'center',                        v_align => 'bottom',
        to_x => $rect_x + $rect_w/2-$score->w/2,    to_y => $rect_y + $rect_h-$score->h,
        xy_x => $rect_x + $xy_x-$score->w/2,        xy_y => $rect_y + $xy_y-$score->h},
    {   h_align => 'right',                         v_align => 'top',
        to_x => $rect_x + $rect_w-$score->w,        to_y => $rect_y + 0,
        xy_x => $rect_x + $xy_x-$score->w,          xy_y => $rect_y + $xy_y},
    {   h_align => 'right',                         v_align => 'middle',
        to_x => $rect_x + $rect_w-$score->w,        to_y => $rect_y + $rect_h/2-$score->h/2,
        xy_x => $rect_x + $xy_x-$score->w,          xy_y => $rect_y + $xy_y-$score->h/2},
    {   h_align => 'right',                         v_align => 'bottom',
        to_x => $rect_x + $rect_w-$score->w,        to_y => $rect_y + $rect_h-$score->h,
        xy_x => $rect_x + $xy_x-$score->w,          xy_y => $rect_y + $xy_y-$score->h},

);

for my $test (@test)
{
    $score->h_align( $test->{h_align} );
    $score->v_align( $test->{v_align} );
    $score->write_to($target);

    is $score->x, $test->{to_x},
        sprintf 'horizontal position write_to for %s:%s', $score->h_align, $score->v_align;
    is $score->y, $test->{to_y},
        sprintf 'vertical position write_to for %s:%s', $score->h_align, $score->v_align;

    $score->write_xy($target, $xy_x, $xy_y);
    is $score->x, $test->{xy_x},
        sprintf 'horizontal position write_xy for %s:%s', $score->h_align, $score->v_align;
    is $score->y, $test->{xy_y},
        sprintf 'vertical position write_xy for %s:%s', $score->h_align, $score->v_align;
}

# Clip test
$score->clip( SDL::Rect->new(10, 10, 50, 50) );
isa_ok($score->clip, 'SDL::Rect');


END {

    if ($videodriver) {
        $ENV{SDL_VIDEODRIVER} = $videodriver;
    } else {
        delete $ENV{SDL_VIDEODRIVER};
    }

    done_testing;
}
