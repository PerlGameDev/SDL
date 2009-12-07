#!perl
use strict;
use warnings;
use Test::More;
use SDL;


# Don't run tests for installs
use Test::More;
unless ( $ENV{AUTOMATED_TESTING} or $ENV{RELEASE_TESTING} ) {
	plan( skip_all => "Author tests not required for installation" );
}

sub overlay_leak()
{

SDL::Init(SDL_INIT_VIDEO);

my $display = SDL::SetVideoMode(640,480,32, SDL_SWSURFACE );

my $overlay = SDL::Overlay->new( 100, 100, SDL_YV12_OVERLAY, $display);

$overlay = undef;

$display = undef;

}


eval 'use Test::Valgrind';
plan skip_all => 'Test::Valgrind is required to test your distribution with valgrind' if $@;

overlay_leak();


sleep(2);
