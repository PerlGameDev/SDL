# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'SDL::Tutorial::MoP' ); }

my $object = SDL::Tutorial::MoP->new ();
isa_ok ($object, 'SDL::Tutorial::MoP');


