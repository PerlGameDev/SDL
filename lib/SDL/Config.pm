package SDL::Config;

use strict;
use warnings;
use SDL::ConfigData;

sub has
{
	my ($class, $define) = @_;
	my $sdl_config = SDL::ConfigData->config('SDL_cfg'); 
	scalar grep { $$sdl_config{$_}{'libs'}{$define} } keys %$sdl_config;
}

1;
