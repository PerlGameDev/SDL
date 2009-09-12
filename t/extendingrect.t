package MyRect;
use base 'SDL::Rect';

sub new {
	my $class = shift;
	my $x = shift || 0;
	my $y = shift || 0;
	my $w = shift || 0;
	my $h = shift || 0;
	my $self = SDL::Rect->new($x, $y, $w, $h);
	unless ($$self) {
		require Carp;
		Carp::croak SDL::GetError();
	}
	bless $self, $class;
	return $self;

}

sub foo {
	my $self = shift;
	return $self->x;
}

package main;
use Test::More tests => 6;

my $rect = MyRect->new;

isa_ok($rect, 'SDL::Rect');
isa_ok($rect, 'MyRect');
can_ok($rect, qw(x y top left w h width height));
can_ok($rect, qw(new foo));

$rect->x(10);
is($rect->x, 10);
is($rect->foo, 10);
