# -*- perl -*-

# t/001_load.t - check module loading and create testing directory
no AutoLoader;

use Test::More tests => 6;

BEGIN { use_ok( 'SDL::Rect' ); }

my $object = SDL::Rect->new();
isa_ok ($object, 'SDL::Rect');

$object->SetRect(0,1,0,2);
is($object->RectX, 0 , "Rect X works: x=".$object->RectX );
is($object->RectY, 1,  "Rect X works: x=".$object->RectY );
is($object->RectW, 0,  "Rect X works: x=".$object->RectW );
is($object->RectH, 2,  "Rect X works: x=".$object->RectH );

 
