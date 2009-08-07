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
	return (
	'/usr/local/include/SDL'   => '/usr/local/lib',
	'/usr/local/include'       => '/usr/local/lib',
	'/usr/local/include/smpeg' => '/usr/local/lib',
	'/usr/include/SDL'         => '/usr/lib',
	'/usr/include'             => '/usr/lib',
	'/usr/include/smpeg'       => '/usr/lib',
	'/usr/local/include/GL'    => '/usr/local/lib',
	'/usr/local/include/gl'    => '/usr/local/lib',
	'/usr/include/GL'          => '/usr/lib', 
	'/usr/include/gl'          => '/usr/lib', 
	'/opt/local/include/SDL'   => '/opt/local/lib',		# Mac Ports
	'/opt/local/include'   => '/opt/local/lib',		# Mac Ports

	'/System/Library/Frameworks/SDL_mixer.framework/Headers'     => '../../lib',
	'/System/Library/Frameworks/SDL_image.framework/Headers'     => '../../lib',
	'/System/Library/Frameworks/SDL_ttf.framework/Headers'       => '../../lib',
	'/System/Library/Frameworks/libogg.framework/Headers'        => '../../lib',
	'/System/Library/Frameworks/libvorbis.framework/Headers'     => '../../lib',
	'/System/Library/Frameworks/libvorbisfile.framework/Headers' => '../../lib',
	'/System/Library/Frameworks/libvorbisenc.framework/Headers'  => '../../lib',
	'../../include'                                              => '../../lib',
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
