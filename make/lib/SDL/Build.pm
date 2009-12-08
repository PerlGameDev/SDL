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

package SDL::Build;

use strict;
use warnings;
use Carp;
use base 'Module::Build';

use File::Spec;
use Data::Dumper;
use Config;

# Module::Build doesn't seem to have a way to use separate flags for separate
# XS files, so here's the override that makes separate files build correctly:
sub process_xs
{
	my ($self, $file) = @_;
	
	#TODO: call this in MSWin32::process_xs
	$file =~ s/\\/\//g if( $^O =~ /MSWin.*/ );

	my $properties                   = $self->{properties};
	my $file_args                    = $self->notes( 'file_flags' )->{$file};
	my @old_values                   = @$properties{ keys %$file_args };
	@$properties{ keys %$file_args } = values %$file_args;

	$self->SUPER::process_xs( $file );
	@$properties{ keys %$file_args } = @old_values;
}


# every platform has slightly different library and header paths
sub get_arch
{
	my ($self, $os)   = @_;
	my $modpath       = File::Spec->catfile(
		'SDL', 'Build', ucfirst( $os ) . '.pm' );
	my $module        = 'SDL::Build::' . ucfirst( $os );

	require $modpath or croak "No module for $os platform\n";

	return $module;
}

# which headers are installed?
sub find_subsystems
{
	my ($self, $subsystems, $libraries) = @_;
	my %includes_libs                   = $self->fetch_includes();
	my %enabled;

	while ( my ($name, $subsystem) = each %$subsystems )
	{
		for my $library (@{ $subsystem->{libraries} })
		{
			my $lib = $libraries->{$library}
				or croak "Unknown library '$library' for '$name'\n";

			my ($inc_dir, $link_dir)    = $self->find_header( $lib->{header}, \%includes_libs );
			$enabled{$name}{ $library } = $inc_dir
			                            ? [ $inc_dir, $link_dir ]
				                        : 0;
		}
	}

	return \%enabled;
}

# set the define flags for the libraries we have
sub build_defines
{
	my ($self, $libraries, $build_systems) = @_;

	my %defines;

	while (my ($subsystem, $buildable) = each %$build_systems)
	{
		for my $build (grep { $buildable->{ $_ } } keys %$buildable)
		{
			push @{ $defines{ $subsystem } }, "-D$libraries->{$build}{define}";
		}
	}

	return \%defines;
}

# set the include paths for the libraries we have
sub build_includes
{
	my ($self, $libraries, $build_systems) = @_;

	my %includes;

	while (my ($subsystem, $buildable) = each %$build_systems)
	{
		my %sub_include;
		for my $build (grep { $buildable->{ $_ } } keys %$buildable)
		{
			$sub_include{ $buildable->{ $build }[0] }++;
		}

		$includes{ $subsystem } = [ map { "-I$_" } keys %sub_include ];
	}

	return \%includes;
}

# set the linker paths and flags for the libraries we have
sub build_links
{
	my ($self, $libraries, $build_systems) = @_;

	my %links;
	my %replace = (
		'SDL_gfx_blitfunc'    => 'SDL_gfx',
		'SDL_gfx_framerate'   => 'SDL_gfx',
		'SDL_gfx_imagefilter' => 'SDL_gfx',
		'SDL_gfx_primitives'  => 'SDL_gfx',
		'SDL_gfx_rotozoom'    => 'SDL_gfx',
    );

	while (my ($subsystem, $buildable) = each %$build_systems)
	{
		my %sub_links;
		for my $build (grep { $buildable->{ $_ } } keys %$buildable)
		{
			$sub_links{ $buildable->{ $build }[1] }++;
			my $newbuild = $replace{$build} || $build;
			push @{ $links{ $subsystem }{libs} }, "-l$newbuild";
		}

		$links{ $subsystem }{paths} = [ map { "-L$_" } keys %sub_links ];
	}
	return \%links;
}

# save this all in a format process_xs() can understand
sub set_flags
{
	my ($self, $subsystems, $build, $defines, $includes, $links,
	    $sdl_compile, $sdl_link) = @_;
	my %file_flags;
	while (my ($subsystem, $buildable) = each %$build)
	{
		my $sub_file     = $subsystems->{$subsystem}{file}{to};

		$file_flags{ $sub_file } = 
		{
			extra_compiler_flags =>
			[
				@{ $includes->{$subsystem} },
				(split(' ',$sdl_compile)),
				@{ $defines->{$subsystem} },
				( defined $Config{usethreads} ? ('-DUSE_THREADS', '-fPIC') : ('-fPIC' )),
			],
			extra_linker_flags => 
			[
				@{ $links->{$subsystem}{paths} },
				(split(' ',$sdl_link)),
				@{ $links->{$subsystem}{libs} },
			],
		},
	}

	$self->notes( 'file_flags' => \%file_flags );
}

# look for a header somewhere on the system
sub find_header
{
	my ($self, $header, $includes) = @_;

	for my $inc_dir (keys %$includes)
	{
		next unless -e File::Spec->catfile( $inc_dir, $header );
		return ($inc_dir, $includes->{$inc_dir});
	}

	print STDERR "Warning: header file '$header' not found.\n";
	return;
}

sub write_sdl_config
{
	my ($self, $config) = @_;
	my $path            = File::Spec->catfile(qw( lib SDL Config.pm ));
	my $dd              = Data::Dumper->new( [ $config ], [ 'sdl_config' ] );
	my $hash            = $dd->Dump();
	(my $text           = <<'	END_HEADER' . $hash . <<'	END_FOOTER');
	package SDL::Config;

	my $sdl_config; 
	END_HEADER

	sub has
	{
		my ($class, $define) = @_;
		scalar grep { $$sdl_config{$_}{$define} } keys %$sdl_config;
	}

	1;
	END_FOOTER

	$text =~ s/^\t//gm;

	open my $file, '>', $path or croak "Cannot write to '$path': $!\n";
	print $file $text;
}



# Subclass  Darwin to build Objective-C addons

sub filter_support {
	my $self = shift;
	print STDERR "[SDL::Build] generic filter\n";
	return ();
}

sub process_support_files {
	my $self = shift;
	my $p = $self->{properties};
	return unless $p->{c_source};
	return unless $p->{c_sources};

	push @{$p->{include_dirs}}, $p->{c_source};
	unless ( $p->{extra_compiler_flags} && $p->{extra_compiler_flags} =~ /DARCHNAME/) {
		$p->{extra_compiler_flags} .=  " -DARCHNAME=" . $self->{config}{archname};
	}
	print STDERR "[SDL::Build] extra compiler flags" . $p->{extra_compiler_flags} . "\n";

	foreach my $file (map($p->{c_source} . "/$_", @{$p->{c_sources}})) {
		push @{$p->{objects}}, $self->compile_c($file);
	}
}

# get link flags with a given a sdl_dir
sub alt_link_flags
{
	my $self = shift;
	my $sdl_dir = shift;

	return '-L"'.$sdl_dir.'\lib"';
}

# get compile flags with a given a sdl_dir
sub alt_compile_flags
{
	 my $self = shift;
	 my $sdl_dir = shift;

	 return '-I"'.$sdl_dir.'\include\SDL"';	
}

# Override to create a MacOS Bundle
sub ACTION_bundle
{
	my ($self) = @_;
	$self->depends_on('build');
	$self->get_arch($^O)->build_bundle();
}

# Override Install method for darwin
sub ACTION_install {
  my ($self) = @_;
  require ExtUtils::Install;
  $self->depends_on('build');
  ExtUtils::Install::install($self->install_map, 1, 0, $self->{args}{uninst}||0);
}

1;
