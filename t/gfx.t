#!perl
use strict;
use warnings;
use SDL;
use SDL::Config;
use SDL::Version;
use SDL::GFX;
use Test::More;

use lib 't/lib';
use SDL::TestTool;

if( !SDL::Config->has('SDL_gfx_primitives') )
{
    plan( skip_all => 'SDL_gfx support not compiled' );
}

my $v       = SDL::GFX::linked_version();
isa_ok($v, 'SDL::Version', '[linked_version]');
printf("got version: %d.%d.%d\n", $v->major, $v->minor, $v->patch);

pass 'Are we still alive? Checking for segfaults';

done_testing;
