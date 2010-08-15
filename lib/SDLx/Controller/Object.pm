package SDLx::Controller::Object;
use strict;
use warnings;

our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;


sub new { 
	shift;
	my %foo = @_;

	my @args;
	push @args, ($foo{x} || 0);
	push @args, ($foo{y} || 0);
	push @args, ($foo{v_x} || 0);
	push @args, ($foo{v_y} || 0);
	push @args, ($foo{rot} || 0);
	push @args, ($foo{ang_v} || 0);

	return SDLx::Controller::Object->make(@args);
};

internal_load_dlls(__PACKAGE__);
bootstrap SDLx::Controller::Object;


1;
