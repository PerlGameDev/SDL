package MyRect;
use base 'SDL::Rect';

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	unless (ref $self) {
		require Carp;
		Carp::croak SDL::GetError();
	}
	return bless $self => $class;;

}

sub foo {
	my $self = shift;
	return $self->x;
}

package main;
use Test::More tests => 6;

my $rect = MyRect->new(0,0,0,0);

isa_ok($rect, 'SDL::Rect');
isa_ok($rect, 'MyRect');
can_ok($rect, qw(x y w h));
can_ok($rect, qw(new foo));

$rect->x(10);
is($rect->x, 10);
is($rect->foo, 10);
sleep(2);
