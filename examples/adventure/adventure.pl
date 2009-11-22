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


package MyRect;
use lib '../lib';
use SDL::Game::Rect;

sub new {
    my $class = shift;
    my ($left, $top, $width, $height) = (@_);
    return SDL::Rect->new(
                -left   => $left,
                -top    => $top,
                -width  => $width,
                -height => $height,
    );
}

package Walker;
use SDL;
use SDL::Surface;

sub new {
    my $class = shift;
    my ($width, $height) = (48, 48);
   
    my $sprite = SDL::Surface->new(-name => 'data/hero.png');
     $sprite->set_color_key(SDL::SDL_SRCCOLORKEY,$sprite->pixel(0,0));

    my $self = {
        'direction' => undef,
        'source' => $sprite,
        'up'     => [
                     # we go down...
                     MyRect->new(0, 0, $width, $height),
                     MyRect->new(0, 0 + $height, $width, $height),
                     MyRect->new(0, 0 + (2 * $height), $width, $height),
                     # then we go back...
                     MyRect->new(0, 0 + $height, $width, $height),
                 ],
        'right'  => [ 
                     # we go down...
                     MyRect->new($width, 0, $width, $height),
                     MyRect->new($width, 0 + $height, $width, $height),
                     MyRect->new($width, 0 + (2 * $height), $width, $height),
                     # then we go back...
                     MyRect->new($width, 0 + $height, $width, $height),
                    ],
        'down'  => [ 
                     # we go down...
                     MyRect->new((2 * $width), 0, $width, $height),
                     MyRect->new((2 * $width), 0 + $height, $width, $height),
                     MyRect->new((2 * $width), 0 + (2 * $height), $width, $height),
                     # then we go back...
                     MyRect->new((2 * $width), 0 + $height, $width, $height),
                    ],
        'left'  => [ 
                     # we go down...
                     MyRect->new((3 * $width), 0, $width, $height),
                     MyRect->new((3 * $width), 0 + $height, $width, $height),
                     MyRect->new((3 * $width), 0 + (2 * $height), $width, $height),
                     # then we go back...
                     MyRect->new((3 * $width), 0 + $height, $width, $height),
                    ],
    };
    bless $self, $class;
    $self->{'source'}->display_format;
    return $self;
}

sub blit { shift->{'source'}->blit(@_) }

# accessor for direction attribute
sub direction { 
    my $self = shift;
    $self->{'direction'} = shift if (@_);
    return $self->{'direction'};
}

sub current {
    my $self = shift;
    my $direction = $self->{direction};
    return $self->{$direction}->[0];
}

sub move {
    my $self = shift;
    my $direction = $self->{direction};
    
    # cycle the rects around, grabbing a copy
    # of current animation
    my $rect = shift @{$self->{$direction}};
    push @{$self->{$direction}}, $rect;
    
    return $rect;
}

package main;

use strict;
use warnings;

use SDL;
use SDL::App;
use SDL::Surface;
use SDL::Color;

# change these values as necessary
my $title                                = 'Keldar Chronicles';
my ($width,      $height,      $depth)   = (  640,  480,   16 );
my ($bg_r,       $bg_g,        $bg_b)    = ( 0x77, 0xee, 0x77 );
my $sleep_msec                           = 0.05;

my $app = SDL::App->new(
	-width  => $width,
	-height => $height,
	-depth  => $depth,
);

my $bg_color = SDL::Color->new(
	-r => $bg_r,
	-g => $bg_g,
	-b => $bg_b,
);

my $background = SDL::Rect->new(
	-width  => $width,
	-height => $height,
);

my $pos = SDL::Rect->new(
	-width  => 50,
	-height => 50,
	-left   => 0,
	-top    => 240,
);

my $walker = Walker->new();
my ($x, $y) = (40, 40);
my ($x_old, $y_old) = ($x, $y); # Walker 'animation speed'. TODO: make it Walker's?
my $event = SDL::Event->new;
my $direction = undef;
my $speed = 6;

event_loop() while 1;

sub event_loop {
    
    # TODO: there's a way to only poll for special events, right?
	while ($event->poll) {
		my $type = $event->type;
		exit if ($type == SDL_QUIT);
		exit if ($type == SDL_KEYDOWN && $event->key_name eq 'escape');
		
		if ( $type == SDL_KEYDOWN ) {
			my $name = $event->key_name;
			if ($name =~ m/^(left|right|down|up)$/ ) {
				$walker->direction($name);
			}
			$speed = ($speed * 2) if $name eq 'space';
		}
        elsif ( $type == SDL_KEYUP ) {
			my $name = $event->key_name;
			if ($name =~ m/^(left|right|down|up)$/ ) {
				$walker->direction(undef);
			}
			$speed = ($speed / 2) if $name eq 'space';
		}
	}

    my $direction = $walker->direction;
    if (defined $direction) {
        if ($direction eq 'right') {
            $x += $speed;
        } elsif ($direction eq 'left') {
            $x -= $speed;
        } elsif ($direction eq 'up') {
            $y -= $speed;
        } elsif ($direction eq 'down') {
            $y += $speed;
        }
    }
	else {
	    return; # no motion events captured
	}

	$pos->x( $x );
	$pos->y( $y );
	
    draw_background( $app, $background, $bg_color );
	draw_walker( $walker, $app, $pos );
	$app->update( $background );
	select( undef, undef, undef, $sleep_msec );
	
}


sub draw_background {
	my ($app, $background, $bg_color) = @_;
	$app->fill( $background, $bg_color );
}

sub draw_walker {
	my ($walker, $app, $pos) = @_;

    my $source;
    
	# get walker's current surface
	if ( abs($x - $x_old) > 15
	  or abs($y - $y_old) > 15
	  ) {
        $source = $walker->move;
        $x_old = $x;
        $y_old = $y;
    }
    else {
        $source = $walker->current;
    }
	$walker->blit($source, $app, $pos);

}


