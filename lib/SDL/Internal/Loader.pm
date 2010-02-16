package SDL::Internal::Loader;
use strict;
use warnings;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(internal_load_dlls);

use SDL::ConfigData;

# xxx TODO xxx some doc saying what is this good for

sub internal_load_dlls($) {
  my $package = shift;
  my $lib_nick;
  require DynaLoader;  
  if ($package =~ /^SDL(::.*)?::(.*)?$/) {
    $lib_nick = SDL::ConfigData->config('subsystems')->{$2}->{libraries};
  }
  if ($package =~ /^(SDL|SDL_perl)$/) {
    $lib_nick = [qw(SDL SDL_ttf smpeg)]; # xxx TODO xxx is the list complete?
  }
  use Data::Dumper;
  return unless $lib_nick;
  my $shlib_map = SDL::ConfigData->config('sdl_ld_shlib_map');  
  foreach my $n (@$lib_nick) {
    $n = SDL::ConfigData->config('libraries')->{$n}->{lib};
    my $file = $shlib_map->{$n};
    next unless $file;
    my $libref = DynaLoader::dl_load_file($file, 0);
    push(@DynaLoader::dl_librefs, $libref) if $libref;
  }
}

1;
