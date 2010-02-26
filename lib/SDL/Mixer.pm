package SDL::Mixer;
use strict;
use warnings;
require Exporter;
require DynaLoader;
our @ISA = qw(Exporter DynaLoader);
use vars qw(@ISA @EXPORT);

BEGIN {
  @ISA = qw(Exporter DynaLoader);
  @EXPORT = qw(  MIX_INIT_FLAC MIX_INIT_MOD MIX_INIT_MP3 MIX_INIT_OGG );      
}



use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

use constant
{
    MIX_INIT_FLAC => 0x00000001,
    MIX_INIT_MOD  => 0x00000002,
    MIX_INIT_MP3  => 0x00000004,
    MIX_INIT_OGG  => 0x00000008
};

bootstrap SDL::Mixer;

1;
