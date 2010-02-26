package SDL::Internal::Loader;
use strict;
use warnings;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(internal_load_dlls);

use SDL::ConfigData;

# SDL::Internal::Loader is a king of "Dynaloader kung-fu" that is
# necessary in situations when you install Allien::SDL from sources
# or from prebuilt binaries as in these scenarios the SDL stuff is
# installed into so called 'sharedir' somewhere in perl/lib/ tree
# on Windows box it is e.g.
# C:\strawberry\perl\site\lib\auto\share\dist\Alien-SDL...
#
# What happens is that for example XS module "SDL::Video" is linked
# with -lSDL library which means that resulting "Video.(so|dll)" has
# a dependency on "libSDL.(so|dll)" - however "libSDL.(so|dll)" is
# neither in PATH (Win) or in LD_LIBRARY_PATH (Unix) so Dynaloader
# will fail to load "Video.(so|dll)".
#
# To handle this we have internal_load_dlls() which has to be called
# from XS modules (e.g. SDL::Video) linked with SDL libs like this:
#
# use SDL::Internal::Loader;
# internal_load_dlls(PACKAGE);

sub internal_load_dlls($) {
  my $package = shift;

  ### check if some ld_shlib_map is defined
  my $shlib_map = SDL::ConfigData->config('sdl_ld_shlib_map');  
  return unless $shlib_map; # empty shlib_map, nothing to do

  ### get list of lib nicknames based on packagename
  my $lib_nick;
  if ($package =~ /^SDL(::.*)?::(.*)?$/) {
    $lib_nick = SDL::ConfigData->config('subsystems')->{$2}->{libraries};
  }
  if ($package =~ /^(SDL|SDL_perl)$/) {
    $lib_nick = [qw(SDL SDL_ttf smpeg)]; # xxx TODO xxx is the list complete?
  }
  return unless $lib_nick; # no need to load anything

  ### let us load the corresponding shlibs (*.dll|*.so)
  require DynaLoader;  
  foreach my $n (@$lib_nick) {
    my $l = SDL::ConfigData->config('libraries')->{$n};
    next unless $l; # maybe some visible warning as something went wrong
    my $file = $shlib_map->{$l->{lib}};
    next unless $file; # maybe some visible warning as something went wrong
    my $libref = DynaLoader::dl_load_file($file, 0);
    push(@DynaLoader::dl_librefs, $libref) if $libref;
  }
}

1;
