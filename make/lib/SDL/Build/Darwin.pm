#!/usr/bin/env perl
#
# Darwin.pm
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

package SDL::Build::Darwin;

use base 'SDL::Build';

sub fetch_includes
{
	use Config;

	my (@include_path, @lib_path);

	{
		my %seen;
		foreach (
			($Config{ccflags} =~ /-I(\S+)/g),
			($Config{cppflags} =~ /-I(\S+)/g),
		) {
			foreach my $sdl_lib_dir ($_, "$_/SDL") {
				next unless -f "$sdl_lib_dir/SDL.h";
				push @include_path, $sdl_lib_dir unless $seen{$sdl_lib_dir}++;
			}
		}
	}

	{
		my %seen;
		foreach (
			($Config{libpth} =~ /(\S+)/g),
			($Config{libsdirs} =~ /(\S+)/g),
			($Config{libspath} =~ /(\S+)/g),
			($Config{lddlflags} =~ /-I(\S+)/g),
			($Config{ldflags} =~ /-I(\S+)/g),
		) {
			next unless -f "$_/libSDL.a";
			push @lib_path, $_ unless $seen{$_}++;
		}
	}

	die "Can't find an SDL library" unless @include_path and @lib_path;
	warn "Found SDL headers in $include_path[0] and library in $lib_path[0]";

	return (
		$include_path[0] => $lib_path[0],

		# Local libraries.
		'/usr/local/include/smpeg' => '/usr/local/lib',
		'/usr/local/include/GL'    => '/usr/local/lib',
		'/usr/local/include/gl'    => '/usr/local/lib',

		# System libraries.
		'/usr/include/smpeg'       => '/usr/lib',
		'/usr/include/GL'          => '/usr/lib', 
		'/usr/include/gl'          => '/usr/lib', 

		# System-wide frameworks.
		'/System/Library/Frameworks/libogg.framework/Headers'        => '../../lib',
		'/System/Library/Frameworks/libvorbis.framework/Headers'     => '../../lib',
		'/System/Library/Frameworks/libvorbisfile.framework/Headers' => '../../lib',
		'/System/Library/Frameworks/libvorbisenc.framework/Headers'  => '../../lib',
		'/System/Library/Frameworks/OpenGL.framework/Headers'        => '/System/Library/Frameworks/OpenGL.framework/Libraries',

		# System libraries.
		'/System/Library/Frameworks/OpenGL.framework/Headers'        => '/System/Library/Frameworks/OpenGL.framework/Libraries',
	);
}

sub build_c_sources 
{
	return [qw/ 
		launcher.m
	/];
}

sub build_c_source
{
	return 'MacOSX';
}

sub build_install_base
{
	return "SDLPerl.app/Contents/Resources";	
}

sub build_bundle
{
	$bundle_contents="SDLPerl.app/Contents";
	system "mkdir -p \"$bundle_contents\"";
	mkdir "$bundle_contents/MacOS",0755;
	$cflags = `sdl-config --cflags`;
	chomp($cflags);
	$cflags .= ' ' . `perl -MExtUtils::Embed -e ccopts`;
	chomp($cflags);
	$libs = `sdl-config  --libs`;
	chomp($libs);
	$libs .= ' ' . `perl -MExtUtils::Embed -e ldopts`;
	chomp($libs);
	$libs =~ s/-lSDLmain//g;
	print STDERR "gcc $cflags MacOSX/launcher.m $libs -framework Cocoa -o \"$bundle_contents/MacOS/SDLPerl\"";
	print STDERR `gcc $cflags MacOSX/launcher.m $libs -framework Cocoa -o \"$bundle_contents/MacOS/SDLPerl\"`;
	mkdir "$bundle_contents/Resources",0755;
	system "echo \"APPL????\" > \"$bundle_contents/PkgInfo\"";
	system "cp MacOSX/Info.plist \"$bundle_contents/\"";
	system "cp \"MacOSX/SDLPerl.icns\" \"$bundle_contents/Resources\"";
}

1;
