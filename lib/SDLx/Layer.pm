package SDLx::Layer;
use strict;
use warnings;
use vars qw($VERSION $XS_VERSION @ISA);
use SDL;
use SDLx::Surface;
use SDLx::Sprite;
use SDL::Events;

our @ISA = qw(Exporter DynaLoader);

our $VERSION    = '2.541_10';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDLx::Layer;

1;
