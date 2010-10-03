package SDLx::Controller::Interface;
use strict;
use warnings;
use Carp qw/confess/;
use Scalar::Util 'refaddr';

our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;

my %_controller;

sub new {
	shift;
	my %foo = @_;

	my @args;
	push @args, ( $foo{x}     || 0 );
	push @args, ( $foo{y}     || 0 );
	push @args, ( $foo{v_x}   || 0 );
	push @args, ( $foo{v_y}   || 0 );
	push @args, ( $foo{rot}   || 0 );
	push @args, ( $foo{ang_v} || 0 );

	return SDLx::Controller::Interface->make(@args);
}


sub attach {
	my ( $self, $controller, $render, @params ) = @_;

	Carp::confess "An SDLx::Controller is needed" unless $controller && $controller->isa('SDLx::Controller');

        $_controller{ refaddr $self } = [ $controller ];
	my $move = sub { $self->update( $_[2], $_[1]->dt )};
	$_controller{ refaddr $self }->[1] = $controller->add_move_handler($move);

	if ($render) {
		my $show = sub { my $state = $self->interpolate( $_[0] ); $render->( $state, @params ); };
		$_controller{ refaddr $self }->[2] = $controller->add_show_handler($show);
	} else {
		Carp::confess "Render callback not provided";

	}
}

sub detach {
	my ( $self) = @_;
        my $controller = $_controller{ refaddr $self }; 
	return unless $controller;
	$controller->[0]->remove_move_handler($controller->[1]);
	$controller->[0]->remove_show_handler($controller->[2]);
}

internal_load_dlls(__PACKAGE__);
bootstrap SDLx::Controller::Interface;


1;
