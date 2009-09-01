# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'SDL::Rect' ); }

my $object = SDL::Rect::NewRect(0,0,0,0);
isa_ok ($object, 'SDL::Rect');


