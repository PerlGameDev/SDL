#!/usr/bin/env perl
#
# Build.pm
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig@cpan.org>
#
# ------------------------------------------------------------------------------
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ------------------------------------------------------------------------------
#
# Please feel free to send questions, suggestions or improvements to:
#
#	David J. Goehrig
#	dgoehrig@cpan.org
#

package My::Builder;

use strict;
use warnings;
use base 'Module::Build';

use Carp;
use File::Spec;
use Config;

# Module::Build doesn't seem to have a way to use separate flags for separate
# XS files, so here's the override that makes separate files build correctly:
sub process_xs
{
	my ($self, $file) = @_;

	#TODO: call this in MSWin32::process_xs
	$file =~ s/\\/\//g if( $^O eq 'MSWin32' );

	my $properties                   = $self->{properties};
	my $file_args                    = $self->notes( 'file_flags' )->{$file};

	my @old_values                   = @$properties{ keys %$file_args };
	@$properties{ keys %$file_args } = values %$file_args;

	$self->SUPER::process_xs( $file );
	@$properties{ keys %$file_args } = @old_values;
}

# which headers are installed?
sub find_subsystems
{
	my ($self, $subsystems, $libraries) = @_;
	my %found;
	my %enabled;
	while ( my ($name, $subsystem) = each %$subsystems )
	{
		for my $library (@{ $subsystem->{libraries} })
		{
			my $lib = $libraries->{$library}
				or croak "Unknown library '$library' for '$name'\n";
			unless (defined($found{$lib->{header}})) {
				$found{$lib->{header}} = Alien::SDL->check_header($lib->{header}) ? 1 : 0;
			}
			$enabled{$name}{$library} = 1 if $found{$lib->{header}};
		}
	}
	return \%enabled;
}

# set the define flags and flags for the libraries we have
sub set_build_opts
{
	my $self = shift;
	my $libraries = $self->notes('libraries');
	my $build_systems = $self->notes('build_systems');
	my %defines;
	my %links;

	while (my ($subsystem, $buildable) = each %$build_systems)
	{
		for my $build (grep { $buildable->{ $_ } } keys %$buildable)
		{
			push @{ $defines{$subsystem} }, "-D$libraries->{$build}{define}";
                        push @{ $links{$subsystem} }, "-l$libraries->{$build}{lib}";
		}
	}

	$self->notes('defines' => \%defines);
	$self->notes('links' => \%links);
}

# save this all in a format process_xs() can understand
sub set_file_flags
{
	my $self = shift;
	my %file_flags;

	while (my ($subsystem, $buildable) = each %{$self->notes('build_systems')} )
	{
		my $sub_file = $self->notes('subsystems')->{$subsystem}{file}{to};
		$file_flags{$sub_file} = {
			extra_compiler_flags =>
			[
				(split(' ', $self->notes('sdl_cflags'))),
				@{$self->notes('defines')->{$subsystem}},
				( defined $Config{usethreads} ? ('-DUSE_THREADS', '-fPIC') : ('-fPIC' )),
			],
			extra_linker_flags =>
			[
				(split(' ', $self->notes('sdl_libs'))),
				@{$self->notes('links')->{$subsystem}},
			],
		},
	}

	$self->notes('file_flags' => \%file_flags);
}

# override the following functions in My::Builder::<platform> if necessary
# both special to MacOS/Darwin, somebody should review whether it is still necessary
# xxx TODO xxx
sub special_build_settings { }
sub build_bundle { }

# build_bundle() currently defined only for MacOS
sub ACTION_bundle
{
	my ($self) = @_;
	$self->depends_on('build');
	$self->build_bundle();
}

# Override Install method for darwin
sub ACTION_install {
	my ($self) = @_;
	require ExtUtils::Install;
	$self->depends_on('build');
	ExtUtils::Install::install($self->install_map, 1, 0, $self->{args}{uninst}||0);
}

1;
