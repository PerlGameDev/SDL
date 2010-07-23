package SDLx::Surface::TiedMatrixRow;
use strict;
use warnings;
use base 'Tie::Array';

sub new {
    my $class  = shift;
    my $matrix = shift;
    my $y      = shift;

    my $self = {
        matrix => $matrix,
        y      => $y,
    };

    return bless $self, $class;
}

sub TIEARRAY {
    return SDLx::Surface::TiedMatrixRow->new( $_[1], $_[2] );
}

sub FETCH {
    my ( $self, $x ) = @_;
    $self->{matrix}->get_pixel( $x, $self->{y} );
}

sub FETCHSIZE {

    my ( $self, $x ) = @_;
    return $self->{matrix}->surface->w;

}

sub STORE {
    my ( $self, $x, $new_value ) = @_;
    $self->{matrix}->set_pixel( $x, $self->{y}, $new_value );
}

1;
