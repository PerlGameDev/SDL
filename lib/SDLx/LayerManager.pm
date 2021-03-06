package SDLx::LayerManager;
use strict;
use warnings;
use SDL;
use SDLx::Surface;
use SDLx::Sprite;
use SDL::Events;

our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

our $VERSION = 2.548;

bootstrap SDLx::LayerManager;

1;
