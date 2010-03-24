package SDL::Tutorial::MoP::Base;

use strict;
use warnings;
use Carp;

use SDL::Tutorial::MoP::EventManager;

our $VERSION = '0.01';

# all the classes will also inherit the evt_manager,
# so we won't have to pass it around everywhere
my $evt_manager = SDL::Tutorial::MoP::EventManager->new();
sub evt_manager { $evt_manager }

sub new 
{
    my ($class, %params) = (@_);

    my $self = bless {%params}, $class;

    # all controllers must register a listener
    $self->evt_manager->reg_listener($self);

    $self->init(%params) if $self->can('init');

    return $self;
}

1;

__END__

=head1 NAME

SDL::Tutorial::MoP::Base - base class

=head1 DESCRIPTION

This is the base class for most of the game objects. We put in this class
all the information that we want to be visible across the game:

=head2 Event Manager

=head1 SEE ALSO

L<SDL::Tutorial::MoP::EventManager>

=head1 AUTHOR

    Kartik Thakore
    CPAN ID: KTHAKORE
    kthakore@CPAN.org
    http://yapgh.blogspot.com

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).
