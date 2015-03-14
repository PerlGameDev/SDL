package SDL::Version;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

use overload '<=>' => \&my_cmp,
             '""'  => \&stringify;

bootstrap SDL::Version;

sub stringify {
    my $self = shift;
    return sprintf "%s%s%s", chr($self->major), chr($self->minor), chr($self->patch);
}

sub my_cmp {
    my ($left, $right) = @_;
    return "$left" cmp "$right";
}

1;
