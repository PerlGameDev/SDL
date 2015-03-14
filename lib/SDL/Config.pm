package SDL::Config;

use strict;
use warnings;
use vars qw($VERSION);
use SDL::ConfigData;

our $VERSION = '2.541_08';
$VERSION = eval $VERSION;

sub has {
	my ( $class, $define ) = @_;
	my $sdl_config = SDL::ConfigData->config('SDL_cfg');
	my $n = scalar grep { $$sdl_config{$_}{'libs'}{$define} } keys %$sdl_config;
	return ( $n > 0 ) ? 1 : 0;
}

1;
