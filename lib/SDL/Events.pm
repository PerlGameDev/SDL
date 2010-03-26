package SDL::Events;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::Events';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::Events;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::Events'} };
our %EXPORT_TAGS = (
	all    => \@EXPORT,
	type   => $SDL::Constants::EXPORT_TAGS{'SDL::Events/type'},
	mask   => $SDL::Constants::EXPORT_TAGS{'SDL::Events/mask'},
	action => $SDL::Constants::EXPORT_TAGS{'SDL::Events/action'},
	state  => $SDL::Constants::EXPORT_TAGS{'SDL::Events/state'},
	hat    => $SDL::Constants::EXPORT_TAGS{'SDL::Events/hat'},
	app    => $SDL::Constants::EXPORT_TAGS{'SDL::Events/app'},
	button => $SDL::Constants::EXPORT_TAGS{'SDL::Events/button'},
	keysym => $SDL::Constants::EXPORT_TAGS{'SDL::Events/meysym'},
	keymod => $SDL::Constants::EXPORT_TAGS{'SDL::Events/keymod'}
);

1;
