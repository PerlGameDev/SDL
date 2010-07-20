package SDL::Config;

use strict;
use warnings;
use SDL::ConfigData;

sub has {
    my ( $class, $define ) = @_;
    my $sdl_config = SDL::ConfigData->config('SDL_cfg');
    my $n = scalar grep { $$sdl_config{$_}{'libs'}{$define} } keys %$sdl_config;
    return ( $n > 0 ) ? 1 : 0;
}

1;
