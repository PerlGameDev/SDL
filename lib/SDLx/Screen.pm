package SDLx::Screen;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use Carp ();
use SDL;
use SDL::Rect;
use SDL::Video;
use SDL::Image;
use SDL::Color;
use SDL::Config;
use SDL::Surface;
use SDL::PixelFormat;

use SDL::GFX::Primitives;

use SDL::Constants ':SDL::Video';
our @ISA = qw(Exporter DynaLoader SDL::Surface);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDLx::Screen;

1;
