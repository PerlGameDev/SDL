use strict;
use warnings;

use Test::More;
use parent qw/SDL::Surface SDLx::InsideOut/;

can_ok('SDLx::InsideOut', '_register');

my $obj = bless SDL::Surface->new(0, 1, 1, 8, 0, 0, 0, 0);
isa_ok($obj, 'main');
isa_ok($obj, 'SDL::Surface');
isa_ok($obj, 'SDLx::InsideOut');

is(scalar keys %SDLx::InsideOut::_, 0, 'nothing in idhash');

$obj->_register(cake => 2);

is(scalar keys %SDLx::InsideOut::_, 1, 'something made in idhash');
is(ref $SDLx::InsideOut::_{ $obj }, 'HASH', 'it\'s a hashref');

$obj->{foo}{bar} = 3;
$obj->{baz}[2] = 4;
$obj->{obj} = $obj;

is($obj->{cake}, 2, 'stored in hash');
is($obj->{foo}{bar}, 3, 'stored in hash of hash');
is($obj->{baz}[2], 4, 'stored in array of hash');
is(delete $obj->{obj}, $obj, 'stored an object in hash');
ok(!exists $obj->{obj}, 'deleted a value');

undef $obj;

is(scalar keys %SDLx::InsideOut::_, 0, 'value in idhash removed after object destroyed');

done_testing;
