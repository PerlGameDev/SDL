#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;
use SDL::Version;
use SDL::Image;
use SDL::RWOps;

use Test::More;
use lib 't/lib';
use SDL::TestTool;
if( !SDL::TestTool->init(SDL_INIT_VIDEO) )
{
    plan( skip_all => 'Failed to init video' );
}
elsif( !SDL::Config->has('SDL_image') )
{
    plan( skip_all => 'SDL_image support not compiled' );
}


my @done = qw/
linked_version
init
quit
/;

my $lver = SDL::Image::linked_version();

isa_ok($lver, "SDL::Version", '[linked_version] got version back!' );

diag ( 'Found version ('.$lver->major.'.'.$lver->minor.'.'.$lver->patch.')');

isa_ok( SDL::Image::load("test/data/highlight.png"), "SDL::Surface", "[load] Gets Surface"); 

my $file = SDL::RWOps->new_file("test/data/logo.png", "rb");

isa_ok (SDL::Image::load_rw($file, 1), "SDL::Surface", "[load_rw] Gets surface");

my $file2 = SDL::RWOps->new_file("test/data/menu.png", "rb");


isa_ok (SDL::Image::loadtyped_rw($file2, 0, "PNG"), "SDL::Surface", "[loadtyped_rw] Makes surface from png");


#need to get DEFINES to SDL::Image::Constants;
#IMG_INIT_JPG =?o
# IMG_INIT_JPG = 0x00000001,
# IMG_INIT_PNG = 0x00000002,
# IMG_INIT_TIF = 0x00000004  
SKIP:
{
	skip ' This is only for version >= 1.2.10', 1 unless !( $lver->major == 1 && $lver->minor ==2 &&  $lver->patch < 10);
	is (SDL::Image::init( 0x00000001 ), 0 , '[init] Inited jpg');
#	SDL::Image::quit();
	# 	pass '[quit] we can quit fine';

}


my @left = qw/
get_error
set_error
is_RW
/;
my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    fail "Not Implmented $_" foreach(@left)
    
}
diag $why;

done_testing;
