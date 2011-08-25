#!/usr/bin/env perl
package My::Builder::Darwin;

use strict;
use warnings;
use Alien::SDL;
use File::Find qw(find);
use Data::Dumper;
use Cwd;
use Config;
use File::Copy;
use base 'My::Builder';

sub special_build_settings {
    my $self = shift;
    $self->{c_source}     = [ 'src', 'main.c' ];
    $self->{c_sources}    = 'MacOSX';
    $self->{install_base} = "SDLPerl.app/Contents/Resources";
}

sub build_bundle {
    my $self = shift;

    system "mkdir -p blib/script";
    my $Perl = ( $ENV{'FULLPERL'} or $^X or 'perl' );
    my $cflags =
      `$Perl -MExtUtils::Embed -e ccopts` . ' ' . Alien::SDL->config('cflags');
    my $libs =
        `$Perl -MExtUtils::Embed -e ldopts` . ' '
      . Alien::SDL->config('libs')
      . ' -lSDLmain';
    my $arch    = '';
    my $sdl_lib = '';
    $sdl_lib =
         Alien::SDL->config('ld_shlib_map')
      && Alien::SDL->config('ld_shlib_map')->{SDL}
      ? Alien::SDL->config('ld_shlib_map')->{SDL}
      : _find_SDL_lib();
    $arch = $1 if $sdl_lib && `lipo -info $sdl_lib` =~ m/\s(\w+)s*$/;
    $arch = $ENV{SDL_ARCH} if $ENV{SDL_ARCH};

    if ($arch) {
        $cflags =~ s/\b-arch \w+\s//g;
        $libs   =~ s/\b-arch \w+\s//g;
        $arch = "-arch $arch";
    }

    my $cmd =
      "gcc $arch -o \"blib/script/SDLPerl\" MacOSX/main.c $cflags $libs";
    $cmd =~ s/\s+/ /g;
    print STDERR $cmd . "\n";
    system($cmd);
}

sub ACTION_test {
    my $self = shift;
    $self->build_bundle() if !( -d getcwd() . '/blib/script/SDLPerl' );
    my $cmd =
      getcwd().'/blib/script/SDLPerl ' . getcwd() . '/Build test';
    if ( $ENV{SDL_PERL_TEST} ) {
        $self->Module::Build::ACTION_test;
        $ENV{SDL_PERL_TEST} = 0;    #unset it again
    }
    else {
        $ENV{SDL_PERL_TEST} = 1;
        system( split ' ', $cmd );
        die 'Errors in Testing. Can\'t continue' if $?;
    }
}

sub _find_SDL_lib {
    my $inc_lib_candidates = {
        '/usr/local/include' => '/usr/local/lib',
        '/usr/include'       => '/usr/lib',
        '/usr/X11R6/include' => '/usr/X11R6/lib',
    };

    if ( -e '/usr/lib64' && $Config{'myarchname'} =~ /64/ ) {
        $inc_lib_candidates->{'/usr/include'} = '/usr/lib64';
    }

    if ( exists $ENV{SDL_LIB} && exists $ENV{SDL_INC} ) {
        $inc_lib_candidates->{ $ENV{SDL_INC} } = $ENV{SDL_LIB};
    }

    foreach ( keys %$inc_lib_candidates ) {
        my $ld = $inc_lib_candidates->{$_};
        next unless -d $ld;
        my ($found_lib) = _find_file( $ld,
            qr/[\/\\]lib\QSDLmain\E[\-\d\.]*\.(so|dylib|bundle[\d\.]*|a|dll.a)$/
        );
        return $found_lib if $found_lib;
    }

    return 0;
}

sub _find_file {
    my ( $dir, $re ) = @_;
    my @files;
    $re ||= qr/.*/;
    {

#hide warning "Can't opendir(...): Permission denied - fix for http://rt.cpan.org/Public/Bug/Display.html?id=57232
        no warnings;
        find(
            {
                wanted => sub { push @files, rel2abs($_) if /$re/ },
                follow => 1,
                no_chdir    => 1,
                follow_skip => 2
            },
            $dir
        );
    };
    return @files;
}

1;
