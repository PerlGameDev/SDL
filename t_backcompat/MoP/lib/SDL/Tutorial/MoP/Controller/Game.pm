package SDL::Tutorial::MoP::Controller::Game;

use strict;
use warnings;

use base 'SDL::Tutorial::MoP::Base';

use Data::Dumper;
use Time::HiRes qw/time/;
use Readonly;

use SDL::Tutorial::MoP::Model::Map;
#use SDL::Tutorial::MoP::Model::Pieces;

Readonly my $STATE_PREPARING => 0;
Readonly my $STATE_RUNNING   => 1;
Readonly my $STATE_PAUSED    => 2;

sub init
{
    my $self = shift;

    $self->{level} = 0.5;
    $self->{state} = $STATE_PREPARING;

    print "Game PREPARING ... \n" if $self->{GDEBUG};

    $self->_init_map;
    $self->evt_manager->post({name => 'MapBuilt', 'map' => $self->{'map'}});

    #$self->{player} =; For points, level so on
}

sub notify
{
    my ($self, $event) = (@_);

    return if $event->{name} eq 'MapBuilt';

    print "Notify in GAME \n" if $self->{EDEBUG};

    my $state = $self->{state};

    my %event_method = (
        $STATE_PREPARING => {
            '*' => '_start',
        },
        $STATE_RUNNING   => {
            'CharactorMoveRequest' => '_charactor_move_request',
            'Tick'                 => '_tick',
        },
    );

    my $method = $event_method{$state}{$event->{name}} || $event_method{$state}{'*'};

    if ( defined $method ) {
        # call the event
        $self->$method($event);
    }

    #if we did not have a tick event then some other controller needs to do
    #something so game state is still beign process we cannot have new input
    #now
}

sub _charactor_move_request
{
    my ($self, $event) = @_;

    print "Move charactor sprite \n" if $self->{GDEBUG};
    my ($mx, $my, $rot) = ($self->{posx}, $self->{posy}, $self->{pieceRotation});

    my %action_direction = (
        'ROTATE_C'        => sub { $rot++; $rot = $rot % 4; },
        'ROTATE_CC'       => sub { $rot--; $rot = $rot % 4; },
        'DIRECTION_DOWN'  => sub { $my++;                   },
        'DIRECTION_LEFT'  => sub { $mx--;                   },
        'DIRECTION_RIGHT' => sub { $mx++;                   },
    );

    my $action = $action_direction{ $event->{direction} };
    if (defined $action) {
        # do it
        $action->();
    }

#    if ($self->{grid}->is_possible_movement($mx, $my, $self->{piece}, $rot)) {
#        ($self->{posx}, $self->{posy}, $self->{pieceRotation}) = ($mx, $my, $rot);
#        $self->evt_manager->post({name => 'CharactorMove'});
#    }
}

sub _tick
{
    my ($self, $event) = @_;

    return if (time - $self->{wait}) < $self->{level};

    $self->{wait} = time;

#    if ($self->{grid}->is_possible_movement($self->{posx}, $self->{posy} + 1, $self->{piece}, $self->{pieceRotation})) {
#        $self->{posy}++;
#        $self->evt_manager->post({name => 'CharactorMove'});
#    }
#    else {

#        $self->{grid}->store_piece($self->{posx}, $self->{posy}, $self->{piece}, $self->{pieceRotation});
#        $self->_create_new_piece();

#        $self->{level} -= (0.01) * $self->{grid}->delete_possible_lines;
#        if ($self->{grid}->is_game_over()) {

#            #make GameOver
#            $self->evt_manager->post({name => 'Quit'});
#        }
#    }
}

sub _start
{
    my $self = shift;

    $self->{state} = $STATE_RUNNING;
    print "Game RUNNING \n" if $self->{GDEBUG};
    $self->evt_manager->post({ name => 'GameStart', game => $self });
    $self->{wait} = time;
}

sub _init_map
{
    my $self = shift;
    $self->{'map'} = SDL::Tutorial::MoP::Model::Map->new();

#    ($self->{piece},$self->{pieceRotation}) = SDL::Tutorial::MoP::Model::Pieces->random();
#    my ($x,$y) = SDL::Tutorial::MoP::Model::Pieces->init_xy($self->{piece}, $self->{pieceRotation});

#    $self->{posx} = $self->{grid}->{width} / 2 + $x;
#    $self->{posy} = $y;

#    ($self->{next_piece}, $self->{next_rotation}) = SDL::Tutorial::MoP::Model::Pieces->random();
#    $self->{next_posx}     = ($self->{grid}->{width}) + 1;
#    $self->{next_posy}     = 0;
}

sub _create_new_piece
{
    my $self = shift;
    $self->{piece}         = $self->{next_piece};
    $self->{pieceRotation} = $self->{next_rotation};

    my ($x,$y) = SDL::Tutorial::MoP::Model::Pieces->init_xy($self->{piece}, $self->{pieceRotation});

    $self->{posx} = $self->{grid}->{width} / 2 + $x;
    $self->{posy} = $y;

    #     //  Next piece
    ($self->{next_piece}, $self->{next_rotation}) = SDL::Tutorial::MoP::Model::Pieces->random();
}

1;

__END__

=head1 NAME

SDL::Tutorial::MoP::Controller::Game

=head1 DESCRIPTION

The C<Game> controller

=head2 init

Initialize game variables, like level and state.

=head2 notify
