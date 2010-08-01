package SDLx::LayerManager;
use strict;
use warnings;
use SDL;
use SDLx::Surface;
use SDLx::Sprite;
use SDL::Events;

our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDLx::LayerManager;

my @layers            = ();
my @attached_layers   = ();
my @attached_distance = ();
my @attached_position = ();
my $snapshot          = SDLx::Sprite->new( width => 800, height => 600 );
my $must_redraw       = 1;

sub set {
	my $self    = shift;
	my $index   = shift;
	my $layer   = shift;
	my $options = shift;

	$layers[$index] = { layer => $layer, options => $options };
	return $self;
}

#sub blit {
#    my $self = shift;
#    my $dest = shift;
#
#    return 0 unless (scalar @attached_layers || $must_redraw);
#
#    my $did_redraw = (scalar @attached_layers || $must_redraw);
#
#    #print("$must_redraw\n");
#    my ( $mask, $x, $y ) = @{ SDL::Events::get_mouse_state() };
#
#    #$snapshot->blit_by($dest) if $must_redraw;
#
#    if(scalar @attached_layers || $must_redraw) {
#        my $layer_index = 0;
#        foreach (@layers) {
#            $_->{layer}->draw($dest) unless join( ',', @attached_layers ) =~ m/\b\Q$layer_index\E\b/;
#            $layer_index++;
#        }
#        #$snapshot = SDLx::Sprite->new(width => $dest->w, height => $dest->h);
#        $snapshot->blit_by($dest);
#        #print("2\n");
#    }
#
#    foreach (@attached_layers) {
#        $layers[$_]->{layer}->draw_xy($dest, $x + @{$attached_distance[$_]}[0], $y + @{$attached_distance[$_]}[1]);
#    }
#
#    #unless (scalar @attached_layers && defined $snapshot) {
#    #    $snapshot = SDLx::Sprite->new(width => $self->{dest}->w, height => $self->{dest}->h);
#    #    $snapshot->blit_by($self->{dest});
#    #}
#
#    $must_redraw = 0;
#    return $did_redraw;
#}

sub attach {
	my $self = shift;

	#my $dest = shift;
	my $y = pop;
	my $x = pop;

	#$snapshot = SDLx::Sprite->new(width => $self->{dest}->w, height => $self->{dest}->h);
	#$snapshot->blit_by($self->{dest});
	$must_redraw       = 1;
	@attached_distance = ();
	@attached_position = ();
	@attached_layers   = @_;
	foreach (@layers) {
		push( @attached_distance, [ $_->{layer}->x - $x, $_->{layer}->y - $y ] );
		push( @attached_position, [ $_->{layer}->x,      $_->{layer}->y ] );
	}
}

sub detach {
	my $self = shift;
	$must_redraw       = 1;
	@attached_distance = ();
	@attached_position = ();
	@attached_layers   = ();
}

sub detach_back {
	my $self = shift;
	foreach (@attached_layers) {
		$layers[$_]->{layer}->x( @{ $attached_position[$_] }[0] );
		$layers[$_]->{layer}->y( @{ $attached_position[$_] }[1] );
	}
	$must_redraw       = 1;
	@attached_distance = ();
	@attached_position = ();
	@attached_layers   = ();
}

sub detach_xy {
	my $self = shift;
	my $x    = shift;
	my $y    = shift;
	my $offset_x;
	my $offset_y;
	foreach (@attached_layers) {
		$offset_x = @{ $attached_position[$_] }[0] - $x unless defined $offset_x;
		$offset_y = @{ $attached_position[$_] }[1] - $y unless defined $offset_y;

		$layers[$_]->{layer}->x( @{ $attached_position[$_] }[0] - $offset_x );
		$layers[$_]->{layer}->y( @{ $attached_position[$_] }[1] - $offset_y );
	}
	my @position_before = @{ $attached_position[ $attached_layers[0] ] };

	$must_redraw       = 1;
	@attached_distance = ();
	@attached_position = ();
	@attached_layers   = ();

	return @position_before;
}

sub foreground {
	my $self    = shift;
	my @layers_ = @_;
	@attached_layers = ();

	for (@layers_) {
		push( @layers,            $layers[$_] );
		push( @attached_distance, $attached_distance[$_] );
		push( @attached_position, $attached_position[$_] );
	}

	for ( sort { $b <=> $a } @layers_ ) {
		splice( @layers,            $_, 1 );
		splice( @attached_distance, $_, 1 );
		splice( @attached_position, $_, 1 );
	}

	for ( my $i = $#layers - $#layers_; $layers[$i]; $i++ ) {
		push( @attached_layers, $i );
	}
	$must_redraw = 1;

	return @attached_layers;
}

1;
