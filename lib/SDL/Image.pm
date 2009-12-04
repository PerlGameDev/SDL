package SDL::Image;
use strict;
use warnings;
require Exporter;
require DynaLoader;
use vars qw(@ISA @EXPORT);

BEGIN {
  @ISA = qw(Exporter DynaLoader);
  @EXPORT = qw( IMG_INIT_JPG IMG_INIT_PNG IMG_INIT_TIF);      
}

bootstrap SDL::Image;

use constant
{
   IMG_INIT_JPG => 0x00000001,
   IMG_INIT_PNG => 0x00000002,
   IMG_INIT_TIF => 0x00000004,
};


1;
