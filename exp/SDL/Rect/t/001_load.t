# -*- perl -*-

# t/001_load.t - check module loading and create testing directory
no AutoLoader;

use Test::More tests => 6;

BEGIN { use_ok( 'SDL::Rect' ); }

my $object = SDL::Rect->new();
isa_ok ($object, 'SDL::Rect');

$object->SetRect(0,1,2,2);
is($object->RectX, 0 , "RectX checks: x=".$object->RectX );
is($object->RectY, 1,  "RectY checks: y=".$object->RectY );
is($object->RectW, 2,  "RectW checks: w=".$object->RectW );
is($object->RectH, 2,  "RectH checks: h=".$object->RectH );

 
