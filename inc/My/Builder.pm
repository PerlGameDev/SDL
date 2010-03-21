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

	return unless defined($file_args);

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
		my $param;
		for my $library (@{ $subsystem->{libraries} })
		{
			my $lib = $libraries->{$library}
				or croak "Unknown library '$library' for '$name'\n";
			my $h = ref($lib->{header}) eq 'ARRAY' ? $lib->{header} : [ $lib->{header} ];
			my $need_check = 0;
			foreach (@$h) {
				$need_check = 1 unless $found{$_};
			}			
			if ( !$need_check || Alien::SDL->check_header(@$h)) {
				$found{$_} = 1 foreach (@$h);
				$param->{libs}->{$library} = 1;
				push @{ $param->{defines} }, "-D$libraries->{$library}{define}";
				push @{ $param->{links} }, "-l$libraries->{$library}{lib}";
			}
			else {
				# I disabled that, so the libs are compiled but the HAVE_* defines are not set
				# so we can e.g. 'use SDL::Pango;' (FROGGS)
				# $param = undef;
				
				print "###WARNING### Disabling subsystem '$name'\n";
				last;
			}
		}
		$enabled{$name} = $param if $param;
	}
	return \%enabled;
}

# create mapping table: { SDL::Any::Lib => [ list of libs ], SDL::Any::OtherLib => [ list of libs ] ... }
# to keep information what libs (.dll|.so) to load via Dynaloader for which module
sub translate_table
{
	my ($self, $subsystems, $libraries) = @_;
	my %ret;
	foreach my $m (keys %$subsystems) {
		my $p = $subsystems->{$m}->{file}->{to};
		$p =~ s|^lib/(.*)\.xs|$1|;
		$p =~ s|/|::|g;
		my @list = map ( $libraries->{$_}->{lib}, @{$subsystems->{$m}->{libraries}});
		$ret{$p} = \@list;
	}
	return \%ret;
}

# save this all in a format process_xs() can understand
sub set_file_flags
{
	my $self = shift;
	my %file_flags;
	my %build_systems = %{$self->notes('build_systems')};

	while (my ($subsystem, $param) = each %build_systems )
	{
		my $sub_file = $self->notes('subsystems')->{$subsystem}{file}{to};
		$file_flags{$sub_file} = {
			extra_compiler_flags =>
			[
				(split(' ', $self->notes('sdl_cflags'))),
				@{$param->{defines}},
				( defined $Config{usethreads} ? ('-DUSE_THREADS', '-fPIC') : ('-fPIC' )),
			],
			extra_linker_flags =>
			[
				(split(' ', $self->notes('sdl_libs'))),
				@{$param->{links}},
			],
		},
	}
	$self->notes('file_flags' => \%file_flags);
}

# override the following functions in My::Builder::<platform> if necessary
# both special to MacOS/Darwin, somebody should review whether it is still necessary
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
