package SDL::Tutorial::MoP::EventManager;

sub new {
    my ($class, %params) = @_;

    my $self = bless {%params}, $class;

    $self->{listeners} ||= {};
    $self->{evt_queue} ||= [];

    return $self;
}

sub listeners : lvalue 
{
    return shift->{listeners};
}

sub evt_queue : lvalue 
{
    return shift->{evt_queue};
}

sub reg_listener 
{
    my ($self, $listener) = (@_);
    $self->listeners->{$listener} = $listener
      if defined $listener;

    return $self->listeners->{$listener};
}

sub un_reg_listener 
{
    my ($self, $listener) = (@_);

    if (defined $listener) {
        return delete $self->listeners->{$listener};
    }
    else {
        return;
    }
}

sub post 
{
    my $self  = shift;
    my $event = shift;

    die "Post needs a Event as parameter" unless defined $event->{name};

    foreach my $listener (values %{$self->listeners}) 
    {
        $listener->notify($event);
    }
}

1;

__END__

=head1 DESCRIPTION

The C<EventManager> is responsible for sending events to
controllers, so they can trigger actions at specific times.

For instance, when you press a key, or the game ticks, it
is an event.

The C<EventManager> will contact all the controllers so they
can take the appropriate action.

=head2 reg_listener

Registers a listener that will be updated

=head2 un_reg_listener

UnRegisters a listerner

=head2 listeners

All listeners attached to this EventManager

=head2 evt_queue

The current evnets in queue

=head2 post

Send update signal to all Controllers
