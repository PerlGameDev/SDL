#!/usr/bin/perl
use strict;
use warnings;

# TODO (in this order):
#
# - why isn't it bliting correctly with transparent sprite background?
#
# - work with loading background tiles (world map)
#
# - making the "world" bigger than the display window and let it scroll.
#   the "world" should scroll centering the player, unless the player is
#   close enough to a borderline, in which case is the player who actually
#   moves
#
# - quick menu creation
#
# - quick text dialog creation (with picture)
#
# - music!
#
# - effects!
#
# - collision detection handling
#
# - a way to create transitioning effects between windows (worlds), like
#   entering a house, going into battle mode, ending a level, etc. Could be
#   fade in/out, scroll up/down/left/right, etc.
#
#
# - actual physics handling
package Walker;
use SDL;
use SDL::Image;
use SDL::Rect;
use SDL::Video;
use SDL::Surface;
use SDL::Color;

sub wtf {
    my $app = shift;

    my $format = $app->format;
    my $pixel = SDL::Video::map_RGB( $format, 0xfc, 0x00, 0xff );
    SDL::Video::fill_rect( $app, SDL::Rect->new( 0, 0, $app->w, $app->h ),
        $pixel );
}

sub new {
    my $class = shift;
    my ( $width, $height ) = ( 48, 48 );

    my $sprite = SDL::Image::load('data/hero.png');
    die 'SDL::Image::load of data/hero.png fail' . SDL::get_error if !($sprite);
    $sprite = SDL::Video::display_format($sprite);
    my $pixel = SDL::Color->new( 0xfc, 0x00, 0xff );
    SDL::Video::set_color_key( $sprite, SDL_SRCCOLORKEY, $pixel );
    my $self = {
        'direction' => undef,
        'source'    => $sprite,
        'up'        => [

            # we go down...
            SDL::Rect->new( 0, 0,           $width, $height ),
            SDL::Rect->new( 0, 0 + $height, $width, $height ),
            SDL::Rect->new( 0, 0 + ( 2 * $height ), $width, $height ),

            # then we go back...
            SDL::Rect->new( 0, 0 + $height, $width, $height ),
        ],
        'right' => [

            # we go down...
            SDL::Rect->new( $width, 0,           $width, $height ),
            SDL::Rect->new( $width, 0 + $height, $width, $height ),
            SDL::Rect->new( $width, 0 + ( 2 * $height ), $width, $height ),

            # then we go back...
            SDL::Rect->new( $width, 0 + $height, $width, $height ),
        ],
        'down' => [

            # we go down...
            SDL::Rect->new( ( 2 * $width ), 0,           $width, $height ),
            SDL::Rect->new( ( 2 * $width ), 0 + $height, $width, $height ),
            SDL::Rect->new(
                ( 2 * $width ),
                0 + ( 2 * $height ),
                $width, $height
            ),

            # then we go back...
            SDL::Rect->new( ( 2 * $width ), 0 + $height, $width, $height ),
        ],
        'left' => [

            # we go down...
            SDL::Rect->new( ( 3 * $width ), 0,           $width, $height ),
            SDL::Rect->new( ( 3 * $width ), 0 + $height, $width, $height ),
            SDL::Rect->new(
                ( 3 * $width ),
                0 + ( 2 * $height ),
                $width, $height
            ),

            # then we go back...
            SDL::Rect->new( ( 3 * $width ), 0 + $height, $width, $height ),
        ],
    };
    bless $self, $class;
    return $self;
}

sub blit { SDL::Video::blit_surface( shift->{'source'}, @_ ) }

# accessor for direction attribute
sub direction {
    my $self = shift;
    $self->{'direction'} = shift if (@_);
    return $self->{'direction'};
}

sub current {
    my $self      = shift;
    my $direction = $self->{direction};
    return $self->{$direction}->[0];
}

sub move {
    my $self      = shift;
    my $direction = $self->{direction};

    # cycle the rects around, grabbing a copy
    # of current animation
    my $rect = shift @{ $self->{$direction} };
    push @{ $self->{$direction} }, $rect;

    return $rect;
}

package main;

use strict;
use warnings;

use SDL;
use SDLx::App;
use SDL::Surface;
use SDL::Color;

# change these values as necessary
my $title = 'Keldar Chronicles';
my ( $width, $height, $depth ) = ( 640,  480,  16 );
my ( $bg_r,  $bg_g,   $bg_b )  = ( 0x77, 0xee, 0x77 );
my $sleep_msec = 0.05;

my $app = SDLx::App->new(
    -width  => $width,
    -height => $height,
    -depth  => $depth,
);

my $bg_color = SDL::Color->new( $bg_r, $bg_g, $bg_b, );

my $background = SDL::Rect->new( 0, 0, $width, $height, );

my $pos = SDL::Rect->new( 0, 240, 50, 50 );

my $walker = Walker->new();
my ( $x, $y ) = ( 40, 40 );
my ( $x_old, $y_old ) =
  ( $x, $y );    # Walker 'animation speed'. TODO: make it Walker's?
my $event     = SDL::Event->new;
my $direction = undef;
my $speed     = 6;

event_loop() while 1;

sub event_loop {

    # TODO: there's a way to only poll for special events, right?
    while ( SDL::Events::poll_event($event) ) {
        my $type = $event->type;
        exit if ( $type == SDL_QUIT );
        exit if ( $type == SDL_KEYDOWN && $event->key_sym == SDLK_ESCAPE );

        if ( $type == SDL_KEYDOWN ) {
            my $name = SDL::Events::get_key_name( $event->key_sym );
            if ( $name =~ m/^(left|right|down|up)$/ ) {
                $walker->direction($name);
            }
            $speed = ( $speed * 2 ) if $name eq 'space';
        }
        elsif ( $type == SDL_KEYUP ) {
            my $name = SDL::Events::get_key_name( $event->key_sym );
            if ( $name =~ m/^(left|right|down|up)$/ ) {
                $walker->direction(undef);
            }
            $speed = ( $speed / 2 ) if $name eq 'space';
        }
    }

    my $direction = $walker->direction;
    if ( defined $direction ) {
        if ( $direction eq 'right' ) {
            $x += $speed;
        }
        elsif ( $direction eq 'left' ) {
            $x -= $speed;
        }
        elsif ( $direction eq 'up' ) {
            $y -= $speed;
        }
        elsif ( $direction eq 'down' ) {
            $y += $speed;
        }
    }
    else {
        return;    # no motion events captured
    }

    $pos->x($x);
    $pos->y($y);

    draw_background( $app, $background, $bg_color );
    draw_walker( $walker, $app, $pos );
    SDL::Video::update_rects( $app, $background );
    select( undef, undef, undef, $sleep_msec );

}

sub draw_background {
    my ( $app, $background, $bg_color ) = @_;
    my $format = $app->format;
    my $pixel =
      SDL::Video::map_RGB( $format, $bg_color->r, $bg_color->g, $bg_color->b );
    SDL::Video::fill_rect( $app, $background, $pixel );
}

sub draw_walker {
    my ( $walker, $app, $pos ) = @_;

    my $source;

    # get walker's current surface
    if (   abs( $x - $x_old ) > 15
        or abs( $y - $y_old ) > 15 )
    {
        $source = $walker->move;
        $x_old  = $x;
        $y_old  = $y;
    }
    else {
        $source = $walker->current;
    }
    $walker->blit( $source, $app, $pos );

}

