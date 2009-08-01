#
# Copyright (C) 2004 chromatic
# Copyright (C) 2004 David J. Goehrig
#

package SDL::Build;

use strict;
use base 'Module::Build';

use File::Spec;
use Data::Dumper;
use Config;

# Module::Build doesn't seem to have a way to use separate flags for separate
# XS files, so here's the override that makes separate files build correctly:
sub process_xs
{
	my ($self, $file) = @_;

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

	require $modpath or die "No module for $os platform\n";

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
				or die "Unknown library '$library' for '$name'\n";

			my ($inc_dir, $link_dir)   =
				$self->find_header( $lib->{header}, \%includes_libs );
			$enabled{$name}{ $library } = $inc_dir ? [ $inc_dir, $link_dir ]
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

	while (my ($subsystem, $buildable) = each %$build_systems)
	{
		my %sub_links;
		for my $build (grep { $buildable->{ $_ } } keys %$buildable)
		{
			$sub_links{ $buildable->{ $build }[1] }++;
			push @{ $links{ $subsystem }{libs} }, "-l$build";
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
		my $sub_includes = join(' ', @{ $includes->{$subsystem} } );

		$file_flags{ $sub_file } = 
		{
			extra_compiler_flags =>
			[
				@{ $includes->{$subsystem} },
				split(' ',$sdl_compile),
				@{ $defines->{$subsystem} },
				( defined $Config{usethreads} ? ('-DUSE_THREADS', '-fPIC') : '-fPIC' ),
			],
			extra_linker_flags => 
			[
				@{ $links->{$subsystem}{paths} },
				split(' ',$sdl_link),
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

	open my $file, '>', $path or die "Cannot write to '$path': $!\n";
	print $file $text;
}

1;
