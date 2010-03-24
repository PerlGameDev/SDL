package SDL::Tutorial::MoP::Controller::CPUSpinner;

use strict;
use warnings;

use base 'SDL::Tutorial::MoP::Base';

sub init {
    my $self = shift;
    $self->{keep_going} ||= 1;
}

sub run {
    my $self = shift;
    while ($self->{keep_going} == 1) {
        $self->evt_manager->post({ name => 'Tick'});
    }
}

sub notify {
    my ($self, $event) = (@_);

    print "Notify in CPU Spinner \n" if $self->{EDEBUG};

    my %event_method = (
        'Quit' =>  '_quit',
    );

    my $method = $event_method{ $event->{name} };

    if ( defined $method ) {
        print "Event: $event->{name}\n" if $self->{EDEBUG};

        # call the corresponding method
        $self->$method();
    }

    #if we did not have a tick event then some other controller needs to do
    #something so game state is still beign process we cannot have new input
    #now
}

sub _quit {
    my $self = shift;
    $self->{keep_going} = 0;
}

1;

__END__

=head1 NAME

SDL::Tutorial::MoP::Controller::CPUSpinner

=head1 DESCRIPTION

The C<CPUSpinner> controller is the heartbeat of the game.

The game proceeds while C<keep_going> is set. When C<CPUSpinner>
receives a C<Quit> event, C<keep_going> is set to zero.

=head2 init

C<init> simply initializes C<keep_going>, so the game will start.

=head2 run

Produces a C<Tick> event while C<keep_going> is set.

=head2 notify

If this controller receives a C<Quit> event, C<keep_going> is
set to zero, stopping the game.

=head1 SEE ALSO

L<SDL::Tutorial::MoP::Controller>
