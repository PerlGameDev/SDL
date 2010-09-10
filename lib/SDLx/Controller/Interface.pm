package SDLx::Controller::Interface;
use strict;
use warnings;
use Carp qw/confess/;

our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;


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
	my $move = sub { $self->update( $_[1], $_[0] ) };
	$controller->add_move_handler($move);

	if ($render) {
		my $show = sub { my $state = $self->interpolate( $_[0] ); $render->( $state, @params ); };
		$controller->add_show_handler($show);
	} else {
		Carp::confess "Render callback not provided";

	}
}

internal_load_dlls(__PACKAGE__);
bootstrap SDLx::Controller::Interface;


1;
