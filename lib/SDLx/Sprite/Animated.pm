package SDLx::Sprite::Animated;
use strict;
use warnings;
use vars qw($VERSION);

use Scalar::Util 'refaddr';
use SDL;
use SDL::Video;
use SDL::Rect;
use SDLx::Sprite;
use SDLx::Validate;

use base 'SDLx::Sprite';

our $VERSION = '2.541_10';
$VERSION = eval $VERSION;

# inside out
my %_ticks;
my %_width;
my %_height;
my %_step_x;
my %_step_y;
my %_offset_x;
my %_offset_y;
my %_type;
my %_max_loops;
my %_ticks_per_frame;
my %_current_frame;
my %_current_loop;
my %_sequences;
my %_sequence;
my %_started;
my %_direction;

sub new {
	my ( $class, %options ) = @_;

	my ( $w, $h );
	if ( exists $options{clip} ) {
		( $w, $h ) = ( $options{clip}->w, $options{clip}->h );
	} elsif ( exists $options{rect} ) {
		( $w, $h ) = ( $options{rect}->w, $options{rect}->h );
	} elsif ( exists $options{width} && $options{height} ) {
		( $w, $h ) = ( $options{width}, $options{height} );
	}

	my $self = $class->SUPER::new(%options);

	$self->_store_geometry( $w, $h );

	$self->step_x( exists $options{step_x} ? $options{step_x} : $self->clip->w );
	$self->step_y( exists $options{step_y} ? $options{step_y} : $self->clip->h );
	$_offset_x{ refaddr $self} = exists $options{clip} ? $options{clip}->x : 0;
	$_offset_y{ refaddr $self} = exists $options{clip} ? $options{clip}->y : 0;

	$self->max_loops( exists $options{max_loops}             ? $options{max_loops}       : 0 );
	$self->ticks_per_frame( exists $options{ticks_per_frame} ? $options{ticks_per_frame} : 1 );
	$self->type( exists $options{type}                       ? $options{type}            : 'circular' );

	if ( exists $options{sequences} ) {
		$_sequences{ refaddr $self} = $options{sequences};
	} else {
		$self->_init_default_sequence();
	}
	$self->sequence( $options{sequence} ) if exists $options{sequence};

	$_ticks{ refaddr $self}     = 0;
	$_direction{ refaddr $self} = 1;

	return $self;
}

sub DESTROY {
	my $self = shift;
	delete $_ticks{ refaddr $self};
	delete $_width{ refaddr $self};
	delete $_height{ refaddr $self};
	delete $_step_x{ refaddr $self};
	delete $_step_y{ refaddr $self};
	delete $_offset_x{ refaddr $self};
	delete $_offset_y{ refaddr $self};
	delete $_type{ refaddr $self};
	delete $_max_loops{ refaddr $self};
	delete $_ticks_per_frame{ refaddr $self};
	delete $_current_frame{ refaddr $self};
	delete $_current_loop{ refaddr $self};
	delete $_sequences{ refaddr $self};
	delete $_sequence{ refaddr $self};
	delete $_started{ refaddr $self};
	delete $_direction{ refaddr $self};
}

sub load {
	my $self  = shift;
	my $image = shift;
	$self->SUPER::load($image);
	$self->_restore_geometry;
	$self->_init_default_sequence;
	return $self;
}

sub _init_default_sequence {
	my $self = shift;

	my $max_x = int( ( $self->surface->w - $_offset_x{ refaddr $self} ) / $self->step_x );
	my $max_y = int( ( $self->surface->h - $_offset_y{ refaddr $self} ) / $self->step_y );

	my @sequence;
	foreach my $y ( 0 .. $max_y - 1 ) {
		foreach my $x ( 0 .. $max_x - 1 ) {
			push @sequence, [ $x, $y ];
		}
	}
	$_sequences{ refaddr $self} = { 'default' => \@sequence };
	$self->sequence('default');
}

sub _store_geometry {
	my ( $self, $w, $h ) = @_;

	$_width{ refaddr $self}  = $w;
	$_height{ refaddr $self} = $h;

	$self->_restore_geometry;
}

sub _restore_geometry {
	my $self = shift;

	$self->clip->w( $_width{ refaddr $self} )  if exists $_width{ refaddr $self};
	$self->clip->h( $_height{ refaddr $self} ) if exists $_height{ refaddr $self};
	$self->rect->w( $_width{ refaddr $self} )  if exists $_width{ refaddr $self};
	$self->rect->h( $_height{ refaddr $self} ) if exists $_height{ refaddr $self};
}

sub step_y {
	my ( $self, $step_y ) = @_;

	if ($step_y) {
		$_step_y{ refaddr $self} = $step_y;
	}

	return $_step_y{ refaddr $self};
}

sub step_x {
	my ( $self, $step_x ) = @_;

	if ($step_x) {
		$_step_x{ refaddr $self} = $step_x;
	}

	return $_step_x{ refaddr $self};
}

sub type {
	my ( $self, $type ) = @_;

	if ($type) {
		$_type{ refaddr $self} = lc $type;
	}

	return $_type{ refaddr $self};
}

sub max_loops {
	my $self = shift;

	if (@_) {
		$_max_loops{ refaddr $self} = shift;
	}

	return $_max_loops{ refaddr $self};
}

sub ticks_per_frame {
	my ( $self, $ticks ) = @_;

	if ($ticks) {
		$_ticks_per_frame{ refaddr $self} = $ticks;
	}

	return $_ticks_per_frame{ refaddr $self};
}

sub current_frame {
	my ( $self, $frame ) = @_;
	return $_current_frame{ refaddr $self};
}

sub current_loop {
	my ($self) = @_;
	return $_current_loop{ refaddr $self };
}

sub set_sequences {
	my ( $self, %sequences ) = @_;

	# TODO: Validate sequences.
	$_sequences{ refaddr $self} = \%sequences;

	return $self;
}

sub sequence {
	my ( $self, $sequence ) = @_;
	my $me = refaddr $self;

	if ($sequence) {

		if ( !defined( $_sequences{$me}{$sequence} ) ) {
			warn 'Unknown sequence: ', $sequence;
			return;
		}
		$_sequence{$me}      = $sequence;
		$_current_frame{$me} = 1;
		$_current_loop{$me}  = 1;
		$_direction{$me}     = 1;
		$self->_update_clip;
	}

	return $_sequence{$me};
}

sub _sequence {
	my $self = shift;
	return $_sequences{ refaddr $self}{ $_sequence{ refaddr $self} };
}

sub _frame {
	my $self = shift;
	return $self->_sequence->[ $_current_frame{ refaddr $self} - 1 ];
}

sub next {
	my $self = shift;
	my $me   = refaddr $self;

	return if @{ $self->_sequence } == 1;

	return if $_max_loops{$me} && $_current_loop{$me} > $_max_loops{$me};

	my $next_frame = ( $_current_frame{$me} - 1 + $_direction{$me} ) % @{ $self->_sequence };

	if ( $next_frame == 0 ) {
		$_current_loop{$me}++ if $_type{$me} eq 'circular';

		if ( $_type{$me} eq 'reverse' ) {

			if ( $_direction{$me} == 1 ) {
				$next_frame = @{ $self->_sequence } - 2;
			} else {
				$_current_loop{$me}++;
			}

			$_direction{$me} *= -1;
		}
	}
	$_current_frame{$me} = $next_frame + 1;

	$self->_update_clip;

	return $self;
}

sub previous {
	my $self = shift;

	return if $_max_loops{ refaddr $self} && $_current_loop{ refaddr $self } > $_max_loops{ refaddr $self};

	$_ticks{ refaddr $self} = 0;

	return if @{ $self->_sequence } == 1;

	my $previous_frame = ( $_current_frame{ refaddr $self} - 1 - $_direction{ refaddr $self} ) % @{ $self->_sequence };

	if ( $previous_frame == 0 ) {
		if ( $_type{ refaddr $self} eq 'reverse' ) {

			if ( $_direction{ refaddr $self} == -1 ) {
				$previous_frame = 1;
			}

			$_direction{ refaddr $self} *= -1;
		}
	}
	$_current_frame{ refaddr $self} = $previous_frame + 1;

	$self->_update_clip;

	return $self;
}

sub reset {
	my $self = shift;

	$self->stop;
	$_current_frame{ refaddr $self} = 1;
	$self->_update_clip;

	return $self;
}

sub start {
	my $self = shift;

	$_started{ refaddr $self} = 1;

	return $self;
}

sub stop {
	my $self = shift;

	$_started{ refaddr $self} = 0;

	return $self;
}

sub _update_clip {
	my $self = shift;

	my $clip  = $self->clip;
	my $frame = $self->_frame;

	$clip->x( $_offset_x{ refaddr $self} + $frame->[0] * $_step_x{ refaddr $self} );
	$clip->y( $_offset_y{ refaddr $self} + $frame->[1] * $_step_y{ refaddr $self} );
}

sub alpha_key {
	my $self = shift;
	$self->SUPER::alpha_key(@_);
	$self->_restore_geometry;
	return $self;
}

sub draw {
	my ( $self, $surface ) = @_;

	$surface = SDLx::Validate::surface($surface);

	$_ticks{ refaddr $self}++;
	$self->next if $_started{ refaddr $self} && $_ticks{ refaddr $self} % $_ticks_per_frame{ refaddr $self} == 0;

	SDL::Video::blit_surface( $self->surface, $self->clip, $surface, $self->rect );

	return $self;
}

1;

