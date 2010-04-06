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

package My::Builder::Darwin;

use strict;
use warnings;
use Alien::SDL;
use Cwd;
use base 'My::Builder';

sub special_build_settings
{
	my $self = shift;
	$self->{c_source} = ['launcher.m'];
	$self->{c_sources} = 'MacOSX';
	$self->{install_base} = "SDLPerl.app/Contents/Resources";
}

sub build_bundle
{
	my $bundle_contents="SDLPerl.app/Contents";
	system "mkdir -p \"$bundle_contents\"";
	mkdir "$bundle_contents/MacOS",0755;
	my $cflags = Alien::SDL->config('cflags');
	chomp($cflags);
	$cflags .= ' ' . `$^X -MExtUtils::Embed -e ccopts`;
	chomp($cflags);
	my $libs = Alien::SDL->config('libs');
	chomp($libs);
	$libs .= ' ' . `$^X -MExtUtils::Embed -e ldopts`;
	chomp($libs);
	$libs =~ s/-lSDLmain//g;
	print STDERR "gcc $cflags MacOSX/launcher.m $libs -framework Cocoa -o \"$bundle_contents/MacOS/SDLPerl\"";
	print STDERR `gcc $cflags MacOSX/launcher.m $libs -framework Cocoa -o \"$bundle_contents/MacOS/SDLPerl\"`;
	mkdir "$bundle_contents/Resources",0755;
	system "echo \"APPL????\" > \"$bundle_contents/PkgInfo\"";
	system "cp MacOSX/Info.plist \"$bundle_contents/\"";
	system "cp \"MacOSX/SDLPerl.icns\" \"$bundle_contents/Resources\"";
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

sub build_test
{
      my $self = shift;
      $self->build_bundle() if !(-d getcwd().'/SDLPerl.app');
      my $cmd = './SDLPerl.app/Contents/MacOS/SDLPerl '.getcwd().'/Build test';
      if($ENV{SDL_PERL_TEST}) {
          $self->Module::Build::ACTION_test;
	  $ENV{SDL_PERL_TEST} = 0; #unset it again
      } else {
          $ENV{SDL_PERL_TEST} = 1;
          system ( split ' ', $cmd );
         die 'Errors in Testing. Can\'t continue' if $?;
      }
}

1;
