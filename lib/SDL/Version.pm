package SDL::Version;
use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA);
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);

our $VERSION    = '2.541_10';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

use overload '<=>' => \&my_cmp, '""' => \&stringify;

bootstrap SDL::Version;

sub stringify {
	my $self = shift;
	return sprintf "%s%s%s", chr( $self->major ), chr( $self->minor ), chr( $self->patch );
}

sub my_cmp {
	my ( $left, $right ) = @_;
	return "$left" cmp "$right";
}

1;
