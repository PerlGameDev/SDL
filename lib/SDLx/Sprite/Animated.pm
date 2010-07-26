package SDLx::Sprite::Animated;
use strict;
use warnings;

use SDL;
use SDL::Video;
use SDL::Rect;
use SDLx::Sprite;

use base 'SDLx::Sprite';

use Carp ();

sub new {
    my ( $class, %options ) = @_;

    if ( exists $options{rect} ) {
        $options{width}  = $options{rect}->w;
        $options{height} = $options{rect}->h;
    }
    my ( $w, $h ) = ( $options{width}, $options{height} );

    my $self = $class->SUPER::new(%options);

    $self->_store_geometry( $w, $h );

    $self->step_y( exists $options{step_y} ? $options{step_y} : 0 );
    $self->step_x( exists $options{step_x} ? $options{step_x} : 0 );
    $self->type( exists $options{type}     ? $options{type}   : 'circular' );
    $self->max_loops( exists $options{max_loops} ? $options{max_loops} : 0 );
    $self->ticks_per_frame(
        exists $options{ticks_per_frame} ? $options{ticks_per_frame} : 1 );

    $self->{ticks} = 0;

    return $self;
}

sub load {
    my $self = shift;

    $self->SUPER::load(@_);

    $self->_restore_geometry;

    return $self;
}

sub _store_geometry {
    my ( $self, $w, $h ) = @_;

    $self->{width}  = $w;
    $self->{height} = $h;

    $self->_restore_geometry;
}

sub _restore_geometry {
    my $self = shift;

    $self->clip->w( $self->{width} );
    $self->clip->h( $self->{height} );
    $self->rect->w( $self->{width} );
    $self->rect->h( $self->{height} );
}

sub step_y {
    my ( $self, $step_y ) = @_;

    if ($step_y) {
        $self->{step_y} = $step_y;
    }

    return $self->{step_y};
}

sub step_x {
    my ( $self, $step_x ) = @_;

    if ($step_x) {
        $self->{step_x} = $step_x;
    }

    return $self->{step_x};
}

sub type {
    my ( $self, $type ) = @_;

    if ($type) {
        $self->{type} = $type;
    }

    return $self->{type};
}

sub max_loops {
    my ( $self, $max ) = @_;

    if ($max) {
        $self->{max_loops} = $max;
    }

    return $self->{max_loops};
}

sub ticks_per_frame {
    my ( $self, $ticks ) = @_;

    if ($ticks) {
        $self->{ticks_per_frame} = $ticks;
    }

    return $self->{ticks_per_frame};
}

sub current_frame {
    my ( $self, $frame ) = @_;

    if ($frame) {

        # TODO: Validate frame.
        $self->{current_frame} = $frame;
    }

    return $self->{current_frame};
}

sub current_loop {
    return $_[0]->{current_loop};
}

sub set_sequences {
    my ( $self, %sequences ) = @_;

    # TODO: Validate sequences.
    $self->{sequences} = \%sequences;

    return $self;
}

sub sequence {
    my ( $self, $sequence ) = @_;

    if ($sequence) {

        #TODO: Validate sequence.
        $self->{sequence}      = $sequence;
        $self->{current_frame} = 0;
        $self->_update_clip;
    }

    return $self->{sequence};
}

sub _sequence {
    my $self = shift;
    return $self->{sequences}->{ $self->{sequence} };
}

sub _frame {
    my $self = shift;
    return $self->_sequence->[ $self->{current_frame} ];
}

sub next {
    my $self = shift;

    # TODO: direction, type, max_loops, current_loop
    $self->{current_frame} =
      ( $self->{current_frame} + 1 ) % @{ $self->_sequence };
    $self->_update_clip;
}

# TODO
sub previous {
    my $self = shift;

    $self->_update_clip;

    return $self;
}

sub reset {
    my $self = shift;

    $self->stop;
    $self->{current_frame} = 0;

    return $self;
}

sub start {
    my $self = shift;

    $self->{started} = 1;

    return $self;
}

sub stop {
    my $self = shift;

    $self->{started} = 0;

    return $self;
}

sub _update_clip {
    my $self = shift;

    my $clip  = $self->clip;
    my $frame = $self->_frame;

    # TODO step_x, step_y
    $clip->x( $frame->[0] * $clip->w );
    $clip->y( $frame->[1] * $clip->h );
}

sub draw {
    my ( $self, $surface ) = @_;

    $self->{ticks}++;
    $self->next
      if $self->{started} && $self->{ticks} % $self->{ticks_per_frame} == 0;

    Carp::croak 'destination must be a SDL::Surface'
      unless ref $surface and $surface->isa('SDL::Surface');

    SDL::Video::blit_surface( $self->surface, $self->clip, $surface,
        $self->rect );

    return $self;
}

1;

