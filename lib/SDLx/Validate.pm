#Interal Module to validate SDLx types
package SDLx::Validate;
use strict;
use warnings;
use Carp;

sub surfaces
{
    my $surface = shift;
    
        if ($surface->isa('SDL::Surface'))
        {
            return 'sdl';
        }
        elsif( $surface->isa('SDLx::Surface' ))
        {
            return 'sdlx';
        }
        else
        {
          Carp::croak 'SDLx::Surface or SDL::Surface for surface required';
        }

}

sub sdl_surface
{
    my $surface = shift;
    Carp::croak 'SDL::Surface for surface required'
    unless $surface->isa('SDL::Surface');

}

1;

