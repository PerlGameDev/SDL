#!/usr/bin/env perl
package My::Builder::Darwin;

use strict;
use warnings;
use Alien::SDL;
use Cwd;
use base 'My::Builder';

sub special_build_settings
{
	my $self = shift;
	$self->{c_source} = ['src','main.c'];
	$self->{c_sources} = 'MacOSX';
	$self->{install_base} = "SDLPerl.app/Contents/Resources";
}

sub build_bundle
{
	my $bundle_contents="SDLPerl.app/Contents";
	system "mkdir -p \"$bundle_contents\"";
	mkdir "$bundle_contents/MacOS",0755;
	my $cflags ;#= Alien::SDL->config('cflags');
	$cflags = ' ' . `$^X -MExtUtils::Embed -e ccopts`;
	chomp($cflags);
	$cflags .= ' '.Alien::SDL->config('cflags');
	my $libs ; #= Alien::SDL->config('libs');
	$libs = ' ' . `$^X -MExtUtils::Embed -e ldopts`;
	chomp($libs);
	$libs .= ' '. Alien::SDL->config('libs').' -lSDLmain';
	chomp($libs);
	my $cmd = "gcc -o \"$bundle_contents/MacOS/SDLPerl\"  MacOSX/main.c $cflags $libs ";
	print STDERR $cmd."\n";
	system ($cmd);
#	my $rez = "/Developer/Tools/Rez -d __DARWIN__ -useDF -o $bundle_content/Resources/SDLPerl.rsrc $(ARCH_FLAGS) SDLPerl.r
#	/Developer/Tools/ResMerger -dstIs DF $bundle_content/Resources/SDLPerl.rsrc -o $@"
	mkdir "$bundle_contents/Resources",0755;
	system "echo \"APPL????\" > \"$bundle_contents/PkgInfo\"";
	system "cp MacOSX/Info.plist \"$bundle_contents/\"";
	system "cp \"MacOSX/SDLPerl.icns\" \"$bundle_contents/Resources\"";
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
