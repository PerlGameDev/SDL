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
	my $cflags = Alien::SDL->config('cflags');
	chomp($cflags);
	$cflags .= ' ' . `$^X -MExtUtils::Embed -e ccopts`;
	chomp($cflags);
	my $libs = Alien::SDL->config('libs');
	chomp($libs);
	$libs .= ' ' . `$^X -MExtUtils::Embed -e ldopts`;
	chomp($libs);
	$libs =~ s/-lSDLmain//g;
	my $cmd = "gcc $cflags $libs MacOSX/main.c  -o \"$bundle_contents/MacOS/SDLPerl\"";
	print STDERR $cmd;
	system ($cmd);
#	my $rez = "/Developer/Tools/Rez -d __DARWIN__ -useDF -o $bundle_content/Resources/SDLPerl.rsrc $(ARCH_FLAGS) SDLPerl.r
#	/Developer/Tools/ResMerger -dstIs DF $bundle_content/Resources/SDLPerl.rsrc -o $@"
	mkdir "$bundle_contents/Resources",0755;
	print
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
