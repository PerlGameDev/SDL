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
use Alien::SDL::ConfigData;

# Module::Build doesn't seem to have a way to use separate flags for separate
# XS files, so here's the override that makes separate files build correctly:
sub process_xs {
	my ( $self, $file ) = @_;

	my $properties = $self->{properties};
	my $file_args  = $self->notes('file_flags')->{$file};

	return unless defined($file_args);

	my @old_values = @$properties{ keys %$file_args };
	@$properties{ keys %$file_args } = values %$file_args;

	$self->SUPER::process_xs($file);
	@$properties{ keys %$file_args } = @old_values;
}

# which headers are installed?
sub find_subsystems {
	my ( $self, $subsystems, $libraries ) = @_;
	my %found;
	my %enabled;
	while ( my ( $name, $subsystem ) = each %$subsystems ) {
		my $param;
		for my $library ( @{ $subsystem->{libraries} } ) {
			my $lib = $libraries->{$library}
				or Carp::confess "Unknown library '$library' for '$name'\n";
			my $h =
				ref( $lib->{header} ) eq 'ARRAY'
				? $lib->{header}
				: [ $lib->{header} ];
			my $need_check = 0;
			foreach (@$h) {
				$need_check = 1 unless $found{$_};
			}
			if ( !$need_check || Alien::SDL->check_header(@$h) ) {
				$found{$_} = 1 foreach (@$h);
				$param->{libs}->{$library} = 1;
				push @{ $param->{defines} }, "-D$libraries->{$library}{define}";
				push @{ $param->{links} },   "-l$libraries->{$library}{lib}";
			} else {

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
sub translate_table {
	my ( $self, $subsystems, $libraries ) = @_;
	my %ret;
	foreach my $m ( keys %$subsystems ) {
		my $p = $subsystems->{$m}->{file}->{to};
		$p =~ s|^lib/(.*)\.xs|$1|;
		$p =~ s|/|::|g;
		my @list =
			map ( $libraries->{$_}->{lib}, @{ $subsystems->{$m}->{libraries} } );
		$ret{$p} = \@list;
	}
	return \%ret;
}

# save this all in a format process_xs() can understand
sub set_file_flags {
	my $self = shift;
	my %file_flags;
	my %build_systems = %{ $self->notes('build_systems') };

	#TODO:  Search for execinfo.h signal.h and turn this on.
	#	This should also be turned on only during CPAN tests
	my $debug = ' -DNOSIGCATCH '; #default until headers found
	if ( Alien::SDL->check_header(qw(execinfo.h signal.h))
		&& $ENV{AUTOMATED_TESTING} )
	{
		$debug .= ' -g -rdynamic ' unless ( $^O =~ /(win|darwin|bsd)/i );

	} else {
		$debug .= ' -O2 ';
	}

	my $arch = ' ';
	$arch = '-arch' . $ENV{SDL_ARCH} if $ENV{SDL_ARCH};

	while ( my ( $subsystem, $param ) = each %build_systems ) {
		my $sub_file = $self->notes('subsystems')->{$subsystem}{file}{to};
		my $extra_compiler_flags = [
			( split( ' ', $arch . $debug . $self->notes('sdl_cflags') ) ),
			@{ $param->{defines} },
		];
		push(@{$extra_compiler_flags}, '-DUSE_THREADS') if defined $Config{usethreads};
		push(@{$extra_compiler_flags}, '-fPIC')         if $^O ne 'MSWin32';
		$file_flags{$sub_file} = {
			extra_compiler_flags => $extra_compiler_flags,
			extra_linker_flags => [
				( split( ' ', $self->notes('sdl_libs') ) ),
				@{ $param->{links} },
			],
		};
	}
	$self->notes( 'file_flags' => \%file_flags );
}

# override the following functions in My::Builder::<platform> if necessary
sub ACTION_build {
	my $self = shift;

	printf(
		"[Alien::SDL] Build option used:\n\t%s\n",
		${ Alien::SDL::ConfigData->config('build_params') }{'title'} || 'n.a.'
	);
	$self->SUPER::ACTION_build;
	$self->ACTION_bundle;
}

# both special to MacOS/Darwin, somebody should review whether it is still necessary
sub special_build_settings { }
sub build_bundle           { }

# build_bundle() currently defined only for MacOS
sub ACTION_bundle {
	my ($self) = @_;
	$self->depends_on('build');
	$self->build_bundle();
}

# inc/My/Darwin.pm will override Install method for MacOS
sub ACTION_install {
	my ($self) = @_;
	require ExtUtils::Install;
	$self->depends_on('build');
	ExtUtils::Install::install(
		$self->install_map, 1, 0,
		$self->{args}{uninst} || 0
	);
}

sub ACTION_test {
	my ($self) = @_;
	$self->depends_on('build');

	$self->SUPER::ACTION_test();
}

1;
